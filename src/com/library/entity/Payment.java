package com.library.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {
    private int paymentId;
    private int invoiceId;
    private BigDecimal amount;
    private PaymentMethod method;
    private Timestamp paidAt;
    private String reference;
    private String cardLast4;
    private String transactionId;
    private String gatewayResponse;
    private Integer processedBy;
    private String notes;
    
    public enum PaymentMethod {
        CASH, CREDIT_CARD, DEBIT_CARD, ONLINE, UPI, WALLET, CHECK
    }
    
    // Getters and Setters
    public int getPaymentId() {
        return paymentId;
    }
    
    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }
    
    public int getInvoiceId() {
        return invoiceId;
    }
    
    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public PaymentMethod getMethod() {
        return method;
    }
    
    public void setMethod(PaymentMethod method) {
        this.method = method;
    }
    
    public Timestamp getPaidAt() {
        return paidAt;
    }
    
    public void setPaidAt(Timestamp paidAt) {
        this.paidAt = paidAt;
    }
    
    public String getReference() {
        return reference;
    }
    
    public void setReference(String reference) {
        this.reference = reference;
    }
    
    public String getCardLast4() {
        return cardLast4;
    }
    
    public void setCardLast4(String cardLast4) {
        this.cardLast4 = cardLast4;
    }
    
    public String getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
    
    public String getGatewayResponse() {
        return gatewayResponse;
    }
    
    public void setGatewayResponse(String gatewayResponse) {
        this.gatewayResponse = gatewayResponse;
    }
    
    public Integer getProcessedBy() {
        return processedBy;
    }
    
    public void setProcessedBy(Integer processedBy) {
        this.processedBy = processedBy;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
}

