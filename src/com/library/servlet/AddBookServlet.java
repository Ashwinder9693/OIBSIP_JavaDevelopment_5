package com.library.servlet;

import com.library.entity.User;
import com.library.service.BookService;
import com.library.service.CategoryService;
import com.library.entity.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/addBook")
public class AddBookServlet extends HttpServlet {
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
        
        request.setAttribute("categories", categoryService.getAllCategories());
        request.getRequestDispatcher("/jsp/admin/addBook.jsp").forward(request, response);
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
            Book book = new Book();
            book.setIsbn(request.getParameter("isbn"));
            book.setTitle(request.getParameter("title"));
            // Note: Author is now managed via BookAuthor relationship, not directly on Book
            // Note: Publisher is now publisherId (Integer), not a string
            String pubYearStr = request.getParameter("publicationYear");
            if (pubYearStr != null && !pubYearStr.isEmpty()) {
                book.setPublicationYear(Integer.parseInt(pubYearStr));
            }
            String categoryIdStr = request.getParameter("categoryId");
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                book.setCategoryId(Integer.parseInt(categoryIdStr));
            }
            String totalCopiesStr = request.getParameter("totalCopies");
            if (totalCopiesStr != null && !totalCopiesStr.isEmpty()) {
                int totalCopies = Integer.parseInt(totalCopiesStr);
                book.setTotalCopies(totalCopies);
                book.setAvailableCopies(totalCopies);
            }
            book.setDescription(request.getParameter("description"));
            // Note: Shelf location is now on BookCopy entity, not Book entity
            
            if (bookService.addBook(book)) {
                request.setAttribute("success", "Book added successfully!");
                response.sendRedirect(request.getContextPath() + "/bookList");
                return;
            } else {
                request.setAttribute("error", "Failed to add book.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}

