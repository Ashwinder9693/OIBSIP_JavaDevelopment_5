package com.library.dao;

import com.library.entity.Branch;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BranchDAO {
    private Connection connection;
    
    public BranchDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    public List<Branch> getAllBranches() {
        List<Branch> branches = new ArrayList<>();
        String sql = "SELECT * FROM branches WHERE is_active = TRUE ORDER BY name";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                branches.add(mapResultSetToBranch(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return branches;
    }
    
    public Branch getBranchById(int branchId) {
        String sql = "SELECT * FROM branches WHERE branch_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, branchId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToBranch(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Branch getBranchByCode(String code) {
        String sql = "SELECT * FROM branches WHERE code = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, code);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToBranch(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addBranch(Branch branch) {
        String sql = "INSERT INTO branches (name, code, address, city, state, zip_code, country, phone, email, manager_id, operating_hours, total_capacity, parking_available, wifi_available, facilities, latitude, longitude, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, branch.getName());
            stmt.setString(2, branch.getCode());
            stmt.setString(3, branch.getAddress());
            stmt.setString(4, branch.getCity());
            stmt.setString(5, branch.getState());
            stmt.setString(6, branch.getZipCode());
            stmt.setString(7, branch.getCountry());
            stmt.setString(8, branch.getPhone());
            stmt.setString(9, branch.getEmail());
            stmt.setObject(10, branch.getManagerId());
            stmt.setString(11, branch.getOperatingHours());
            stmt.setObject(12, branch.getTotalCapacity());
            stmt.setBoolean(13, branch.isParkingAvailable());
            stmt.setBoolean(14, branch.isWifiAvailable());
            stmt.setString(15, branch.getFacilities());
            stmt.setBigDecimal(16, branch.getLatitude());
            stmt.setBigDecimal(17, branch.getLongitude());
            stmt.setBoolean(18, branch.isActive());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    branch.setBranchId(generatedKeys.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateBranch(Branch branch) {
        String sql = "UPDATE branches SET name=?, code=?, address=?, city=?, state=?, zip_code=?, country=?, phone=?, email=?, manager_id=?, operating_hours=?, total_capacity=?, parking_available=?, wifi_available=?, facilities=?, latitude=?, longitude=?, is_active=? WHERE branch_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, branch.getName());
            stmt.setString(2, branch.getCode());
            stmt.setString(3, branch.getAddress());
            stmt.setString(4, branch.getCity());
            stmt.setString(5, branch.getState());
            stmt.setString(6, branch.getZipCode());
            stmt.setString(7, branch.getCountry());
            stmt.setString(8, branch.getPhone());
            stmt.setString(9, branch.getEmail());
            stmt.setObject(10, branch.getManagerId());
            stmt.setString(11, branch.getOperatingHours());
            stmt.setObject(12, branch.getTotalCapacity());
            stmt.setBoolean(13, branch.isParkingAvailable());
            stmt.setBoolean(14, branch.isWifiAvailable());
            stmt.setString(15, branch.getFacilities());
            stmt.setBigDecimal(16, branch.getLatitude());
            stmt.setBigDecimal(17, branch.getLongitude());
            stmt.setBoolean(18, branch.isActive());
            stmt.setInt(19, branch.getBranchId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteBranch(int branchId) {
        String sql = "UPDATE branches SET is_active = FALSE WHERE branch_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, branchId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Branch mapResultSetToBranch(ResultSet rs) throws SQLException {
        Branch branch = new Branch();
        branch.setBranchId(rs.getInt("branch_id"));
        branch.setName(rs.getString("name"));
        branch.setCode(rs.getString("code"));
        branch.setAddress(rs.getString("address"));
        branch.setCity(rs.getString("city"));
        branch.setState(rs.getString("state"));
        branch.setZipCode(rs.getString("zip_code"));
        branch.setCountry(rs.getString("country"));
        branch.setPhone(rs.getString("phone"));
        branch.setEmail(rs.getString("email"));
        
        Integer managerId = rs.getInt("manager_id");
        if (!rs.wasNull()) {
            branch.setManagerId(managerId);
        }
        
        branch.setOperatingHours(rs.getString("operating_hours"));
        
        Integer totalCapacity = rs.getInt("total_capacity");
        if (!rs.wasNull()) {
            branch.setTotalCapacity(totalCapacity);
        }
        
        branch.setParkingAvailable(rs.getBoolean("parking_available"));
        branch.setWifiAvailable(rs.getBoolean("wifi_available"));
        branch.setFacilities(rs.getString("facilities"));
        branch.setLatitude(rs.getBigDecimal("latitude"));
        branch.setLongitude(rs.getBigDecimal("longitude"));
        branch.setActive(rs.getBoolean("is_active"));
        branch.setCreatedAt(rs.getTimestamp("created_at"));
        return branch;
    }
}

