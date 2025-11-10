package com.library.service;

import com.library.dao.ReservationDAO;
import com.library.dao.InvoiceDAO;
import com.library.dao.BookDAO;
import com.library.dao.MemberDAO;
import com.library.entity.Reservation;
import com.library.entity.Invoice;
import com.library.entity.Book;
import com.library.entity.Member;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class ReservationService {
    private ReservationDAO reservationDAO;
    private InvoiceDAO invoiceDAO;
    private BookDAO bookDAO;
    private MemberDAO memberDAO;
    private static final BigDecimal DEFAULT_FINE_PER_DAY = new BigDecimal("2.00");
    
    public ReservationService() {
        this.reservationDAO = new ReservationDAO();
        this.invoiceDAO = new InvoiceDAO();
        this.bookDAO = new BookDAO();
        this.memberDAO = new MemberDAO();
    }
    
    public Reservation createReservation(int bookId, int userId, Date startDate, int numberOfDays) {
        Book book = bookDAO.getBookById(bookId);
        if (book == null) {
            return null;
        }
        
        // Check if book is available
        if (book.getAvailableCopies() <= 0) {
            return null;
        }
        
        // Get member and membership tier
        Member member = memberDAO.getMemberByUserId(userId);
        Integer memberId = (member != null) ? member.getMemberId() : null;
        Member.MembershipType membershipType = (member != null && member.getMembershipType() != null) 
            ? member.getMembershipType() 
            : Member.MembershipType.SILVER;  // Default to SILVER
        
        // Calculate price per day based on membership tier
        BigDecimal basePrice = (book.getPrice() != null && book.getPrice().compareTo(BigDecimal.ZERO) > 0) 
            ? book.getPrice() 
            : new BigDecimal("25.00");  // Default book price if not set
        
        // Get rental rate percentage based on membership tier
        BigDecimal rentalRatePercentage = Member.getRentalRatePercentage(membershipType);
        BigDecimal pricePerDay = basePrice.multiply(rentalRatePercentage);
        
        // Calculate discount compared to base Silver rate (20%)
        BigDecimal baseSilverRate = basePrice.multiply(new BigDecimal("0.20"));
        BigDecimal discountPerDay = baseSilverRate.subtract(pricePerDay);
        BigDecimal totalDiscount = discountPerDay.multiply(new BigDecimal(numberOfDays));
        
        // Calculate total amount
        BigDecimal totalAmount = pricePerDay.multiply(new BigDecimal(numberOfDays));
        
        // Calculate end date
        LocalDate startLocalDate = startDate.toLocalDate();
        LocalDate endLocalDate = startLocalDate.plusDays(numberOfDays);
        Date endDate = Date.valueOf(endLocalDate);
        
        // Create reservation
        Reservation reservation = new Reservation();
        reservation.setBookId(bookId);
        reservation.setUserId(userId);
        reservation.setMemberId(memberId);
        reservation.setReservationDate(new Timestamp(System.currentTimeMillis()));
        reservation.setStartDate(startDate);
        reservation.setEndDate(endDate);
        reservation.setNumberOfDays(numberOfDays);
        reservation.setPricePerDay(pricePerDay);
        reservation.setTotalAmount(totalAmount);
        reservation.setFineAmount(BigDecimal.ZERO);
        reservation.setDaysOverdue(0);
        reservation.setMembershipTier(membershipType.name());
        reservation.setDiscountAmount(totalDiscount.compareTo(BigDecimal.ZERO) > 0 ? totalDiscount : BigDecimal.ZERO);
        reservation.setReservationStatus(Reservation.ReservationStatus.PENDING);
        
        reservation = reservationDAO.createReservation(reservation);
        
        if (reservation != null) {
            // Decrease available copies
            book.setAvailableCopies(book.getAvailableCopies() - 1);
            bookDAO.updateBook(book);
            
            // Create invoice
            createInvoice(reservation, book);
        }
        
        return reservation;
    }
    
    public Invoice createInvoice(Reservation reservation, Book book) {
        // Calculate original amount (at Silver rate) for invoice display
        BigDecimal baseRate = new BigDecimal("0.20");  // Silver base rate
        BigDecimal originalAmount = book.getPrice().multiply(baseRate).multiply(new BigDecimal(reservation.getNumberOfDays()));
        
        Invoice invoice = new Invoice();
        invoice.setReservationId(reservation.getReservationId());
        invoice.setInvoiceNumber(invoiceDAO.generateInvoiceNumber());
        invoice.setMemberId(reservation.getMemberId());
        invoice.setInvoiceType(Invoice.InvoiceType.RESERVATION);
        invoice.setIssueDate(reservation.getReservationDate());
        invoice.setDueDate(reservation.getEndDate());
        invoice.setSubtotal(originalAmount);  // Original price before discount
        invoice.setTaxAmount(BigDecimal.ZERO);
        invoice.setDiscountAmount(reservation.getDiscountAmount() != null ? reservation.getDiscountAmount() : BigDecimal.ZERO);
        invoice.setFineAmount(BigDecimal.ZERO);
        invoice.setTotalAmount(reservation.getTotalAmount());  // After discount
        invoice.setPaymentStatus(Invoice.PaymentStatus.PENDING);
        
        String tierNote = reservation.getMembershipTier() != null ? " (" + reservation.getMembershipTier() + " tier)" : "";
        invoice.setNotes("Reservation for " + book.getTitle() + " - " + reservation.getNumberOfDays() + " day(s)" + tierNote);
        
        return invoiceDAO.createInvoice(invoice);
    }
    
    public boolean processPayment(int reservationId, String paymentMethod, String paymentReference) {
        Reservation reservation = reservationDAO.getReservationById(reservationId);
        if (reservation == null) {
            return false;
        }
        
        // Update reservation status to ACTIVE (payment is handled via invoice)
        reservation.setReservationStatus(Reservation.ReservationStatus.ACTIVE);
        boolean updated = reservationDAO.updateReservation(reservation);
        
        if (updated) {
            // Update invoice payment status
            Invoice invoice = invoiceDAO.getInvoiceByReservationId(reservationId);
            if (invoice != null) {
                invoiceDAO.updateInvoicePayment(invoice.getInvoiceId(), 
                    Invoice.PaymentStatus.PAID, paymentMethod, paymentReference);
            }
        }
        
        return updated;
    }
    
    public void checkAndUpdateOverdueReservations() {
        List<Reservation> overdueReservations = reservationDAO.getOverdueReservations();
        
        for (Reservation reservation : overdueReservations) {
            if (reservation.getReservationStatus() == Reservation.ReservationStatus.ACTIVE) {
                LocalDate endDate = reservation.getEndDate().toLocalDate();
                LocalDate today = LocalDate.now();
                
                if (today.isAfter(endDate)) {
                    long daysOverdue = ChronoUnit.DAYS.between(endDate, today);
                    BigDecimal fineAmount = DEFAULT_FINE_PER_DAY.multiply(new BigDecimal(daysOverdue));
                    
                    reservation.setDaysOverdue((int) daysOverdue);
                    reservation.setFineAmount(fineAmount);
                    reservation.setReservationStatus(Reservation.ReservationStatus.OVERDUE);
                    reservationDAO.updateReservation(reservation);
                    
                    // Update invoice with fine
                    Invoice invoice = invoiceDAO.getInvoiceByReservationId(reservation.getReservationId());
                    if (invoice != null && invoice.getPaymentStatus() != Invoice.PaymentStatus.PAID) {
                        invoice.setFineAmount(fineAmount);
                        invoice.setTotalAmount(invoice.getSubtotal().add(fineAmount));
                        // Note: Fine will be added when invoice is paid or when reservation is returned
                    }
                }
            }
        }
    }
    
    public boolean returnBook(int reservationId) {
        Reservation reservation = reservationDAO.getReservationById(reservationId);
        if (reservation == null) {
            return false;
        }
        
        Date returnDate = Date.valueOf(LocalDate.now());
        
        // Calculate fine if overdue
        if (returnDate.after(reservation.getEndDate())) {
            LocalDate endDate = reservation.getEndDate().toLocalDate();
            LocalDate returnLocalDate = returnDate.toLocalDate();
            long daysOverdue = ChronoUnit.DAYS.between(endDate, returnLocalDate);
            BigDecimal fineAmount = DEFAULT_FINE_PER_DAY.multiply(new BigDecimal(daysOverdue));
            
            reservation.setDaysOverdue((int) daysOverdue);
            reservation.setFineAmount(fineAmount);
        }
        
        reservation.setActualReturnDate(returnDate);
        reservation.setReservationStatus(Reservation.ReservationStatus.COMPLETED);
        
        boolean updated = reservationDAO.updateReservation(reservation);
        
        if (updated) {
            // Increase available copies
            Book book = bookDAO.getBookById(reservation.getBookId());
            if (book != null) {
                book.setAvailableCopies(book.getAvailableCopies() + 1);
                bookDAO.updateBook(book);
            }
        }
        
        return updated;
    }
    
    public List<Reservation> getUserReservations(int userId) {
        return reservationDAO.getReservationsByUserId(userId);
    }
    
    public List<Reservation> getActiveUserReservations(int userId) {
        return reservationDAO.getActiveReservationsByUserId(userId);
    }
    
    public Reservation getReservationById(int reservationId) {
        return reservationDAO.getReservationById(reservationId);
    }
    
    public Invoice getInvoiceByReservationId(int reservationId) {
        return invoiceDAO.getInvoiceByReservationId(reservationId);
    }
}

