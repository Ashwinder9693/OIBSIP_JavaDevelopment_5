package com.library.dao;

import com.library.entity.Author;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuthorDAO {
    private Connection connection;
    
    public AuthorDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    public List<Author> getAllAuthors() {
        List<Author> authors = new ArrayList<>();
        String sql = "SELECT * FROM authors ORDER BY last_name, first_name";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                authors.add(mapResultSetToAuthor(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return authors;
    }
    
    public Author getAuthorById(int authorId) {
        String sql = "SELECT * FROM authors WHERE author_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, authorId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToAuthor(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Author> searchAuthors(String keyword) {
        List<Author> authors = new ArrayList<>();
        String sql = "SELECT * FROM authors WHERE LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR LOWER(full_name) LIKE ? ORDER BY last_name, first_name";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchTerm = "%" + keyword.toLowerCase() + "%";
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            stmt.setString(3, searchTerm);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                authors.add(mapResultSetToAuthor(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return authors;
    }
    
    public List<Author> getAuthorsByBookId(int bookId) {
        List<Author> authors = new ArrayList<>();
        String sql = "SELECT a.* FROM authors a " +
                    "INNER JOIN book_authors ba ON a.author_id = ba.author_id " +
                    "WHERE ba.book_id = ? ORDER BY ba.author_order";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                authors.add(mapResultSetToAuthor(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return authors;
    }
    
    public boolean addAuthor(Author author) {
        String sql = "INSERT INTO authors (first_name, last_name, birth_date, death_date, nationality, biography, website, awards) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, author.getFirstName());
            stmt.setString(2, author.getLastName());
            stmt.setDate(3, author.getBirthDate());
            stmt.setDate(4, author.getDeathDate());
            stmt.setString(5, author.getNationality());
            stmt.setString(6, author.getBiography());
            stmt.setString(7, author.getWebsite());
            stmt.setString(8, author.getAwards());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    author.setAuthorId(generatedKeys.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateAuthor(Author author) {
        String sql = "UPDATE authors SET first_name=?, last_name=?, birth_date=?, death_date=?, nationality=?, biography=?, website=?, awards=? WHERE author_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, author.getFirstName());
            stmt.setString(2, author.getLastName());
            stmt.setDate(3, author.getBirthDate());
            stmt.setDate(4, author.getDeathDate());
            stmt.setString(5, author.getNationality());
            stmt.setString(6, author.getBiography());
            stmt.setString(7, author.getWebsite());
            stmt.setString(8, author.getAwards());
            stmt.setInt(9, author.getAuthorId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteAuthor(int authorId) {
        String sql = "DELETE FROM authors WHERE author_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, authorId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Author mapResultSetToAuthor(ResultSet rs) throws SQLException {
        Author author = new Author();
        author.setAuthorId(rs.getInt("author_id"));
        author.setFirstName(rs.getString("first_name"));
        author.setLastName(rs.getString("last_name"));
        author.setFullName(rs.getString("full_name"));
        author.setBirthDate(rs.getDate("birth_date"));
        author.setDeathDate(rs.getDate("death_date"));
        author.setNationality(rs.getString("nationality"));
        author.setBiography(rs.getString("biography"));
        author.setWebsite(rs.getString("website"));
        author.setAwards(rs.getString("awards"));
        author.setCreatedAt(rs.getTimestamp("created_at"));
        return author;
    }
}

