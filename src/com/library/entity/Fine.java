package com.library.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Fine {
    private int fineId;
    private Integer transactionId;
    private int memberId;
    private FineType fineType;
    private BigDecimal fineAmount;
    private int daysOverdue;
    private FineStatus status;
    private Timestamp fineDate;
    private Timestamp paidDate;
    private BigDecimal paidAmount;
    private BigDecimal waivedAmount;
    private Integer waivedBy;
    private String waiveReason;
    private String paymentReference;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public enum FineStatus {
        PENDING, PAID, PARTIAL, WAIVED, CANCELLED
    }
    
    public enum FineType {
        OVERDUE, DAMAGE, LOST, LATE_RETURN, OTHER
    }
    
    // Getters and Setters
    public int getFineId() {
        return fineId;
    }
    
    public void setFineId(int fineId) {
        this.fineId = fineId;
    }
    
    public Integer getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(Integer transactionId) {
        this.transactionId = transactionId;
    }
    
    public int getMemberId() {
        return memberId;
    }
    
    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }
    
    public BigDecimal getFineAmount() {
        return fineAmount;
    }
    
    public void setFineAmount(BigDecimal fineAmount) {
        this.fineAmount = fineAmount;
    }
    
    public int getDaysOverdue() {
        return daysOverdue;
    }
    
    public void setDaysOverdue(int daysOverdue) {
        this.daysOverdue = daysOverdue;
    }
    
    public FineStatus getStatus() {
        return status;
    }
    
    public void setStatus(FineStatus status) {
        this.status = status;
    }
    
    public FineType getFineType() {
        return fineType;
    }
    
    public void setFineType(FineType fineType) {
        this.fineType = fineType;
    }
    
    public Timestamp getFineDate() {
        return fineDate;
    }
    
    public void setFineDate(Timestamp fineDate) {
        this.fineDate = fineDate;
    }
    
    public Timestamp getPaidDate() {
        return paidDate;
    }
    
    public void setPaidDate(Timestamp paidDate) {
        this.paidDate = paidDate;
    }
    
    public BigDecimal getPaidAmount() {
        return paidAmount;
    }
    
    public void setPaidAmount(BigDecimal paidAmount) {
        this.paidAmount = paidAmount;
    }
    
    public BigDecimal getWaivedAmount() {
        return waivedAmount;
    }
    
    public void setWaivedAmount(BigDecimal waivedAmount) {
        this.waivedAmount = waivedAmount;
    }
    
    public Integer getWaivedBy() {
        return waivedBy;
    }
    
    public void setWaivedBy(Integer waivedBy) {
        this.waivedBy = waivedBy;
    }
    
    public String getWaiveReason() {
        return waiveReason;
    }
    
    public void setWaiveReason(String waiveReason) {
        this.waiveReason = waiveReason;
    }
    
    public String getPaymentReference() {
        return paymentReference;
    }
    
    public void setPaymentReference(String paymentReference) {
        this.paymentReference = paymentReference;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Convenience methods for backward compatibility
    public java.sql.Date getPaymentDate() {
        return paidDate != null ? new java.sql.Date(paidDate.getTime()) : null;
    }
    
    public void setPaymentDate(java.sql.Date paymentDate) {
        this.paidDate = paymentDate != null ? new Timestamp(paymentDate.getTime()) : null;
    }
    
    public String getPaymentMethod() {
        return null;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        // This would need to be retrieved from payment
    }
    
    public String getRemarks() {
        return waiveReason;
    }
    
    public void setRemarks(String remarks) {
        this.waiveReason = remarks;
    }
}