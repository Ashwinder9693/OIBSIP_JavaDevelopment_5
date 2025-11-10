package com.library.servlet;

import com.library.entity.User;
import com.library.entity.Member;
import com.library.service.MemberService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/membershipEnrollment")
public class MembershipEnrollmentServlet extends HttpServlet {
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
        
        // Check if user already has membership
        Member existingMember = memberService.getMemberByUserId(user.getUserId());
        if (existingMember != null) {
            // Already has membership - redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        // Get action parameter
        String action = request.getParameter("action");
        
        if ("form".equals(action)) {
            // Show enrollment form
            request.getRequestDispatcher("/jsp/membershipEnrollmentForm.jsp").forward(request, response);
        } else {
            // Show invitation page
            request.getRequestDispatcher("/jsp/membershipInvitation.jsp").forward(request, response);
        }
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
        
        // Check if user already has membership
        Member existingMember = memberService.getMemberByUserId(user.getUserId());
        if (existingMember != null) {
            // Already has membership - redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        try {
            // Create new member from form data
            Member member = new Member();
            member.setUserId(user.getUserId());
            
            // Contact information
            member.setPhone(request.getParameter("phone"));
            member.setAlternatePhone(request.getParameter("alternatePhone"));
            member.setAddress(request.getParameter("address"));
            member.setCity(request.getParameter("city"));
            member.setState(request.getParameter("state"));
            member.setZipCode(request.getParameter("zipCode"));
            
            String country = request.getParameter("country");
            member.setCountry(country != null && !country.trim().isEmpty() ? country : "USA");
            
            // Personal information
            String dobStr = request.getParameter("dateOfBirth");
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                try {
                    member.setDateOfBirth(Date.valueOf(dobStr));
                } catch (IllegalArgumentException e) {
                    // Invalid date format, skip
                }
            }
            
            String genderStr = request.getParameter("gender");
            if (genderStr != null && !genderStr.trim().isEmpty()) {
                try {
                    member.setGender(Member.Gender.valueOf(genderStr));
                } catch (IllegalArgumentException e) {
                    member.setGender(Member.Gender.PREFER_NOT_TO_SAY);
                }
            } else {
                member.setGender(Member.Gender.PREFER_NOT_TO_SAY);
            }
            
            member.setOccupation(request.getParameter("occupation"));
            member.setOrganization(request.getParameter("organization"));
            
            // Emergency contact
            member.setEmergencyContactName(request.getParameter("emergencyContactName"));
            member.setEmergencyContactPhone(request.getParameter("emergencyContactPhone"));
            
            // Set membership type to SILVER (default free tier)
            member.setMembershipType(Member.MembershipType.SILVER);
            
            // Set limits for SILVER membership
            member.setMaxBooksAllowed(3);
            member.setMaxDaysAllowed(14);
            
            // Set membership dates
            member.setJoinDate(new Date(System.currentTimeMillis()));
            // 1 year from now
            long oneYearFromNow = System.currentTimeMillis() + (365L * 24L * 60L * 60L * 1000L);
            member.setExpiryDate(new Date(oneYearFromNow));
            
            // Generate membership number
            member.setMembershipNumber("MEM" + System.currentTimeMillis());
            
            // Set as active
            member.setActive(true);
            
            // Add member to database
            boolean success = memberService.updateMember(member); // Using updateMember since it handles insert if not exists
            
            // If updateMember doesn't work, try using MemberDAO directly
            if (!success) {
                com.library.dao.MemberDAO memberDAO = new com.library.dao.MemberDAO();
                success = memberDAO.addMember(member);
            }
            
            if (success) {
                // Success! Show success message and redirect to dashboard
                session.setAttribute("success", 
                    "🎉 Congratulations! Your SILVER membership is now active. " +
                    "You can borrow up to 3 books for 14 days each. Enjoy reading!");
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                request.setAttribute("error", "Failed to create membership. Please try again.");
                request.getRequestDispatcher("/jsp/membershipEnrollmentForm.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error creating membership: " + e.getMessage());
            request.getRequestDispatcher("/jsp/membershipEnrollmentForm.jsp").forward(request, response);
        }
    }
}


