package com.library.service;

import com.library.dao.MemberDAO;
import com.library.dao.UserDAO;
import com.library.entity.Member;
import com.library.entity.User;
import com.library.entity.Member.MembershipType;
import com.library.entity.User.UserRole;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

public class MemberService {
    private MemberDAO memberDAO;
    private UserDAO userDAO;
    
    public MemberService() {
        this.memberDAO = new MemberDAO();
        this.userDAO = new UserDAO();
    }
    
    public List<Member> getAllMembers() {
        return memberDAO.getAllMembers();
    }
    
    public Member getMemberById(int memberId) {
        return memberDAO.getMemberById(memberId);
    }
    
    public Member getMemberByUserId(int userId) {
        return memberDAO.getMemberByUserId(userId);
    }
    
    public List<Member> searchMembers(String keyword) {
        return memberDAO.searchMembers(keyword);
    }
    
    public boolean registerMember(User user, Member member) {
        // First register user
        if (user.getRole() == null) {
            user.setRole(UserRole.MEMBER);
        }
        if (userDAO.register(user)) {
            // Then create member profile
            member.setUserId(user.getUserId());
            if (member.getMembershipNumber() == null || member.getMembershipNumber().isEmpty()) {
                // Generate membership number
                member.setMembershipNumber("MEM" + System.currentTimeMillis());
            }
            if (member.getMembershipType() == null) {
                member.setMembershipType(MembershipType.SILVER);  // Default to SILVER tier (free)
            }
            if (member.getJoinDate() == null) {
                member.setJoinDate(Date.valueOf(LocalDate.now()));
            }
            if (member.getExpiryDate() == null) {
                member.setExpiryDate(Date.valueOf(LocalDate.now().plusYears(1)));
            }
            if (member.getMaxBooksAllowed() == 0) {
                member.setMaxBooksAllowed(3);
            }
            if (member.getMaxDaysAllowed() == 0) {
                member.setMaxDaysAllowed(14);
            }
            member.setActive(true);
            
            return memberDAO.addMember(member);
        }
        return false;
    }
    
    public boolean updateMember(Member member) {
        return memberDAO.updateMember(member);
    }
    
    public boolean deleteMember(int memberId) {
        return memberDAO.deleteMember(memberId);
    }
}