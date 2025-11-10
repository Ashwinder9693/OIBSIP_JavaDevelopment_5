<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.Book" %>
<%@ page import="com.library.entity.Category" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !user.getRole().name().equals("ADMIN")) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    Book book = (Book) request.getAttribute("book");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Book - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-dark bg-dark">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1">Library Management System</span>
            <a href="${pageContext.request.contextPath}/bookList" class="btn btn-light">Back to Book List</a>
        </div>
    </nav>
    
    <div class="container mt-4">
        <h2>Edit Book</h2>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <% if (book != null) { %>
        <form method="post" action="${pageContext.request.contextPath}/editBook" class="mt-4">
            <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">ISBN</label>
                    <input type="text" class="form-control" name="isbn" value="<%= book.getIsbn() %>" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Title</label>
                    <input type="text" class="form-control" name="title" value="<%= book.getTitle() %>" required>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Author</label>
                    <input type="text" class="form-control" name="author" value="<%= book.getAuthor() %>" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Publisher ID</label>
                    <input type="number" class="form-control" name="publisherId" value="<%= book.getPublisherId() != null ? book.getPublisherId() : "" %>" placeholder="Publisher ID">
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Publication Year</label>
                    <input type="number" class="form-control" name="publicationYear" value="<%= book.getPublicationYear() != null ? book.getPublicationYear() : "" %>" min="1000" max="9999" placeholder="e.g., 2024">
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Category</label>
                    <select class="form-control" name="categoryId" required>
                        <option value="">Select Category</option>
                        <% if (categories != null) { %>
                            <% for (Category cat : categories) { %>
                                <option value="<%= cat.getCategoryId() %>" <%= cat.getCategoryId() == book.getCategoryId() ? "selected" : "" %>><%= cat.getName() %></option>
                            <% } %>
                        <% } %>
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Total Copies</label>
                    <input type="number" class="form-control" name="totalCopies" value="<%= book.getTotalCopies() %>" min="1" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Available Copies</label>
                    <input type="number" class="form-control" name="availableCopies" value="<%= book.getAvailableCopies() %>" min="0" required>
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea class="form-control" name="description" rows="3"><%= book.getDescription() != null ? book.getDescription() : "" %></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Update Book</button>
            <a href="${pageContext.request.contextPath}/bookList" class="btn btn-secondary">Cancel</a>
        </form>
        <% } %>
    </div>
</body>
</html>

