package com.library.servlet;

import com.library.entity.User;
import com.library.service.BookService;
import com.library.entity.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/bookList")
public class BookListServlet extends HttpServlet {
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
        
        if (user == null || !user.getRole().name().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        String search = request.getParameter("search");
        List<Book> books;
        
        if (search != null && !search.trim().isEmpty()) {
            books = bookService.searchBooks(search);
        } else {
            books = bookService.getAllBooks();
        }
        
        request.setAttribute("books", books);
        request.getRequestDispatcher("/jsp/admin/bookList.jsp").forward(request, response);
    }
}

