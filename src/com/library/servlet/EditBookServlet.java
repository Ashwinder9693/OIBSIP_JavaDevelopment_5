package com.library.servlet;

import com.library.entity.User;
import com.library.service.BookService;
import com.library.service.CategoryService;
import com.library.entity.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/editBook")
public class EditBookServlet extends HttpServlet {
    private BookService bookService;
    private CategoryService categoryService;
    
    @Override
    public void init() throws ServletException {
        bookService = new BookService();
        categoryService = new CategoryService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.getRole().name().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        Book book = bookService.getBookById(bookId);
        
        if (book != null) {
            request.setAttribute("book", book);
            request.setAttribute("categories", categoryService.getAllCategories());
            request.getRequestDispatcher("/jsp/admin/editBook.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/bookList");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.getRole().name().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            // Get existing book to preserve fields not in the form
            Book book = bookService.getBookById(bookId);
            if (book == null) {
                request.setAttribute("error", "Book not found.");
                doGet(request, response);
                return;
            }
            
            // Update fields from form
            book.setIsbn(request.getParameter("isbn"));
            book.setTitle(request.getParameter("title"));
            // Note: Author is now managed via BookAuthor relationship, not directly on Book
            // Publisher is now publisherId (Integer)
            String publisherIdStr = request.getParameter("publisherId");
            if (publisherIdStr != null && !publisherIdStr.isEmpty()) {
                book.setPublisherId(Integer.parseInt(publisherIdStr));
            } else {
                book.setPublisherId(null);
            }
            String pubYearStr = request.getParameter("publicationYear");
            if (pubYearStr != null && !pubYearStr.isEmpty()) {
                book.setPublicationYear(Integer.parseInt(pubYearStr));
            } else {
                book.setPublicationYear(null);
            }
            String categoryIdStr = request.getParameter("categoryId");
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                book.setCategoryId(Integer.parseInt(categoryIdStr));
            } else {
                book.setCategoryId(null);
            }
            String totalCopiesStr = request.getParameter("totalCopies");
            if (totalCopiesStr != null && !totalCopiesStr.isEmpty()) {
                book.setTotalCopies(Integer.parseInt(totalCopiesStr));
            }
            String availableCopiesStr = request.getParameter("availableCopies");
            if (availableCopiesStr != null && !availableCopiesStr.isEmpty()) {
                book.setAvailableCopies(Integer.parseInt(availableCopiesStr));
            }
            String description = request.getParameter("description");
            if (description != null) {
                book.setDescription(description);
            }
            // Note: Shelf location is now on BookCopy entity, not Book entity
            
            // Use updateBookFull to update all fields including publisherId
            if (bookService.updateBookFull(book)) {
                response.sendRedirect(request.getContextPath() + "/bookList");
                return;
            } else {
                request.setAttribute("error", "Failed to update book.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}

