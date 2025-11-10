package com.library.dao;

import com.library.entity.Reservation;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {
    private Connection connection;
    
    public ReservationDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    public Reservation createReservation(Reservation reservation) {
        String sql = "INSERT INTO reservations (book_id, user_id, member_id, branch_id, reservation_status, " +
                    "reservation_date, start_date, end_date, number_of_days, price_per_day, total_amount, " +
                    "fine_amount, days_overdue) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, reservation.getBookId());
            stmt.setInt(2, reservation.getUserId());
            stmt.setInt(3, reservation.getMemberId());
            stmt.setObject(4, reservation.getBranchId());
            stmt.setString(5, reservation.getReservationStatus().name());
            stmt.setTimestamp(6, reservation.getReservationDate());
            stmt.setDate(7, reservation.getStartDate());
            stmt.setDate(8, reservation.getEndDate());
            stmt.setInt(9, reservation.getNumberOfDays());
            stmt.setBigDecimal(10, reservation.getPricePerDay());
            stmt.setBigDecimal(11, reservation.getTotalAmount());
            stmt.setBigDecimal(12, reservation.getFineAmount());
            stmt.setInt(13, reservation.getDaysOverdue());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    reservation.setReservationId(generatedKeys.getInt(1));
                    return reservation;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating reservation: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    public Reservation getReservationById(int reservationId) {
        String sql = "SELECT * FROM reservations WHERE reservation_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToReservation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Reservation> getReservationsByUserId(int userId) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE user_id = ? ORDER BY reservation_date DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }
    
    public List<Reservation> getActiveReservationsByUserId(int userId) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE user_id = ? AND reservation_status IN ('PENDING', 'ACTIVE') ORDER BY start_date ASC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }
    
    public boolean updateReservation(Reservation reservation) {
        String sql = "UPDATE reservations SET reservation_status=?, actual_return_date=?, fine_amount=?, " +
                    "days_overdue=?, reminder_sent_count=?, last_reminder_sent=?, cancellation_reason=?, notes=? " +
                    "WHERE reservation_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, reservation.getReservationStatus().name());
            if (reservation.getActualReturnDate() != null) {
                stmt.setDate(2, reservation.getActualReturnDate());
            } else {
                stmt.setNull(2, Types.DATE);
            }
            stmt.setBigDecimal(3, reservation.getFineAmount());
            stmt.setInt(4, reservation.getDaysOverdue());
            stmt.setInt(5, reservation.getReminderSentCount());
            if (reservation.getLastReminderSent() != null) {
                stmt.setTimestamp(6, reservation.getLastReminderSent());
            } else {
                stmt.setNull(6, Types.TIMESTAMP);
            }
            stmt.setString(7, reservation.getCancellationReason());
            stmt.setString(8, reservation.getNotes());
            stmt.setInt(9, reservation.getReservationId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Reservation> getOverdueReservations() {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE end_date < CURDATE() AND reservation_status = 'ACTIVE'";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }
    
    public boolean returnBook(int reservationId, Date returnDate) {
        String sql = "UPDATE reservations SET return_date=?, reservation_status='RETURNED' WHERE reservation_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, returnDate);
            stmt.setInt(2, reservationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation();
        reservation.setReservationId(rs.getInt("reservation_id"));
        reservation.setBookId(rs.getInt("book_id"));
        reservation.setUserId(rs.getInt("user_id"));
        reservation.setMemberId(rs.getInt("member_id"));
        
        Integer branchId = rs.getInt("branch_id");
        if (!rs.wasNull()) {
            reservation.setBranchId(branchId);
        }
        
        String statusStr = rs.getString("reservation_status");
        if (statusStr != null) {
            try {
                reservation.setReservationStatus(Reservation.ReservationStatus.valueOf(statusStr));
            } catch (IllegalArgumentException e) {
                reservation.setReservationStatus(Reservation.ReservationStatus.PENDING);
            }
        }
        
        reservation.setReservationDate(rs.getTimestamp("reservation_date"));
        reservation.setStartDate(rs.getDate("start_date"));
        reservation.setEndDate(rs.getDate("end_date"));
        
        Date actualReturnDate = rs.getDate("actual_return_date");
        if (actualReturnDate != null) {
            reservation.setActualReturnDate(actualReturnDate);
        }
        
        reservation.setNumberOfDays(rs.getInt("number_of_days"));
        reservation.setPricePerDay(rs.getBigDecimal("price_per_day"));
        reservation.setTotalAmount(rs.getBigDecimal("total_amount"));
        reservation.setFineAmount(rs.getBigDecimal("fine_amount"));
        reservation.setDaysOverdue(rs.getInt("days_overdue"));
        reservation.setReminderSentCount(rs.getInt("reminder_sent_count"));
        reservation.setLastReminderSent(rs.getTimestamp("last_reminder_sent"));
        reservation.setCancellationReason(rs.getString("cancellation_reason"));
        reservation.setNotes(rs.getString("notes"));
        reservation.setCreatedAt(rs.getTimestamp("created_at"));
        reservation.setUpdatedAt(rs.getTimestamp("updated_at"));
        return reservation;
    }
}

