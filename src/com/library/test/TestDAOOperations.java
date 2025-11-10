package com.library.test;

import com.library.dao.*;
import com.library.entity.*;
import java.util.List;

public class TestDAOOperations {
    public static void main(String[] args) {
        testUserDAO();
        testBookDAO();
        testMemberDAO();
        System.out.println("All tests completed!");
    }
    
    private static void testUserDAO() {
        System.out.println("Testing UserDAO...");
        UserDAO userDAO = new UserDAO();
        
        // Test user registration
        User newUser = new User();
        newUser.setUsername("testuser");
        newUser.setPassword("password123"); // Convenience method sets passwordHash
        newUser.setEmail("test@example.com");
        newUser.setFirstName("Test");
        newUser.setLastName("User");
        newUser.setRole(User.UserRole.MEMBER);
        newUser.setActive(true);
        newUser.setEmailVerified(false);
        
        boolean registered = userDAO.register(newUser);
        System.out.println("User registration: " + (registered ? "Success" : "Failed"));
        
        // Test login
        User loggedInUser = userDAO.login("testuser", "password123");
        System.out.println("User login: " + (loggedInUser != null ? "Success" : "Failed"));
    }
    
    private static void testBookDAO() {
        System.out.println("\nTesting BookDAO...");
        BookDAO bookDAO = new BookDAO();
        
        // Test adding a book
        Book newBook = new Book();
        newBook.setIsbn("1234567890");
        newBook.setTitle("Test Book");
        // Note: Authors are now in separate authors table with many-to-many relationship via book_authors
        // Authors must be added separately after book creation
        newBook.setPublisherId(1); // Assuming publisher ID 1 exists (use setPublisherId instead of setPublisher)
        newBook.setLanguageId(1); // Assuming language ID 1 exists (English)
        newBook.setPublicationYear(2024);
        newBook.setCategoryId(1); // Assuming category 1 exists
        newBook.setTotalCopies(5);
        newBook.setAvailableCopies(5);
        newBook.setReservedCopies(0);
        // Note: shelfLocation is now in BookCopy entity, not Book entity
        newBook.setDescription("Test book description");
        newBook.setFormat(Book.BookFormat.PAPERBACK);
        newBook.setAgeRestriction(Book.AgeRestriction.ALL);
        
        boolean added = bookDAO.addBook(newBook);
        System.out.println("Book addition: " + (added ? "Success" : "Failed"));
        if (added) {
            System.out.println("Note: To add authors, use BookAuthorDAO after book creation");
        }
        
        // Test getting all books
        List<Book> books = bookDAO.getAllBooks();
        System.out.println("Total books: " + books.size());
    }
    
    private static void testMemberDAO() {
        System.out.println("\nTesting MemberDAO...");
        MemberDAO memberDAO = new MemberDAO();
        
        // Test getting all members
        List<Member> members = memberDAO.getAllMembers();
        System.out.println("Total members: " + members.size());
    }
}