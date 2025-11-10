package com.library.servlet;

import com.library.service.AuthService;
import com.library.service.MemberService;
import com.library.entity.User;
import com.library.entity.Member;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private AuthService authService;
    private MemberService memberService;
    
    @Override
    public void init() throws ServletException {
        authService = new AuthService();
        memberService = new MemberService();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        User user = authService.login(username, password);
        
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Check if user is ADMIN or LIBRARIAN
            if (authService.isAdmin(user) || user.getRole() == User.UserRole.LIBRARIAN) {
                response.sendRedirect(request.getContextPath() + "/jsp/dashboard/adminDashboard.jsp");
            } 
            // Check if MEMBER user has membership record
            else if (user.getRole() == User.UserRole.MEMBER) {
                Member member = memberService.getMemberByUserId(user.getUserId());
                
                if (member == null) {
                    // No membership found - redirect to enrollment invitation
                    response.sendRedirect(request.getContextPath() + "/membershipEnrollment");
                } else {
                    // Has membership - proceed to dashboard
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                }
            }
            else {
                // Other roles (GUEST, etc.) go to dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    }
}