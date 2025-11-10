<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.IssueReturn" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !user.getRole().name().equals("ADMIN")) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    List<IssueReturn> issuedBooks = (List<IssueReturn>) request.getAttribute("issuedBooks");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Return Book - Admin</title>
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
        <h2>Return Book</h2>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        
        <table class="table table-striped mt-4">
            <thead>
                <tr>
                    <th>Transaction ID</th>
                    <th>Book ID</th>
                    <th>Member ID</th>
                    <th>Issue Date</th>
                    <th>Due Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (issuedBooks != null && !issuedBooks.isEmpty()) { %>
                    <% for (IssueReturn transaction : issuedBooks) { %>
                        <% if (transaction.getStatus() == IssueReturn.TransactionStatus.ISSUED) { %>
                            <tr>
                                <td><%= transaction.getTransactionId() %></td>
                                <td><%= transaction.getBookId() %></td>
                                <td><%= transaction.getMemberId() %></td>
                                <td><%= transaction.getIssueDate() %></td>
                                <td><%= transaction.getDueDate() %></td>
                                <td><%= transaction.getStatus() %></td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/returnBook" style="display:inline;">
                                        <input type="hidden" name="transactionId" value="<%= transaction.getTransactionId() %>">
                                        <button type="submit" class="btn btn-sm btn-success">Return</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    <% } %>
                <% } else { %>
                    <tr><td colspan="7" class="text-center">No issued books found</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>

