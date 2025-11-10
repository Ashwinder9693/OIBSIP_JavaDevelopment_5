<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !user.getRole().name().equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Library Management</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar h1 {
            font-size: 24px;
        }
        .navbar .user-info {
            display: flex;
            gap: 20px;
            align-items: center;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            background: rgba(255,255,255,0.2);
            border-radius: 5px;
        }
        .container {
            padding: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .welcome {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center;
            cursor: pointer;
            transition: transform 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .card h3 {
            margin-bottom: 10px;
            color: #667eea;
        }
        .card-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>📚 Library Management System</h1>
        <div class="user-info">
            <span>Welcome, <%= user.getUsername() %> (Admin)</span>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome">
            <h2>Admin Dashboard</h2>
            <p>Manage your library system from here</p>
        </div>
        
        <div class="dashboard-cards">
            <div class="card" onclick="location.href='${pageContext.request.contextPath}/bookList'">
                <div class="card-icon">📚</div>
                <h3>Manage Books</h3>
                <p>Add, edit, and delete books</p>
            </div>
            
            <div class="card" onclick="location.href='${pageContext.request.contextPath}/memberList'">
                <div class="card-icon">👥</div>
                <h3>Manage Members</h3>
                <p>View and manage members</p>
            </div>
            
            <div class="card" onclick="location.href='${pageContext.request.contextPath}/issueBook'">
                <div class="card-icon">📖</div>
                <h3>Issue Books</h3>
                <p>Issue books to members</p>
            </div>
            
            <div class="card" onclick="location.href='${pageContext.request.contextPath}/returnBook'">
                <div class="card-icon">↩️</div>
                <h3>Return Books</h3>
                <p>Process book returns</p>
            </div>
            
            <div class="card" onclick="location.href='${pageContext.request.contextPath}/fineManagement'">
                <div class="card-icon">💰</div>
                <h3>Fines</h3>
                <p>Manage overdue fines</p>
            </div>
            
            <div class="card" onclick="location.href='${pageContext.request.contextPath}/reports'">
                <div class="card-icon">📊</div>
                <h3>Reports</h3>
                <p>Generate reports</p>
            </div>
            
            <div class="card" onclick="location.href='${pageContext.request.contextPath}/admin/wallet?action=approvals'" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                <div class="card-icon" style="color: white;">💳</div>
                <h3 style="color: white;">Wallet Approvals</h3>
                <p style="color: rgba(255,255,255,0.9);">Approve pending top-ups</p>
            </div>
            
            <div class="card" onclick="location.href='${pageContext.request.contextPath}/admin/wallet?action=credit'" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white;">
                <div class="card-icon" style="color: white;">➕</div>
                <h3 style="color: white;">Credit Wallet</h3>
                <p style="color: rgba(255,255,255,0.9);">Add money to user wallets</p>
            </div>
        </div>
    </div>
</body>
</html>