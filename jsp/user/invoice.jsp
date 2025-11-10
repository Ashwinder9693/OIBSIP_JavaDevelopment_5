<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.Book" %>
<%@ page import="com.library.entity.Reservation" %>
<%@ page import="com.library.entity.Invoice" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    Invoice invoice = (Invoice) request.getAttribute("invoice");
    Book book = (Book) request.getAttribute("book");
    
    if(reservation == null || invoice == null || book == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice - LibraryHub</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
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
            cursor: pointer;
        }

        .navbar-brand a:hover {
            opacity: 0.8;
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
            letter-spacing: -0.025em;
            margin: 0;
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
            border-color: #d1d5db;
            color: #1a1a1a;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .nav-btn-primary {
            background: #2563eb;
            border-color: #2563eb;
            color: white;
        }

        .nav-btn-primary:hover {
            background: #1d4ed8;
            border-color: #1d4ed8;
            color: white;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 2.5rem 3rem;
        }

        .invoice-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 2.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .invoice-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 2px solid #e5e7eb;
        }

        .invoice-title {
            font-size: 2rem;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 0.5rem;
        }

        .invoice-number {
            font-size: 1rem;
            color: #6b7280;
        }

        .invoice-date {
            text-align: right;
            color: #6b7280;
            font-size: 0.9375rem;
        }

        .invoice-section {
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }

        .info-item {
            font-size: 0.9375rem;
        }

        .info-label {
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 0.25rem;
            display: block;
        }

        .info-value {
            color: #1a1a1a;
        }

        .book-details {
            background: #f8f9fa;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .book-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 0.75rem;
        }

        .book-meta {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.75rem;
            font-size: 0.9375rem;
        }

        .book-meta-item {
            display: flex;
        }

        .book-meta-label {
            font-weight: 600;
            color: #6b7280;
            min-width: 100px;
        }

        .book-meta-value {
            color: #1a1a1a;
        }

        .invoice-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 1.5rem;
        }

        .invoice-table th {
            text-align: left;
            padding: 0.75rem;
            background: #f8f9fa;
            border-bottom: 2px solid #e5e7eb;
            font-weight: 600;
            color: #374151;
            font-size: 0.9375rem;
        }

        .invoice-table td {
            padding: 0.75rem;
            border-bottom: 1px solid #e5e7eb;
            font-size: 0.9375rem;
            color: #1a1a1a;
        }

        .invoice-table tr:last-child td {
            border-bottom: none;
        }

        .text-right {
            text-align: right;
        }

        .total-section {
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 2px solid #e5e7eb;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            font-size: 0.9375rem;
        }

        .total-row:last-child {
            margin-bottom: 0;
            font-size: 1.25rem;
            font-weight: 700;
            color: #1a1a1a;
            padding-top: 0.75rem;
            border-top: 2px solid #e5e7eb;
        }

        .total-label {
            color: #6b7280;
        }

        .total-value {
            font-weight: 600;
            color: #1a1a1a;
        }

        .total-row:last-child .total-value {
            font-size: 1.5rem;
            color: #2563eb;
        }

        .status-badge {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.8125rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .status-paid {
            background: #f0fdf4;
            color: #166534;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .invoice-actions {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e5e7eb;
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
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
            text-align: center;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
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

        .btn-secondary:hover {
            background: #f8f9fa;
            border-color: #d1d5db;
        }

        @media print {
            .navbar, .invoice-actions {
                display: none;
            }
            
            .container {
                padding: 0;
            }
            
            .invoice-card {
                box-shadow: none;
                border: none;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 1.5rem;
            }

            .invoice-header {
                flex-direction: column;
                gap: 1rem;
            }

            .invoice-date {
                text-align: left;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .book-meta {
                grid-template-columns: 1fr;
            }

            .invoice-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
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
        <div class="invoice-card">
            <div class="invoice-header">
                <div>
                    <div class="invoice-title">Invoice</div>
                    <div class="invoice-number">#<%= invoice.getInvoiceNumber() %></div>
                </div>
                <div class="invoice-date">
                    Date: <%= sdf.format(invoice.getInvoiceDate()) %><br>
                    Status: <span class="status-badge <%= invoice.getPaymentStatus() == Invoice.PaymentStatus.PAID ? "status-paid" : "status-pending" %>">
                        <%= invoice.getPaymentStatus() %>
                    </span>
                </div>
            </div>

            <div class="invoice-section">
                <div class="section-title">Customer Information</div>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Name</span>
                        <span class="info-value"><%= user.getFirstName() %> <%= user.getLastName() %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Email</span>
                        <span class="info-value"><%= user.getEmail() %></span>
                    </div>
                </div>
            </div>

            <div class="invoice-section">
                <div class="section-title">Reservation Details</div>
                <div class="book-details">
                    <div class="book-title"><%= book.getTitle() %></div>
                    <div class="book-meta">
                        <div class="book-meta-item">
                            <span class="book-meta-label">ISBN:</span>
                            <span class="book-meta-value"><%= book.getIsbn() != null ? book.getIsbn() : "N/A" %></span>
                        </div>
                        <div class="book-meta-item">
                            <span class="book-meta-label">Publication Year:</span>
                            <span class="book-meta-value"><%= book.getPublicationYear() != null ? book.getPublicationYear() : "N/A" %></span>
                        </div>
                        <div class="book-meta-item">
                            <span class="book-meta-label">Start Date:</span>
                            <span class="book-meta-value"><%= sdf.format(reservation.getStartDate()) %></span>
                        </div>
                        <div class="book-meta-item">
                            <span class="book-meta-label">End Date:</span>
                            <span class="book-meta-value"><%= sdf.format(reservation.getEndDate()) %></span>
                        </div>
                        <div class="book-meta-item">
                            <span class="book-meta-label">Days:</span>
                            <span class="book-meta-value"><%= reservation.getNumberOfDays() %></span>
                        </div>
                        <div class="book-meta-item">
                            <span class="book-meta-label">Price per day:</span>
                            <span class="book-meta-value">$<%= String.format("%.2f", reservation.getPricePerDay()) %></span>
                        </div>
                        <% if (reservation.getMembershipTier() != null) { %>
                        <div class="book-meta-item">
                            <span class="book-meta-label">Membership:</span>
                            <span class="book-meta-value" style="font-weight: 600; color: #2563eb;"><%= reservation.getMembershipTier() %></span>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="invoice-section">
                <div class="section-title">Payment Summary</div>
                <table class="invoice-table">
                    <thead>
                        <tr>
                            <th>Description</th>
                            <th class="text-right">Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Reservation Fee (<%= reservation.getNumberOfDays() %> days × $<%= String.format("%.2f", reservation.getPricePerDay()) %>)</td>
                            <td class="text-right">$<%= String.format("%.2f", invoice.getSubtotal()) %></td>
                        </tr>
                        <% if (invoice.getDiscountAmount() != null && invoice.getDiscountAmount().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                        <tr style="background: #f0fdf4;">
                            <td style="color: #166534; font-weight: 600;">
                                <% if (reservation.getMembershipTier() != null) { %>
                                <%= reservation.getMembershipTier() %> Member Discount
                                <% } else { %>
                                Membership Discount
                                <% } %>
                            </td>
                            <td class="text-right" style="color: #16a34a; font-weight: 700;">-$<%= String.format("%.2f", invoice.getDiscountAmount()) %></td>
                        </tr>
                        <% } %>
                        <% if (invoice.getFineAmount() != null && invoice.getFineAmount().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                        <tr>
                            <td>Late Fee (<%= reservation.getDaysOverdue() %> days overdue)</td>
                            <td class="text-right">$<%= String.format("%.2f", invoice.getFineAmount()) %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <div class="total-section">
                    <div class="total-row">
                        <span class="total-label">Subtotal:</span>
                        <span class="total-value">$<%= String.format("%.2f", invoice.getSubtotal()) %></span>
                    </div>
                    <% if (invoice.getDiscountAmount() != null && invoice.getDiscountAmount().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                    <div class="total-row">
                        <span class="total-label" style="color: #16a34a;">Member Discount:</span>
                        <span class="total-value" style="color: #16a34a;">-$<%= String.format("%.2f", invoice.getDiscountAmount()) %></span>
                    </div>
                    <% } %>
                    <% if (invoice.getFineAmount() != null && invoice.getFineAmount().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                    <div class="total-row">
                        <span class="total-label">Late Fee:</span>
                        <span class="total-value">$<%= String.format("%.2f", invoice.getFineAmount()) %></span>
                    </div>
                    <% } %>
                    <div class="total-row">
                        <span class="total-label">Total:</span>
                        <span class="total-value">$<%= String.format("%.2f", invoice.getTotalAmount()) %></span>
                    </div>
                </div>
            </div>

            <% if (invoice.getPaymentStatus() == Invoice.PaymentStatus.PAID && reservation.getPaymentMethod() != null) { %>
            <div class="invoice-section">
                <div class="section-title">Payment Information</div>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Payment Method</span>
                        <span class="info-value"><%= reservation.getPaymentMethod() %></span>
                    </div>
                    <% if (reservation.getPaymentDate() != null) { %>
                    <div class="info-item">
                        <span class="info-label">Payment Date</span>
                        <span class="info-value"><%= sdf.format(reservation.getPaymentDate()) %></span>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>

            <div class="invoice-actions">
                <button onclick="window.print()" class="btn btn-secondary">Print Invoice</button>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>

