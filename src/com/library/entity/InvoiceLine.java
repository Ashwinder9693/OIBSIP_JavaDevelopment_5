package com.library.entity;

import java.math.BigDecimal;

public class InvoiceLine {
    private int lineId;
    private int invoiceId;
    private String lineType;
    private String description;
    private BigDecimal qty;
    private BigDecimal unitPrice;
    private BigDecimal lineTotal;
    
    // Getters and Setters
    public int getLineId() {
        return lineId;
    }
    
    public void setLineId(int lineId) {
        this.lineId = lineId;
    }
    
    public int getInvoiceId() {
        return invoiceId;
    }
    
    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }
    
    public String getLineType() {
        return lineType;
    }
    
    public void setLineType(String lineType) {
        this.lineType = lineType;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getQty() {
        return qty;
    }
    
    public void setQty(BigDecimal qty) {
        this.qty = qty;
    }
    
    public BigDecimal getUnitPrice() {
        return unitPrice;
    }
    
    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
    
    public BigDecimal getLineTotal() {
        return lineTotal;
    }
    
    public void setLineTotal(BigDecimal lineTotal) {
        this.lineTotal = lineTotal;
    }
}

