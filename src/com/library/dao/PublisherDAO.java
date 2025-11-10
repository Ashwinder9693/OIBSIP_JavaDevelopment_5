package com.library.dao;

import com.library.entity.Publisher;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PublisherDAO {
    private Connection connection;
    
    public PublisherDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    public List<Publisher> getAllPublishers() {
        List<Publisher> publishers = new ArrayList<>();
        String sql = "SELECT * FROM publishers WHERE is_active = TRUE ORDER BY name";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                publishers.add(mapResultSetToPublisher(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return publishers;
    }
    
    public Publisher getPublisherById(int publisherId) {
        String sql = "SELECT * FROM publishers WHERE publisher_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, publisherId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToPublisher(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Publisher getPublisherByName(String name) {
        String sql = "SELECT * FROM publishers WHERE name = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToPublisher(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addPublisher(Publisher publisher) {
        String sql = "INSERT INTO publishers (name, country, website, email, phone, founded_year, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, publisher.getName());
            stmt.setString(2, publisher.getCountry());
            stmt.setString(3, publisher.getWebsite());
            stmt.setString(4, publisher.getEmail());
            stmt.setString(5, publisher.getPhone());
            stmt.setObject(6, publisher.getFoundedYear());
            stmt.setBoolean(7, publisher.isActive());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    publisher.setPublisherId(generatedKeys.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updatePublisher(Publisher publisher) {
        String sql = "UPDATE publishers SET name=?, country=?, website=?, email=?, phone=?, founded_year=?, is_active=? WHERE publisher_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, publisher.getName());
            stmt.setString(2, publisher.getCountry());
            stmt.setString(3, publisher.getWebsite());
            stmt.setString(4, publisher.getEmail());
            stmt.setString(5, publisher.getPhone());
            stmt.setObject(6, publisher.getFoundedYear());
            stmt.setBoolean(7, publisher.isActive());
            stmt.setInt(8, publisher.getPublisherId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deletePublisher(int publisherId) {
        String sql = "UPDATE publishers SET is_active = FALSE WHERE publisher_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, publisherId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Publisher mapResultSetToPublisher(ResultSet rs) throws SQLException {
        Publisher publisher = new Publisher();
        publisher.setPublisherId(rs.getInt("publisher_id"));
        publisher.setName(rs.getString("name"));
        publisher.setCountry(rs.getString("country"));
        publisher.setWebsite(rs.getString("website"));
        publisher.setEmail(rs.getString("email"));
        publisher.setPhone(rs.getString("phone"));
        
        Integer foundedYear = rs.getInt("founded_year");
        if (!rs.wasNull()) {
            publisher.setFoundedYear(foundedYear);
        }
        
        publisher.setActive(rs.getBoolean("is_active"));
        publisher.setCreatedAt(rs.getTimestamp("created_at"));
        return publisher;
    }
}

