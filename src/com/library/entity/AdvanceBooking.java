package com.library.entity;

import java.sql.Date;
import java.sql.Timestamp;

public class AdvanceBooking {
    private int bookingId;
    private int bookId;
    private int memberId;
    private BookingStatus status;
    private Timestamp bookingDate;
    private Date requestedDate;
    private Date fulfilledDate;
    private Date expiryDate;
    private int priority;
    private boolean notificationSent;
    private Timestamp notificationSentAt;
    private String notes;
    private boolean isPending;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public enum BookingStatus {
        PENDING, FULFILLED, CANCELLED, EXPIRED, NOTIFIED
    }
    
    // Getters and Setters
    public int getBookingId() {
        return bookingId;
    }
    
    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }
    
    public int getBookId() {
        return bookId;
    }
    
    public void setBookId(int bookId) {
        this.bookId = bookId;
    }
    
    public int getMemberId() {
        return memberId;
    }
    
    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }
    
    public BookingStatus getStatus() {
        return status;
    }
    
    public void setStatus(BookingStatus status) {
        this.status = status;
    }
    
    public Timestamp getBookingDate() {
        return bookingDate;
    }
    
    public void setBookingDate(Timestamp bookingDate) {
        this.bookingDate = bookingDate;
    }
    
    public Date getRequestedDate() {
        return requestedDate;
    }
    
    public void setRequestedDate(Date requestedDate) {
        this.requestedDate = requestedDate;
    }
    
    public Date getFulfilledDate() {
        return fulfilledDate;
    }
    
    public void setFulfilledDate(Date fulfilledDate) {
        this.fulfilledDate = fulfilledDate;
    }
    
    public Date getExpiryDate() {
        return expiryDate;
    }
    
    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }
    
    public int getPriority() {
        return priority;
    }
    
    public void setPriority(int priority) {
        this.priority = priority;
    }
    
    public boolean isNotificationSent() {
        return notificationSent;
    }
    
    public void setNotificationSent(boolean notificationSent) {
        this.notificationSent = notificationSent;
    }
    
    public Timestamp getNotificationSentAt() {
        return notificationSentAt;
    }
    
    public void setNotificationSentAt(Timestamp notificationSentAt) {
        this.notificationSentAt = notificationSentAt;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public boolean isPending() {
        return isPending;
    }
    
    public void setPending(boolean pending) {
        isPending = pending;
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
}

