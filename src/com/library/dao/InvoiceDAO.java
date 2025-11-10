package com.library.dao;

import com.library.entity.Invoice;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {
    private Connection connection;
    
    public InvoiceDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    public Invoice createInvoice(Invoice invoice) {
        String sql = "INSERT INTO invoices (reservation_id, member_id, branch_id, invoice_number, invoice_type, " +
                    "subtotal, tax_amount, discount_amount, fine_amount, total_amount, payment_status, " +
                    "issue_date, due_date, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setObject(1, invoice.getReservationId());
            stmt.setInt(2, invoice.getMemberId());
            stmt.setObject(3, invoice.getBranchId());
            stmt.setString(4, invoice.getInvoiceNumber());
            stmt.setString(5, invoice.getInvoiceType().name());
            stmt.setBigDecimal(6, invoice.getSubtotal());
            stmt.setBigDecimal(7, invoice.getTaxAmount());
            stmt.setBigDecimal(8, invoice.getDiscountAmount());
            stmt.setBigDecimal(9, invoice.getFineAmount());
            stmt.setBigDecimal(10, invoice.getTotalAmount());
            stmt.setString(11, invoice.getPaymentStatus().name());
            stmt.setTimestamp(12, invoice.getIssueDate());
            stmt.setDate(13, invoice.getDueDate());
            stmt.setString(14, invoice.getNotes());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    invoice.setInvoiceId(generatedKeys.getInt(1));
                    return invoice;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating invoice: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    public Invoice getInvoiceById(int invoiceId) {
        String sql = "SELECT * FROM invoices WHERE invoice_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, invoiceId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToInvoice(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Invoice getInvoiceByReservationId(int reservationId) {
        String sql = "SELECT * FROM invoices WHERE reservation_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToInvoice(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Invoice getInvoiceByInvoiceNumber(String invoiceNumber) {
        String sql = "SELECT * FROM invoices WHERE invoice_number = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, invoiceNumber);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToInvoice(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Invoice> getInvoicesByMemberId(int memberId) {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT * FROM invoices WHERE member_id = ? ORDER BY issue_date DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, memberId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                invoices.add(mapResultSetToInvoice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoices;
    }
    
    public boolean updateInvoicePayment(int invoiceId, Invoice.PaymentStatus paymentStatus, String paymentMethod, String paymentReference) {
        String sql = "UPDATE invoices SET payment_status=?, paid_date=? WHERE invoice_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, paymentStatus.name());
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(3, invoiceId);
            
            // Create payment record via PaymentDAO if needed
            // For now, just update the invoice
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public String generateInvoiceNumber() {
        // Generate unique invoice number: INV-YYYYMMDD-HHMMSS-XXX
        String sql = "SELECT COUNT(*) FROM invoices WHERE invoice_number LIKE ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyyMMdd");
            String datePrefix = "INV-" + dateFormat.format(new java.util.Date()) + "-";
            stmt.setString(1, datePrefix + "%");
            ResultSet rs = stmt.executeQuery();
            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
            java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("HHmmss");
            String timeSuffix = timeFormat.format(new java.util.Date());
            String sequence = String.format("%03d", count + 1);
            return datePrefix + timeSuffix + "-" + sequence;
        } catch (SQLException e) {
            e.printStackTrace();
            // Fallback to timestamp-based number
            return "INV-" + System.currentTimeMillis();
        }
    }
    
    private Invoice mapResultSetToInvoice(ResultSet rs) throws SQLException {
        Invoice invoice = new Invoice();
        invoice.setInvoiceId(rs.getInt("invoice_id"));
        
        Integer reservationId = rs.getInt("reservation_id");
        if (!rs.wasNull()) {
            invoice.setReservationId(reservationId);
        }
        
        invoice.setMemberId(rs.getInt("member_id"));
        
        Integer branchId = rs.getInt("branch_id");
        if (!rs.wasNull()) {
            invoice.setBranchId(branchId);
        }
        
        invoice.setInvoiceNumber(rs.getString("invoice_number"));
        
        String invoiceTypeStr = rs.getString("invoice_type");
        if (invoiceTypeStr != null) {
            try {
                invoice.setInvoiceType(Invoice.InvoiceType.valueOf(invoiceTypeStr));
            } catch (IllegalArgumentException e) {
                invoice.setInvoiceType(Invoice.InvoiceType.OTHER);
            }
        }
        
        invoice.setSubtotal(rs.getBigDecimal("subtotal"));
        invoice.setTaxAmount(rs.getBigDecimal("tax_amount"));
        invoice.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        invoice.setFineAmount(rs.getBigDecimal("fine_amount"));
        invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
        
        String paymentStatusStr = rs.getString("payment_status");
        if (paymentStatusStr != null) {
            try {
                invoice.setPaymentStatus(Invoice.PaymentStatus.valueOf(paymentStatusStr));
            } catch (IllegalArgumentException e) {
                invoice.setPaymentStatus(Invoice.PaymentStatus.PENDING);
            }
        }
        
        invoice.setIssueDate(rs.getTimestamp("issue_date"));
        invoice.setDueDate(rs.getDate("due_date"));
        invoice.setPaidDate(rs.getTimestamp("paid_date"));
        invoice.setNotes(rs.getString("notes"));
        invoice.setCreatedAt(rs.getTimestamp("created_at"));
        invoice.setUpdatedAt(rs.getTimestamp("updated_at"));
        return invoice;
    }
}

