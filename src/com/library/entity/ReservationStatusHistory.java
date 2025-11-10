package com.library.entity;

import java.sql.Timestamp;

public class ReservationStatusHistory {
    private int id;
    private int reservationId;
    private String fromStatus;
    private String toStatus;
    private Timestamp changedAt;
    private Integer changedBy;
    private String notes;
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getReservationId() {
        return reservationId;
    }
    
    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }
    
    public String getFromStatus() {
        return fromStatus;
    }
    
    public void setFromStatus(String fromStatus) {
        this.fromStatus = fromStatus;
    }
    
    public String getToStatus() {
        return toStatus;
    }
    
    public void setToStatus(String toStatus) {
        this.toStatus = toStatus;
    }
    
    public Timestamp getChangedAt() {
        return changedAt;
    }
    
    public void setChangedAt(Timestamp changedAt) {
        this.changedAt = changedAt;
    }
    
    public Integer getChangedBy() {
        return changedBy;
    }
    
    public void setChangedBy(Integer changedBy) {
        this.changedBy = changedBy;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
}

