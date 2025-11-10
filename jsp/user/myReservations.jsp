<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
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
    List<Map<String, Object>> reservations = (List<Map<String, Object>>) request.getAttribute("reservations");
    if(reservations == null) {
        reservations = new java.util.ArrayList<>();
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reservations - LibraryHub</title>
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

        .nav-btn-primary {
            background: #2563eb;
            border-color: #2563eb;
            color: white;
        }

        .nav-btn-primary:hover {
            background: #1d4ed8;
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
        }

        .reservations-grid {
            display: grid;
            gap: 1.5rem;
        }

        .reservation-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 1.75rem;
            transition: all 0.3s ease;
        }

        .reservation-card:hover {
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            transform: translateY(-2px);
        }

        .reservation-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .reservation-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 0.25rem;
        }

        .reservation-id {
            font-size: 0.875rem;
            color: #6b7280;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.8125rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-active {
            background: #dcfce7;
            color: #166534;
        }

        .status-returned {
            background: #e0e7ff;
            color: #4f46e5;
        }

        .status-overdue {
            background: #fee2e2;
            color: #dc2626;
        }

        .reservation-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .detail-item {
            font-size: 0.9375rem;
        }

        .detail-label {
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 0.25rem;
            display: block;
        }

        .detail-value {
            color: #1a1a1a;
        }

        .reservation-actions {
            display: flex;
            gap: 0.75rem;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #e5e7eb;
        }

        .btn {
            padding: 0.625rem 1.25rem;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.875rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-secondary {
            background: #f8f9fa;
            color: #374151;
            border: 1px solid #e5e7eb;
        }

        .btn-secondary:hover {
            background: #e5e7eb;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
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

        @media (max-width: 768px) {
            .container {
                padding: 1.5rem;
            }

            .reservation-header {
                flex-direction: column;
                gap: 1rem;
            }

            .reservation-details {
                grid-template-columns: 1fr;
            }

            .reservation-actions {
                flex-direction: column;
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
        <div class="page-header">
            <h2>My Reservations</h2>
            <p>View and manage your book reservations</p>
        </div>

        <% if (reservations != null && !reservations.isEmpty()) { %>
            <div class="reservations-grid">
                <% for (Map<String, Object> detail : reservations) { 
                    Reservation reservation = (Reservation) detail.get("reservation");
                    Book book = (Book) detail.get("book");
                    
                    if (reservation == null) continue;
                    
                    String statusClass = "status-" + reservation.getReservationStatus().toString().toLowerCase();
                    String statusText = reservation.getReservationStatus().toString();
                %>
                    <div class="reservation-card">
                        <div class="reservation-header">
                            <div>
                                <div class="reservation-title"><%= book != null ? book.getTitle() : "Book #" + reservation.getBookId() %></div>
                                <div class="reservation-id">Reservation #<%= reservation.getReservationId() %></div>
                            </div>
                            <span class="status-badge <%= statusClass %>"><%= statusText %></span>
                        </div>

                        <div class="reservation-details">
                            <div class="detail-item">
                                <span class="detail-label">ISBN</span>
                                <span class="detail-value"><%= book != null && book.getIsbn() != null ? book.getIsbn() : "N/A" %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Start Date</span>
                                <span class="detail-value"><%= sdf.format(reservation.getStartDate()) %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">End Date</span>
                                <span class="detail-value"><%= sdf.format(reservation.getEndDate()) %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Days</span>
                                <span class="detail-value"><%= reservation.getNumberOfDays() %> day(s)</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Price per Day</span>
                                <span class="detail-value">$<%= String.format("%.2f", reservation.getPricePerDay()) %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Total Amount</span>
                                <span class="detail-value">$<%= String.format("%.2f", reservation.getTotalAmount()) %></span>
                            </div>
                            <% if (reservation.getFineAmount() != null && reservation.getFineAmount().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                            <div class="detail-item">
                                <span class="detail-label">Fine Amount</span>
                                <span class="detail-value" style="color: #dc2626;">$<%= String.format("%.2f", reservation.getFineAmount()) %></span>
                            </div>
                            <% } %>
                        </div>

                        <div class="reservation-actions">
                            <a href="${pageContext.request.contextPath}/reservation?action=invoice&reservationId=<%= reservation.getReservationId() %>" class="btn btn-primary">View Invoice</a>
                            <% if (reservation.getReservationStatus() == Reservation.ReservationStatus.ACTIVE && reservation.getReturnDate() == null) { %>
                                <a href="${pageContext.request.contextPath}/browseBooks" class="btn btn-secondary">Browse More Books</a>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <div class="empty-state-icon">⭐</div>
                <h3>No Reservations</h3>
                <p>You don't have any reservations yet. Browse books to make a reservation!</p>
                <a href="${pageContext.request.contextPath}/browseBooks" class="btn btn-primary" style="margin-top: 1rem;">Browse Books</a>
            </div>
        <% } %>
    </div>
</body>
</html>

