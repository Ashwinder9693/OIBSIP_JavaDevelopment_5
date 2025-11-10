package com.library.dao;

import com.library.entity.BookReview;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookReviewDAO {
    private Connection connection;
    
    public BookReviewDAO() {
        this.connection = DatabaseConnection.getConnection();
    }
    
    public List<BookReview> getReviewsByBookId(int bookId) {
        List<BookReview> reviews = new ArrayList<>();
        String sql = "SELECT * FROM book_reviews WHERE book_id = ? ORDER BY created_at DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reviews.add(mapResultSetToReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }
    
    public List<BookReview> getReviewsByUserId(int userId) {
        List<BookReview> reviews = new ArrayList<>();
        String sql = "SELECT * FROM book_reviews WHERE user_id = ? ORDER BY created_at DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reviews.add(mapResultSetToReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }
    
    public BookReview getReviewById(int reviewId) {
        String sql = "SELECT * FROM book_reviews WHERE review_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, reviewId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToReview(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public BookReview getReviewByBookAndUser(int bookId, int userId) {
        String sql = "SELECT * FROM book_reviews WHERE book_id = ? AND user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToReview(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addReview(BookReview review) {
        String sql = "INSERT INTO book_reviews (book_id, user_id, rating, review_title, review_text, is_verified_purchase) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, review.getBookId());
            stmt.setInt(2, review.getUserId());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getReviewTitle());
            stmt.setString(5, review.getReviewText());
            stmt.setBoolean(6, review.isVerifiedPurchase());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    review.setReviewId(generatedKeys.getInt(1));
                    // Update book rating
                    updateBookRating(review.getBookId());
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateReview(BookReview review) {
        String sql = "UPDATE book_reviews SET rating=?, review_title=?, review_text=?, is_verified_purchase=? WHERE review_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, review.getRating());
            stmt.setString(2, review.getReviewTitle());
            stmt.setString(3, review.getReviewText());
            stmt.setBoolean(4, review.isVerifiedPurchase());
            stmt.setInt(5, review.getReviewId());
            
            boolean result = stmt.executeUpdate() > 0;
            if (result) {
                // Update book rating
                updateBookRating(review.getBookId());
            }
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteReview(int reviewId) {
        String sql = "SELECT book_id FROM book_reviews WHERE review_id = ?";
        int bookId = 0;
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, reviewId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                bookId = rs.getInt("book_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        
        sql = "DELETE FROM book_reviews WHERE review_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, reviewId);
            boolean result = stmt.executeUpdate() > 0;
            if (result && bookId > 0) {
                // Update book rating
                updateBookRating(bookId);
            }
            return result;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean incrementHelpfulCount(int reviewId) {
        String sql = "UPDATE book_reviews SET helpful_count = helpful_count + 1 WHERE review_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, reviewId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private void updateBookRating(int bookId) {
        String sql = "UPDATE books SET rating_avg = (SELECT AVG(rating) FROM book_reviews WHERE book_id = ?), " +
                    "rating_count = (SELECT COUNT(*) FROM book_reviews WHERE book_id = ?) WHERE book_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            stmt.setInt(2, bookId);
            stmt.setInt(3, bookId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    private BookReview mapResultSetToReview(ResultSet rs) throws SQLException {
        BookReview review = new BookReview();
        review.setReviewId(rs.getInt("review_id"));
        review.setBookId(rs.getInt("book_id"));
        review.setUserId(rs.getInt("user_id"));
        review.setRating(rs.getInt("rating"));
        review.setReviewTitle(rs.getString("review_title"));
        review.setReviewText(rs.getString("review_text"));
        review.setVerifiedPurchase(rs.getBoolean("is_verified_purchase"));
        review.setHelpfulCount(rs.getInt("helpful_count"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        review.setUpdatedAt(rs.getTimestamp("updated_at"));
        return review;
    }
}

