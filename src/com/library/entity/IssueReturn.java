package com.library.entity;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class IssueReturn {
    private int transactionId;
    private int bookId;
    private Integer copyId;
    private int memberId;
    private Integer branchId;
    private int issuedBy;
    private Integer returnedTo;
    private TransactionStatus status;
    private Timestamp issueDate;
    private Date dueDate;
    private Timestamp returnDate;
    private int extendedCount;
    private Date lastExtendedDate;
    private BigDecimal fineAmount;
    private Condition conditionAtIssue;
    private Condition conditionAtReturn;
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public enum TransactionStatus {
        ISSUED, RETURNED, LOST, DAMAGED, LATE_RETURN
    }
    
    public enum Condition {
        EXCELLENT, GOOD, FAIR, POOR, DAMAGED
    }
    
    // Getters and Setters
    public int getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }
    
    public int getBookId() {
        return bookId;
    }
    
    public void setBookId(int bookId) {
        this.bookId = bookId;
    }
    
    public int getMemberId() {
        return memberId;
    }
    
    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }
    
    public Timestamp getIssueDate() {
        return issueDate;
    }
    
    public void setIssueDate(Timestamp issueDate) {
        this.issueDate = issueDate;
    }
    
    public Date getDueDate() {
        return dueDate;
    }
    
    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }
    
    public Timestamp getReturnDate() {
        return returnDate;
    }
    
    public void setReturnDate(Timestamp returnDate) {
        this.returnDate = returnDate;
    }
    
    public int getIssuedBy() {
        return issuedBy;
    }
    
    public void setIssuedBy(int issuedBy) {
        this.issuedBy = issuedBy;
    }
    
    public Integer getReturnedTo() {
        return returnedTo;
    }
    
    public void setReturnedTo(Integer returnedTo) {
        this.returnedTo = returnedTo;
    }
    
    public TransactionStatus getStatus() {
        return status;
    }
    
    public void setStatus(TransactionStatus status) {
        this.status = status;
    }
    
    public Integer getCopyId() {
        return copyId;
    }
    
    public void setCopyId(Integer copyId) {
        this.copyId = copyId;
    }
    
    public Integer getBranchId() {
        return branchId;
    }
    
    public void setBranchId(Integer branchId) {
        this.branchId = branchId;
    }
    
    public int getExtendedCount() {
        return extendedCount;
    }
    
    public void setExtendedCount(int extendedCount) {
        this.extendedCount = extendedCount;
    }
    
    public Date getLastExtendedDate() {
        return lastExtendedDate;
    }
    
    public void setLastExtendedDate(Date lastExtendedDate) {
        this.lastExtendedDate = lastExtendedDate;
    }
    
    public BigDecimal getFineAmount() {
        return fineAmount;
    }
    
    public void setFineAmount(BigDecimal fineAmount) {
        this.fineAmount = fineAmount;
    }
    
    public Condition getConditionAtIssue() {
        return conditionAtIssue;
    }
    
    public void setConditionAtIssue(Condition conditionAtIssue) {
        this.conditionAtIssue = conditionAtIssue;
    }
    
    public Condition getConditionAtReturn() {
        return conditionAtReturn;
    }
    
    public void setConditionAtReturn(Condition conditionAtReturn) {
        this.conditionAtReturn = conditionAtReturn;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
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
    
    // Convenience methods for backward compatibility
    public String getRemarks() {
        return notes;
    }
    
    public void setRemarks(String remarks) {
        this.notes = remarks;
    }
}