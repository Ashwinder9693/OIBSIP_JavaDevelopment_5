package com.library.servlet;

import com.library.entity.User;
import com.library.entity.WalletTransaction;
import com.library.service.WalletService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/wallet")
public class AdminWalletServlet extends HttpServlet {
    private WalletService walletService;
    
    @Override
    public void init() throws ServletException {
        walletService = new WalletService();
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
        
        String action = request.getParameter("action");
        
        if ("approvals".equals(action)) {
            // Show pending approvals
            List<WalletTransaction> pendingTopups = walletService.getPendingTopups();
            request.setAttribute("pendingTopups", pendingTopups);
            request.getRequestDispatcher("/jsp/admin/walletApprovals.jsp").forward(request, response);
        } else if ("credit".equals(action)) {
            // Show direct credit page
            request.getRequestDispatcher("/jsp/admin/walletCredit.jsp").forward(request, response);
        } else {
            // Default: show approvals
            List<WalletTransaction> pendingTopups = walletService.getPendingTopups();
            request.setAttribute("pendingTopups", pendingTopups);
            request.getRequestDispatcher("/jsp/admin/walletApprovals.jsp").forward(request, response);
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
        
        User admin = (User) session.getAttribute("user");
        if (admin == null || !admin.getRole().name().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("approve".equals(action)) {
            try {
                int transactionId = Integer.parseInt(request.getParameter("transactionId"));
                
                if (walletService.approveTopup(transactionId, admin.getUserId())) {
                    request.setAttribute("success", "Top-up approved successfully!");
                } else {
                    request.setAttribute("error", "Failed to approve top-up");
                }
                
            } catch (Exception e) {
                request.setAttribute("error", "Error: " + e.getMessage());
            }
            
            // Redirect back to approvals page
            response.sendRedirect(request.getContextPath() + "/admin/wallet?action=approvals");
            
        } else if ("reject".equals(action)) {
            try {
                int transactionId = Integer.parseInt(request.getParameter("transactionId"));
                
                if (walletService.rejectTopup(transactionId, admin.getUserId())) {
                    request.setAttribute("success", "Top-up rejected");
                } else {
                    request.setAttribute("error", "Failed to reject top-up");
                }
                
            } catch (Exception e) {
                request.setAttribute("error", "Error: " + e.getMessage());
            }
            
            // Redirect back to approvals page
            response.sendRedirect(request.getContextPath() + "/admin/wallet?action=approvals");
            
        } else if ("direct_credit".equals(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                BigDecimal amount = new BigDecimal(request.getParameter("amount"));
                String description = request.getParameter("description");
                
                // Validate
                if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                    request.setAttribute("error", "Amount must be greater than zero");
                    request.getRequestDispatcher("/jsp/admin/walletCredit.jsp").forward(request, response);
                    return;
                }
                
                WalletTransaction transaction = walletService.adminCreditWallet(
                    userId, 
                    amount, 
                    admin.getUserId(), 
                    description
                );
                
                if (transaction != null) {
                    request.setAttribute("success", "Successfully credited $" + amount + " to user ID: " + userId);
                } else {
                    request.setAttribute("error", "Failed to credit wallet. Check if user exists.");
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid user ID or amount");
            } catch (Exception e) {
                request.setAttribute("error", "Error: " + e.getMessage());
            }
            
            request.getRequestDispatcher("/jsp/admin/walletCredit.jsp").forward(request, response);
            
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/wallet?action=approvals");
        }
    }
}

