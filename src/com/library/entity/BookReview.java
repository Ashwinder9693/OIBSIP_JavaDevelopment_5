package com.library.entity;

import java.sql.Timestamp;

public class BookReview {
    private int reviewId;
    private int bookId;
    private int userId;
    private int rating;
    private String reviewTitle;
    private String reviewText;
    private boolean isVerifiedPurchase;
    private int helpfulCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Getters and Setters
    public int getReviewId() {
        return reviewId;
    }
    
    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
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
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public String getReviewTitle() {
        return reviewTitle;
    }
    
    public void setReviewTitle(String reviewTitle) {
        this.reviewTitle = reviewTitle;
    }
    
    public String getReviewText() {
        return reviewText;
    }
    
    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }
    
    public boolean isVerifiedPurchase() {
        return isVerifiedPurchase;
    }
    
    public void setVerifiedPurchase(boolean verifiedPurchase) {
        isVerifiedPurchase = verifiedPurchase;
    }
    
    public int getHelpfulCount() {
        return helpfulCount;
    }
    
    public void setHelpfulCount(int helpfulCount) {
        this.helpfulCount = helpfulCount;
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

