package com.library.service;

import com.library.dao.FineDAO;
import com.library.entity.Fine;
import com.library.entity.Fine.FineStatus;
import com.library.entity.IssueReturn;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class FineService {
    private FineDAO fineDAO;
    private static final BigDecimal FINE_PER_DAY = new BigDecimal("1.00"); // $1 per day
    
    public FineService() {
        this.fineDAO = new FineDAO();
    }
    
    public BigDecimal calculateFine(IssueReturn transaction) {
        if (transaction.getReturnDate() == null) {
            // Book not yet returned, calculate from today
            long daysOverdue = ChronoUnit.DAYS.between(
                transaction.getDueDate().toLocalDate(),
                LocalDate.now()
            );
            
            if (daysOverdue > 0) {
                return FINE_PER_DAY.multiply(BigDecimal.valueOf(daysOverdue));
            }
        } else {
            // Book already returned, calculate actual overdue days
            long daysOverdue = ChronoUnit.DAYS.between(
                transaction.getDueDate().toLocalDate(),
                new Date(transaction.getReturnDate().getTime()).toLocalDate()
            );
            
            if (daysOverdue > 0) {
                return FINE_PER_DAY.multiply(BigDecimal.valueOf(daysOverdue));
            }
        }
        
        return BigDecimal.ZERO;
    }
    
    public boolean createFine(IssueReturn transaction) {
        // Check if fine already exists
        if (fineDAO.fineExistsForTransaction(transaction.getTransactionId())) {
            return false;
        }
        
        BigDecimal fineAmount = calculateFine(transaction);
        
        if (fineAmount.compareTo(BigDecimal.ZERO) > 0) {
            long daysOverdue = ChronoUnit.DAYS.between(
                transaction.getDueDate().toLocalDate(),
                transaction.getReturnDate() != null ? 
                    new Date(transaction.getReturnDate().getTime()).toLocalDate() : 
                    LocalDate.now()
            );
            
            Fine fine = new Fine();
            fine.setTransactionId(transaction.getTransactionId());
            fine.setMemberId(transaction.getMemberId());
            fine.setFineType(Fine.FineType.OVERDUE);
            fine.setFineAmount(fineAmount);
            fine.setFineDate(new Timestamp(System.currentTimeMillis()));
            fine.setDaysOverdue((int) daysOverdue);
            fine.setStatus(FineStatus.PENDING);
            
            return fineDAO.addFine(fine);
        }
        
        return false;
    }
    
    public boolean payFine(int fineId, BigDecimal paidAmount, String paymentReference) {
        Timestamp paymentDate = new Timestamp(System.currentTimeMillis());
        return fineDAO.payFine(fineId, paymentDate, paidAmount, paymentReference);
    }
    
    public boolean waiveFine(int fineId, Integer waivedBy, BigDecimal waivedAmount, String waiveReason) {
        return fineDAO.waiveFine(fineId, waivedBy, waivedAmount, waiveReason);
    }
    
    public List<Fine> getAllFines() {
        return fineDAO.getAllFines();
    }
    
    public List<Fine> getAllPendingFines() {
        return fineDAO.getAllPendingFines();
    }
    
    public List<Fine> getFinesByMember(int memberId) {
        return fineDAO.getFinesByMember(memberId);
    }
    
    public Fine getFineById(int fineId) {
        return fineDAO.getFineById(fineId);
    }
    
    public Fine getFineByTransactionId(int transactionId) {
        return fineDAO.getFineByTransactionId(transactionId);
    }
    
    public BigDecimal getTotalPendingFinesByMember(int memberId) {
        return fineDAO.getTotalPendingFinesByMember(memberId);
    }
}