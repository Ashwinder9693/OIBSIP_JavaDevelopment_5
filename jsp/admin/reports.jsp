<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !user.getRole().name().equals("ADMIN")) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    Integer totalBooks = (Integer) request.getAttribute("totalBooks");
    Integer totalMembers = (Integer) request.getAttribute("totalMembers");
    Integer totalIssued = (Integer) request.getAttribute("totalIssued");
    Integer totalOverdue = (Integer) request.getAttribute("totalOverdue");
    Integer totalPendingFines = (Integer) request.getAttribute("totalPendingFines");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reports - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-dark bg-dark">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1">Library Management System</span>
            <a href="${pageContext.request.contextPath}/jsp/dashboard/adminDashboard.jsp" class="btn btn-light">Dashboard</a>
        </div>
    </nav>
    
    <div class="container mt-4">
        <h2>Library Reports</h2>
        
        <div class="row mt-4">
            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Total Books</h5>
                        <h2 class="text-primary"><%= totalBooks != null ? totalBooks : 0 %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Total Members</h5>
                        <h2 class="text-success"><%= totalMembers != null ? totalMembers : 0 %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Issued Books</h5>
                        <h2 class="text-info"><%= totalIssued != null ? totalIssued : 0 %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Overdue Books</h5>
                        <h2 class="text-warning"><%= totalOverdue != null ? totalOverdue : 0 %></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Pending Fines</h5>
                        <h2 class="text-danger"><%= totalPendingFines != null ? totalPendingFines : 0 %></h2>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

