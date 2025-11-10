package com.library.entity;

public class BookAuthor {
    private int bookId;
    private int authorId;
    private AuthorRole authorRole;
    private int authorOrder;
    
    public enum AuthorRole {
        PRIMARY_AUTHOR, CO_AUTHOR, EDITOR, TRANSLATOR, ILLUSTRATOR
    }
    
    // Getters and Setters
    public int getBookId() {
        return bookId;
    }
    
    public void setBookId(int bookId) {
        this.bookId = bookId;
    }
    
    public int getAuthorId() {
        return authorId;
    }
    
    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }
    
    public AuthorRole getAuthorRole() {
        return authorRole;
    }
    
    public void setAuthorRole(AuthorRole authorRole) {
        this.authorRole = authorRole;
    }
    
    public int getAuthorOrder() {
        return authorOrder;
    }
    
    public void setAuthorOrder(int authorOrder) {
        this.authorOrder = authorOrder;
    }
}

