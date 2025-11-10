package com.library.servlet;

import com.library.entity.*;
import com.library.dao.*;
import com.library.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/admin/userDetail")
public class UserDetailServlet extends HttpServlet {
    private UserDAO userDAO;
    private MemberService memberService;
    private WalletDAO walletDAO;
    private IssueReturnService issueReturnService;
    private ReservationService reservationService;
    private FineService fineService;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        memberService = new MemberService();
        walletDAO = new WalletDAO();
        issueReturnService = new IssueReturnService();
        reservationService = new ReservationService();
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
        
        User admin = (User) session.getAttribute("user");
        
        if (admin == null || !admin.getRole().name().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        // Get user ID from parameter
        String userIdParam = request.getParameter("userId");
        if (userIdParam == null || userIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/memberList");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdParam);
            
            // 1. Get User basic info
            User user = userDAO.getUserById(userId);
            if (user == null) {
                request.setAttribute("error", "User not found");
                response.sendRedirect(request.getContextPath() + "/memberList");
                return;
            }
            
            // 2. Get Member details
            Member member = memberService.getMemberByUserId(userId);
            
            // 3. Get Wallet transactions (if wallet exists)
            List<WalletTransaction> walletTransactions = new ArrayList<>();
            if (user.getWalletBalance() != null || user.getWalletPendingBalance() != null) {
                walletTransactions = walletDAO.getUserTransactions(userId);
            }
            
            // 4. Get Current Issued Books (traditional borrows)
            List<?> currentlyIssuedBooks = new ArrayList<>();
            if (member != null) {
                currentlyIssuedBooks = issueReturnService.getCurrentlyIssuedBooksByMember(member.getMemberId());
            }
            
            // 5. Get All Issue History
            List<?> allIssueHistory = new ArrayList<>();
            if (member != null) {
                allIssueHistory = issueReturnService.getBooksByMember(member.getMemberId());
            }
            
            // 6. Get Active Reservations
            List<Reservation> activeReservations = new ArrayList<>();
            try {
                activeReservations = reservationService.getActiveUserReservations(userId);
            } catch (Exception e) {
                System.err.println("Error fetching active reservations: " + e.getMessage());
            }
            
            // 7. Get All Reservations
            List<Reservation> allReservations = new ArrayList<>();
            try {
                allReservations = reservationService.getUserReservations(userId);
            } catch (Exception e) {
                System.err.println("Error fetching all reservations: " + e.getMessage());
            }
            
            // 8. Get Fines (Pending and All)
            List<Fine> pendingFines = new ArrayList<>();
            List<Fine> allFines = new ArrayList<>();
            BigDecimal totalPendingFines = BigDecimal.ZERO;
            BigDecimal totalPaidFines = BigDecimal.ZERO;
            
            if (member != null) {
                try {
                    allFines = fineService.getFinesByMember(member.getMemberId());
                    totalPendingFines = fineService.getTotalPendingFinesByMember(member.getMemberId());
                    if (totalPendingFines == null) totalPendingFines = BigDecimal.ZERO;
                    
                    // Separate pending fines and calculate total paid fines
                    for (Fine fine : allFines) {
                        if (fine.getStatus() == Fine.FineStatus.PENDING) {
                            pendingFines.add(fine);
                        } else if (fine.getStatus() == Fine.FineStatus.PAID) {
                            totalPaidFines = totalPaidFines.add(fine.getFineAmount());
                        }
                    }
                } catch (Exception e) {
                    System.err.println("Error fetching fines: " + e.getMessage());
                }
            }
            
            // 9. Calculate Statistics
            int totalBooksBorrowed = 0;
            int totalReservations = allReservations != null ? allReservations.size() : 0;
            int activeLoans = 0;
            
            if (currentlyIssuedBooks != null) {
                activeLoans = currentlyIssuedBooks.size();
                totalBooksBorrowed += activeLoans;
            }
            
            if (activeReservations != null) {
                totalBooksBorrowed += activeReservations.size();
            }
            
            // Set all attributes
            request.setAttribute("detailUser", user);
            request.setAttribute("member", member);
            request.setAttribute("walletTransactions", walletTransactions);
            request.setAttribute("currentlyIssuedBooks", currentlyIssuedBooks);
            request.setAttribute("allIssueHistory", allIssueHistory);
            request.setAttribute("activeReservations", activeReservations);
            request.setAttribute("allReservations", allReservations);
            request.setAttribute("pendingFines", pendingFines);
            request.setAttribute("allFines", allFines);
            request.setAttribute("totalPendingFines", totalPendingFines);
            request.setAttribute("totalPaidFines", totalPaidFines);
            request.setAttribute("totalBooksBorrowed", totalBooksBorrowed);
            request.setAttribute("totalReservations", totalReservations);
            request.setAttribute("activeLoans", activeLoans);
            
            request.getRequestDispatcher("/jsp/admin/userDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/memberList");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error loading user details: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/memberList?error=" + URLEncoder.encode("Error loading user details: " + e.getMessage(), StandardCharsets.UTF_8.toString()));
        }
    }
}

