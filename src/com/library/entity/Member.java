package com.library.entity;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Member {
    private int memberId;
    private int userId;
    private String membershipNumber;
    private MembershipType membershipType;
    private Date joinDate;
    private Date expiryDate;
    private int maxBooksAllowed;
    private int maxDaysAllowed;
    private String address;
    private String city;
    private String state;
    private String zipCode;
    private String country;
    private String phone;
    private String alternatePhone;
    private Date dateOfBirth;
    private Gender gender;
    private String occupation;
    private String organization;
    private String emergencyContactName;
    private String emergencyContactPhone;
    private int totalBooksBorrowed;
    private BigDecimal totalFinesPaid;
    private BigDecimal outstandingFines;
    private boolean isActive;
    private boolean isBlacklisted;
    private String blacklistReason;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public enum MembershipType {
        BASIC, PREMIUM, STUDENT, FACULTY, SENIOR, CORPORATE,
        SILVER, GOLD, PLATINUM  // New paid membership tiers
    }
    
    // Membership tier pricing (annual)
    public static BigDecimal getMembershipPrice(MembershipType type) {
        switch (type) {
            case SILVER: return BigDecimal.ZERO;  // Free tier
            case GOLD: return new BigDecimal("90.00");    // $90/year
            case PLATINUM: return new BigDecimal("120.00"); // $120/year
            case BASIC: return BigDecimal.ZERO;   // Legacy free tier
            case STUDENT: return BigDecimal.ZERO; // Free for students
            default: return BigDecimal.ZERO;      // Others free
        }
    }
    
    // Get rental rate as percentage of book price per day
    public static BigDecimal getRentalRatePercentage(MembershipType type) {
        switch (type) {
            case PLATINUM: return new BigDecimal("0.10");  // 10% per day (best rate)
            case GOLD: return new BigDecimal("0.15");      // 15% per day
            case SILVER: return new BigDecimal("0.20");    // 20% per day (base rate)
            case PREMIUM: return new BigDecimal("0.15");   // Same as Gold
            case STUDENT: return new BigDecimal("0.18");   // 18% per day
            case FACULTY: return new BigDecimal("0.12");   // 12% per day
            default: return new BigDecimal("0.20");        // Default to Silver rate
        }
    }
    
    // Get discount percentage compared to base Silver rate
    public static int getDiscountPercentage(MembershipType type) {
        BigDecimal baseRate = new BigDecimal("0.20");  // Silver base rate
        BigDecimal memberRate = getRentalRatePercentage(type);
        if (memberRate.compareTo(baseRate) >= 0) {
            return 0;  // No discount
        }
        BigDecimal discount = baseRate.subtract(memberRate).divide(baseRate, 2, java.math.RoundingMode.HALF_UP);
        return discount.multiply(new BigDecimal("100")).intValue();
    }
    
    // Get membership benefits
    public static String getMembershipBenefits(MembershipType type) {
        int discount = getDiscountPercentage(type);
        String discountText = discount > 0 ? ", " + discount + "% rental discount" : "";
        
        switch (type) {
            case SILVER:
                return "3 books, 14 days, Standard support" + discountText;
            case GOLD:
                return "10 books, 30 days, Priority support, No late fees for 3 days" + discountText;
            case PLATINUM:
                return "20 books, 60 days, VIP support, No late fees for 7 days" + discountText;
            case PREMIUM:
                return "10 books, 30 days, Priority support" + discountText;
            case STUDENT:
                return "5 books, 21 days, Student discount" + discountText;
            case FACULTY:
                return "15 books, 60 days, Faculty privileges" + discountText;
            default:
                return "3 books, 14 days, Standard support";
        }
    }
    
    public enum Gender {
        MALE, FEMALE, OTHER, PREFER_NOT_TO_SAY
    }
    
    // Getters and Setters
    public int getMemberId() {
        return memberId;
    }
    
    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getMembershipNumber() {
        return membershipNumber;
    }
    
    public void setMembershipNumber(String membershipNumber) {
        this.membershipNumber = membershipNumber;
    }
    
    public MembershipType getMembershipType() {
        return membershipType;
    }
    
    public void setMembershipType(MembershipType membershipType) {
        this.membershipType = membershipType;
    }
    
    public Date getJoinDate() {
        return joinDate;
    }
    
    public void setJoinDate(Date joinDate) {
        this.joinDate = joinDate;
    }
    
    public Date getExpiryDate() {
        return expiryDate;
    }
    
    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }
    
    public int getMaxBooksAllowed() {
        return maxBooksAllowed;
    }
    
    public void setMaxBooksAllowed(int maxBooksAllowed) {
        this.maxBooksAllowed = maxBooksAllowed;
    }
    
    public int getMaxDaysAllowed() {
        return maxDaysAllowed;
    }
    
    public void setMaxDaysAllowed(int maxDaysAllowed) {
        this.maxDaysAllowed = maxDaysAllowed;
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
    
    public String getAlternatePhone() {
        return alternatePhone;
    }
    
    public void setAlternatePhone(String alternatePhone) {
        this.alternatePhone = alternatePhone;
    }
    
    public Date getDateOfBirth() {
        return dateOfBirth;
    }
    
    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
    
    public Gender getGender() {
        return gender;
    }
    
    public void setGender(Gender gender) {
        this.gender = gender;
    }
    
    public String getOccupation() {
        return occupation;
    }
    
    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }
    
    public String getOrganization() {
        return organization;
    }
    
    public void setOrganization(String organization) {
        this.organization = organization;
    }
    
    public String getEmergencyContactName() {
        return emergencyContactName;
    }
    
    public void setEmergencyContactName(String emergencyContactName) {
        this.emergencyContactName = emergencyContactName;
    }
    
    public String getEmergencyContactPhone() {
        return emergencyContactPhone;
    }
    
    public void setEmergencyContactPhone(String emergencyContactPhone) {
        this.emergencyContactPhone = emergencyContactPhone;
    }
    
    public int getTotalBooksBorrowed() {
        return totalBooksBorrowed;
    }
    
    public void setTotalBooksBorrowed(int totalBooksBorrowed) {
        this.totalBooksBorrowed = totalBooksBorrowed;
    }
    
    public BigDecimal getTotalFinesPaid() {
        return totalFinesPaid;
    }
    
    public void setTotalFinesPaid(BigDecimal totalFinesPaid) {
        this.totalFinesPaid = totalFinesPaid;
    }
    
    public BigDecimal getOutstandingFines() {
        return outstandingFines;
    }
    
    public void setOutstandingFines(BigDecimal outstandingFines) {
        this.outstandingFines = outstandingFines;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public boolean isBlacklisted() {
        return isBlacklisted;
    }
    
    public void setBlacklisted(boolean blacklisted) {
        isBlacklisted = blacklisted;
    }
    
    public String getBlacklistReason() {
        return blacklistReason;
    }
    
    public void setBlacklistReason(String blacklistReason) {
        this.blacklistReason = blacklistReason;
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
    public String getFirstName() {
        // This would need to be retrieved from User entity
        return null;
    }
    
    public String getLastName() {
        // This would need to be retrieved from User entity
        return null;
    }
    
    public Date getMembershipDate() {
        return joinDate;
    }
    
    public void setMembershipDate(Date membershipDate) {
        this.joinDate = membershipDate;
    }
    
    public Date getMembershipExpiry() {
        return expiryDate;
    }
    
    public void setMembershipExpiry(Date membershipExpiry) {
        this.expiryDate = membershipExpiry;
    }
    
    // Helper method for membership status
    public String getMembershipStatus() {
        if (!isActive) {
            return "Inactive";
        }
        if (isBlacklisted) {
            return "Blacklisted";
        }
        if (expiryDate != null && expiryDate.before(new java.util.Date())) {
            return "Expired";
        }
        return "Active";
    }
}