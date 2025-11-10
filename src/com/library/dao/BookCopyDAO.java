package com.library.dao;

import com.library.entity.BookCopy;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookCopyDAO {
    private Connection connection;
    
    public BookCopyDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    public List<BookCopy> getAllBookCopies() {
        List<BookCopy> copies = new ArrayList<>();
        String sql = "SELECT * FROM book_copies ORDER BY book_id, copy_id";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                copies.add(mapResultSetToBookCopy(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return copies;
    }
    
    public BookCopy getBookCopyById(int copyId) {
        String sql = "SELECT * FROM book_copies WHERE copy_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, copyId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToBookCopy(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public BookCopy getBookCopyByBarcode(String barcode) {
        String sql = "SELECT * FROM book_copies WHERE barcode = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, barcode);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToBookCopy(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<BookCopy> getBookCopiesByBookId(int bookId) {
        List<BookCopy> copies = new ArrayList<>();
        String sql = "SELECT * FROM book_copies WHERE book_id = ? ORDER BY copy_id";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                copies.add(mapResultSetToBookCopy(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return copies;
    }
    
    public List<BookCopy> getAvailableBookCopiesByBookId(int bookId) {
        List<BookCopy> copies = new ArrayList<>();
        String sql = "SELECT * FROM book_copies WHERE book_id = ? AND copy_status = 'AVAILABLE' ORDER BY copy_id";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                copies.add(mapResultSetToBookCopy(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return copies;
    }
    
    public List<BookCopy> getBookCopiesByBranchId(int branchId) {
        List<BookCopy> copies = new ArrayList<>();
        String sql = "SELECT * FROM book_copies WHERE branch_id = ? ORDER BY book_id, copy_id";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, branchId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                copies.add(mapResultSetToBookCopy(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return copies;
    }
    
    public boolean addBookCopy(BookCopy copy) {
        String sql = "INSERT INTO book_copies (book_id, branch_id, barcode, rfid_tag, condition_note, copy_status, acquisition_date, acquisition_source, acquisition_cost, location_shelf, is_reference_only) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, copy.getBookId());
            stmt.setObject(2, copy.getBranchId());
            stmt.setString(3, copy.getBarcode());
            stmt.setString(4, copy.getRfidTag());
            stmt.setString(5, copy.getConditionNote());
            stmt.setString(6, copy.getCopyStatus().name());
            stmt.setDate(7, copy.getAcquisitionDate());
            stmt.setString(8, copy.getAcquisitionSource());
            stmt.setBigDecimal(9, copy.getAcquisitionCost());
            stmt.setString(10, copy.getLocationShelf());
            stmt.setBoolean(11, copy.isReferenceOnly());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    copy.setCopyId(generatedKeys.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateBookCopy(BookCopy copy) {
        String sql = "UPDATE book_copies SET book_id=?, branch_id=?, barcode=?, rfid_tag=?, condition_note=?, copy_status=?, acquisition_date=?, acquisition_source=?, acquisition_cost=?, last_maintenance_date=?, is_reference_only=?, location_shelf=? WHERE copy_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, copy.getBookId());
            stmt.setObject(2, copy.getBranchId());
            stmt.setString(3, copy.getBarcode());
            stmt.setString(4, copy.getRfidTag());
            stmt.setString(5, copy.getConditionNote());
            stmt.setString(6, copy.getCopyStatus().name());
            stmt.setDate(7, copy.getAcquisitionDate());
            stmt.setString(8, copy.getAcquisitionSource());
            stmt.setBigDecimal(9, copy.getAcquisitionCost());
            stmt.setDate(10, copy.getLastMaintenanceDate());
            stmt.setBoolean(11, copy.isReferenceOnly());
            stmt.setString(12, copy.getLocationShelf());
            stmt.setInt(13, copy.getCopyId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateBookCopyStatus(int copyId, BookCopy.CopyStatus status) {
        String sql = "UPDATE book_copies SET copy_status = ? WHERE copy_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            stmt.setInt(2, copyId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteBookCopy(int copyId) {
        String sql = "DELETE FROM book_copies WHERE copy_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, copyId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private BookCopy mapResultSetToBookCopy(ResultSet rs) throws SQLException {
        BookCopy copy = new BookCopy();
        copy.setCopyId(rs.getInt("copy_id"));
        copy.setBookId(rs.getInt("book_id"));
        
        Integer branchId = rs.getInt("branch_id");
        if (!rs.wasNull()) {
            copy.setBranchId(branchId);
        }
        
        copy.setBarcode(rs.getString("barcode"));
        copy.setRfidTag(rs.getString("rfid_tag"));
        copy.setConditionNote(rs.getString("condition_note"));
        copy.setCopyStatus(BookCopy.CopyStatus.valueOf(rs.getString("copy_status")));
        copy.setAcquisitionDate(rs.getDate("acquisition_date"));
        copy.setAcquisitionSource(rs.getString("acquisition_source"));
        copy.setAcquisitionCost(rs.getBigDecimal("acquisition_cost"));
        copy.setLastMaintenanceDate(rs.getDate("last_maintenance_date"));
        copy.setTotalIssues(rs.getInt("total_issues"));
        copy.setReferenceOnly(rs.getBoolean("is_reference_only"));
        copy.setLocationShelf(rs.getString("location_shelf"));
        copy.setCreatedAt(rs.getTimestamp("created_at"));
        copy.setUpdatedAt(rs.getTimestamp("updated_at"));
        return copy;
    }
}

