package com.library.entity;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class BookCopy {
    private int copyId;
    private int bookId;
    private Integer branchId;
    private String barcode;
    private String rfidTag;
    private String conditionNote;
    private CopyStatus copyStatus;
    private Date acquisitionDate;
    private String acquisitionSource;
    private BigDecimal acquisitionCost;
    private Date lastMaintenanceDate;
    private int totalIssues;
    private boolean isReferenceOnly;
    private String locationShelf;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public enum CopyStatus {
        AVAILABLE, ISSUED, RESERVED, DAMAGED, LOST, REPAIR, REFERENCE_ONLY
    }
    
    // Getters and Setters
    public int getCopyId() {
        return copyId;
    }
    
    public void setCopyId(int copyId) {
        this.copyId = copyId;
    }
    
    public int getBookId() {
        return bookId;
    }
    
    public void setBookId(int bookId) {
        this.bookId = bookId;
    }
    
    public Integer getBranchId() {
        return branchId;
    }
    
    public void setBranchId(Integer branchId) {
        this.branchId = branchId;
    }
    
    public String getBarcode() {
        return barcode;
    }
    
    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }
    
    public String getRfidTag() {
        return rfidTag;
    }
    
    public void setRfidTag(String rfidTag) {
        this.rfidTag = rfidTag;
    }
    
    public String getConditionNote() {
        return conditionNote;
    }
    
    public void setConditionNote(String conditionNote) {
        this.conditionNote = conditionNote;
    }
    
    public CopyStatus getCopyStatus() {
        return copyStatus;
    }
    
    public void setCopyStatus(CopyStatus copyStatus) {
        this.copyStatus = copyStatus;
    }
    
    public Date getAcquisitionDate() {
        return acquisitionDate;
    }
    
    public void setAcquisitionDate(Date acquisitionDate) {
        this.acquisitionDate = acquisitionDate;
    }
    
    public String getAcquisitionSource() {
        return acquisitionSource;
    }
    
    public void setAcquisitionSource(String acquisitionSource) {
        this.acquisitionSource = acquisitionSource;
    }
    
    public BigDecimal getAcquisitionCost() {
        return acquisitionCost;
    }
    
    public void setAcquisitionCost(BigDecimal acquisitionCost) {
        this.acquisitionCost = acquisitionCost;
    }
    
    public Date getLastMaintenanceDate() {
        return lastMaintenanceDate;
    }
    
    public void setLastMaintenanceDate(Date lastMaintenanceDate) {
        this.lastMaintenanceDate = lastMaintenanceDate;
    }
    
    public int getTotalIssues() {
        return totalIssues;
    }
    
    public void setTotalIssues(int totalIssues) {
        this.totalIssues = totalIssues;
    }
    
    public boolean isReferenceOnly() {
        return isReferenceOnly;
    }
    
    public void setReferenceOnly(boolean referenceOnly) {
        isReferenceOnly = referenceOnly;
    }
    
    public String getLocationShelf() {
        return locationShelf;
    }
    
    public void setLocationShelf(String locationShelf) {
        this.locationShelf = locationShelf;
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

