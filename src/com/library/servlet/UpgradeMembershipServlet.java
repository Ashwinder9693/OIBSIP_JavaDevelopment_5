package com.library.servlet;

import com.library.entity.User;
import com.library.entity.Member;
import com.library.entity.Member.MembershipType;
import com.library.service.MemberService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet("/upgradeMembership")
public class UpgradeMembershipServlet extends HttpServlet {
    private MemberService memberService;
    
    @Override
    public void init() throws ServletException {
        memberService = new MemberService();
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
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }
        
        try {
            Member member = memberService.getMemberByUserId(user.getUserId());
            
            if (member == null) {
                session.setAttribute("error", "No membership found for your account.");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }
            
            String newTierStr = request.getParameter("newTier");
            
            if (newTierStr == null || newTierStr.trim().isEmpty()) {
                session.setAttribute("error", "Invalid upgrade option.");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }
            
            try {
                MembershipType newTier = MembershipType.valueOf(newTierStr);
                MembershipType currentTier = member.getMembershipType();
                
                // Validate upgrade path
                if (!isValidUpgrade(currentTier, newTier)) {
                    session.setAttribute("error", "Invalid upgrade path.");
                    response.sendRedirect(request.getContextPath() + "/profile");
                    return;
                }
                
                // Get upgrade price
                BigDecimal price = Member.getMembershipPrice(newTier);
                
                // Update membership
                member.setMembershipType(newTier);
                
                // Update borrowing limits based on tier
                switch (newTier) {
                    case GOLD:
                        member.setMaxBooksAllowed(10);
                        member.setMaxDaysAllowed(30);
                        break;
                    case PLATINUM:
                        member.setMaxBooksAllowed(20);
                        member.setMaxDaysAllowed(60);
                        break;
                    default:
                        break;
                }
                
                // Extend expiry date by 1 year from today
                member.setExpiryDate(Date.valueOf(LocalDate.now().plusYears(1)));
                
                // Update in database
                boolean updated = memberService.updateMember(member);
                
                if (updated) {
                    session.setAttribute("success", 
                        String.format("Successfully upgraded to %s membership! " +
                                     "You'll be charged $%s. New expiry date: %s",
                                     newTier.name(), price.toString(), member.getExpiryDate().toString()));
                } else {
                    session.setAttribute("error", "Failed to upgrade membership. Please try again.");
                }
                
            } catch (IllegalArgumentException e) {
                session.setAttribute("error", "Invalid membership tier selected.");
            }
            
            response.sendRedirect(request.getContextPath() + "/profile");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error upgrading membership: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
    
    private boolean isValidUpgrade(MembershipType current, MembershipType target) {
        // Silver can upgrade to Gold or Platinum
        if (current == MembershipType.SILVER) {
            return target == MembershipType.GOLD || target == MembershipType.PLATINUM;
        }
        // Gold can upgrade to Platinum only
        if (current == MembershipType.GOLD) {
            return target == MembershipType.PLATINUM;
        }
        // Basic can upgrade to any paid tier
        if (current == MembershipType.BASIC) {
            return target == MembershipType.SILVER || 
                   target == MembershipType.GOLD || 
                   target == MembershipType.PLATINUM;
        }
        // Student, Faculty, Senior, Corporate cannot upgrade (special memberships)
        // Platinum cannot upgrade (already highest tier)
        return false;
    }
}


