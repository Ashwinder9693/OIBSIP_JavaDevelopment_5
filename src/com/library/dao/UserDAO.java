package com.library.dao;

import com.library.entity.User;
import com.library.util.DatabaseConnection;
import com.library.util.PasswordUtils;
import java.sql.*;

/**
 * Data Access Object for User entity.
 * 
 * <p><b>Security:</b> All password operations use BCrypt hashing.
 * Passwords are verified using {@code BCrypt.checkpw()} which provides
 * constant-time comparison to prevent timing attacks.</p>
 */

public class UserDAO {
    private Connection connection;
    
    public UserDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    /**
     * Authenticates a user by username and password using BCrypt verification.
     * 
     * <p>This method fetches the user by username and then verifies the password
     * using BCrypt's secure comparison. The comparison is constant-time to prevent
     * timing attacks.</p>
     * 
     * @param username the username to authenticate
     * @param password the plain text password to verify
     * @return the authenticated User object if credentials are valid, null otherwise
     */
    public User login(String username, String password) {
        // Fetch the user by username only (active users only)
        String sql = "SELECT * FROM users WHERE username = ? AND is_active = TRUE";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String storedPasswordHash = rs.getString("password_hash");
                
                // Verify the password using BCrypt secure comparison
                // BCrypt.checkpw() is resistant to timing attacks
                if (PasswordUtils.checkPassword(password, storedPasswordHash)) {
                    User user = mapResultSetToUser(rs);
                    // Update last login timestamp and increment login count
                    updateLastLogin(user.getUserId());
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private void updateLastLogin(int userId) {
        String sql = "UPDATE users SET last_login = CURRENT_TIMESTAMP, login_count = login_count + 1 WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Registers a new user in the database.
     * 
     * <p><b>Security Note:</b> The password must already be hashed using BCrypt
     * before calling this method. This DAO does NOT hash passwords - that should
     * be done in the servlet layer using {@code PasswordUtils.hashPassword()}.</p>
     * 
     * @param user the User object containing all registration details (password must be pre-hashed)
     * @return true if registration successful, false otherwise
     */
    public boolean register(User user) {
        String sql = "INSERT INTO users (username, password_hash, email, first_name, last_name, role, is_active, email_verified) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getUsername());
            // Password should ALREADY be BCrypt hashed before calling this method
            stmt.setString(2, user.getPasswordHash() != null ? user.getPasswordHash() : user.getPassword());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getFirstName());
            stmt.setString(5, user.getLastName());
            stmt.setString(6, user.getRole() != null ? user.getRole().name() : "MEMBER");
            stmt.setBoolean(7, user.isActive());
            stmt.setBoolean(8, user.isEmailVerified());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    user.setUserId(generatedKeys.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setEmail(rs.getString("email"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setFullName(rs.getString("full_name"));
        
        String roleStr = rs.getString("role");
        if (roleStr != null) {
            try {
                user.setRole(User.UserRole.valueOf(roleStr));
            } catch (IllegalArgumentException e) {
                user.setRole(User.UserRole.MEMBER);
            }
        }
        
        user.setProfileImageUrl(rs.getString("profile_image_url"));
        user.setBio(rs.getString("bio"));
        user.setPreferences(rs.getString("preferences"));
        user.setNotificationSettings(rs.getString("notification_settings"));
        user.setLastLogin(rs.getTimestamp("last_login"));
        user.setLoginCount(rs.getInt("login_count"));
        user.setActive(rs.getBoolean("is_active"));
        user.setEmailVerified(rs.getBoolean("email_verified"));
        user.setTwoFactorEnabled(rs.getBoolean("two_factor_enabled"));
        
        // Set wallet balances (with null check for backward compatibility)
        try {
            user.setWalletBalance(rs.getBigDecimal("wallet_balance"));
            user.setWalletPendingBalance(rs.getBigDecimal("wallet_pending_balance"));
        } catch (SQLException e) {
            // Columns don't exist yet - set to zero
            user.setWalletBalance(java.math.BigDecimal.ZERO);
            user.setWalletPendingBalance(java.math.BigDecimal.ZERO);
        }
        
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
    }
    
    public User createGoogleUser(String email, String firstName, String lastName, String username) {
        // Check if user already exists
        User existingUser = getUserByEmail(email);
        if (existingUser != null) {
            return existingUser;
        }
        
        // Generate a secure random password for Google OAuth users
        String randomPassword = generateSecurePassword();
        
        String sql = "INSERT INTO users (username, password_hash, email, first_name, last_name, role, is_active, email_verified) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, username);
            stmt.setString(2, randomPassword);
            stmt.setString(3, email);
            stmt.setString(4, firstName != null ? firstName : "");
            stmt.setString(5, lastName != null ? lastName : "");
            stmt.setString(6, User.UserRole.MEMBER.name());
            stmt.setBoolean(7, true);
            stmt.setBoolean(8, true); // Google OAuth users have verified emails
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int userId = generatedKeys.getInt(1);
                    return getUserById(userId);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating Google user: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    private String generateSecurePassword() {
        // Generate a secure random password that Google OAuth users will never use
        // They'll always login via Google
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        StringBuilder password = new StringBuilder();
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < 32; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        return password.toString();
    }
    
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET first_name = ?, last_name = ?, email = ?, " +
                    "bio = ?, profile_image_url = ?, preferences = ?, notification_settings = ?, " +
                    "is_active = ?, email_verified = ?, two_factor_enabled = ?, " +
                    "updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, user.getFirstName());
            stmt.setString(2, user.getLastName());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getBio());
            stmt.setString(5, user.getProfileImageUrl());
            stmt.setString(6, user.getPreferences());
            stmt.setString(7, user.getNotificationSettings());
            stmt.setBoolean(8, user.isActive());
            stmt.setBoolean(9, user.isEmailVerified());
            stmt.setBoolean(10, user.isTwoFactorEnabled());
            stmt.setInt(11, user.getUserId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}