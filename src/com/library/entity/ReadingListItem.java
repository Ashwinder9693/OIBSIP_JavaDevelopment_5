package com.library.entity;

import java.sql.Timestamp;

public class ReadingListItem {
    private int itemId;
    private int listId;
    private int bookId;
    private Timestamp addedAt;
    private String notes;
    
    // Getters and Setters
    public int getItemId() {
        return itemId;
    }
    
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }
    
    public int getListId() {
        return listId;
    }
    
    public void setListId(int listId) {
        this.listId = listId;
    }
    
    public int getBookId() {
        return bookId;
    }
    
    public void setBookId(int bookId) {
        this.bookId = bookId;
    }
    
    public Timestamp getAddedAt() {
        return addedAt;
    }
    
    public void setAddedAt(Timestamp addedAt) {
        this.addedAt = addedAt;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
}

