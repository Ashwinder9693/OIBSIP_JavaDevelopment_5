<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.Member" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !user.getRole().name().equals("ADMIN")) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    List<Member> members = (List<Member>) request.getAttribute("members");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Member List - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .clickable-row {
            cursor: pointer;
            transition: all 0.3s;
        }
        .clickable-row:hover {
            background-color: #f0f0f0 !important;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transform: scale(1.01);
        }
        .table {
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-dark bg-dark">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1">Library Management System</span>
            <a href="${pageContext.request.contextPath}/jsp/dashboard/adminDashboard.jsp" class="btn btn-light">Dashboard</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light">Logout</a>
        </div>
    </nav>
    
    <div class="container mt-4">
        <h2>Member Management</h2>
        
        <form method="get" action="${pageContext.request.contextPath}/memberList" class="mb-3">
            <div class="input-group">
                <input type="text" class="form-control" name="search" placeholder="Search members..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button class="btn btn-outline-secondary" type="submit">Search</button>
            </div>
        </form>
        
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Member ID</th>
                    <th>Phone</th>
                    <th>Address</th>
                    <th>City</th>
                    <th>State</th>
                    <th>Membership Status</th>
                    <th>Expiry Date</th>
                </tr>
            </thead>
            <tbody>
                <% if (members != null && !members.isEmpty()) { %>
                    <% for (Member member : members) { %>
                        <tr class="clickable-row" onclick="window.location='${pageContext.request.contextPath}/admin/userDetail?userId=<%= member.getUserId() %>'">
                            <td><%= member.getMemberId() %></td>
                            <td><%= member.getPhone() %></td>
                            <td><%= member.getAddress() %></td>
                            <td><%= member.getCity() %></td>
                            <td><%= member.getState() %></td>
                            <td><%= member.getMembershipStatus() %></td>
                            <td><%= member.getMembershipExpiry() %></td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr><td colspan="7" class="text-center">No members found</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>

