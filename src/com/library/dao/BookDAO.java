package com.library.dao;

import com.library.entity.Book;
import com.library.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    private Connection connection;
    private BookAuthorDAO bookAuthorDAO;
    
    public BookDAO() {
        this.connection = DatabaseConnection.getConnection();
        this.bookAuthorDAO = new BookAuthorDAO();
    }
    
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }
    
    public List<Book> getAvailableBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE available_copies > 0";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }
    
    public List<Book> searchBooks(String keyword) {
        List<Book> books = new ArrayList<>();
        // Search in title, subtitle, description, and ISBN - authors are in separate table
        String sql = "SELECT DISTINCT b.* FROM books b " +
                    "LEFT JOIN book_authors ba ON b.book_id = ba.book_id " +
                    "LEFT JOIN authors a ON ba.author_id = a.author_id " +
                    "WHERE LOWER(b.title) LIKE ? OR LOWER(b.subtitle) LIKE ? OR LOWER(b.description) LIKE ? " +
                    "OR b.isbn LIKE ? OR b.isbn13 LIKE ? OR LOWER(a.first_name) LIKE ? OR LOWER(a.last_name) LIKE ? OR LOWER(a.full_name) LIKE ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchTerm = "%" + keyword.toLowerCase() + "%";
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            stmt.setString(3, searchTerm);
            stmt.setString(4, searchTerm);
            stmt.setString(5, searchTerm);
            stmt.setString(6, searchTerm);
            stmt.setString(7, searchTerm);
            stmt.setString(8, searchTerm);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }
    
    public List<Book> getBooksByCategory(int categoryId) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE category_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }
    
    public Book getBookById(int bookId) {
        String sql = "SELECT * FROM books WHERE book_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToBook(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Book getBookByISBN(String isbn) {
        String sql = "SELECT * FROM books WHERE isbn = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, isbn);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToBook(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addBook(Book book) {
        String sql = "INSERT INTO books (title, subtitle, isbn, isbn13, publisher_id, language_id, edition, pages, " +
                    "format, description, category_id, publication_year, original_publication_year, price, " +
                    "weight_grams, dimensions, total_copies, available_copies, reserved_copies, " +
                    "cover_image_url, is_bestseller, is_featured, age_restriction) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getSubtitle());
            stmt.setString(3, book.getIsbn());
            stmt.setString(4, book.getIsbn13());
            stmt.setObject(5, book.getPublisherId());
            stmt.setObject(6, book.getLanguageId());
            stmt.setString(7, book.getEdition());
            stmt.setObject(8, book.getPages());
            stmt.setString(9, book.getFormat() != null ? book.getFormat().name() : null);
            stmt.setString(10, book.getDescription());
            stmt.setObject(11, book.getCategoryId());
            stmt.setObject(12, book.getPublicationYear());
            stmt.setObject(13, book.getOriginalPublicationYear());
            stmt.setBigDecimal(14, book.getPrice());
            stmt.setObject(15, book.getWeightGrams());
            stmt.setString(16, book.getDimensions());
            stmt.setInt(17, book.getTotalCopies());
            stmt.setInt(18, book.getAvailableCopies());
            stmt.setInt(19, book.getReservedCopies());
            stmt.setString(20, book.getCoverImageUrl());
            stmt.setBoolean(21, book.isBestseller());
            stmt.setBoolean(22, book.isFeatured());
            stmt.setString(23, book.getAgeRestriction() != null ? book.getAgeRestriction().name() : "ALL");
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    book.setBookId(generatedKeys.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateBook(Book book) {
        // Try to update with available_copies first, then available_quantity
        String sql = "UPDATE books SET available_copies=? WHERE book_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, book.getAvailableCopies());
            stmt.setInt(2, book.getBookId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            // Try with available_quantity
            try {
                sql = "UPDATE books SET available_quantity=? WHERE book_id=?";
                try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                    stmt.setInt(1, book.getAvailableCopies());
                    stmt.setInt(2, book.getBookId());
                    return stmt.executeUpdate() > 0;
                }
            } catch (SQLException e2) {
                e2.printStackTrace();
            }
        }
        return false;
    }
    
    public boolean updateBookFull(Book book) {
        String sql = "UPDATE books SET title=?, subtitle=?, isbn=?, isbn13=?, publisher_id=?, language_id=?, " +
                    "edition=?, pages=?, format=?, description=?, category_id=?, publication_year=?, " +
                    "original_publication_year=?, price=?, weight_grams=?, dimensions=?, total_copies=?, " +
                    "available_copies=?, reserved_copies=?, cover_image_url=?, is_bestseller=?, " +
                    "is_featured=?, age_restriction=? WHERE book_id=?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getSubtitle());
            stmt.setString(3, book.getIsbn());
            stmt.setString(4, book.getIsbn13());
            stmt.setObject(5, book.getPublisherId());
            stmt.setObject(6, book.getLanguageId());
            stmt.setString(7, book.getEdition());
            stmt.setObject(8, book.getPages());
            stmt.setString(9, book.getFormat() != null ? book.getFormat().name() : null);
            stmt.setString(10, book.getDescription());
            stmt.setObject(11, book.getCategoryId());
            stmt.setObject(12, book.getPublicationYear());
            stmt.setObject(13, book.getOriginalPublicationYear());
            stmt.setBigDecimal(14, book.getPrice());
            stmt.setObject(15, book.getWeightGrams());
            stmt.setString(16, book.getDimensions());
            stmt.setInt(17, book.getTotalCopies());
            stmt.setInt(18, book.getAvailableCopies());
            stmt.setInt(19, book.getReservedCopies());
            stmt.setString(20, book.getCoverImageUrl());
            stmt.setBoolean(21, book.isBestseller());
            stmt.setBoolean(22, book.isFeatured());
            stmt.setString(23, book.getAgeRestriction() != null ? book.getAgeRestriction().name() : "ALL");
            stmt.setInt(24, book.getBookId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteBook(int bookId) {
        String sql = "DELETE FROM books WHERE book_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean isBookAvailable(int bookId) {
        String sql = "SELECT available_copies FROM books WHERE book_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("available_copies") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public int getTotalBooks() {
        String sql = "SELECT COUNT(*) FROM books";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookId(rs.getInt("book_id"));
        book.setTitle(rs.getString("title"));
        book.setSubtitle(rs.getString("subtitle"));
        book.setIsbn(rs.getString("isbn"));
        book.setIsbn13(rs.getString("isbn13"));
        
        Integer publisherId = rs.getInt("publisher_id");
        if (!rs.wasNull()) {
            book.setPublisherId(publisherId);
        }
        
        Integer languageId = rs.getInt("language_id");
        if (!rs.wasNull()) {
            book.setLanguageId(languageId);
        }
        
        book.setEdition(rs.getString("edition"));
        
        Integer pages = rs.getInt("pages");
        if (!rs.wasNull()) {
            book.setPages(pages);
        }
        
        String formatStr = rs.getString("format");
        if (formatStr != null) {
            try {
                book.setFormat(Book.BookFormat.valueOf(formatStr));
            } catch (IllegalArgumentException e) {
                // Invalid format, use default
                book.setFormat(Book.BookFormat.PAPERBACK);
            }
        }
        
        book.setDescription(rs.getString("description"));
        
        Integer categoryId = rs.getInt("category_id");
        if (!rs.wasNull()) {
            book.setCategoryId(categoryId);
        }
        
        Integer pubYear = rs.getInt("publication_year");
        if (!rs.wasNull()) {
            book.setPublicationYear(pubYear);
        }
        
        Integer originalPubYear = rs.getInt("original_publication_year");
        if (!rs.wasNull()) {
            book.setOriginalPublicationYear(originalPubYear);
        }
        
        book.setPrice(rs.getBigDecimal("price"));
        
        Integer weightGrams = rs.getInt("weight_grams");
        if (!rs.wasNull()) {
            book.setWeightGrams(weightGrams);
        }
        
        book.setDimensions(rs.getString("dimensions"));
        book.setTotalCopies(rs.getInt("total_copies"));
        book.setAvailableCopies(rs.getInt("available_copies"));
        book.setReservedCopies(rs.getInt("reserved_copies"));
        book.setRatingAvg(rs.getBigDecimal("rating_avg"));
        book.setRatingCount(rs.getInt("rating_count"));
        book.setViewCount(rs.getInt("view_count"));
        book.setBorrowCount(rs.getInt("borrow_count"));
        book.setCoverImageUrl(rs.getString("cover_image_url"));
        book.setBestseller(rs.getBoolean("is_bestseller"));
        book.setFeatured(rs.getBoolean("is_featured"));
        
        String ageRestrictionStr = rs.getString("age_restriction");
        if (ageRestrictionStr != null) {
            try {
                book.setAgeRestriction(Book.AgeRestriction.valueOf(ageRestrictionStr));
            } catch (IllegalArgumentException e) {
                book.setAgeRestriction(Book.AgeRestriction.ALL);
            }
        } else {
            book.setAgeRestriction(Book.AgeRestriction.ALL);
        }
        
        book.setCreatedAt(rs.getTimestamp("created_at"));
        book.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Populate author name
        String authorName = bookAuthorDAO.getPrimaryAuthorName(book.getBookId());
        book.setAuthor(authorName);
        
        return book;
    }
}