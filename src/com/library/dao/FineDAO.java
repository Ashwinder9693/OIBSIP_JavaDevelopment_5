package com.library.dao;

import com.library.entity.Fine;
import com.library.entity.Fine.FineStatus;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class FineDAO {
    private Connection connection;
    
    public FineDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    public boolean addFine(Fine fine) {
        String sql = "INSERT INTO fines (transaction_id, member_id, fine_type, fine_amount, days_overdue, status, fine_date) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setObject(1, fine.getTransactionId());
            stmt.setInt(2, fine.getMemberId());
            stmt.setString(3, fine.getFineType() != null ? fine.getFineType().name() : "OVERDUE");
            stmt.setBigDecimal(4, fine.getFineAmount());
            stmt.setInt(5, fine.getDaysOverdue());
            stmt.setString(6, fine.getStatus() != null ? fine.getStatus().name() : "PENDING");
            stmt.setTimestamp(7, fine.getFineDate());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    fine.setFineId(generatedKeys.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean payFine(int fineId, Timestamp paymentDate, BigDecimal paidAmount, String paymentReference) {
        String sql = "UPDATE fines SET paid_date=?, paid_amount=?, payment_reference=?, status=? WHERE fine_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, paymentDate);
            stmt.setBigDecimal(2, paidAmount);
            stmt.setString(3, paymentReference);
            stmt.setString(4, FineStatus.PAID.name());
            stmt.setInt(5, fineId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean waiveFine(int fineId, Integer waivedBy, BigDecimal waivedAmount, String waiveReason) {
        String sql = "UPDATE fines SET status=?, waived_by=?, waived_amount=?, waive_reason=? WHERE fine_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, FineStatus.WAIVED.name());
            stmt.setObject(2, waivedBy);
            stmt.setBigDecimal(3, waivedAmount);
            stmt.setString(4, waiveReason);
            stmt.setInt(5, fineId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Fine> getAllFines() {
        List<Fine> fines = new ArrayList<>();
        String sql = "SELECT * FROM fines";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                fines.add(mapResultSetToFine(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fines;
    }
    
    public List<Fine> getAllPendingFines() {
        List<Fine> fines = new ArrayList<>();
        String sql = "SELECT * FROM fines WHERE status = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, FineStatus.PENDING.name());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                fines.add(mapResultSetToFine(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fines;
    }
    
    public List<Fine> getFinesByMember(int memberId) {
        List<Fine> fines = new ArrayList<>();
        String sql = "SELECT * FROM fines WHERE member_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, memberId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                fines.add(mapResultSetToFine(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fines;
    }
    
    public Fine getFineById(int fineId) {
        String sql = "SELECT * FROM fines WHERE fine_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, fineId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToFine(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Fine getFineByTransactionId(int transactionId) {
        String sql = "SELECT * FROM fines WHERE transaction_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, transactionId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToFine(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean fineExistsForTransaction(int transactionId) {
        String sql = "SELECT COUNT(*) FROM fines WHERE transaction_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, transactionId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public BigDecimal getTotalPendingFinesByMember(int memberId) {
        String sql = "SELECT SUM(fine_amount) FROM fines WHERE member_id = ? AND status = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, memberId);
            stmt.setString(2, FineStatus.PENDING.name());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal(1);
                return total != null ? total : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    private Fine mapResultSetToFine(ResultSet rs) throws SQLException {
        Fine fine = new Fine();
        fine.setFineId(rs.getInt("fine_id"));
        
        Integer transactionId = rs.getInt("transaction_id");
        if (!rs.wasNull()) {
            fine.setTransactionId(transactionId);
        }
        
        fine.setMemberId(rs.getInt("member_id"));
        
        String fineTypeStr = rs.getString("fine_type");
        if (fineTypeStr != null) {
            try {
                fine.setFineType(Fine.FineType.valueOf(fineTypeStr));
            } catch (IllegalArgumentException e) {
                fine.setFineType(Fine.FineType.OVERDUE);
            }
        }
        
        fine.setFineAmount(rs.getBigDecimal("fine_amount"));
        fine.setDaysOverdue(rs.getInt("days_overdue"));
        
        String statusStr = rs.getString("status");
        if (statusStr != null) {
            try {
                fine.setStatus(FineStatus.valueOf(statusStr));
            } catch (IllegalArgumentException e) {
                fine.setStatus(FineStatus.PENDING);
            }
        }
        
        fine.setFineDate(rs.getTimestamp("fine_date"));
        fine.setPaidDate(rs.getTimestamp("paid_date"));
        fine.setPaidAmount(rs.getBigDecimal("paid_amount"));
        fine.setWaivedAmount(rs.getBigDecimal("waived_amount"));
        
        Integer waivedBy = rs.getInt("waived_by");
        if (!rs.wasNull()) {
            fine.setWaivedBy(waivedBy);
        }
        
        fine.setWaiveReason(rs.getString("waive_reason"));
        fine.setPaymentReference(rs.getString("payment_reference"));
        fine.setCreatedAt(rs.getTimestamp("created_at"));
        fine.setUpdatedAt(rs.getTimestamp("updated_at"));
        return fine;
    }
}