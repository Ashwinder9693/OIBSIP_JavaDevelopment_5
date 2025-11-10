package com.library.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class User {
    private int userId;
    private String username;
    private String passwordHash;
    private String email;
    private String firstName;
    private String lastName;
    private String fullName;
    private UserRole role;
    private String profileImageUrl;
    private String bio;
    private String preferences;
    private String notificationSettings;
    private Timestamp lastLogin;
    private int loginCount;
    private boolean isActive;
    private boolean emailVerified;
    private boolean twoFactorEnabled;
    private BigDecimal walletBalance;  // Available wallet balance
    private BigDecimal walletPendingBalance;  // Pending balance waiting for approval
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public enum UserRole {
        ADMIN, LIBRARIAN, MEMBER, GUEST
    }
    
    // Getters and Setters
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPasswordHash() {
        return passwordHash;
    }
    
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getFirstName() {
        return firstName;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    
    public String getLastName() {
        return lastName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public UserRole getRole() {
        return role;
    }
    
    public void setRole(UserRole role) {
        this.role = role;
    }
    
    public String getProfileImageUrl() {
        return profileImageUrl;
    }
    
    public void setProfileImageUrl(String profileImageUrl) {
        this.profileImageUrl = profileImageUrl;
    }
    
    public String getBio() {
        return bio;
    }
    
    public void setBio(String bio) {
        this.bio = bio;
    }
    
    public String getPreferences() {
        return preferences;
    }
    
    public void setPreferences(String preferences) {
        this.preferences = preferences;
    }
    
    public String getNotificationSettings() {
        return notificationSettings;
    }
    
    public void setNotificationSettings(String notificationSettings) {
        this.notificationSettings = notificationSettings;
    }
    
    public Timestamp getLastLogin() {
        return lastLogin;
    }
    
    public void setLastLogin(Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }
    
    public int getLoginCount() {
        return loginCount;
    }
    
    public void setLoginCount(int loginCount) {
        this.loginCount = loginCount;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public boolean isEmailVerified() {
        return emailVerified;
    }
    
    public void setEmailVerified(boolean emailVerified) {
        this.emailVerified = emailVerified;
    }
    
    public boolean isTwoFactorEnabled() {
        return twoFactorEnabled;
    }
    
    public void setTwoFactorEnabled(boolean twoFactorEnabled) {
        this.twoFactorEnabled = twoFactorEnabled;
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
    
    public BigDecimal getWalletBalance() {
        return walletBalance != null ? walletBalance : BigDecimal.ZERO;
    }
    
    public void setWalletBalance(BigDecimal walletBalance) {
        this.walletBalance = walletBalance;
    }
    
    public BigDecimal getWalletPendingBalance() {
        return walletPendingBalance != null ? walletPendingBalance : BigDecimal.ZERO;
    }
    
    public void setWalletPendingBalance(BigDecimal walletPendingBalance) {
        this.walletPendingBalance = walletPendingBalance;
    }
    
    // Convenience methods for backward compatibility
    public String getPassword() {
        return passwordHash;
    }
    
    public void setPassword(String password) {
        this.passwordHash = password;
    }
}