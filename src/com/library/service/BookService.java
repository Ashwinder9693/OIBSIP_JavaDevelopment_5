package com.library.service;

import com.library.dao.BookDAO;
import com.library.entity.Book;
import java.util.List;

public class BookService {
    private BookDAO bookDAO;
    
    public BookService() {
        this.bookDAO = new BookDAO();
    }
    
    public List<Book> getAllBooks() {
        return bookDAO.getAllBooks();
    }
    
    public List<Book> getAvailableBooks() {
        return bookDAO.getAvailableBooks();
    }
    
    public List<Book> searchBooks(String keyword) {
        return bookDAO.searchBooks(keyword);
    }
    
    public List<Book> getBooksByCategory(int categoryId) {
        return bookDAO.getBooksByCategory(categoryId);
    }
    
    public Book getBookById(int bookId) {
        return bookDAO.getBookById(bookId);
    }
    
    public Book getBookByISBN(String isbn) {
        return bookDAO.getBookByISBN(isbn);
    }
    
    public boolean addBook(Book book) {
        return bookDAO.addBook(book);
    }
    
    public boolean updateBook(Book book) {
        return bookDAO.updateBook(book);
    }
    
    public boolean updateBookFull(Book book) {
        return bookDAO.updateBookFull(book);
    }
    
    public boolean deleteBook(int bookId) {
        return bookDAO.deleteBook(bookId);
    }
    
    public boolean isBookAvailable(int bookId) {
        return bookDAO.isBookAvailable(bookId);
    }
    
    public int getTotalBooks() {
        return bookDAO.getTotalBooks();
    }
}