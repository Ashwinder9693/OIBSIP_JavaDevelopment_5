package com.library.entity;

import java.sql.Timestamp;

public class ReadingList {
    private int listId;
    private int userId;
    private String listName;
    private String description;
    private boolean isPublic;
    private Timestamp createdAt;
    
    // Getters and Setters
    public int getListId() {
        return listId;
    }
    
    public void setListId(int listId) {
        this.listId = listId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getListName() {
        return listName;
    }
    
    public void setListName(String listName) {
        this.listName = listName;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public boolean isPublic() {
        return isPublic;
    }
    
    public void setPublic(boolean aPublic) {
        isPublic = aPublic;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

