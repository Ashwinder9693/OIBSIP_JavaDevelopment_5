package com.library.servlet;

import com.library.entity.User;
import com.library.service.IssueReturnService;
import com.library.service.MemberService;
import com.library.service.BookService;
import com.library.entity.Member;
import com.library.entity.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/issueBook")
public class IssueBookServlet extends HttpServlet {
    private IssueReturnService issueReturnService;
    private MemberService memberService;
    private BookService bookService;
    
    @Override
    public void init() throws ServletException {
        issueReturnService = new IssueReturnService();
        memberService = new MemberService();
        bookService = new BookService();
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
        
        List<Member> members = memberService.getAllMembers();
        List<Book> books = bookService.getAvailableBooks();
        
        request.setAttribute("members", members);
        request.setAttribute("books", books);
        request.getRequestDispatcher("/jsp/admin/issueBook.jsp").forward(request, response);
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
        
        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            int memberId = Integer.parseInt(request.getParameter("memberId"));
            int loanDays = Integer.parseInt(request.getParameter("loanDays"));
            int issuedBy = user.getUserId();
            
            if (issueReturnService.issueBook(bookId, memberId, issuedBy, loanDays)) {
                request.setAttribute("success", "Book issued successfully!");
            } else {
                request.setAttribute("error", "Failed to issue book. Book may not be available.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}

