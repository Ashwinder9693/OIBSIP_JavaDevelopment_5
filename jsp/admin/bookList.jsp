<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.Book" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !user.getRole().name().equals("ADMIN")) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    List<Book> books = (List<Book>) request.getAttribute("books");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book List - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-dark bg-dark">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1">Library Management System</span>
            <span class="text-white">Welcome, <%= user.getUsername() %></span>
            <a href="${pageContext.request.contextPath}/jsp/dashboard/adminDashboard.jsp" class="btn btn-light">Dashboard</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light">Logout</a>
        </div>
    </nav>
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Book Management</h2>
            <a href="${pageContext.request.contextPath}/addBook" class="btn btn-primary">Add New Book</a>
        </div>
        
        <form method="get" action="${pageContext.request.contextPath}/bookList" class="mb-3">
            <div class="input-group">
                <input type="text" class="form-control" name="search" placeholder="Search books..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button class="btn btn-outline-secondary" type="submit">Search</button>
            </div>
        </form>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>ISBN</th>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Quantity</th>
                    <th>Available</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (books != null && !books.isEmpty()) { %>
                    <% for (Book book : books) { %>
                        <tr>
                            <td><%= book.getBookId() %></td>
                            <td><%= book.getIsbn() %></td>
                            <td><%= book.getTitle() %></td>
                            <td><%= book.getAuthor() %></td>
                            <td><%= book.getTotalCopies() %></td>
                            <td><%= book.getAvailableCopies() %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/editBook?bookId=<%= book.getBookId() %>" class="btn btn-sm btn-warning">Edit</a>
                                <form method="post" action="${pageContext.request.contextPath}/deleteBook" style="display:inline;">
                                    <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                                    <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr><td colspan="7" class="text-center">No books found</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>

