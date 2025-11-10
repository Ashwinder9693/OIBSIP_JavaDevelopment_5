package com.library.servlet;

import com.library.entity.User;
import com.library.service.BookService;
import com.library.entity.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/browseBooks")
public class BrowseBooksServlet extends HttpServlet {
    private BookService bookService;
    
    @Override
    public void init() throws ServletException {
        bookService = new BookService();
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
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        try {
            String search = request.getParameter("search");
            List<Book> books;
            
            if (search != null && !search.trim().isEmpty()) {
                books = bookService.searchBooks(search);
            } else {
                books = bookService.getAvailableBooks();
            }
            
            request.setAttribute("books", books != null ? books : new java.util.ArrayList<Book>());
            request.getRequestDispatcher("/jsp/user/browseBooks.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading books: " + e.getMessage());
            request.setAttribute("books", new java.util.ArrayList<Book>());
            request.getRequestDispatcher("/jsp/user/browseBooks.jsp").forward(request, response);
        }
    }
}

