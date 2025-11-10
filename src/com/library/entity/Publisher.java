package com.library.entity;

import java.sql.Timestamp;

public class Publisher {
    private int publisherId;
    private String name;
    private String country;
    private String website;
    private String email;
    private String phone;
    private Integer foundedYear;
    private boolean isActive;
    private Timestamp createdAt;
    
    // Getters and Setters
    public int getPublisherId() {
        return publisherId;
    }
    
    public void setPublisherId(int publisherId) {
        this.publisherId = publisherId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getCountry() {
        return country;
    }
    
    public void setCountry(String country) {
        this.country = country;
    }
    
    public String getWebsite() {
        return website;
    }
    
    public void setWebsite(String website) {
        this.website = website;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public Integer getFoundedYear() {
        return foundedYear;
    }
    
    public void setFoundedYear(Integer foundedYear) {
        this.foundedYear = foundedYear;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

