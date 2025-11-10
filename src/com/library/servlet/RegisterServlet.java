package com.library.servlet;

import com.library.service.MemberService;
import com.library.entity.User;
import com.library.entity.Member;
import com.library.util.PasswordUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Handles user registration for all roles: Member, Librarian, and Administrator.
 * 
 * <p><b>Security:</b> Passwords are hashed using BCrypt (cost factor 10) before storage.
 * No plaintext passwords are ever stored in the database.</p>
 * 
 * @see PasswordUtils
 */
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private MemberService memberService;
    
    @Override
    public void init() throws ServletException {
        memberService = new MemberService();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get form data
        String roleParam = request.getParameter("role");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zipCode = request.getParameter("zipCode");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }
        
        // Determine user role
        User.UserRole userRole;
        try {
            userRole = User.UserRole.valueOf(roleParam);
        } catch (Exception e) {
            userRole = User.UserRole.MEMBER; // Default to MEMBER
        }
        
        // For ADMIN role, check admin code
        if (userRole == User.UserRole.ADMIN) {
            String adminCode = request.getParameter("adminCode");
            // Simple admin code check (in production, use a secure method)
            if (!"ADMIN2024".equals(adminCode)) {
                request.setAttribute("error", "Invalid admin access code!");
                request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
                return;
            }
        }
        
        // Create User object
        User user = new User();
        user.setUsername(username);
        
        // Hash the password using BCrypt before storing (cost factor: 10)
        // BCrypt automatically generates a unique salt for each password
        String hashedPassword = PasswordUtils.hashPassword(password);
        user.setPasswordHash(hashedPassword);
        
        user.setEmail(email);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setRole(userRole);
        user.setActive(true);
        user.setEmailVerified(false);
        
        // Register the user
        try {
            if (userRole == User.UserRole.MEMBER) {
                // For members, create member record as well
                Member member = new Member();
                member.setPhone(phone);
                member.setAddress(address);
                member.setCity(city);
                member.setState(state);
                member.setZipCode(zipCode);
                member.setCountry("USA"); // Default country
                
                if (memberService.registerMember(user, member)) {
                    request.setAttribute("success", "Registration successful! Please login.");
                    request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Registration failed. Please try again.");
                    request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
                }
            } else {
                // For ADMIN and LIBRARIAN, just create user account (no member record)
                com.library.dao.UserDAO userDAO = new com.library.dao.UserDAO();
                if (userDAO.register(user)) {
                    String roleLabel = userRole == User.UserRole.ADMIN ? "Administrator" : "Librarian";
                    request.setAttribute("success", roleLabel + " account created successfully! Please login.");
                    request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Registration failed. Username or email may already exist.");
                    request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration error: " + e.getMessage());
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/jsp/register.jsp");
    }
}