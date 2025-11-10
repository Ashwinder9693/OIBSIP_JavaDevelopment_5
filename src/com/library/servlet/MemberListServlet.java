package com.library.servlet;

import com.library.entity.User;
import com.library.service.MemberService;
import com.library.entity.Member;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/memberList")
public class MemberListServlet extends HttpServlet {
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
        
        if (user == null || !user.getRole().name().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        String search = request.getParameter("search");
        List<Member> members;
        
        if (search != null && !search.trim().isEmpty()) {
            members = memberService.searchMembers(search);
        } else {
            members = memberService.getAllMembers();
        }
        
        request.setAttribute("members", members);
        request.getRequestDispatcher("/jsp/admin/memberList.jsp").forward(request, response);
    }
}

