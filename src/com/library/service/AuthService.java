package com.library.service;

import com.library.dao.UserDAO;
import com.library.entity.User;

public class AuthService {
    private UserDAO userDAO;
    
    public AuthService() {
        this.userDAO = new UserDAO();
    }
    
    public User login(String username, String password) {
        return userDAO.login(username, password);
    }
    
    public boolean register(User user) {
        // Check if username already exists
        if (userDAO.usernameExists(user.getUsername())) {
            System.out.println("Username already exists!");
            return false;
        }
        
        // Check if email already exists
        if (userDAO.emailExists(user.getEmail())) {
            System.out.println("Email already exists!");
            return false;
        }
        
        return userDAO.register(user);
    }
    
    public boolean isAdmin(User user) {
        return user != null && user.getRole() == User.UserRole.ADMIN;
    }
    
    public boolean isMember(User user) {
        return user != null && user.getRole() == User.UserRole.MEMBER;
    }
    
    public boolean isUser(User user) {
        // Backward compatibility - MEMBER is the new USER role
        return isMember(user);
    }
}