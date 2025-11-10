package com.library.servlet;

import com.library.entity.User;
import com.library.service.MemberService;
import com.library.entity.Member;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private MemberService memberService;
    
    @Override
    public void init() throws ServletException {
        memberService = new MemberService();
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
            Member member = memberService.getMemberByUserId(user.getUserId());
            request.setAttribute("user", user);
            request.setAttribute("member", member);
            request.getRequestDispatcher("/jsp/user/profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading profile: " + e.getMessage());
            request.getRequestDispatcher("/jsp/user/profile.jsp").forward(request, response);
        }
    }
}

