package com.library.entity;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Invoice {
    private int invoiceId;
    private Integer reservationId;
    private int memberId;
    private Integer branchId;
    private String invoiceNumber;
    private InvoiceType invoiceType;
    private BigDecimal subtotal;
    private BigDecimal taxAmount;
    private BigDecimal discountAmount;
    private BigDecimal fineAmount;
    private BigDecimal totalAmount;
    private PaymentStatus paymentStatus;
    private Timestamp issueDate;
    private Date dueDate;
    private Timestamp paidDate;
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public enum PaymentStatus {
        PENDING, PAID, PARTIAL, CANCELLED, REFUNDED, OVERDUE
    }
    
    public enum InvoiceType {
        RESERVATION, MEMBERSHIP, FINE, LOST_BOOK, DAMAGE, OTHER
    }
    
    // Getters and Setters
    public int getInvoiceId() {
        return invoiceId;
    }
    
    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }
    
    public Integer getReservationId() {
        return reservationId;
    }
    
    public void setReservationId(Integer reservationId) {
        this.reservationId = reservationId;
    }
    
    public String getInvoiceNumber() {
        return invoiceNumber;
    }
    
    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }
    
    public int getMemberId() {
        return memberId;
    }
    
    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }
    
    public Integer getBranchId() {
        return branchId;
    }
    
    public void setBranchId(Integer branchId) {
        this.branchId = branchId;
    }
    
    public InvoiceType getInvoiceType() {
        return invoiceType;
    }
    
    public void setInvoiceType(InvoiceType invoiceType) {
        this.invoiceType = invoiceType;
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    public BigDecimal getTaxAmount() {
        return taxAmount;
    }
    
    public void setTaxAmount(BigDecimal taxAmount) {
        this.taxAmount = taxAmount;
    }
    
    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }
    
    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }
    
    public BigDecimal getFineAmount() {
        return fineAmount;
    }
    
    public void setFineAmount(BigDecimal fineAmount) {
        this.fineAmount = fineAmount;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public Date getDueDate() {
        return dueDate;
    }
    
    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }
    
    public Timestamp getIssueDate() {
        return issueDate;
    }
    
    public void setIssueDate(Timestamp issueDate) {
        this.issueDate = issueDate;
    }
    
    public Timestamp getPaidDate() {
        return paidDate;
    }
    
    public void setPaidDate(Timestamp paidDate) {
        this.paidDate = paidDate;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
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
    public int getUserId() {
        return memberId;
    }
    
    public void setUserId(int userId) {
        this.memberId = userId;
    }
    
    public int getBookId() {
        return 0;
    }
    
    public void setBookId(int bookId) {
        // This would need to be retrieved from reservation
    }
    
    public Date getInvoiceDate() {
        return issueDate != null ? new Date(issueDate.getTime()) : null;
    }
    
    public void setInvoiceDate(Date invoiceDate) {
        this.issueDate = invoiceDate != null ? new Timestamp(invoiceDate.getTime()) : null;
    }
    
    public String getPaymentMethod() {
        return null;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        // This would need to be retrieved from payment
    }
    
    public Date getPaymentDate() {
        return paidDate != null ? new Date(paidDate.getTime()) : null;
    }
    
    public void setPaymentDate(Date paymentDate) {
        this.paidDate = paymentDate != null ? new Timestamp(paymentDate.getTime()) : null;
    }
    
    public String getPaymentReference() {
        return null;
    }
    
    public void setPaymentReference(String paymentReference) {
        // This would need to be retrieved from payment
    }
}

