package com.library.entity;

import java.sql.Date;
import java.sql.Timestamp;

public class Report {
    private int reportId;
    private String reportName;
    private ReportType reportType;
    private int generatedBy;
    private Timestamp generatedAt;
    private Date startDate;
    private Date endDate;
    private String parameters;
    private String filePath;
    private FileFormat fileFormat;
    private ReportStatus status;
    
    public enum ReportType {
        CIRCULATION, FINANCIAL, INVENTORY, MEMBER, OVERDUE, POPULAR_BOOKS, CUSTOM
    }
    
    public enum FileFormat {
        PDF, EXCEL, CSV, HTML
    }
    
    public enum ReportStatus {
        PENDING, COMPLETED, FAILED
    }
    
    // Getters and Setters
    public int getReportId() {
        return reportId;
    }
    
    public void setReportId(int reportId) {
        this.reportId = reportId;
    }
    
    public String getReportName() {
        return reportName;
    }
    
    public void setReportName(String reportName) {
        this.reportName = reportName;
    }
    
    public ReportType getReportType() {
        return reportType;
    }
    
    public void setReportType(ReportType reportType) {
        this.reportType = reportType;
    }
    
    public int getGeneratedBy() {
        return generatedBy;
    }
    
    public void setGeneratedBy(int generatedBy) {
        this.generatedBy = generatedBy;
    }
    
    public Timestamp getGeneratedAt() {
        return generatedAt;
    }
    
    public void setGeneratedAt(Timestamp generatedAt) {
        this.generatedAt = generatedAt;
    }
    
    public Date getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public String getParameters() {
        return parameters;
    }
    
    public void setParameters(String parameters) {
        this.parameters = parameters;
    }
    
    public String getFilePath() {
        return filePath;
    }
    
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }
    
    public FileFormat getFileFormat() {
        return fileFormat;
    }
    
    public void setFileFormat(FileFormat fileFormat) {
        this.fileFormat = fileFormat;
    }
    
    public ReportStatus getStatus() {
        return status;
    }
    
    public void setStatus(ReportStatus status) {
        this.status = status;
    }
}

