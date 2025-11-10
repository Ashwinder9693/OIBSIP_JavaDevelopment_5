package com.library.servlet;

import com.library.entity.User;
import com.library.entity.WalletTransaction;
import com.library.service.WalletService;
import com.library.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/wallet")
public class WalletServlet extends HttpServlet {
    private WalletService walletService;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        walletService = new WalletService();
        userDAO = new UserDAO();
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
        
        // Refresh user data to get latest wallet balance
        user = userDAO.getUserById(user.getUserId());
        session.setAttribute("user", user);
        
        String action = request.getParameter("action");
        
        if ("topup".equals(action)) {
            // Show top-up page
            request.getRequestDispatcher("/jsp/user/walletTopup.jsp").forward(request, response);
        } else if ("history".equals(action)) {
            // Show transaction history
            List<WalletTransaction> transactions = walletService.getUserTransactions(user.getUserId());
            request.setAttribute("transactions", transactions);
            request.getRequestDispatcher("/jsp/user/walletHistory.jsp").forward(request, response);
        } else {
            // Default: redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");
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
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("request_topup".equals(action)) {
            try {
                BigDecimal amount = new BigDecimal(request.getParameter("amount"));
                String paymentMethod = request.getParameter("paymentMethod");
                String paymentReference = request.getParameter("paymentReference");
                
                // Validate amount
                if (amount.compareTo(BigDecimal.ZERO) <= 0 || amount.compareTo(new BigDecimal("10000")) > 0) {
                    request.setAttribute("error", "Amount must be between ₹1 and ₹10,000");
                    request.getRequestDispatcher("/jsp/user/walletTopup.jsp").forward(request, response);
                    return;
                }
                
                // Create top-up request
                WalletTransaction transaction = walletService.requestTopup(
                    user.getUserId(), 
                    amount, 
                    paymentMethod, 
                    paymentReference
                );
                
                if (transaction != null) {
                    // Refresh user data
                    user = userDAO.getUserById(user.getUserId());
                    session.setAttribute("user", user);
                    
                    request.setAttribute("success", "Top-up request submitted! Waiting for admin approval. Amount: $" + amount);
                    request.setAttribute("pendingAmount", amount);
                } else {
                    request.setAttribute("error", "Failed to submit top-up request. Please try again.");
                }
                
                request.getRequestDispatcher("/jsp/user/walletTopup.jsp").forward(request, response);
                
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid amount entered");
                request.getRequestDispatcher("/jsp/user/walletTopup.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("error", "Error: " + e.getMessage());
                request.getRequestDispatcher("/jsp/user/walletTopup.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/wallet");
        }
    }
}

