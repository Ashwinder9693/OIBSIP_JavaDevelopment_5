package com.library.dao;

import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookAuthorDAO {
    private Connection connection;
    
    public BookAuthorDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    /**
     * Get primary author name for a book
     */
    public String getPrimaryAuthorName(int bookId) {
        String sql = "SELECT CONCAT(a.first_name, ' ', a.last_name) as author_name " +
                    "FROM book_authors ba " +
                    "JOIN authors a ON ba.author_id = a.author_id " +
                    "WHERE ba.book_id = ? AND ba.author_role = 'PRIMARY_AUTHOR' " +
                    "ORDER BY ba.author_order LIMIT 1";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("author_name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Unknown Author";
    }
    
    /**
     * Get all authors for a book
     */
    public List<String> getAllAuthors(int bookId) {
        List<String> authors = new ArrayList<>();
        String sql = "SELECT CONCAT(a.first_name, ' ', a.last_name) as author_name " +
                    "FROM book_authors ba " +
                    "JOIN authors a ON ba.author_id = a.author_id " +
                    "WHERE ba.book_id = ? " +
                    "ORDER BY ba.author_order";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                authors.add(rs.getString("author_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return authors;
    }
}

