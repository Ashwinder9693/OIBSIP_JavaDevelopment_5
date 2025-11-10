package com.library.servlet;

import com.library.entity.User;
import com.library.service.BookService;
import com.library.service.MemberService;
import com.library.service.IssueReturnService;
import com.library.service.FineService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reports")
public class ReportsServlet extends HttpServlet {
    private BookService bookService;
    private MemberService memberService;
    private IssueReturnService issueReturnService;
    private FineService fineService;
    
    @Override
    public void init() throws ServletException {
        bookService = new BookService();
        memberService = new MemberService();
        issueReturnService = new IssueReturnService();
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
        
        int totalBooks = bookService.getTotalBooks();
        int totalMembers = memberService.getAllMembers().size();
        int totalIssued = issueReturnService.getAllIssuedBooks().size();
        int totalOverdue = issueReturnService.getOverdueBooks().size();
        int totalPendingFines = fineService.getAllPendingFines().size();
        
        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("totalMembers", totalMembers);
        request.setAttribute("totalIssued", totalIssued);
        request.setAttribute("totalOverdue", totalOverdue);
        request.setAttribute("totalPendingFines", totalPendingFines);
        
        request.getRequestDispatcher("/jsp/admin/reports.jsp").forward(request, response);
    }
}

