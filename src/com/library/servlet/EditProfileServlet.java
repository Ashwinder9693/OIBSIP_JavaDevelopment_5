package com.library.servlet;

import com.library.entity.User;
import com.library.entity.Member;
import com.library.service.MemberService;
import com.library.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/editProfile")
public class EditProfileServlet extends HttpServlet {
    private MemberService memberService;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
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
        
        try {
            Member member = memberService.getMemberByUserId(user.getUserId());
            request.setAttribute("member", member);
            request.getRequestDispatcher("/jsp/user/editProfile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading profile: " + e.getMessage());
            request.getRequestDispatcher("/jsp/user/editProfile.jsp").forward(request, response);
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
        
        try {
            // Update User fields
            user.setFirstName(request.getParameter("firstName"));
            user.setLastName(request.getParameter("lastName"));
            user.setEmail(request.getParameter("email"));
            user.setBio(request.getParameter("bio"));
            
            // Update user in database
            boolean userUpdated = userDAO.updateUser(user);
            
            // Update Member fields (if member exists)
            Member member = memberService.getMemberByUserId(user.getUserId());
            boolean memberUpdated = false;
            
            if (member != null) {
                member.setPhone(request.getParameter("phone"));
                member.setAlternatePhone(request.getParameter("alternatePhone"));
                member.setAddress(request.getParameter("address"));
                member.setCity(request.getParameter("city"));
                member.setState(request.getParameter("state"));
                member.setZipCode(request.getParameter("zipCode"));
                member.setCountry(request.getParameter("country"));
                
                // Parse date of birth
                String dobStr = request.getParameter("dateOfBirth");
                if (dobStr != null && !dobStr.trim().isEmpty()) {
                    try {
                        member.setDateOfBirth(Date.valueOf(dobStr));
                    } catch (IllegalArgumentException e) {
                        // Invalid date format, skip
                    }
                }
                
                // Parse gender
                String genderStr = request.getParameter("gender");
                if (genderStr != null && !genderStr.trim().isEmpty()) {
                    try {
                        member.setGender(Member.Gender.valueOf(genderStr));
                    } catch (IllegalArgumentException e) {
                        // Invalid gender value, skip
                    }
                }
                
                member.setOccupation(request.getParameter("occupation"));
                member.setOrganization(request.getParameter("organization"));
                member.setEmergencyContactName(request.getParameter("emergencyContactName"));
                member.setEmergencyContactPhone(request.getParameter("emergencyContactPhone"));
                
                // Update member in database
                memberUpdated = memberService.updateMember(member);
            }
            
            if (userUpdated || memberUpdated) {
                // Update session with new user data
                session.setAttribute("user", user);
                
                request.setAttribute("success", "Profile updated successfully!");
                request.setAttribute("member", member);
            } else {
                request.setAttribute("error", "Failed to update profile. Please try again.");
                request.setAttribute("member", member);
            }
            
            request.getRequestDispatcher("/jsp/user/editProfile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating profile: " + e.getMessage());
            Member member = memberService.getMemberByUserId(user.getUserId());
            request.setAttribute("member", member);
            request.getRequestDispatcher("/jsp/user/editProfile.jsp").forward(request, response);
        }
    }
}


