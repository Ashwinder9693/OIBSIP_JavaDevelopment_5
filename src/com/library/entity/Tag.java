package com.library.entity;

public class Tag {
    private int tagId;
    private String tagName;
    private int usageCount;
    
    // Getters and Setters
    public int getTagId() {
        return tagId;
    }
    
    public void setTagId(int tagId) {
        this.tagId = tagId;
    }
    
    public String getTagName() {
        return tagName;
    }
    
    public void setTagName(String tagName) {
        this.tagName = tagName;
    }
    
    public int getUsageCount() {
        return usageCount;
    }
    
    public void setUsageCount(int usageCount) {
        this.usageCount = usageCount;
    }
}

