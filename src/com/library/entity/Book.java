package com.library.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Book {
    private int bookId;
    private String title;
    private String subtitle;
    private String isbn;
    private String isbn13;
    private Integer publisherId;
    private Integer languageId;
    private String edition;
    private Integer pages;
    private BookFormat format;
    private String description;
    private Integer categoryId;
    private Integer publicationYear;
    private Integer originalPublicationYear;
    private BigDecimal price;
    private Integer weightGrams;
    private String dimensions;
    private int totalCopies;
    private int availableCopies;
    private int reservedCopies;
    private BigDecimal ratingAvg;
    private int ratingCount;
    private int viewCount;
    private int borrowCount;
    private String coverImageUrl;
    private boolean isBestseller;
    private boolean isFeatured;
    private AgeRestriction ageRestriction;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public enum BookFormat {
        HARDCOVER, PAPERBACK, EBOOK, AUDIOBOOK, MAGAZINE, REFERENCE
    }
    
    public enum AgeRestriction {
        ALL, SEVEN_PLUS, THIRTEEN_PLUS, SIXTEEN_PLUS, EIGHTEEN_PLUS
    }
    
    // Getters and Setters
    public int getBookId() {
        return bookId;
    }
    
    public void setBookId(int bookId) {
        this.bookId = bookId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getSubtitle() {
        return subtitle;
    }
    
    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }
    
    public String getIsbn() {
        return isbn;
    }
    
    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }
    
    public String getIsbn13() {
        return isbn13;
    }
    
    public void setIsbn13(String isbn13) {
        this.isbn13 = isbn13;
    }
    
    public Integer getPublisherId() {
        return publisherId;
    }
    
    public void setPublisherId(Integer publisherId) {
        this.publisherId = publisherId;
    }
    
    public Integer getLanguageId() {
        return languageId;
    }
    
    public void setLanguageId(Integer languageId) {
        this.languageId = languageId;
    }
    
    public String getEdition() {
        return edition;
    }
    
    public void setEdition(String edition) {
        this.edition = edition;
    }
    
    public Integer getPages() {
        return pages;
    }
    
    public void setPages(Integer pages) {
        this.pages = pages;
    }
    
    public BookFormat getFormat() {
        return format;
    }
    
    public void setFormat(BookFormat format) {
        this.format = format;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Integer getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }
    
    public Integer getPublicationYear() {
        return publicationYear;
    }
    
    public void setPublicationYear(Integer publicationYear) {
        this.publicationYear = publicationYear;
    }
    
    public Integer getOriginalPublicationYear() {
        return originalPublicationYear;
    }
    
    public void setOriginalPublicationYear(Integer originalPublicationYear) {
        this.originalPublicationYear = originalPublicationYear;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    // Alias methods for price per day (rental price)
    public BigDecimal getPricePerDay() {
        return price;
    }
    
    public void setPricePerDay(BigDecimal pricePerDay) {
        this.price = pricePerDay;
    }
    
    // Helper method to get author name (will be populated by DAO)
    private String authorName;
    
    public String getAuthor() {
        return authorName != null ? authorName : "Unknown Author";
    }
    
    public void setAuthor(String authorName) {
        this.authorName = authorName;
    }
    
    // Alias method for backward compatibility
    public int getAvailableQuantity() {
        return availableCopies;
    }
    
    public void setAvailableQuantity(int quantity) {
        this.availableCopies = quantity;
    }
    
    public Integer getWeightGrams() {
        return weightGrams;
    }
    
    public void setWeightGrams(Integer weightGrams) {
        this.weightGrams = weightGrams;
    }
    
    public String getDimensions() {
        return dimensions;
    }
    
    public void setDimensions(String dimensions) {
        this.dimensions = dimensions;
    }
    
    public int getTotalCopies() {
        return totalCopies;
    }
    
    public void setTotalCopies(int totalCopies) {
        this.totalCopies = totalCopies;
    }
    
    public int getAvailableCopies() {
        return availableCopies;
    }
    
    public void setAvailableCopies(int availableCopies) {
        this.availableCopies = availableCopies;
    }
    
    public int getReservedCopies() {
        return reservedCopies;
    }
    
    public void setReservedCopies(int reservedCopies) {
        this.reservedCopies = reservedCopies;
    }
    
    public BigDecimal getRatingAvg() {
        return ratingAvg;
    }
    
    public void setRatingAvg(BigDecimal ratingAvg) {
        this.ratingAvg = ratingAvg;
    }
    
    public int getRatingCount() {
        return ratingCount;
    }
    
    public void setRatingCount(int ratingCount) {
        this.ratingCount = ratingCount;
    }
    
    public int getViewCount() {
        return viewCount;
    }
    
    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }
    
    public int getBorrowCount() {
        return borrowCount;
    }
    
    public void setBorrowCount(int borrowCount) {
        this.borrowCount = borrowCount;
    }
    
    public String getCoverImageUrl() {
        return coverImageUrl;
    }
    
    public void setCoverImageUrl(String coverImageUrl) {
        this.coverImageUrl = coverImageUrl;
    }
    
    public boolean isBestseller() {
        return isBestseller;
    }
    
    public void setBestseller(boolean bestseller) {
        isBestseller = bestseller;
    }
    
    public boolean isFeatured() {
        return isFeatured;
    }
    
    public void setFeatured(boolean featured) {
        isFeatured = featured;
    }
    
    public AgeRestriction getAgeRestriction() {
        return ageRestriction;
    }
    
    public void setAgeRestriction(AgeRestriction ageRestriction) {
        this.ageRestriction = ageRestriction;
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