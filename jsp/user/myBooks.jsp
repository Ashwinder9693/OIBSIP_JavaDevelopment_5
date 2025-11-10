<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.IssueReturn" %>
<%@ page import="com.library.entity.Reservation" %>
<%@ page import="com.library.entity.Book" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    List<Map<String, Object>> myBooks = (List<Map<String, Object>>) request.getAttribute("myBooks");
    if (myBooks == null) {
        myBooks = new java.util.ArrayList<>();
    }
    List<Map<String, Object>> myReservations = (List<Map<String, Object>>) request.getAttribute("myReservations");
    if (myReservations == null) {
        myReservations = new java.util.ArrayList<>();
    }
    SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Books - LibraryHub</title>
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

        .section-header {
            margin-top: 3rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .section-header h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1a1a1a;
            margin: 0;
        }

        .section-header .icon {
            font-size: 1.75rem;
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

        .status-badge.active {
            background: #dcfce7;
            color: #16a34a;
            border: 1px solid #86efac;
        }

        .status-badge.overdue {
            background: #fee2e2;
            color: #dc2626;
            border: 1px solid #fca5a5;
        }

        .status-badge.returned {
            background: #e0e7ff;
            color: #4f46e5;
            border: 1px solid #a5b4fc;
        }

        .status-badge.pending {
            background: #fffbeb;
            color: #d97706;
            border: 1px solid #fcd34d;
        }

        .status-badge.active {
            background: #dcfce7;
            color: #16a34a;
            border: 1px solid #86efac;
        }

        .status-badge.overdue {
            background: #fee2e2;
            color: #dc2626;
            border: 1px solid #fca5a5;
        }

        .status-badge.cancelled {
            background: #f3f4f6;
            color: #6b7280;
            border: 1px solid #d1d5db;
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

        .table-container {
            animation: fadeIn 0.4s ease-out;
        }

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
            <h2>My Books</h2>
            <p>View and manage your borrowed books and reservations</p>
        </div>

        <div class="table-container">
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Type</th>
                            <th>Book Title</th>
                            <th>Transaction/Reservation ID</th>
                            <th>Start/Issue Date</th>
                            <th>End/Due Date</th>
                            <th>Status</th>
                            <th>Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            boolean hasAnyBooks = false;
                            
                            // Display borrowed books
                            if (myBooks != null && !myBooks.isEmpty()) {
                                hasAnyBooks = true;
                                for (Map<String, Object> detail : myBooks) { 
                                    IssueReturn transaction = (IssueReturn) detail.get("transaction");
                                    Book book = (Book) detail.get("book");
                                    
                                    if (transaction == null) continue;
                                    
                                    String statusClass = "";
                                    String statusText = transaction.getStatus().toString();
                                    
                                    if (transaction.getStatus() == IssueReturn.TransactionStatus.LATE_RETURN) {
                                        statusClass = "overdue";
                                        statusText = "OVERDUE";
                                    } else if (transaction.getStatus() == IssueReturn.TransactionStatus.RETURNED) {
                                        statusClass = "returned";
                                    } else if (transaction.getStatus() == IssueReturn.TransactionStatus.ISSUED) {
                                        statusClass = "active";
                                        statusText = "ACTIVE";
                                    } else {
                                        statusClass = "active";
                                    }
                        %>
                                    <tr>
                                        <td><span class="status-badge active">📖 Borrowed</span></td>
                                        <td><%= book != null ? book.getTitle() : "Book ID: " + transaction.getBookId() %></td>
                                        <td><%= transaction.getTransactionId() %></td>
                                        <td><%= transaction.getIssueDate() != null ? sdf.format(transaction.getIssueDate()) : "N/A" %></td>
                                        <td><%= transaction.getDueDate() != null ? sdf.format(transaction.getDueDate()) : "N/A" %></td>
                                        <td>
                                            <span class="status-badge <%= statusClass %>">
                                                <%= statusText %>
                                            </span>
                                        </td>
                                        <td>-</td>
                                    </tr>
                        <%      }
                            }
                            
                            // Display reservations
                            if (myReservations != null && !myReservations.isEmpty()) {
                                hasAnyBooks = true;
                                for (Map<String, Object> detail : myReservations) { 
                                    Reservation reservation = (Reservation) detail.get("reservation");
                                    Book book = (Book) detail.get("book");
                                    
                                    if (reservation == null) continue;
                                    
                                    String statusClass = "";
                                    String statusText = reservation.getReservationStatus().toString();
                                    
                                    switch (reservation.getReservationStatus()) {
                                        case PENDING:
                                            statusClass = "pending";
                                            break;
                                        case ACTIVE:
                                            statusClass = "active";
                                            break;
                                        case COMPLETED:
                                            statusClass = "returned";
                                            statusText = "COMPLETED";
                                            break;
                                        case OVERDUE:
                                            statusClass = "overdue";
                                            break;
                                        case CANCELLED:
                                            statusClass = "cancelled";
                                            break;
                                        case CONFIRMED:
                                            statusClass = "active";
                                            break;
                                        case EXPIRED:
                                            statusClass = "cancelled";
                                            statusText = "EXPIRED";
                                            break;
                                    }
                        %>
                                    <tr>
                                        <td><span class="status-badge pending">⭐ Reserved</span></td>
                                        <td><%= book != null ? book.getTitle() : "Book ID: " + reservation.getBookId() %></td>
                                        <td><%= reservation.getReservationId() %></td>
                                        <td><%= sdf.format(reservation.getStartDate()) %></td>
                                        <td><%= sdf.format(reservation.getEndDate()) %></td>
                                        <td>
                                            <span class="status-badge <%= statusClass %>">
                                                <%= statusText %>
                                            </span>
                                        </td>
                                        <td>$<%= String.format("%.2f", reservation.getTotalAmount()) %></td>
                                    </tr>
                        <%      }
                            }
                            
                            // Show empty state if no books or reservations
                            if (!hasAnyBooks) {
                        %>
                                <tr>
                                    <td colspan="7" style="padding: 0;">
                                        <div class="empty-state">
                                            <div class="empty-state-icon">📖</div>
                                            <h3>No Books or Reservations</h3>
                                            <p>You haven't borrowed or reserved any books yet. Visit the browse section to get started!</p>
                                        </div>
                                    </td>
                                </tr>
                        <%  } %>
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