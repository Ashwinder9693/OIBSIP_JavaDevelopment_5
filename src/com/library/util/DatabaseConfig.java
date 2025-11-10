package com.library.util;

public class DatabaseConfig {
    // JDBC Database URL
    public static final String URL = "jdbc:mysql://localhost:3306/library_management";
    
    // Database credentials
    public static final String USERNAME = "root";
    public static final String PASSWORD = "your_password_here"; // Update this with your database password
    
    // JDBC Driver
    public static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    
    // Connection pool settings
    public static final int MAX_POOL_SIZE = 10;
    public static final int INITIAL_POOL_SIZE = 5;
    public static final int MAX_IDLE_TIME = 300;
    
    // Query timeout in seconds
    public static final int QUERY_TIMEOUT = 30;
}