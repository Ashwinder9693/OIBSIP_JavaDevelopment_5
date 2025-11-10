package com.library.dao;

import com.library.entity.IssueReturn;
import com.library.entity.IssueReturn.TransactionStatus;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IssueReturnDAO {
    private Connection connection;
    
    public IssueReturnDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    public boolean issueBook(IssueReturn transaction) {
        String sql = "INSERT INTO issue_return (book_id, copy_id, member_id, branch_id, issued_by, status, issue_date, due_date, condition_at_issue) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, transaction.getBookId());
            stmt.setObject(2, transaction.getCopyId());
            stmt.setInt(3, transaction.getMemberId());
            stmt.setObject(4, transaction.getBranchId());
            stmt.setInt(5, transaction.getIssuedBy());
            stmt.setString(6, transaction.getStatus().name());
            stmt.setTimestamp(7, transaction.getIssueDate());
            stmt.setDate(8, transaction.getDueDate());
            stmt.setString(9, transaction.getConditionAtIssue() != null ? transaction.getConditionAtIssue().name() : "GOOD");
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                // Update book available quantity
                updateBookQuantity(transaction.getBookId(), -1);
                
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    transaction.setTransactionId(generatedKeys.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean returnBook(int transactionId, Timestamp returnDate, int returnedTo) {
        String sql = "UPDATE issue_return SET return_date=?, returned_to=?, status=?, condition_at_return=? WHERE transaction_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setTimestamp(1, returnDate);
            stmt.setInt(2, returnedTo);
            stmt.setString(3, TransactionStatus.RETURNED.name());
            stmt.setString(4, "GOOD"); // Default condition, can be enhanced to accept parameter
            stmt.setInt(5, transactionId);
            
            if (stmt.executeUpdate() > 0) {
                // Get the book ID from the transaction
                IssueReturn transaction = getTransactionById(transactionId);
                if (transaction != null) {
                    // Update book available quantity
                    return updateBookQuantity(transaction.getBookId(), 1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private boolean updateBookQuantity(int bookId, int change) {
        String sql = "UPDATE books SET available_copies = available_copies + ? WHERE book_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, change);
            stmt.setInt(2, bookId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<IssueReturn> getAllIssuedBooks() {
        List<IssueReturn> transactions = new ArrayList<>();
        String sql = "SELECT * FROM issue_return WHERE status = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, TransactionStatus.ISSUED.name());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                transactions.add(mapResultSetToTransaction(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }
    
    public List<IssueReturn> getBooksByMember(int memberId) {
        List<IssueReturn> transactions = new ArrayList<>();
        String sql = "SELECT * FROM issue_return WHERE member_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, memberId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                transactions.add(mapResultSetToTransaction(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }
    
    public List<IssueReturn> getCurrentlyIssuedBooksByMember(int memberId) {
        List<IssueReturn> transactions = new ArrayList<>();
        String sql = "SELECT * FROM issue_return WHERE member_id = ? AND status = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, memberId);
            stmt.setString(2, TransactionStatus.ISSUED.name());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                transactions.add(mapResultSetToTransaction(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }
    
    public List<IssueReturn> getOverdueBooks() {
        List<IssueReturn> transactions = new ArrayList<>();
        String sql = "SELECT * FROM issue_return WHERE status = ? AND due_date < CURRENT_DATE";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, TransactionStatus.ISSUED.name());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                transactions.add(mapResultSetToTransaction(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }
    
    public IssueReturn getTransactionById(int transactionId) {
        String sql = "SELECT * FROM issue_return WHERE transaction_id = ?";
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
    
    public List<IssueReturn> getAllTransactions() {
        List<IssueReturn> transactions = new ArrayList<>();
        String sql = "SELECT * FROM issue_return";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                transactions.add(mapResultSetToTransaction(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }
    
    private IssueReturn mapResultSetToTransaction(ResultSet rs) throws SQLException {
        IssueReturn transaction = new IssueReturn();
        transaction.setTransactionId(rs.getInt("transaction_id"));
        transaction.setBookId(rs.getInt("book_id"));
        
        Integer copyId = rs.getInt("copy_id");
        if (!rs.wasNull()) {
            transaction.setCopyId(copyId);
        }
        
        transaction.setMemberId(rs.getInt("member_id"));
        
        Integer branchId = rs.getInt("branch_id");
        if (!rs.wasNull()) {
            transaction.setBranchId(branchId);
        }
        
        transaction.setIssuedBy(rs.getInt("issued_by"));
        
        Integer returnedTo = rs.getInt("returned_to");
        if (!rs.wasNull()) {
            transaction.setReturnedTo(returnedTo);
        }
        
        String statusStr = rs.getString("status");
        if (statusStr != null) {
            try {
                transaction.setStatus(TransactionStatus.valueOf(statusStr));
            } catch (IllegalArgumentException e) {
                transaction.setStatus(TransactionStatus.ISSUED);
            }
        }
        
        transaction.setIssueDate(rs.getTimestamp("issue_date"));
        transaction.setDueDate(rs.getDate("due_date"));
        transaction.setReturnDate(rs.getTimestamp("return_date"));
        transaction.setExtendedCount(rs.getInt("extended_count"));
        transaction.setLastExtendedDate(rs.getDate("last_extended_date"));
        transaction.setFineAmount(rs.getBigDecimal("fine_amount"));
        
        String conditionAtIssueStr = rs.getString("condition_at_issue");
        if (conditionAtIssueStr != null) {
            try {
                transaction.setConditionAtIssue(IssueReturn.Condition.valueOf(conditionAtIssueStr));
            } catch (IllegalArgumentException e) {
                transaction.setConditionAtIssue(IssueReturn.Condition.GOOD);
            }
        }
        
        String conditionAtReturnStr = rs.getString("condition_at_return");
        if (conditionAtReturnStr != null) {
            try {
                transaction.setConditionAtReturn(IssueReturn.Condition.valueOf(conditionAtReturnStr));
            } catch (IllegalArgumentException e) {
                // Leave as null if invalid
            }
        }
        
        transaction.setNotes(rs.getString("notes"));
        transaction.setCreatedAt(rs.getTimestamp("created_at"));
        transaction.setUpdatedAt(rs.getTimestamp("updated_at"));
        return transaction;
    }
}