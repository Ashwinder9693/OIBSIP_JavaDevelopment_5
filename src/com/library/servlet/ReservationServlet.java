package com.library.servlet;

import com.library.entity.User;
import com.library.entity.Book;
import com.library.entity.Reservation;
import com.library.entity.Invoice;
import com.library.service.ReservationService;
import com.library.service.BookService;
import com.library.service.WalletService;
import com.library.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.math.BigDecimal;

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {
    private ReservationService reservationService;
    private BookService bookService;
    private WalletService walletService;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        reservationService = new ReservationService();
        bookService = new BookService();
        walletService = new WalletService();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String bookIdParam = request.getParameter("bookId");
        
        if ("show".equals(action) && bookIdParam != null) {
            // Show reservation page for a specific book
            try {
                int bookId = Integer.parseInt(bookIdParam);
                Book book = bookService.getBookById(bookId);
                
                if (book == null) {
                    request.setAttribute("error", "Book not found");
                    request.getRequestDispatcher("/jsp/user/browseBooks.jsp").forward(request, response);
                    return;
                }
                
                // Get member information for pricing
                com.library.service.MemberService memberService = new com.library.service.MemberService();
                com.library.entity.Member member = memberService.getMemberByUserId(user.getUserId());
                
                request.setAttribute("book", book);
                request.setAttribute("user", user);
                request.setAttribute("member", member);
                request.getRequestDispatcher("/jsp/user/reservation.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid book ID");
                request.getRequestDispatcher("/jsp/user/browseBooks.jsp").forward(request, response);
            }
        } else if ("invoice".equals(action)) {
            // Show invoice
            String reservationIdParam = request.getParameter("reservationId");
            if (reservationIdParam != null) {
                try {
                    int reservationId = Integer.parseInt(reservationIdParam);
                    Reservation reservation = reservationService.getReservationById(reservationId);
                    Invoice invoice = reservationService.getInvoiceByReservationId(reservationId);
                    
                    if (reservation != null && reservation.getUserId() == user.getUserId()) {
                        Book book = bookService.getBookById(reservation.getBookId());
                        request.setAttribute("reservation", reservation);
                        request.setAttribute("invoice", invoice);
                        request.setAttribute("book", book);
                        request.setAttribute("user", user);
                        request.getRequestDispatcher("/jsp/user/invoice.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    // Invalid reservation ID
                }
            }
            request.setAttribute("error", "Invoice not found");
            response.sendRedirect(request.getContextPath() + "/jsp/dashboard/userDashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/jsp/user/browseBooks.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            // Create reservation
            try {
                int bookId = Integer.parseInt(request.getParameter("bookId"));
                String startDateStr = request.getParameter("startDate");
                int numberOfDays = Integer.parseInt(request.getParameter("numberOfDays"));
                String paymentMethod = request.getParameter("paymentMethod");
                String paymentReference = request.getParameter("paymentReference");
                
                // Parse start date
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date startDateUtil = sdf.parse(startDateStr);
                Date startDate = new Date(startDateUtil.getTime());
                
                // Create reservation
                Reservation reservation = reservationService.createReservation(bookId, user.getUserId(), startDate, numberOfDays);
                
                if (reservation != null) {
                    // Process payment
                    if (paymentMethod != null && !paymentMethod.isEmpty()) {
                        // Check if user wants to pay via wallet
                        if ("Wallet".equals(paymentMethod)) {
                            BigDecimal reservationAmount = reservation.getTotalAmount();
                            
                            // Check wallet balance
                            if (walletService.hasSufficientBalance(user.getUserId(), reservationAmount)) {
                                // Deduct from wallet
                                walletService.deductFromWallet(
                                    user.getUserId(), 
                                    reservationAmount, 
                                    reservation.getReservationId(),
                                    "Payment for book reservation #" + reservation.getReservationId()
                                );
                                
                                // Mark reservation as paid
                                reservationService.processPayment(reservation.getReservationId(), paymentMethod, "WALLET_TXN_" + reservation.getReservationId());
                                
                                // Refresh user session with updated wallet balance
                                user = userDAO.getUserById(user.getUserId());
                                session.setAttribute("user", user);
                            } else {
                                request.setAttribute("error", "Insufficient wallet balance. Please add money to your wallet.");
                                Book book = bookService.getBookById(bookId);
                                request.setAttribute("book", book);
                                request.setAttribute("user", user);
                                request.getRequestDispatcher("/jsp/user/reservation.jsp").forward(request, response);
                                return;
                            }
                        } else {
                            // Process other payment methods
                            reservationService.processPayment(reservation.getReservationId(), paymentMethod, paymentReference);
                        }
                    }
                    
                    // Redirect to invoice page
                    response.sendRedirect(request.getContextPath() + "/reservation?action=invoice&reservationId=" + reservation.getReservationId());
                } else {
                    request.setAttribute("error", "Failed to create reservation. Book may not be available.");
                    Book book = bookService.getBookById(bookId);
                    request.setAttribute("book", book);
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/jsp/user/reservation.jsp").forward(request, response);
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Error creating reservation: " + e.getMessage());
                String bookIdParam = request.getParameter("bookId");
                if (bookIdParam != null) {
                    try {
                        int bookId = Integer.parseInt(bookIdParam);
                        Book book = bookService.getBookById(bookId);
                        request.setAttribute("book", book);
                        request.setAttribute("user", user);
                        request.getRequestDispatcher("/jsp/user/reservation.jsp").forward(request, response);
                        return;
                    } catch (NumberFormatException ex) {
                        // Invalid book ID
                    }
                }
                response.sendRedirect(request.getContextPath() + "/jsp/user/browseBooks.jsp");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/jsp/user/browseBooks.jsp");
        }
    }
}

