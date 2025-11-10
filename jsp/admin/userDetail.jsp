<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.sql.Date" %>
<%
    User admin = (User) session.getAttribute("user");
    if(admin == null || !admin.getRole().name().equals("ADMIN")) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    User detailUser = (User) request.getAttribute("detailUser");
    if (detailUser == null) {
        response.sendRedirect(request.getContextPath() + "/memberList");
        return;
    }
    Member member = (Member) request.getAttribute("member");
    
    @SuppressWarnings("unchecked")
    List<WalletTransaction> walletTransactions = (List<WalletTransaction>) request.getAttribute("walletTransactions");
    if (walletTransactions == null) walletTransactions = new ArrayList<WalletTransaction>();
    
    @SuppressWarnings("unchecked")
    List currentlyIssuedBooks = (List) request.getAttribute("currentlyIssuedBooks");
    if (currentlyIssuedBooks == null) currentlyIssuedBooks = new ArrayList();
    
    @SuppressWarnings("unchecked")
    List allIssueHistory = (List) request.getAttribute("allIssueHistory");
    if (allIssueHistory == null) allIssueHistory = new ArrayList();
    
    @SuppressWarnings("unchecked")
    List<Reservation> activeReservations = (List<Reservation>) request.getAttribute("activeReservations");
    if (activeReservations == null) activeReservations = new ArrayList<Reservation>();
    
    @SuppressWarnings("unchecked")
    List<Reservation> allReservations = (List<Reservation>) request.getAttribute("allReservations");
    if (allReservations == null) allReservations = new ArrayList<Reservation>();
    
    @SuppressWarnings("unchecked")
    List<Fine> pendingFines = (List<Fine>) request.getAttribute("pendingFines");
    if (pendingFines == null) pendingFines = new ArrayList<Fine>();
    
    @SuppressWarnings("unchecked")
    List<Fine> allFines = (List<Fine>) request.getAttribute("allFines");
    if (allFines == null) allFines = new ArrayList<Fine>();
    
    BigDecimal totalPendingFines = (BigDecimal) request.getAttribute("totalPendingFines");
    if (totalPendingFines == null) totalPendingFines = BigDecimal.ZERO;
    
    BigDecimal totalPaidFines = (BigDecimal) request.getAttribute("totalPaidFines");
    if (totalPaidFines == null) totalPaidFines = BigDecimal.ZERO;
    
    Integer totalBooksBorrowed = (Integer) request.getAttribute("totalBooksBorrowed");
    if (totalBooksBorrowed == null) totalBooksBorrowed = 0;
    
    Integer totalReservations = (Integer) request.getAttribute("totalReservations");
    if (totalReservations == null) totalReservations = 0;
    
    Integer activeLoans = (Integer) request.getAttribute("activeLoans");
    if (activeLoans == null) activeLoans = 0;
    
    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
    SimpleDateFormat sdfTime = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Details - <%= detailUser.getFullName() %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .user-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            font-weight: 700;
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }

        .user-info h1 {
            font-size: 1.75rem;
            color: #1a1a1a;
            margin-bottom: 0.25rem;
        }

        .user-info p {
            color: #666;
            font-size: 0.95rem;
        }

        .header-right {
            display: flex;
            gap: 1rem;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-secondary {
            background: #f5f5f5;
            color: #333;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            transition: transform 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-icon {
            font-size: 2rem;
            margin-bottom: 0.75rem;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 0.25rem;
        }

        .stat-label {
            color: #666;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .sections-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
        }

        .section {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            margin-bottom: 2rem;
        }

        .section-full {
            grid-column: 1 / -1;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f0f0f0;
        }

        .section-header i {
            font-size: 1.5rem;
            color: #667eea;
        }

        .section-header h2 {
            font-size: 1.25rem;
            color: #1a1a1a;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }

        .info-item {
            padding: 0.75rem 0;
        }

        .info-label {
            font-size: 0.85rem;
            color: #888;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.25rem;
        }

        .info-value {
            font-size: 1rem;
            color: #1a1a1a;
            font-weight: 500;
        }

        .badge {
            display: inline-block;
            padding: 0.35rem 0.85rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .badge-success {
            background: #d4edda;
            color: #155724;
        }

        .badge-warning {
            background: #fff3cd;
            color: #856404;
        }

        .badge-danger {
            background: #f8d7da;
            color: #721c24;
        }

        .badge-info {
            background: #d1ecf1;
            color: #0c5460;
        }

        .badge-premium {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }

        .badge-platinum {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }

        .badge-gold {
            background: linear-gradient(135deg, #ffd89b 0%, #ff9a56 100%);
            color: white;
        }

        .badge-silver {
            background: linear-gradient(135deg, #a8a8a8 0%, #c9c9c9 100%);
            color: white;
        }

        .amount-credit {
            font-weight: 600;
            color: #28a745;
        }

        .amount-debit {
            font-weight: 600;
            color: #dc3545;
        }

        .fine-amount-paid {
            font-weight: 700;
            color: #28a745;
        }

        .fine-amount-unpaid {
            font-weight: 700;
            color: #dc3545;
        }

        .table-container {
            overflow-x: auto;
            margin-top: 1rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table th {
            background: #f8f9fa;
            color: #333;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 1rem;
            text-align: left;
        }

        table td {
            padding: 1rem;
            border-bottom: 1px solid #f0f0f0;
            color: #333;
            font-size: 0.9rem;
        }

        table tr:hover {
            background: #f8f9fa;
        }

        .no-data {
            text-align: center;
            color: #999;
            padding: 3rem;
            font-size: 1.1rem;
        }

        .no-data i {
            font-size: 3rem;
            display: block;
            margin-bottom: 1rem;
            opacity: 0.3;
        }

        .membership-tier-badge {
            padding: 0.5rem 1rem;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.9rem;
            display: inline-block;
        }

        .tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid #f0f0f0;
        }

        .tab {
            padding: 0.75rem 1.5rem;
            border: none;
            background: none;
            color: #666;
            font-weight: 600;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
        }

        .tab.active {
            color: #667eea;
            border-bottom-color: #667eea;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        @media (max-width: 768px) {
            .sections-container {
                grid-template-columns: 1fr;
            }

            .header {
                flex-direction: column;
                text-align: center;
            }

            .header-left {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <div class="header-left">
                <div class="user-avatar">
                    <%= detailUser.getFirstName().substring(0,1).toUpperCase() + detailUser.getLastName().substring(0,1).toUpperCase() %>
                </div>
                <div class="user-info">
                    <h1><%= detailUser.getFullName() %></h1>
                    <p><i class="fas fa-envelope"></i> <%= detailUser.getEmail() %> | <i class="fas fa-user"></i> <%= detailUser.getUsername() %></p>
                </div>
            </div>
            <div class="header-right">
                <a href="${pageContext.request.contextPath}/admin/wallet?action=credit&userId=<%= detailUser.getUserId() %>" class="btn btn-primary">
                    <i class="fas fa-wallet"></i> Credit Wallet
                </a>
                <a href="${pageContext.request.contextPath}/memberList" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to List
                </a>
            </div>
        </div>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">📚</div>
                <div class="stat-value"><%= totalBooksBorrowed != null ? totalBooksBorrowed : 0 %></div>
                <div class="stat-label">Total Books Borrowed</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📖</div>
                <div class="stat-value"><%= activeLoans != null ? activeLoans : 0 %></div>
                <div class="stat-label">Active Loans</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🎫</div>
                <div class="stat-value"><%= totalReservations != null ? totalReservations : 0 %></div>
                <div class="stat-label">Total Reservations</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">💰</div>
                <div class="stat-value">$<%= String.format("%.2f", detailUser.getWalletBalance() != null ? detailUser.getWalletBalance() : BigDecimal.ZERO) %></div>
                <div class="stat-label">Wallet Balance</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">⚠️</div>
                <div class="stat-value">$<%= String.format("%.2f", totalPendingFines != null ? totalPendingFines : BigDecimal.ZERO) %></div>
                <div class="stat-label">Pending Fines</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">✅</div>
                <div class="stat-value">$<%= String.format("%.2f", totalPaidFines != null ? totalPaidFines : BigDecimal.ZERO) %></div>
                <div class="stat-label">Total Fines Paid</div>
            </div>
        </div>

        <!-- Sections -->
        <div class="sections-container">
            <!-- User Information -->
            <div class="section">
                <div class="section-header">
                    <i class="fas fa-user-circle"></i>
                    <h2>User Information</h2>
                </div>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">User ID</div>
                        <div class="info-value">#<%= detailUser.getUserId() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Username</div>
                        <div class="info-value"><%= detailUser.getUsername() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Email</div>
                        <div class="info-value"><%= detailUser.getEmail() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Full Name</div>
                        <div class="info-value"><%= detailUser.getFullName() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Role</div>
                        <div class="info-value">
                            <span class="badge <%= detailUser.getRole().name().equals("ADMIN") ? "badge-danger" : "badge-info" %>">
                                <%= detailUser.getRole().name() %>
                            </span>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Account Status</div>
                        <div class="info-value">
                            <span class="badge <%= detailUser.isActive() ? "badge-success" : "badge-danger" %>">
                                <%= detailUser.isActive() ? "Active" : "Inactive" %>
                            </span>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Created At</div>
                        <div class="info-value"><%= detailUser.getCreatedAt() != null ? sdfTime.format(detailUser.getCreatedAt()) : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Last Login</div>
                        <div class="info-value"><%= detailUser.getLastLogin() != null ? sdfTime.format(detailUser.getLastLogin()) : "Never" %></div>
                    </div>
                </div>
            </div>

            <!-- Member Information -->
            <div class="section">
                <div class="section-header">
                    <i class="fas fa-id-card"></i>
                    <h2>Membership Information</h2>
                </div>
                <% if (member != null) { %>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Member ID</div>
                        <div class="info-value">#<%= member.getMemberId() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Membership Number</div>
                        <div class="info-value"><%= member.getMembershipNumber() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Membership Type</div>
                        <div class="info-value">
                            <span class="membership-tier-badge badge-<%= member.getMembershipType().name().toLowerCase() %>">
                                <%= member.getMembershipType().name() %>
                            </span>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Join Date</div>
                        <div class="info-value"><%= member.getJoinDate() != null ? sdf.format(member.getJoinDate()) : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Expiry Date</div>
                        <div class="info-value"><%= member.getMembershipExpiry() != null ? sdf.format(member.getMembershipExpiry()) : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Status</div>
                        <div class="info-value">
                            <span class="badge <%= member.isActive() ? "badge-success" : "badge-danger" %>">
                                <%= member.getMembershipStatus() %>
                            </span>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Phone</div>
                        <div class="info-value"><%= member.getPhone() != null ? member.getPhone() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Address</div>
                        <div class="info-value"><%= member.getAddress() != null ? member.getAddress() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">City</div>
                        <div class="info-value"><%= member.getCity() != null ? member.getCity() : "N/A" %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">State</div>
                        <div class="info-value"><%= member.getState() != null ? member.getState() : "N/A" %></div>
                    </div>
                </div>
                <% } else { %>
                <div class="no-data">
                    <i class="fas fa-user-slash"></i>
                    <p>No membership information available</p>
                </div>
                <% } %>
            </div>

            <!-- Wallet Information -->
            <div class="section section-full">
                <div class="section-header">
                    <i class="fas fa-wallet"></i>
                    <h2>Wallet Information</h2>
                </div>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Available Balance</div>
                        <div class="info-value" style="color: #28a745; font-size: 1.5rem; font-weight: 700;">
                            $<%= String.format("%.2f", detailUser.getWalletBalance() != null ? detailUser.getWalletBalance() : BigDecimal.ZERO) %>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Pending Balance</div>
                        <div class="info-value" style="color: #ffc107; font-size: 1.5rem; font-weight: 700;">
                            $<%= String.format("%.2f", detailUser.getWalletPendingBalance() != null ? detailUser.getWalletPendingBalance() : BigDecimal.ZERO) %>
                        </div>
                    </div>
                </div>

                <% if (walletTransactions != null && !walletTransactions.isEmpty()) { %>
                <h3 style="margin-top: 2rem; margin-bottom: 1rem; color: #333;">Transaction History</h3>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Type</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Description</th>
                                <th>Approved By</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (WalletTransaction txn : walletTransactions) { %>
                            <%
                                String txnTypeStr = txn.getTransactionType() != null ? txn.getTransactionType().toString() : "";
                                String statusStr = txn.getStatus() != null ? txn.getStatus().toString() : "";
                                // Credit transactions: TOPUP, ADMIN_CREDIT, REFUND (green, +)
                                // Debit transactions: DEBIT, ADMIN_DEBIT (red, -)
                                boolean isCredit = txnTypeStr.contains("CREDIT") || txnTypeStr.contains("TOPUP") || txnTypeStr.contains("REFUND");
                                String amountColor = isCredit ? "#28a745" : "#dc3545";
                                String amountPrefix = isCredit ? "+" : "-";
                                String badgeClass = "badge-warning";
                                if ("APPROVED".equals(statusStr) || "COMPLETED".equals(statusStr)) {
                                    badgeClass = "badge-success";
                                } else if ("PENDING".equals(statusStr)) {
                                    badgeClass = "badge-warning";
                                } else {
                                    badgeClass = "badge-danger";
                                }
                                String amountClass = isCredit ? "amount-credit" : "amount-debit";
                            %>
                            <tr>
                                <td><%= txn.getCreatedAt() != null ? sdfTime.format(txn.getCreatedAt()) : "N/A" %></td>
                                <td><span class="badge badge-info"><%= txn.getTransactionType() %></span></td>
                                <td class="<%= amountClass %>">
                                    <%= amountPrefix %>$<%= String.format("%.2f", txn.getAmount()) %>
                                </td>
                                <td>
                                    <span class="badge <%= badgeClass %>">
                                        <%= txn.getStatus() %>
                                    </span>
                                </td>
                                <td><%= txn.getDescription() != null ? txn.getDescription() : "N/A" %></td>
                                <td><%= txn.getApprovedBy() != null ? "Admin #" + txn.getApprovedBy() : "N/A" %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="no-data">
                    <i class="fas fa-receipt"></i>
                    <p>No wallet transactions found</p>
                </div>
                <% } %>
            </div>

            <!-- Books & Reservations -->
            <div class="section section-full">
                <div class="section-header">
                    <i class="fas fa-books"></i>
                    <h2>Books & Reservations</h2>
                </div>

                <div class="tabs">
                    <button class="tab active" onclick="switchTab(event, 'active-reservations')">Active Reservations (<%= activeReservations != null ? activeReservations.size() : 0 %>)</button>
                    <button class="tab" onclick="switchTab(event, 'all-reservations')">All Reservations (<%= allReservations != null ? allReservations.size() : 0 %>)</button>
                    <button class="tab" onclick="switchTab(event, 'current-issues')">Current Issues (<%= currentlyIssuedBooks != null ? currentlyIssuedBooks.size() : 0 %>)</button>
                    <button class="tab" onclick="switchTab(event, 'issue-history')">Issue History (<%= allIssueHistory != null ? allIssueHistory.size() : 0 %>)</button>
                </div>

                <!-- Active Reservations Tab -->
                <div id="active-reservations" class="tab-content active">
                    <% if (activeReservations != null && !activeReservations.isEmpty()) { %>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Reservation ID</th>
                                    <th>Book ID</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Status</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Reservation res : activeReservations) { %>
                                <tr>
                                    <td>#<%= res.getReservationId() %></td>
                                    <td>#<%= res.getBookId() %></td>
                                    <td><%= res.getStartDate() != null ? sdf.format(res.getStartDate()) : "N/A" %></td>
                                    <td><%= res.getEndDate() != null ? sdf.format(res.getEndDate()) : "N/A" %></td>
                                    <td><span class="badge badge-info"><%= res.getReservationStatus() %></span></td>
                                    <td>$<%= String.format("%.2f", res.getTotalAmount()) %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="no-data">
                        <i class="fas fa-calendar-times"></i>
                        <p>No active reservations</p>
                    </div>
                    <% } %>
                </div>

                <!-- All Reservations Tab -->
                <div id="all-reservations" class="tab-content">
                    <% if (allReservations != null && !allReservations.isEmpty()) { %>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Reservation ID</th>
                                    <th>Book ID</th>
                                    <th>Reservation Date</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Status</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Reservation res : allReservations) { %>
                                <%
                                    String resStatusStr = res.getReservationStatus() != null ? res.getReservationStatus().toString() : "";
                                    String resBadgeClass = "badge-info";
                                    if ("ACTIVE".equals(resStatusStr) || "CONFIRMED".equals(resStatusStr)) {
                                        resBadgeClass = "badge-success";
                                    } else if ("PENDING".equals(resStatusStr)) {
                                        resBadgeClass = "badge-warning";
                                    } else if ("CANCELLED".equals(resStatusStr)) {
                                        resBadgeClass = "badge-danger";
                                    }
                                %>
                                <tr>
                                    <td>#<%= res.getReservationId() %></td>
                                    <td>#<%= res.getBookId() %></td>
                                    <td><%= res.getReservationDate() != null ? sdfTime.format(res.getReservationDate()) : "N/A" %></td>
                                    <td><%= res.getStartDate() != null ? sdf.format(res.getStartDate()) : "N/A" %></td>
                                    <td><%= res.getEndDate() != null ? sdf.format(res.getEndDate()) : "N/A" %></td>
                                    <td>
                                        <span class="badge <%= resBadgeClass %>">
                                            <%= res.getReservationStatus() %>
                                        </span>
                                    </td>
                                    <td>$<%= String.format("%.2f", res.getTotalAmount()) %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="no-data">
                        <i class="fas fa-calendar-times"></i>
                        <p>No reservations found</p>
                    </div>
                    <% } %>
                </div>

                <!-- Current Issues Tab -->
                <div id="current-issues" class="tab-content">
                    <% if (currentlyIssuedBooks != null && !currentlyIssuedBooks.isEmpty()) { %>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Transaction ID</th>
                                    <th>Book ID</th>
                                    <th>Issue Date</th>
                                    <th>Due Date</th>
                                    <th>Status</th>
                                    <th>Fine Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Object obj : currentlyIssuedBooks) { %>
                                <%
                                    try {
                                        java.lang.reflect.Method getTransactionId = obj.getClass().getMethod("getTransactionId");
                                        java.lang.reflect.Method getBookId = obj.getClass().getMethod("getBookId");
                                        java.lang.reflect.Method getIssueDate = obj.getClass().getMethod("getIssueDate");
                                        java.lang.reflect.Method getDueDate = obj.getClass().getMethod("getDueDate");
                                        java.lang.reflect.Method getStatus = obj.getClass().getMethod("getStatus");
                                        java.lang.reflect.Method getFineAmount = obj.getClass().getMethod("getFineAmount");
                                        
                                        Integer txnId = (Integer) getTransactionId.invoke(obj);
                                        Integer bookId = (Integer) getBookId.invoke(obj);
                                        java.sql.Timestamp issueDate = (java.sql.Timestamp) getIssueDate.invoke(obj);
                                        java.sql.Date dueDate = (java.sql.Date) getDueDate.invoke(obj);
                                        Object status = getStatus.invoke(obj);
                                        BigDecimal fineAmount = (BigDecimal) getFineAmount.invoke(obj);
                                %>
                                <tr>
                                    <td>#<%= txnId %></td>
                                    <td>#<%= bookId %></td>
                                    <td><%= issueDate != null ? sdfTime.format(issueDate) : "N/A" %></td>
                                    <td><%= dueDate != null ? sdf.format(dueDate) : "N/A" %></td>
                                    <td><span class="badge badge-warning"><%= status %></span></td>
                                    <td>$<%= String.format("%.2f", fineAmount != null ? fineAmount : BigDecimal.ZERO) %></td>
                                </tr>
                                <%
                                    } catch (Exception e) {
                                        System.err.println("Error displaying issue: " + e.getMessage());
                                    }
                                %>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="no-data">
                        <i class="fas fa-book-open"></i>
                        <p>No currently issued books</p>
                    </div>
                    <% } %>
                </div>

                <!-- Issue History Tab -->
                <div id="issue-history" class="tab-content">
                    <% if (allIssueHistory != null && !allIssueHistory.isEmpty()) { %>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Transaction ID</th>
                                    <th>Book ID</th>
                                    <th>Issue Date</th>
                                    <th>Due Date</th>
                                    <th>Return Date</th>
                                    <th>Status</th>
                                    <th>Fine Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Object obj : allIssueHistory) { %>
                                <%
                                    try {
                                        java.lang.reflect.Method getTransactionId = obj.getClass().getMethod("getTransactionId");
                                        java.lang.reflect.Method getBookId = obj.getClass().getMethod("getBookId");
                                        java.lang.reflect.Method getIssueDate = obj.getClass().getMethod("getIssueDate");
                                        java.lang.reflect.Method getDueDate = obj.getClass().getMethod("getDueDate");
                                        java.lang.reflect.Method getReturnDate = obj.getClass().getMethod("getReturnDate");
                                        java.lang.reflect.Method getStatus = obj.getClass().getMethod("getStatus");
                                        java.lang.reflect.Method getFineAmount = obj.getClass().getMethod("getFineAmount");
                                        
                                        Integer txnId = (Integer) getTransactionId.invoke(obj);
                                        Integer bookId = (Integer) getBookId.invoke(obj);
                                        java.sql.Timestamp issueDate = (java.sql.Timestamp) getIssueDate.invoke(obj);
                                        java.sql.Date dueDate = (java.sql.Date) getDueDate.invoke(obj);
                                        java.sql.Timestamp returnDate = (java.sql.Timestamp) getReturnDate.invoke(obj);
                                        Object status = getStatus.invoke(obj);
                                        BigDecimal fineAmount = (BigDecimal) getFineAmount.invoke(obj);
                                %>
                                <tr>
                                    <td>#<%= txnId %></td>
                                    <td>#<%= bookId %></td>
                                    <td><%= issueDate != null ? sdfTime.format(issueDate) : "N/A" %></td>
                                    <td><%= dueDate != null ? sdf.format(dueDate) : "N/A" %></td>
                                    <td><%= returnDate != null ? sdfTime.format(returnDate) : "Not Returned" %></td>
                                    <td>
                                        <span class="badge <%= status.toString().equals("RETURNED") ? "badge-success" : status.toString().equals("ISSUED") ? "badge-warning" : "badge-danger" %>">
                                            <%= status %>
                                        </span>
                                    </td>
                                    <td>$<%= String.format("%.2f", fineAmount != null ? fineAmount : BigDecimal.ZERO) %></td>
                                </tr>
                                <%
                                    } catch (Exception e) {
                                        System.err.println("Error displaying issue history: " + e.getMessage());
                                    }
                                %>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="no-data">
                        <i class="fas fa-history"></i>
                        <p>No issue history found</p>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Fines -->
            <div class="section section-full">
                <div class="section-header">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h2>Fines</h2>
                </div>

                <div class="tabs">
                    <button class="tab active" onclick="switchTab(event, 'pending-fines')">Pending Fines (<%= pendingFines != null ? pendingFines.size() : 0 %>)</button>
                    <button class="tab" onclick="switchTab(event, 'all-fines')">All Fines (<%= allFines != null ? allFines.size() : 0 %>)</button>
                </div>

                <!-- Pending Fines Tab -->
                <div id="pending-fines" class="tab-content active">
                    <% if (pendingFines != null && !pendingFines.isEmpty()) { %>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Fine ID</th>
                                    <th>Transaction ID</th>
                                    <th>Amount</th>
                                    <th>Type</th>
                                    <th>Fine Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Fine fine : pendingFines) { %>
                                <tr>
                                    <td>#<%= fine.getFineId() %></td>
                                    <td>#<%= fine.getTransactionId() %></td>
                                    <td style="font-weight: 700; color: #dc3545;">$<%= String.format("%.2f", fine.getFineAmount()) %></td>
                                    <td><%= fine.getFineType() != null ? fine.getFineType().toString() : "N/A" %></td>
                                    <td><%= fine.getFineDate() != null ? sdf.format(fine.getFineDate()) : "N/A" %></td>
                                    <td><span class="badge badge-warning"><%= fine.getStatus() %></span></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="no-data">
                        <i class="fas fa-check-circle"></i>
                        <p>No pending fines</p>
                    </div>
                    <% } %>
                </div>

                <!-- All Fines Tab -->
                <div id="all-fines" class="tab-content">
                    <% if (allFines != null && !allFines.isEmpty()) { %>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Fine ID</th>
                                    <th>Transaction ID</th>
                                    <th>Amount</th>
                                    <th>Type</th>
                                    <th>Fine Date</th>
                                    <th>Payment Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Fine fine : allFines) { %>
                                <%
                                    String fineStatusStr = fine.getStatus() != null ? fine.getStatus().toString() : "";
                                    String fineAmountColor = "PAID".equals(fineStatusStr) ? "#28a745" : "#dc3545";
                                    String fineBadgeClass = "badge-warning";
                                    if ("PAID".equals(fineStatusStr)) {
                                        fineBadgeClass = "badge-success";
                                    } else if ("WAIVED".equals(fineStatusStr)) {
                                        fineBadgeClass = "badge-info";
                                    }
                                    String fineAmountClass = "PAID".equals(fineStatusStr) ? "fine-amount-paid" : "fine-amount-unpaid";
                                %>
                                <tr>
                                    <td>#<%= fine.getFineId() %></td>
                                    <td>#<%= fine.getTransactionId() %></td>
                                    <td class="<%= fineAmountClass %>">
                                        $<%= String.format("%.2f", fine.getFineAmount()) %>
                                    </td>
                                    <td><%= fine.getFineType() != null ? fine.getFineType().toString() : "N/A" %></td>
                                    <td><%= fine.getFineDate() != null ? sdf.format(fine.getFineDate()) : "N/A" %></td>
                                    <td><%= fine.getPaymentDate() != null ? sdf.format(fine.getPaymentDate()) : "Not Paid" %></td>
                                    <td>
                                        <span class="badge <%= fineBadgeClass %>">
                                            <%= fine.getStatus() %>
                                        </span>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="no-data">
                        <i class="fas fa-file-invoice-dollar"></i>
                        <p>No fines found</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <script>
        function switchTab(event, tabId) {
            // Hide all tab contents in the same section
            const section = event.target.closest('.section');
            const tabContents = section.querySelectorAll('.tab-content');
            const tabs = section.querySelectorAll('.tab');
            
            tabContents.forEach(content => content.classList.remove('active'));
            tabs.forEach(tab => tab.classList.remove('active'));
            
            // Show the selected tab
            document.getElementById(tabId).classList.add('active');
            event.target.classList.add('active');
        }
    </script>
</body>
</html>

