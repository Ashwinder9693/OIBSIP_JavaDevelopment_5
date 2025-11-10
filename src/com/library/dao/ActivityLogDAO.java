package com.library.dao;

import com.library.entity.ActivityLog;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ActivityLogDAO {
    private Connection connection;
    
    public ActivityLogDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    public List<ActivityLog> getActivityLogs(int limit) {
        List<ActivityLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM activity_logs ORDER BY created_at DESC LIMIT ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                logs.add(mapResultSetToActivityLog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }
    
    public List<ActivityLog> getActivityLogsByUserId(int userId, int limit) {
        List<ActivityLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM activity_logs WHERE user_id = ? ORDER BY created_at DESC LIMIT ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                logs.add(mapResultSetToActivityLog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }
    
    public List<ActivityLog> getActivityLogsByType(String activityType, int limit) {
        List<ActivityLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM activity_logs WHERE activity_type = ? ORDER BY created_at DESC LIMIT ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, activityType);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                logs.add(mapResultSetToActivityLog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }
    
    public List<ActivityLog> getActivityLogsByEntity(String entityType, int entityId, int limit) {
        List<ActivityLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM activity_logs WHERE entity_type = ? AND entity_id = ? ORDER BY created_at DESC LIMIT ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, entityType);
            stmt.setInt(2, entityId);
            stmt.setInt(3, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                logs.add(mapResultSetToActivityLog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }
    
    public boolean addActivityLog(ActivityLog log) {
        String sql = "INSERT INTO activity_logs (user_id, activity_type, entity_type, entity_id, action, description, ip_address, user_agent) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setObject(1, log.getUserId());
            stmt.setString(2, log.getActivityType());
            stmt.setString(3, log.getEntityType());
            stmt.setObject(4, log.getEntityId());
            stmt.setString(5, log.getAction());
            stmt.setString(6, log.getDescription());
            stmt.setString(7, log.getIpAddress());
            stmt.setString(8, log.getUserAgent());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    log.setLogId(generatedKeys.getLong(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteOldLogs(int daysOld) {
        String sql = "DELETE FROM activity_logs WHERE created_at < DATE_SUB(NOW(), INTERVAL ? DAY)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, daysOld);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private ActivityLog mapResultSetToActivityLog(ResultSet rs) throws SQLException {
        ActivityLog log = new ActivityLog();
        log.setLogId(rs.getLong("log_id"));
        
        Integer userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            log.setUserId(userId);
        }
        
        log.setActivityType(rs.getString("activity_type"));
        log.setEntityType(rs.getString("entity_type"));
        
        Integer entityId = rs.getInt("entity_id");
        if (!rs.wasNull()) {
            log.setEntityId(entityId);
        }
        
        log.setAction(rs.getString("action"));
        log.setDescription(rs.getString("description"));
        log.setIpAddress(rs.getString("ip_address"));
        log.setUserAgent(rs.getString("user_agent"));
        log.setCreatedAt(rs.getTimestamp("created_at"));
        return log;
    }
}

