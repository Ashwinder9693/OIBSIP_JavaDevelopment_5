package com.library.servlet;

import com.library.entity.User;
import com.library.service.FineService;
import com.library.service.MemberService;
import com.library.entity.Member;
import com.library.entity.Fine;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/myFines")
public class MyFinesServlet extends HttpServlet {
    private FineService fineService;
    private MemberService memberService;
    
    @Override
    public void init() throws ServletException {
        fineService = new FineService();
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
        
        Member member = memberService.getMemberByUserId(user.getUserId());
        if (member != null) {
            List<Fine> fines = fineService.getFinesByMember(member.getMemberId());
            request.setAttribute("fines", fines);
        }
        
        request.getRequestDispatcher("/jsp/user/myFines.jsp").forward(request, response);
    }
}

