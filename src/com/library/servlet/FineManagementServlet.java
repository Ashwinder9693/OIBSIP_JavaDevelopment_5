package com.library.servlet;

import com.library.entity.User;
import com.library.service.FineService;
import com.library.entity.Fine;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/fineManagement")
public class FineManagementServlet extends HttpServlet {
    private FineService fineService;
    
    @Override
    public void init() throws ServletException {
        fineService = new FineService();
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
        
        List<Fine> fines = fineService.getAllPendingFines();
        request.setAttribute("fines", fines);
        request.getRequestDispatcher("/jsp/admin/fineManagement.jsp").forward(request, response);
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
        
        String action = request.getParameter("action");
        try {
            int fineId = Integer.parseInt(request.getParameter("fineId"));
            
            if ("pay".equals(action)) {
                String paymentReference = request.getParameter("paymentReference");
                String paidAmountStr = request.getParameter("paidAmount");
                
                // Get the fine to determine the amount
                Fine fine = fineService.getFineById(fineId);
                if (fine == null) {
                    request.setAttribute("error", "Fine not found.");
                } else {
                    java.math.BigDecimal paidAmount = fine.getFineAmount();
                    if (paidAmountStr != null && !paidAmountStr.isEmpty()) {
                        try {
                            paidAmount = new java.math.BigDecimal(paidAmountStr);
                        } catch (NumberFormatException e) {
                            // Use fine amount as default
                        }
                    }
                    
                    if (fineService.payFine(fineId, paidAmount, paymentReference != null ? paymentReference : "")) {
                        request.setAttribute("success", "Fine paid successfully!");
                    } else {
                        request.setAttribute("error", "Failed to process payment.");
                    }
                }
            } else if ("waive".equals(action)) {
                String waiveReason = request.getParameter("remarks");
                String waivedAmountStr = request.getParameter("waivedAmount");
                String waivedByStr = request.getParameter("waivedBy");
                
                // Get the fine to determine the amount
                Fine fine = fineService.getFineById(fineId);
                if (fine == null) {
                    request.setAttribute("error", "Fine not found.");
                } else {
                    java.math.BigDecimal waivedAmount = fine.getFineAmount();
                    if (waivedAmountStr != null && !waivedAmountStr.isEmpty()) {
                        try {
                            waivedAmount = new java.math.BigDecimal(waivedAmountStr);
                        } catch (NumberFormatException e) {
                            // Use fine amount as default
                        }
                    }
                    
                    Integer waivedBy = null;
                    if (waivedByStr != null && !waivedByStr.isEmpty()) {
                        try {
                            waivedBy = Integer.parseInt(waivedByStr);
                        } catch (NumberFormatException e) {
                            // Leave as null
                        }
                    }
                    
                    if (fineService.waiveFine(fineId, waivedBy, waivedAmount, waiveReason != null ? waiveReason : "")) {
                        request.setAttribute("success", "Fine waived successfully!");
                    } else {
                        request.setAttribute("error", "Failed to waive fine.");
                    }
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}

