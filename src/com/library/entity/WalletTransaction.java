package com.library.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class WalletTransaction {
    private int transactionId;
    private int userId;
    private TransactionType transactionType;
    private BigDecimal amount;
    private BigDecimal balanceBefore;
    private BigDecimal balanceAfter;
    private TransactionStatus status;
    private String paymentMethod;  // For top-ups: UPI, Card, NetBanking, etc.
    private String paymentReference;  // Transaction reference from payment gateway
    private String description;
    private Integer approvedBy;  // Admin user ID who approved
    private Timestamp approvedAt;
    private Integer relatedReservationId;  // If transaction is for a reservation payment
    private Timestamp createdAt;
    
    public enum TransactionType {
        TOPUP,           // User adding money
        DEBIT,           // Money deducted for reservation
        REFUND,          // Money refunded (e.g., cancelled reservation)
        ADMIN_CREDIT,    // Admin directly adding money
        ADMIN_DEBIT      // Admin directly deducting money
    }
    
    public enum TransactionStatus {
        PENDING,         // Waiting for admin approval (for top-ups)
        APPROVED,        // Approved and processed
        REJECTED,        // Rejected by admin
        COMPLETED,       // Transaction completed successfully
        FAILED           // Transaction failed
    }
    
    // Getters and Setters
    public int getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public TransactionType getTransactionType() {
        return transactionType;
    }
    
    public void setTransactionType(TransactionType transactionType) {
        this.transactionType = transactionType;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public BigDecimal getBalanceBefore() {
        return balanceBefore;
    }
    
    public void setBalanceBefore(BigDecimal balanceBefore) {
        this.balanceBefore = balanceBefore;
    }
    
    public BigDecimal getBalanceAfter() {
        return balanceAfter;
    }
    
    public void setBalanceAfter(BigDecimal balanceAfter) {
        this.balanceAfter = balanceAfter;
    }
    
    public TransactionStatus getStatus() {
        return status;
    }
    
    public void setStatus(TransactionStatus status) {
        this.status = status;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getPaymentReference() {
        return paymentReference;
    }
    
    public void setPaymentReference(String paymentReference) {
        this.paymentReference = paymentReference;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Integer getApprovedBy() {
        return approvedBy;
    }
    
    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }
    
    public Timestamp getApprovedAt() {
        return approvedAt;
    }
    
    public void setApprovedAt(Timestamp approvedAt) {
        this.approvedAt = approvedAt;
    }
    
    public Integer getRelatedReservationId() {
        return relatedReservationId;
    }
    
    public void setRelatedReservationId(Integer relatedReservationId) {
        this.relatedReservationId = relatedReservationId;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

