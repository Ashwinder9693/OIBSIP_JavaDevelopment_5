package com.library.dao;

import com.library.entity.Payment;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {
    private Connection connection;
    
    public PaymentDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    public List<Payment> getPaymentsByInvoiceId(int invoiceId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments WHERE invoice_id = ? ORDER BY paid_at DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, invoiceId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                payments.add(mapResultSetToPayment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }
    
    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT * FROM payments WHERE payment_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, paymentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToPayment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addPayment(Payment payment) {
        String sql = "INSERT INTO payments (invoice_id, amount, method, reference, card_last_4, transaction_id, gateway_response, processed_by, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, payment.getInvoiceId());
            stmt.setBigDecimal(2, payment.getAmount());
            stmt.setString(3, payment.getMethod().name());
            stmt.setString(4, payment.getReference());
            stmt.setString(5, payment.getCardLast4());
            stmt.setString(6, payment.getTransactionId());
            stmt.setString(7, payment.getGatewayResponse());
            stmt.setObject(8, payment.getProcessedBy());
            stmt.setString(9, payment.getNotes());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    payment.setPaymentId(generatedKeys.getInt(1));
                    // Update invoice payment status
                    updateInvoicePaymentStatus(payment.getInvoiceId());
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deletePayment(int paymentId) {
        String sql = "SELECT invoice_id FROM payments WHERE payment_id = ?";
        int invoiceId = 0;
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, paymentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                invoiceId = rs.getInt("invoice_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        
        sql = "DELETE FROM payments WHERE payment_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, paymentId);
            boolean result = stmt.executeUpdate() > 0;
            if (result && invoiceId > 0) {
                // Update invoice payment status
                updateInvoicePaymentStatus(invoiceId);
            }
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public java.math.BigDecimal getTotalPaidAmount(int invoiceId) {
        String sql = "SELECT SUM(amount) FROM payments WHERE invoice_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, invoiceId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                java.math.BigDecimal total = rs.getBigDecimal(1);
                return total != null ? total : java.math.BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }
    
    private void updateInvoicePaymentStatus(int invoiceId) {
        // Get invoice total and paid amount
        String sql = "SELECT total_amount FROM invoices WHERE invoice_id = ?";
        java.math.BigDecimal totalAmount = java.math.BigDecimal.ZERO;
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, invoiceId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                totalAmount = rs.getBigDecimal("total_amount");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return;
        }
        
        java.math.BigDecimal paidAmount = getTotalPaidAmount(invoiceId);
        String status = "PENDING";
        if (paidAmount.compareTo(java.math.BigDecimal.ZERO) == 0) {
            status = "PENDING";
        } else if (paidAmount.compareTo(totalAmount) >= 0) {
            status = "PAID";
        } else {
            status = "PARTIAL";
        }
        
        sql = "UPDATE invoices SET payment_status = ? WHERE invoice_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, invoiceId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setInvoiceId(rs.getInt("invoice_id"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setMethod(Payment.PaymentMethod.valueOf(rs.getString("method")));
        payment.setPaidAt(rs.getTimestamp("paid_at"));
        payment.setReference(rs.getString("reference"));
        payment.setCardLast4(rs.getString("card_last_4"));
        payment.setTransactionId(rs.getString("transaction_id"));
        payment.setGatewayResponse(rs.getString("gateway_response"));
        
        Integer processedBy = rs.getInt("processed_by");
        if (!rs.wasNull()) {
            payment.setProcessedBy(processedBy);
        }
        
        payment.setNotes(rs.getString("notes"));
        return payment;
    }
}

