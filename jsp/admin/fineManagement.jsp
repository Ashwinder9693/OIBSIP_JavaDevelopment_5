<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.Fine" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !user.getRole().name().equals("ADMIN")) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    List<Fine> fines = (List<Fine>) request.getAttribute("fines");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fine Management - Admin</title>
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
        <h2>Fine Management</h2>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        
        <table class="table table-striped mt-4">
            <thead>
                <tr>
                    <th>Fine ID</th>
                    <th>Transaction ID</th>
                    <th>Member ID</th>
                    <th>Amount</th>
                    <th>Days Overdue</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (fines != null && !fines.isEmpty()) { %>
                    <% for (Fine fine : fines) { %>
                        <tr>
                            <td><%= fine.getFineId() %></td>
                            <td><%= fine.getTransactionId() %></td>
                            <td><%= fine.getMemberId() %></td>
                            <td>$<%= fine.getFineAmount() %></td>
                            <td><%= fine.getDaysOverdue() %></td>
                            <td><%= fine.getStatus() %></td>
                            <td>
                                <% if (fine.getStatus() == Fine.FineStatus.PENDING) { %>
                                    <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#payModal<%= fine.getFineId() %>">Pay</button>
                                    <button type="button" class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#waiveModal<%= fine.getFineId() %>">Waive</button>
                                <% } %>
                            </td>
                        </tr>
                        
                        <!-- Pay Modal -->
                        <div class="modal fade" id="payModal<%= fine.getFineId() %>" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <form method="post" action="${pageContext.request.contextPath}/fineManagement">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Pay Fine</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <input type="hidden" name="action" value="pay">
                                            <input type="hidden" name="fineId" value="<%= fine.getFineId() %>">
                                            <div class="mb-3">
                                                <label class="form-label">Payment Method</label>
                                                <select class="form-control" name="paymentMethod" required>
                                                    <option value="Cash">Cash</option>
                                                    <option value="Credit Card">Credit Card</option>
                                                    <option value="Debit Card">Debit Card</option>
                                                    <option value="Check">Check</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                            <button type="submit" class="btn btn-primary">Pay</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Waive Modal -->
                        <div class="modal fade" id="waiveModal<%= fine.getFineId() %>" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <form method="post" action="${pageContext.request.contextPath}/fineManagement">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Waive Fine</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <input type="hidden" name="action" value="waive">
                                            <input type="hidden" name="fineId" value="<%= fine.getFineId() %>">
                                            <div class="mb-3">
                                                <label class="form-label">Remarks</label>
                                                <textarea class="form-control" name="remarks" rows="3"></textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                            <button type="submit" class="btn btn-warning">Waive</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <tr><td colspan="7" class="text-center">No pending fines found</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

