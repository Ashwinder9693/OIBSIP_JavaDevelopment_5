package com.library.entity;

import java.math.BigDecimal;
import java.sql.Date;

public class FineRate {
    private int rateId;
    private com.library.entity.Member.MembershipType membershipType;
    private com.library.entity.Book.BookFormat bookFormat;
    private BigDecimal ratePerDay;
    private BigDecimal maxFine;
    private int gracePeriodDays;
    private boolean isActive;
    private Date effectiveFrom;
    private Date effectiveTo;
    
    // Getters and Setters
    public int getRateId() {
        return rateId;
    }
    
    public void setRateId(int rateId) {
        this.rateId = rateId;
    }
    
    public com.library.entity.Member.MembershipType getMembershipType() {
        return membershipType;
    }
    
    public void setMembershipType(com.library.entity.Member.MembershipType membershipType) {
        this.membershipType = membershipType;
    }
    
    public com.library.entity.Book.BookFormat getBookFormat() {
        return bookFormat;
    }
    
    public void setBookFormat(com.library.entity.Book.BookFormat bookFormat) {
        this.bookFormat = bookFormat;
    }
    
    public BigDecimal getRatePerDay() {
        return ratePerDay;
    }
    
    public void setRatePerDay(BigDecimal ratePerDay) {
        this.ratePerDay = ratePerDay;
    }
    
    public BigDecimal getMaxFine() {
        return maxFine;
    }
    
    public void setMaxFine(BigDecimal maxFine) {
        this.maxFine = maxFine;
    }
    
    public int getGracePeriodDays() {
        return gracePeriodDays;
    }
    
    public void setGracePeriodDays(int gracePeriodDays) {
        this.gracePeriodDays = gracePeriodDays;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public Date getEffectiveFrom() {
        return effectiveFrom;
    }
    
    public void setEffectiveFrom(Date effectiveFrom) {
        this.effectiveFrom = effectiveFrom;
    }
    
    public Date getEffectiveTo() {
        return effectiveTo;
    }
    
    public void setEffectiveTo(Date effectiveTo) {
        this.effectiveTo = effectiveTo;
    }
}

