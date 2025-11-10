package com.library.entity;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Reservation {
    private int reservationId;
    private int bookId;
    private int userId;
    private int memberId;
    private Integer branchId;
    private ReservationStatus reservationStatus;
    private Timestamp reservationDate;
    private Date startDate;
    private Date endDate;
    private Date actualReturnDate;
    private int numberOfDays;
    private BigDecimal pricePerDay;
    private BigDecimal totalAmount;
    private BigDecimal fineAmount;
    private String membershipTier;  // Track membership tier used for this reservation
    private BigDecimal discountAmount;  // Discount amount based on membership
    private int daysOverdue;
    private int reminderSentCount;
    private Timestamp lastReminderSent;
    private String cancellationReason;
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public enum ReservationStatus {
        PENDING, CONFIRMED, ACTIVE, COMPLETED, CANCELLED, OVERDUE, EXPIRED
    }
    
    // Getters and Setters
    public int getReservationId() {
        return reservationId;
    }
    
    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }
    
    public int getBookId() {
        return bookId;
    }
    
    public void setBookId(int bookId) {
        this.bookId = bookId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public Integer getMemberId() {
        return memberId;
    }
    
    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }
    
    public Timestamp getReservationDate() {
        return reservationDate;
    }
    
    public void setReservationDate(Timestamp reservationDate) {
        this.reservationDate = reservationDate;
    }
    
    public Date getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public int getNumberOfDays() {
        return numberOfDays;
    }
    
    public void setNumberOfDays(int numberOfDays) {
        this.numberOfDays = numberOfDays;
    }
    
    public BigDecimal getPricePerDay() {
        return pricePerDay;
    }
    
    public void setPricePerDay(BigDecimal pricePerDay) {
        this.pricePerDay = pricePerDay;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
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
    
    public String getMembershipTier() {
        return membershipTier;
    }
    
    public void setMembershipTier(String membershipTier) {
        this.membershipTier = membershipTier;
    }
    
    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }
    
    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }
    
    public Integer getBranchId() {
        return branchId;
    }
    
    public void setBranchId(Integer branchId) {
        this.branchId = branchId;
    }
    
    public ReservationStatus getReservationStatus() {
        return reservationStatus;
    }
    
    public void setReservationStatus(ReservationStatus reservationStatus) {
        this.reservationStatus = reservationStatus;
    }
    
    public Date getActualReturnDate() {
        return actualReturnDate;
    }
    
    public void setActualReturnDate(Date actualReturnDate) {
        this.actualReturnDate = actualReturnDate;
    }
    
    public int getReminderSentCount() {
        return reminderSentCount;
    }
    
    public void setReminderSentCount(int reminderSentCount) {
        this.reminderSentCount = reminderSentCount;
    }
    
    public Timestamp getLastReminderSent() {
        return lastReminderSent;
    }
    
    public void setLastReminderSent(Timestamp lastReminderSent) {
        this.lastReminderSent = lastReminderSent;
    }
    
    public String getCancellationReason() {
        return cancellationReason;
    }
    
    public void setCancellationReason(String cancellationReason) {
        this.cancellationReason = cancellationReason;
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
    public Date getReturnDate() {
        return actualReturnDate;
    }
    
    public void setReturnDate(Date returnDate) {
        this.actualReturnDate = returnDate;
    }
    
    public PaymentStatus getPaymentStatus() {
        // This would need to be derived from invoice
        return PaymentStatus.PENDING;
    }
    
    public void setPaymentStatus(PaymentStatus paymentStatus) {
        // This would need to update invoice
    }
    
    public String getPaymentMethod() {
        return null;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        // This would need to update invoice
    }
    
    public Date getPaymentDate() {
        return null;
    }
    
    public void setPaymentDate(Date paymentDate) {
        // This would need to update invoice
    }
    
    public String getRemarks() {
        return notes;
    }
    
    public void setRemarks(String remarks) {
        this.notes = remarks;
    }
    
    public enum PaymentStatus {
        PENDING, PAID, REFUNDED
    }
}

