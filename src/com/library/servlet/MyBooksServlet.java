package com.library.servlet;

import com.library.entity.User;
import com.library.service.IssueReturnService;
import com.library.service.MemberService;
import com.library.service.ReservationService;
import com.library.service.BookService;
import com.library.entity.Member;
import com.library.entity.IssueReturn;
import com.library.entity.Reservation;
import com.library.entity.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/myBooks")
public class MyBooksServlet extends HttpServlet {
    private IssueReturnService issueReturnService;
    private MemberService memberService;
    private ReservationService reservationService;
    private BookService bookService;
    
    @Override
    public void init() throws ServletException {
        issueReturnService = new IssueReturnService();
        memberService = new MemberService();
        reservationService = new ReservationService();
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
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        Member member = memberService.getMemberByUserId(user.getUserId());
        List<Map<String, Object>> bookDetails = new ArrayList<>();
        if (member != null) {
            List<IssueReturn> myBooks = issueReturnService.getCurrentlyIssuedBooksByMember(member.getMemberId());
            if (myBooks != null) {
                for (IssueReturn transaction : myBooks) {
                    Map<String, Object> detail = new HashMap<>();
                    detail.put("transaction", transaction);
                    Book book = bookService.getBookById(transaction.getBookId());
                    detail.put("book", book);
                    bookDetails.add(detail);
                }
            }
        }
        request.setAttribute("myBooks", bookDetails);
        
        // Get reservations for the user with book details
        List<Reservation> reservations = reservationService.getUserReservations(user.getUserId());
        List<Map<String, Object>> reservationDetails = new ArrayList<>();
        if (reservations != null) {
            for (Reservation reservation : reservations) {
                Map<String, Object> detail = new HashMap<>();
                detail.put("reservation", reservation);
                Book book = bookService.getBookById(reservation.getBookId());
                detail.put("book", book);
                reservationDetails.add(detail);
            }
        }
        request.setAttribute("myReservations", reservationDetails);
        
        request.getRequestDispatcher("/jsp/user/myBooks.jsp").forward(request, response);
    }
}

