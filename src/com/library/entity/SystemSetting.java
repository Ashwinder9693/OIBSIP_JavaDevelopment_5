package com.library.entity;

import java.sql.Timestamp;

public class SystemSetting {
    private int settingId;
    private String settingKey;
    private String settingValue;
    private SettingType settingType;
    private String description;
    private boolean isEditable;
    private Timestamp updatedAt;
    private Integer updatedBy;
    
    public enum SettingType {
        STRING, NUMBER, BOOLEAN, JSON
    }
    
    // Getters and Setters
    public int getSettingId() {
        return settingId;
    }
    
    public void setSettingId(int settingId) {
        this.settingId = settingId;
    }
    
    public String getSettingKey() {
        return settingKey;
    }
    
    public void setSettingKey(String settingKey) {
        this.settingKey = settingKey;
    }
    
    public String getSettingValue() {
        return settingValue;
    }
    
    public void setSettingValue(String settingValue) {
        this.settingValue = settingValue;
    }
    
    public SettingType getSettingType() {
        return settingType;
    }
    
    public void setSettingType(SettingType settingType) {
        this.settingType = settingType;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public boolean isEditable() {
        return isEditable;
    }
    
    public void setEditable(boolean editable) {
        isEditable = editable;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public Integer getUpdatedBy() {
        return updatedBy;
    }
    
    public void setUpdatedBy(Integer updatedBy) {
        this.updatedBy = updatedBy;
    }
}

