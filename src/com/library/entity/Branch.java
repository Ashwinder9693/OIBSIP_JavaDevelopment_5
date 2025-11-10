package com.library.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Branch {
    private int branchId;
    private String name;
    private String code;
    private String address;
    private String city;
    private String state;
    private String zipCode;
    private String country;
    private String phone;
    private String email;
    private Integer managerId;
    private String operatingHours;
    private Integer totalCapacity;
    private boolean parkingAvailable;
    private boolean wifiAvailable;
    private String facilities;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private boolean isActive;
    private Timestamp createdAt;
    
    // Getters and Setters
    public int getBranchId() {
        return branchId;
    }
    
    public void setBranchId(int branchId) {
        this.branchId = branchId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getCode() {
        return code;
    }
    
    public void setCode(String code) {
        this.code = code;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getCity() {
        return city;
    }
    
    public void setCity(String city) {
        this.city = city;
    }
    
    public String getState() {
        return state;
    }
    
    public void setState(String state) {
        this.state = state;
    }
    
    public String getZipCode() {
        return zipCode;
    }
    
    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
    }
    
    public String getCountry() {
        return country;
    }
    
    public void setCountry(String country) {
        this.country = country;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public Integer getManagerId() {
        return managerId;
    }
    
    public void setManagerId(Integer managerId) {
        this.managerId = managerId;
    }
    
    public String getOperatingHours() {
        return operatingHours;
    }
    
    public void setOperatingHours(String operatingHours) {
        this.operatingHours = operatingHours;
    }
    
    public Integer getTotalCapacity() {
        return totalCapacity;
    }
    
    public void setTotalCapacity(Integer totalCapacity) {
        this.totalCapacity = totalCapacity;
    }
    
    public boolean isParkingAvailable() {
        return parkingAvailable;
    }
    
    public void setParkingAvailable(boolean parkingAvailable) {
        this.parkingAvailable = parkingAvailable;
    }
    
    public boolean isWifiAvailable() {
        return wifiAvailable;
    }
    
    public void setWifiAvailable(boolean wifiAvailable) {
        this.wifiAvailable = wifiAvailable;
    }
    
    public String getFacilities() {
        return facilities;
    }
    
    public void setFacilities(String facilities) {
        this.facilities = facilities;
    }
    
    public BigDecimal getLatitude() {
        return latitude;
    }
    
    public void setLatitude(BigDecimal latitude) {
        this.latitude = latitude;
    }
    
    public BigDecimal getLongitude() {
        return longitude;
    }
    
    public void setLongitude(BigDecimal longitude) {
        this.longitude = longitude;
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

