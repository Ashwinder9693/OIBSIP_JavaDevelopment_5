<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.WalletTransaction" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.library.dao.UserDAO" %>
<%
    User admin = (User) session.getAttribute("user");
    if(admin == null || !admin.getRole().name().equals("ADMIN")) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<WalletTransaction> pendingTopups = (List<WalletTransaction>) request.getAttribute("pendingTopups");
    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy HH:mm");
    UserDAO userDAO = new UserDAO();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wallet Approvals - LibraryHub Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: #f8f9fa;
            color: #1a1a1a;
            min-height: 100vh;
        }

        .navbar {
            background: white;
            border-bottom: 1px solid #e5e7eb;
            padding: 1rem 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .navbar-brand a {
            display: flex;
            align-items: center;
            gap: 0.875rem;
            text-decoration: none;
            color: inherit;
        }

        .logo-mini {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
        }

        .navbar-brand h1 {
            font-size: 1.375rem;
            font-weight: 700;
        }

        .navbar-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .nav-btn {
            padding: 0.625rem 1.25rem;
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            color: #374151;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }

        .nav-btn:hover {
            background: #f8f9fa;
        }

        .nav-btn-primary {
            background: #2563eb;
            border-color: #2563eb;
            color: white;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2.5rem 3rem;
        }

        .page-header {
            margin-bottom: 2rem;
        }

        .page-header h2 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .page-header p {
            color: #6b7280;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        .stat-icon.pending {
            background: #fef3c7;
            color: #92400e;
        }

        .stat-content h3 {
            font-size: 1.75rem;
            font-weight: 700;
            color: #1a1a1a;
        }

        .stat-content p {
            color: #6b7280;
            font-size: 0.875rem;
        }

        .table-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .table-header {
            padding: 1.5rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .table-header h3 {
            font-size: 1.25rem;
            font-weight: 600;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            text-align: left;
            padding: 1rem 1.5rem;
            background: #f8f9fa;
            font-weight: 600;
            color: #374151;
            font-size: 0.875rem;
            border-bottom: 1px solid #e5e7eb;
        }

        td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e5e7eb;
            font-size: 0.9375rem;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tbody tr:hover {
            background: #f8f9fa;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.8125rem;
            font-weight: 600;
        }

        .badge-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .badge-success {
            background: #d1fae5;
            color: #065f46;
        }

        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 6px;
            font-weight: 500;
            font-size: 0.875rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-approve {
            background: #10b981;
            color: white;
        }

        .btn-approve:hover {
            background: #059669;
        }

        .btn-reject {
            background: #ef4444;
            color: white;
        }

        .btn-reject:hover {
            background: #dc2626;
        }

        .btn-group {
            display: flex;
            gap: 0.5rem;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6b7280;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.3;
        }

        .user-info {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .user-name {
            font-weight: 600;
            color: #1a1a1a;
        }

        .user-email {
            font-size: 0.875rem;
            color: #6b7280;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <a href="${pageContext.request.contextPath}/index.html">
                <div class="logo-mini">📚</div>
                <h1>LibraryHub Admin</h1>
            </a>
        </div>
        <div class="navbar-actions">
            <a href="${pageContext.request.contextPath}/admin/wallet?action=credit" class="nav-btn nav-btn-primary">
                <i class="fas fa-plus"></i> Credit Wallet
            </a>
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-btn">Dashboard</a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-btn">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <h2>💳 Wallet Top-Up Approvals</h2>
            <p>Review and approve user wallet top-up requests</p>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon pending">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-content">
                    <h3><%= pendingTopups != null ? pendingTopups.size() : 0 %></h3>
                    <p>Pending Requests</p>
                </div>
            </div>
        </div>

        <div class="table-card">
            <div class="table-header">
                <h3>Pending Top-Up Requests</h3>
            </div>

            <% if (pendingTopups != null && !pendingTopups.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Amount</th>
                            <th>Payment Method</th>
                            <th>Transaction Ref</th>
                            <th>Request Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (WalletTransaction txn : pendingTopups) { 
                            User requestUser = userDAO.getUserById(txn.getUserId());
                        %>
                            <tr>
                                <td>
                                    <div class="user-info">
                                        <span class="user-name"><%= requestUser != null ? requestUser.getFullName() : "User #" + txn.getUserId() %></span>
                                        <span class="user-email"><%= requestUser != null ? requestUser.getEmail() : "" %></span>
                                    </div>
                                </td>
                                <td><strong>$<%= String.format("%.2f", txn.getAmount()) %></strong></td>
                                <td><%= txn.getPaymentMethod() %></td>
                                <td><code><%= txn.getPaymentReference() %></code></td>
                                <td><%= sdf.format(txn.getCreatedAt()) %></td>
                                <td><span class="badge badge-pending"><i class="fas fa-clock"></i> Pending</span></td>
                                <td>
                                    <div class="btn-group">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/wallet" style="display: inline;">
                                            <input type="hidden" name="action" value="approve">
                                            <input type="hidden" name="transactionId" value="<%= txn.getTransactionId() %>">
                                            <button type="submit" class="btn btn-approve" onclick="return confirm('Approve this top-up request?')">
                                                <i class="fas fa-check"></i> Approve
                                            </button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/wallet" style="display: inline;">
                                            <input type="hidden" name="action" value="reject">
                                            <input type="hidden" name="transactionId" value="<%= txn.getTransactionId() %>">
                                            <button type="submit" class="btn btn-reject" onclick="return confirm('Reject this top-up request?')">
                                                <i class="fas fa-times"></i> Reject
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>No Pending Requests</h3>
                    <p>All wallet top-up requests have been processed</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>

