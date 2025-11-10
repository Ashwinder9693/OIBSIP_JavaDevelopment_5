package com.library.entity;

import java.sql.Timestamp;

public class Notification {
    private long notificationId;
    private int userId;
    private NotificationType notificationType;
    private String title;
    private String message;
    private boolean isRead;
    private Timestamp readAt;
    private String link;
    private Timestamp createdAt;
    
    public enum NotificationType {
        DUE_REMINDER, OVERDUE, RESERVATION_READY, BOOKING_CONFIRMED, FINE_ALERT, SYSTEM
    }
    
    // Getters and Setters
    public long getNotificationId() {
        return notificationId;
    }
    
    public void setNotificationId(long notificationId) {
        this.notificationId = notificationId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public NotificationType getNotificationType() {
        return notificationType;
    }
    
    public void setNotificationType(NotificationType notificationType) {
        this.notificationType = notificationType;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public boolean isRead() {
        return isRead;
    }
    
    public void setRead(boolean read) {
        isRead = read;
    }
    
    public Timestamp getReadAt() {
        return readAt;
    }
    
    public void setReadAt(Timestamp readAt) {
        this.readAt = readAt;
    }
    
    public String getLink() {
        return link;
    }
    
    public void setLink(String link) {
        this.link = link;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

