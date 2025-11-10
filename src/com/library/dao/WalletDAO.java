package com.library.dao;

import com.library.entity.WalletTransaction;
import com.library.entity.User;
import com.library.util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WalletDAO {
    private Connection connection;
    
    public WalletDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    // Create a wallet transaction
    public WalletTransaction createTransaction(WalletTransaction transaction) {
        String sql = "INSERT INTO wallet_transactions (user_id, transaction_type, amount, balance_before, " +
                    "balance_after, status, payment_method, payment_reference, description, " +
                    "related_reservation_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, transaction.getUserId());
            stmt.setString(2, transaction.getTransactionType().name());
            stmt.setBigDecimal(3, transaction.getAmount());
            stmt.setBigDecimal(4, transaction.getBalanceBefore());
            stmt.setBigDecimal(5, transaction.getBalanceAfter());
            stmt.setString(6, transaction.getStatus().name());
            stmt.setString(7, transaction.getPaymentMethod());
            stmt.setString(8, transaction.getPaymentReference());
            stmt.setString(9, transaction.getDescription());
            stmt.setObject(10, transaction.getRelatedReservationId());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    transaction.setTransactionId(generatedKeys.getInt(1));
                    return transaction;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get user's wallet balance
    public BigDecimal getUserWalletBalance(int userId) {
        String sql = "SELECT wallet_balance FROM users WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("wallet_balance");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    // Update user wallet balance
    public boolean updateUserWalletBalance(int userId, BigDecimal newBalance) {
        String sql = "UPDATE users SET wallet_balance = ? WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBigDecimal(1, newBalance);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update user pending wallet balance
    public boolean updateUserPendingBalance(int userId, BigDecimal newPendingBalance) {
        String sql = "UPDATE users SET wallet_pending_balance = ? WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setBigDecimal(1, newPendingBalance);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get pending top-up transactions
    public List<WalletTransaction> getPendingTopups() {
        List<WalletTransaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM wallet_transactions WHERE transaction_type = 'TOPUP' " +
                    "AND status = 'PENDING' ORDER BY created_at DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                transactions.add(mapResultSetToTransaction(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }
    
    // Get user's transaction history
    public List<WalletTransaction> getUserTransactions(int userId) {
        List<WalletTransaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM wallet_transactions WHERE user_id = ? ORDER BY created_at DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                transactions.add(mapResultSetToTransaction(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }
    
    // Approve a pending transaction
    public boolean approveTransaction(int transactionId, int approvedBy) {
        String sql = "UPDATE wallet_transactions SET status = 'APPROVED', approved_by = ?, " +
                    "approved_at = CURRENT_TIMESTAMP WHERE transaction_id = ? AND status = 'PENDING'";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, approvedBy);
            stmt.setInt(2, transactionId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Reject a pending transaction
    public boolean rejectTransaction(int transactionId, int rejectedBy) {
        String sql = "UPDATE wallet_transactions SET status = 'REJECTED', approved_by = ?, " +
                    "approved_at = CURRENT_TIMESTAMP WHERE transaction_id = ? AND status = 'PENDING'";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, rejectedBy);
            stmt.setInt(2, transactionId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get transaction by ID
    public WalletTransaction getTransactionById(int transactionId) {
        String sql = "SELECT * FROM wallet_transactions WHERE transaction_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, transactionId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToTransaction(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Map ResultSet to WalletTransaction object
    private WalletTransaction mapResultSetToTransaction(ResultSet rs) throws SQLException {
        WalletTransaction transaction = new WalletTransaction();
        transaction.setTransactionId(rs.getInt("transaction_id"));
        transaction.setUserId(rs.getInt("user_id"));
        transaction.setTransactionType(WalletTransaction.TransactionType.valueOf(rs.getString("transaction_type")));
        transaction.setAmount(rs.getBigDecimal("amount"));
        transaction.setBalanceBefore(rs.getBigDecimal("balance_before"));
        transaction.setBalanceAfter(rs.getBigDecimal("balance_after"));
        transaction.setStatus(WalletTransaction.TransactionStatus.valueOf(rs.getString("status")));
        transaction.setPaymentMethod(rs.getString("payment_method"));
        transaction.setPaymentReference(rs.getString("payment_reference"));
        transaction.setDescription(rs.getString("description"));
        transaction.setApprovedBy((Integer) rs.getObject("approved_by"));
        transaction.setApprovedAt(rs.getTimestamp("approved_at"));
        transaction.setRelatedReservationId((Integer) rs.getObject("related_reservation_id"));
        transaction.setCreatedAt(rs.getTimestamp("created_at"));
        return transaction;
    }
}

