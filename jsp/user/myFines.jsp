<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.Fine" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    List<Fine> fines = (List<Fine>) request.getAttribute("fines");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Fines - LibraryHub</title>
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
            transition: box-shadow 0.3s ease;
        }

        .navbar.scrolled {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 0.875rem;
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
            display: inline-block;
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
            color: #1a1a1a;
            margin-bottom: 0.5rem;
            letter-spacing: -0.025em;
        }

        .page-header p {
            color: #6b7280;
            font-size: 1rem;
        }

        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .summary-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 1.5rem;
            transition: all 0.3s ease;
        }

        .summary-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
        }

        .summary-card-label {
            font-size: 0.875rem;
            color: #6b7280;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .summary-card-value {
            font-size: 2rem;
            font-weight: 700;
            color: #2563eb;
            letter-spacing: -0.025em;
        }

        .table-container {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #f8f9fa;
            border-bottom: 2px solid #e5e7eb;
        }

        th {
            padding: 1rem 1.5rem;
            text-align: left;
            font-weight: 600;
            font-size: 0.875rem;
            color: #374151;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #f3f4f6;
            font-size: 0.9375rem;
            color: #1a1a1a;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tbody tr {
            transition: background-color 0.2s ease;
        }

        tbody tr:hover {
            background: #f8f9fa;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.8125rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .status-badge.pending {
            background: #fef3c7;
            color: #ca8a04;
            border: 1px solid #fcd34d;
        }

        .status-badge.paid {
            background: #dcfce7;
            color: #16a34a;
            border: 1px solid #86efac;
        }

        .status-badge.waived {
            background: #e0e7ff;
            color: #4f46e5;
            border: 1px solid #a5b4fc;
        }

        .amount-cell {
            font-weight: 600;
            color: #dc2626;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
        }

        .empty-state-icon {
            font-size: 4rem;
            opacity: 0.3;
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: #6b7280;
            font-size: 0.9375rem;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .summary-card,
        .table-container {
            animation: fadeIn 0.4s ease-out;
        }

        .summary-card:nth-child(1) { animation-delay: 0.1s; }
        .summary-card:nth-child(2) { animation-delay: 0.2s; }
        .summary-card:nth-child(3) { animation-delay: 0.3s; }

        @media (max-width: 768px) {
            .navbar {
                padding: 1rem 1.5rem;
                flex-wrap: wrap;
            }

            .navbar-actions {
                width: 100%;
                margin-top: 1rem;
                justify-content: flex-end;
            }

            .container {
                padding: 1.5rem;
            }

            th, td {
                padding: 0.75rem 1rem;
                font-size: 0.8125rem;
            }

            .page-header h2 {
                font-size: 1.5rem;
            }

            .summary-cards {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar" id="navbar">
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
        <div class="page-header">
            <h2>My Fines</h2>
            <p>View and manage your library fines</p>
        </div>

        <% 
            double totalPending = 0;
            double totalPaid = 0;
            int pendingCount = 0;
            
            if (fines != null && !fines.isEmpty()) {
                for (Fine fine : fines) {
                    if (fine.getStatus() == Fine.FineStatus.PENDING) {
                        totalPending += fine.getFineAmount().doubleValue();
                        pendingCount++;
                    } else if (fine.getStatus() == Fine.FineStatus.PAID) {
                        totalPaid += fine.getFineAmount().doubleValue();
                    }
                }
            }
        %>

        <div class="summary-cards">
            <div class="summary-card">
                <div class="summary-card-label">Total Pending</div>
                <div class="summary-card-value">$<%= String.format("%.2f", totalPending) %></div>
            </div>
            <div class="summary-card">
                <div class="summary-card-label">Pending Fines</div>
                <div class="summary-card-value"><%= pendingCount %></div>
            </div>
            <div class="summary-card">
                <div class="summary-card-label">Total Paid</div>
                <div class="summary-card-value">$<%= String.format("%.2f", totalPaid) %></div>
            </div>
        </div>

        <div class="table-container">
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Fine ID</th>
                            <th>Transaction ID</th>
                            <th>Amount</th>
                            <th>Days Overdue</th>
                            <th>Status</th>
                            <th>Payment Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (fines != null && !fines.isEmpty()) { %>
                            <% for (Fine fine : fines) { 
                                String statusClass = "";
                                String statusText = fine.getStatus().toString();
                                
                                if (fine.getStatus() == Fine.FineStatus.PENDING) {
                                    statusClass = "pending";
                                } else if (fine.getStatus() == Fine.FineStatus.PAID) {
                                    statusClass = "paid";
                                } else {
                                    statusClass = "waived";
                                }
                            %>
                                <tr>
                                    <td><%= fine.getFineId() %></td>
                                    <td><%= fine.getTransactionId() %></td>
                                    <td class="amount-cell">$<%= String.format("%.2f", fine.getFineAmount()) %></td>
                                    <td><%= fine.getDaysOverdue() %> days</td>
                                    <td>
                                        <span class="status-badge <%= statusClass %>">
                                            <%= statusText %>
                                        </span>
                                    </td>
                                    <td><%= fine.getPaymentDate() != null ? fine.getPaymentDate() : "—" %></td>
                                </tr>
                            <% } %>
                        <% } else { %>
                            <tr>
                                <td colspan="6" style="padding: 0;">
                                    <div class="empty-state">
                                        <div class="empty-state-icon">💰</div>
                                        <h3>No Fines Found</h3>
                                        <p>Great news! You don't have any library fines.</p>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        window.addEventListener('scroll', function() {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 10) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
    </script>
</body>
</html>