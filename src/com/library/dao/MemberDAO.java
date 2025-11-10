package com.library.dao;

import com.library.entity.Member;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {
    private Connection connection;
    
    public MemberDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    public List<Member> getAllMembers() {
        List<Member> members = new ArrayList<>();
        String sql = "SELECT * FROM members ORDER BY member_id";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                members.add(mapResultSetToMember(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return members;
    }
    
    public Member getMemberById(int memberId) {
        String sql = "SELECT * FROM members WHERE member_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, memberId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToMember(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Member getMemberByUserId(int userId) {
        String sql = "SELECT * FROM members WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToMember(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Member> searchMembers(String keyword) {
        List<Member> members = new ArrayList<>();
        String sql = "SELECT m.* FROM members m " +
                    "JOIN users u ON m.user_id = u.user_id " +
                    "WHERE LOWER(u.first_name) LIKE ? OR LOWER(u.last_name) LIKE ? " +
                    "OR LOWER(u.email) LIKE ? OR m.phone LIKE ? OR m.membership_number LIKE ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchTerm = "%" + keyword.toLowerCase() + "%";
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            stmt.setString(3, searchTerm);
            stmt.setString(4, searchTerm);
            stmt.setString(5, searchTerm);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                members.add(mapResultSetToMember(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return members;
    }
    
    public boolean addMember(Member member) {
        String sql = "INSERT INTO members (user_id, membership_number, membership_type, join_date, expiry_date, " +
                    "max_books_allowed, max_days_allowed, address, city, state, zip_code, country, phone, " +
                    "date_of_birth, gender, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, member.getUserId());
            stmt.setString(2, member.getMembershipNumber());
            stmt.setString(3, member.getMembershipType().name());
            stmt.setDate(4, member.getJoinDate());
            stmt.setDate(5, member.getExpiryDate());
            stmt.setInt(6, member.getMaxBooksAllowed());
            stmt.setInt(7, member.getMaxDaysAllowed());
            stmt.setString(8, member.getAddress());
            stmt.setString(9, member.getCity());
            stmt.setString(10, member.getState());
            stmt.setString(11, member.getZipCode());
            stmt.setString(12, member.getCountry() != null ? member.getCountry() : "USA");
            stmt.setString(13, member.getPhone());
            stmt.setDate(14, member.getDateOfBirth());
            stmt.setString(15, member.getGender() != null ? member.getGender().name() : null);
            stmt.setBoolean(16, member.isActive());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    member.setMemberId(generatedKeys.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateMember(Member member) {
        String sql = "UPDATE members SET membership_number=?, membership_type=?, join_date=?, expiry_date=?, " +
                    "max_books_allowed=?, max_days_allowed=?, address=?, city=?, state=?, zip_code=?, country=?, " +
                    "phone=?, alternate_phone=?, date_of_birth=?, gender=?, occupation=?, organization=?, " +
                    "emergency_contact_name=?, emergency_contact_phone=?, is_active=?, is_blacklisted=?, " +
                    "blacklist_reason=? WHERE member_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, member.getMembershipNumber());
            stmt.setString(2, member.getMembershipType().name());
            stmt.setDate(3, member.getJoinDate());
            stmt.setDate(4, member.getExpiryDate());
            stmt.setInt(5, member.getMaxBooksAllowed());
            stmt.setInt(6, member.getMaxDaysAllowed());
            stmt.setString(7, member.getAddress());
            stmt.setString(8, member.getCity());
            stmt.setString(9, member.getState());
            stmt.setString(10, member.getZipCode());
            stmt.setString(11, member.getCountry());
            stmt.setString(12, member.getPhone());
            stmt.setString(13, member.getAlternatePhone());
            stmt.setDate(14, member.getDateOfBirth());
            stmt.setString(15, member.getGender() != null ? member.getGender().name() : null);
            stmt.setString(16, member.getOccupation());
            stmt.setString(17, member.getOrganization());
            stmt.setString(18, member.getEmergencyContactName());
            stmt.setString(19, member.getEmergencyContactPhone());
            stmt.setBoolean(20, member.isActive());
            stmt.setBoolean(21, member.isBlacklisted());
            stmt.setString(22, member.getBlacklistReason());
            stmt.setInt(23, member.getMemberId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteMember(int memberId) {
        String sql = "UPDATE members SET is_active = FALSE WHERE member_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, memberId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Member mapResultSetToMember(ResultSet rs) throws SQLException {
        Member member = new Member();
        member.setMemberId(rs.getInt("member_id"));
        member.setUserId(rs.getInt("user_id"));
        member.setMembershipNumber(rs.getString("membership_number"));
        
        String membershipTypeStr = rs.getString("membership_type");
        if (membershipTypeStr != null) {
            try {
                member.setMembershipType(Member.MembershipType.valueOf(membershipTypeStr));
            } catch (IllegalArgumentException e) {
                member.setMembershipType(Member.MembershipType.BASIC);
            }
        } else {
            member.setMembershipType(Member.MembershipType.BASIC);
        }
        
        member.setJoinDate(rs.getDate("join_date"));
        member.setExpiryDate(rs.getDate("expiry_date"));
        member.setMaxBooksAllowed(rs.getInt("max_books_allowed"));
        member.setMaxDaysAllowed(rs.getInt("max_days_allowed"));
        member.setAddress(rs.getString("address"));
        member.setCity(rs.getString("city"));
        member.setState(rs.getString("state"));
        member.setZipCode(rs.getString("zip_code"));
        member.setCountry(rs.getString("country"));
        member.setPhone(rs.getString("phone"));
        member.setAlternatePhone(rs.getString("alternate_phone"));
        member.setDateOfBirth(rs.getDate("date_of_birth"));
        
        String genderStr = rs.getString("gender");
        if (genderStr != null) {
            try {
                member.setGender(Member.Gender.valueOf(genderStr));
            } catch (IllegalArgumentException e) {
                // Invalid gender, leave as null
            }
        }
        
        member.setOccupation(rs.getString("occupation"));
        member.setOrganization(rs.getString("organization"));
        member.setEmergencyContactName(rs.getString("emergency_contact_name"));
        member.setEmergencyContactPhone(rs.getString("emergency_contact_phone"));
        member.setTotalBooksBorrowed(rs.getInt("total_books_borrowed"));
        member.setTotalFinesPaid(rs.getBigDecimal("total_fines_paid"));
        member.setOutstandingFines(rs.getBigDecimal("outstanding_fines"));
        member.setActive(rs.getBoolean("is_active"));
        member.setBlacklisted(rs.getBoolean("is_blacklisted"));
        member.setBlacklistReason(rs.getString("blacklist_reason"));
        member.setCreatedAt(rs.getTimestamp("created_at"));
        member.setUpdatedAt(rs.getTimestamp("updated_at"));
        return member;
    }
}
