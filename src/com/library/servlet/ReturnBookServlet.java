package com.library.servlet;

import com.library.entity.User;
import com.library.service.IssueReturnService;
import com.library.entity.IssueReturn;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/returnBook")
public class ReturnBookServlet extends HttpServlet {
    private IssueReturnService issueReturnService;
    
    @Override
    public void init() throws ServletException {
        issueReturnService = new IssueReturnService();
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
        
        List<IssueReturn> issuedBooks = issueReturnService.getAllIssuedBooks();
        request.setAttribute("issuedBooks", issuedBooks);
        request.getRequestDispatcher("/jsp/admin/returnBook.jsp").forward(request, response);
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
            int transactionId = Integer.parseInt(request.getParameter("transactionId"));
            int returnedTo = user.getUserId();
            
            if (issueReturnService.returnBook(transactionId, returnedTo)) {
                request.setAttribute("success", "Book returned successfully!");
            } else {
                request.setAttribute("error", "Failed to return book.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}

