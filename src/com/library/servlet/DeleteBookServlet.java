package com.library.servlet;

import com.library.entity.User;
import com.library.service.BookService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteBook")
public class DeleteBookServlet extends HttpServlet {
    private BookService bookService;
    
    @Override
    public void init() throws ServletException {
        bookService = new BookService();
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
            if (bookService.deleteBook(bookId)) {
                request.setAttribute("success", "Book deleted successfully!");
            } else {
                request.setAttribute("error", "Failed to delete book.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/bookList");
    }
}

