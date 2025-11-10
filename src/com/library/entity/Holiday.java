package com.library.entity;

import java.sql.Date;
import java.sql.Timestamp;

public class Holiday {
    private int holidayId;
    private String holidayName;
    private Date holidayDate;
    private boolean isRecurring;
    private String description;
    private String branchesAffected;
    private Timestamp createdAt;
    
    // Getters and Setters
    public int getHolidayId() {
        return holidayId;
    }
    
    public void setHolidayId(int holidayId) {
        this.holidayId = holidayId;
    }
    
    public String getHolidayName() {
        return holidayName;
    }
    
    public void setHolidayName(String holidayName) {
        this.holidayName = holidayName;
    }
    
    public Date getHolidayDate() {
        return holidayDate;
    }
    
    public void setHolidayDate(Date holidayDate) {
        this.holidayDate = holidayDate;
    }
    
    public boolean isRecurring() {
        return isRecurring;
    }
    
    public void setRecurring(boolean recurring) {
        isRecurring = recurring;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getBranchesAffected() {
        return branchesAffected;
    }
    
    public void setBranchesAffected(String branchesAffected) {
        this.branchesAffected = branchesAffected;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

