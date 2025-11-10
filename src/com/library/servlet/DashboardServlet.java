package com.library.servlet;

import com.library.entity.User;
import com.library.entity.Reservation;
import com.library.service.ReservationService;
import com.library.service.IssueReturnService;
import com.library.service.FineService;
import com.library.service.MemberService;
import com.library.dao.UserDAO;
import com.library.entity.Member;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private ReservationService reservationService;
    private IssueReturnService issueReturnService;
    private FineService fineService;
    private MemberService memberService;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        reservationService = new ReservationService();
        issueReturnService = new IssueReturnService();
        fineService = new FineService();
        memberService = new MemberService();
        userDAO = new UserDAO();
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
        
        // Refresh user data from database to get latest wallet balance
        User refreshedUser = userDAO.getUserById(user.getUserId());
        if (refreshedUser != null) {
            user = refreshedUser;
            session.setAttribute("user", user);  // Update session with fresh data
        }
        
        // Route admin users to admin dashboard
        if (user.getRole() == User.UserRole.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/jsp/dashboard/adminDashboard.jsp");
            return;
        }
        
        try {
            // Get member if exists
            Member member = memberService.getMemberByUserId(user.getUserId());
            
            // Pass member to JSP (to show enrollment banner if null)
            request.setAttribute("member", member);
            
            // Get statistics
            int booksBorrowed = 0;
            int activeLoans = 0;
            BigDecimal pendingFines = BigDecimal.ZERO;
            int reservations = 0;
            
            // Get issued books (traditional borrows)
            if (member != null) {
                try {
                    List<?> myBooks = issueReturnService.getCurrentlyIssuedBooksByMember(member.getMemberId());
                    if (myBooks != null) {
                        activeLoans = myBooks.size();
                        booksBorrowed = myBooks.size();
                    }
                } catch (Exception e) {
                    System.err.println("Error fetching issued books: " + e.getMessage());
                    e.printStackTrace();
                }
                
                // Get pending fines total
                try {
                    pendingFines = fineService.getTotalPendingFinesByMember(member.getMemberId());
                    if (pendingFines == null) {
                        pendingFines = BigDecimal.ZERO;
                    }
                } catch (Exception e) {
                    System.err.println("Error fetching fines: " + e.getMessage());
                    e.printStackTrace();
                    pendingFines = BigDecimal.ZERO;
                }
            }
            
            // Get all reservations (for total count)
            try {
                List<Reservation> allReservations = reservationService.getUserReservations(user.getUserId());
                if (allReservations != null) {
                    reservations = allReservations.size();
                }
            } catch (Exception e) {
                System.err.println("Error fetching reservations: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Get active reservations (PENDING and ACTIVE) and add them to books borrowed count
            // These represent books that are currently reserved/borrowed by the user
            try {
                List<Reservation> activeReservations = reservationService.getActiveUserReservations(user.getUserId());
                if (activeReservations != null && !activeReservations.isEmpty()) {
                    // getActiveUserReservations already returns only PENDING and ACTIVE reservations
                    booksBorrowed += activeReservations.size();
                    System.out.println("  Active Reservations counted: " + activeReservations.size());
                }
            } catch (Exception e) {
                System.err.println("Error fetching active reservations: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Set attributes
            request.setAttribute("booksBorrowed", booksBorrowed);
            request.setAttribute("activeLoans", activeLoans);
            request.setAttribute("pendingFines", pendingFines);
            request.setAttribute("reservations", reservations);
            
            // Debug logging
            System.out.println("Dashboard Stats for User " + user.getUserId() + ":");
            System.out.println("  Books Borrowed: " + booksBorrowed);
            System.out.println("  Active Loans: " + activeLoans);
            System.out.println("  Reservations: " + reservations);
            System.out.println("  Pending Fines: " + pendingFines);
            
        } catch (Exception e) {
            System.err.println("Error in DashboardServlet: " + e.getMessage());
            e.printStackTrace();
            // Set defaults on error
            request.setAttribute("booksBorrowed", 0);
            request.setAttribute("activeLoans", 0);
            request.setAttribute("pendingFines", BigDecimal.ZERO);
            request.setAttribute("reservations", 0);
        }
        
        // Forward to dashboard JSP
        request.getRequestDispatcher("/jsp/dashboard/userDashboard.jsp").forward(request, response);
    }
}

