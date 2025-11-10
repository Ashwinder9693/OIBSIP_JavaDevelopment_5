package com.library.servlet;

import com.library.dao.UserDAO;
import com.library.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/GoogleOAuthServlet")
public class GoogleOAuthServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Set request encoding
        request.setCharacterEncoding("UTF-8");
        
        // Debug: Log all parameters
        System.out.println("=== GoogleOAuthServlet Request ===");
        System.out.println("Content-Type: " + request.getContentType());
        System.out.println("Method: " + request.getMethod());
        
        // Get user information from Google Sign-In
        // Data is sent as application/x-www-form-urlencoded
        String email = request.getParameter("email");
        String givenName = request.getParameter("givenName");
        String familyName = request.getParameter("familyName");
        String name = request.getParameter("name");
        
        // Debug: Log received parameters
        System.out.println("Email: " + email);
        System.out.println("GivenName: " + givenName);
        System.out.println("FamilyName: " + familyName);
        System.out.println("Name: " + name);
        
        // Final check
        if (email == null || email.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            String errorMsg = "Email is required";
            System.out.println("ERROR: " + errorMsg);
            response.getWriter().write("{\"success\": false, \"error\": \"" + errorMsg + "\"}");
            return;
        }
        
        try {
            // Check if user exists by email
            User user = userDAO.getUserByEmail(email);
            
            // If user doesn't exist, create a new user
            if (user == null) {
                // Generate username from email (take part before @)
                String username = email.split("@")[0];
                // Ensure username is unique
                int counter = 1;
                String originalUsername = username;
                while (userDAO.usernameExists(username)) {
                    username = originalUsername + counter;
                    counter++;
                }
                
                // Use provided names or defaults
                String firstName = (givenName != null && !givenName.isEmpty()) ? givenName : 
                                   (name != null && !name.isEmpty() ? name.split(" ")[0] : "");
                String lastName = (familyName != null && !familyName.isEmpty()) ? familyName : 
                                  (name != null && name.contains(" ") ? name.substring(name.indexOf(" ") + 1) : "");
                
                user = userDAO.createGoogleUser(
                    email,
                    firstName,
                    lastName,
                    username
                );
            }
            
            if (user != null) {
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                // Return success response with redirect URL
                String redirectUrl = request.getContextPath() + 
                    (user.getRole() == User.UserRole.ADMIN ? 
                        "/jsp/dashboard/adminDashboard.jsp" : 
                        "/jsp/dashboard/userDashboard.jsp");
                
                response.getWriter().write("{\"success\": true, \"redirect\": \"" + redirectUrl + "\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"error\": \"Failed to create or retrieve user\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            String errorMsg = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"") : "Internal server error";
            response.getWriter().write("{\"success\": false, \"error\": \"" + errorMsg + "\"}");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    }
}

