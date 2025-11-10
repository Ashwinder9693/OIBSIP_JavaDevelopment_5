<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Money to Wallet - LibraryHub</title>
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
            position: sticky;
            top: 0;
            z-index: 1000;
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
            color: #1a1a1a;
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
            transform: translateY(-1px);
        }

        .nav-btn-primary {
            background: #2563eb;
            border-color: #2563eb;
            color: white;
        }

        .nav-btn-primary:hover {
            background: #1d4ed8;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2.5rem 3rem;
        }

        .wallet-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            padding: 2rem;
            color: white;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }

        .wallet-label {
            font-size: 0.875rem;
            opacity: 0.9;
            margin-bottom: 0.5rem;
        }

        .wallet-amount {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .wallet-pending {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-size: 0.875rem;
        }

        .form-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .form-card h2 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: #1a1a1a;
        }

        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.9375rem;
        }

        .alert-success {
            background: #f0fdf4;
            border: 1px solid #86efac;
            color: #166534;
        }

        .alert-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #991b1b;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.5rem;
            font-size: 0.9375rem;
        }

        .form-input, .form-select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.9375rem;
            font-family: inherit;
            transition: all 0.3s ease;
        }

        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .quick-amounts {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 0.75rem;
            margin-top: 0.75rem;
        }

        .quick-amount-btn {
            padding: 0.75rem;
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-weight: 600;
            color: #374151;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .quick-amount-btn:hover {
            border-color: #2563eb;
            color: #2563eb;
            background: #eff6ff;
        }

        .btn {
            padding: 0.875rem 2rem;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9375rem;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: inherit;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
            width: 100%;
        }

        .btn-primary:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        .btn-secondary {
            background: white;
            color: #374151;
            border: 1px solid #e5e7eb;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1.5rem;
            }

            .quick-amounts {
                grid-template-columns: repeat(2, 1fr);
            }

            .wallet-amount {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-brand">
            <a href="${pageContext.request.contextPath}/index.html">
                <div class="logo-mini">📚</div>
                <h1>LibraryHub</h1>
            </a>
        </div>
        <div class="navbar-actions">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-btn nav-btn-primary">Dashboard</a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-btn">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="wallet-card">
            <div class="wallet-label">Current Balance</div>
            <div class="wallet-amount">$<%= String.format("%.2f", user.getWalletBalance()) %></div>
            <% if (user.getWalletPendingBalance().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                <div class="wallet-pending">
                    <i class="fas fa-clock"></i>
                    Pending: $<%= String.format("%.2f", user.getWalletPendingBalance()) %>
                </div>
            <% } %>
        </div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <div class="form-card">
            <h2>💰 Add Money to Wallet</h2>

            <form method="post" action="${pageContext.request.contextPath}/wallet">
                <input type="hidden" name="action" value="request_topup">

                <div class="form-group">
                    <label class="form-label" for="amount">Amount ($)</label>
                    <input type="number" id="amount" name="amount" class="form-input" 
                           placeholder="Enter amount" min="1" max="10000" step="0.01" required>
                    <div class="quick-amounts">
                        <button type="button" class="quick-amount-btn" onclick="setAmount(10)">$10</button>
                        <button type="button" class="quick-amount-btn" onclick="setAmount(50)">$50</button>
                        <button type="button" class="quick-amount-btn" onclick="setAmount(100)">$100</button>
                        <button type="button" class="quick-amount-btn" onclick="setAmount(500)">$500</button>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="paymentMethod">Payment Method</label>
                    <select id="paymentMethod" name="paymentMethod" class="form-select" required>
                        <option value="">Select payment method</option>
                        <option value="UPI">UPI</option>
                        <option value="Credit Card">Credit Card</option>
                        <option value="Debit Card">Debit Card</option>
                        <option value="Net Banking">Net Banking</option>
                        <option value="PayPal">PayPal</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="paymentReference">Payment Reference / Transaction ID</label>
                    <input type="text" id="paymentReference" name="paymentReference" class="form-input" 
                           placeholder="Enter transaction ID or reference number" required>
                    <small style="color: #6b7280; font-size: 0.875rem; margin-top: 0.25rem; display: block;">
                        This will be verified by admin before approval
                    </small>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i> Submit Request
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function setAmount(value) {
            document.getElementById('amount').value = value;
        }
    </script>
</body>
</html>

