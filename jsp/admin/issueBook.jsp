<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.Book" %>
<%@ page import="com.library.entity.Member" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !user.getRole().name().equals("ADMIN")) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    List<Book> books = (List<Book>) request.getAttribute("books");
    List<Member> members = (List<Member>) request.getAttribute("members");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Issue Book - Admin</title>
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
        <h2>Issue Book</h2>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        
        <form method="post" action="${pageContext.request.contextPath}/issueBook" class="mt-4">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Select Member</label>
                    <select class="form-control" name="memberId" required>
                        <option value="">Select Member</option>
                        <% if (members != null) { %>
                            <% for (Member member : members) { %>
                                <option value="<%= member.getMemberId() %>">Member ID: <%= member.getMemberId() %> - Phone: <%= member.getPhone() %></option>
                            <% } %>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Select Book</label>
                    <select class="form-control" name="bookId" required>
                        <option value="">Select Book</option>
                        <% if (books != null) { %>
                            <% for (Book book : books) { %>
                                <option value="<%= book.getBookId() %>"><%= book.getTitle() %> by <%= book.getAuthor() %> (Available: <%= book.getAvailableQuantity() %>)</option>
                            <% } %>
                        <% } %>
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Loan Period (Days)</label>
                    <input type="number" class="form-control" name="loanDays" value="14" min="1" max="30" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Issue Book</button>
            <a href="${pageContext.request.contextPath}/jsp/dashboard/adminDashboard.jsp" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</body>
</html>

