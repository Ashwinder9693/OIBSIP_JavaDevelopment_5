<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.Member" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    Member member = (Member) request.getAttribute("member");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - LibraryHub</title>
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
            max-width: 1200px;
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
        
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-top: 1rem;
            animation: slideDown 0.3s ease-out;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #6ee7b7;
        }
        
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }

        .profile-grid {
            display: grid;
            gap: 2rem;
        }

        .profile-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
            transition: all 0.3s ease;
        }

        .profile-card:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
        }

        .card-header {
            background: #f8f9fa;
            padding: 1.25rem 1.75rem;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-header h3 {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1a1a1a;
            letter-spacing: -0.025em;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin: 0;
        }
        
        .edit-profile-btn {
            padding: 0.5rem 1rem;
            background: #2563eb;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
        }
        
        .edit-profile-btn:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.3);
        }

        .card-icon {
            font-size: 1.25rem;
        }

        .card-body {
            padding: 1.75rem;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 0.375rem;
        }

        .info-label {
            font-size: 0.8125rem;
            font-weight: 500;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .info-value {
            font-size: 0.9375rem;
            color: #1a1a1a;
            font-weight: 500;
        }

        .info-value.empty {
            color: #9ca3af;
            font-style: italic;
        }
        
        /* Membership Upgrade Styles */
        .upgrade-card {
            background: linear-gradient(to bottom, #ffffff, #f8f9fa);
        }
        
        .current-tier {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .tier-label {
            font-weight: 600;
            color: #374151;
        }
        
        .tier-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .tier-silver {
            background: linear-gradient(135deg, #94a3b8, #cbd5e1);
            color: #1e293b;
        }
        
        .tier-gold {
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            color: #78350f;
        }
        
        .tier-platinum {
            background: linear-gradient(135deg, #a78bfa, #8b5cf6);
            color: white;
        }
        
        .tier-benefits {
            color: #6b7280;
            margin: 0.5rem 0 1rem;
            padding: 0.75rem;
            background: #f9fafb;
            border-radius: 6px;
            border-left: 3px solid #2563eb;
        }
        
        .upgrade-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }
        
        .tier-card {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 1.5rem;
            transition: all 0.3s ease;
        }
        
        .tier-card:hover {
            border-color: #2563eb;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.15);
            transform: translateY(-2px);
        }
        
        .tier-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .tier-card-header h5 {
            margin: 0;
            font-size: 1.125rem;
            font-weight: 600;
            color: #1a1a1a;
        }
        
        .tier-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2563eb;
        }
        
        .tier-features {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .tier-features li {
            padding: 0.5rem 0;
            color: #374151;
            font-size: 0.9375rem;
        }
        
        .upgrade-btn {
            width: 100%;
            padding: 0.75rem 1.5rem;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9375rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .upgrade-btn:hover {
            background: linear-gradient(135deg, #1d4ed8, #1e40af);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.4);
        }
        
        .upgrade-btn-platinum {
            background: linear-gradient(135deg, #8b5cf6, #7c3aed);
        }
        
        .upgrade-btn-platinum:hover {
            background: linear-gradient(135deg, #7c3aed, #6d28d9);
            box-shadow: 0 4px 12px rgba(139, 92, 246, 0.4);
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
            width: fit-content;
        }

        .status-badge.active {
            background: #dcfce7;
            color: #16a34a;
            border: 1px solid #86efac;
        }

        .status-badge.inactive {
            background: #fee2e2;
            color: #dc2626;
            border: 1px solid #fca5a5;
        }

        .status-badge.expired {
            background: #fef3c7;
            color: #ca8a04;
            border: 1px solid #fcd34d;
        }

        .profile-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .user-header-section {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid #e5e7eb;
            margin-bottom: 1.5rem;
        }

        .user-name-section h4 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 0.25rem;
            letter-spacing: -0.025em;
        }

        .user-role {
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

        .profile-card {
            animation: fadeIn 0.4s ease-out;
        }

        .profile-card:nth-child(1) { animation-delay: 0.1s; }
        .profile-card:nth-child(2) { animation-delay: 0.2s; }
        .profile-card:nth-child(3) { animation-delay: 0.3s; }
        .profile-card:nth-child(4) { animation-delay: 0.4s; }

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

            .page-header h2 {
                font-size: 1.5rem;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .user-header-section {
                flex-direction: column;
                text-align: center;
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
            <h2>My Profile</h2>
            <p>Manage your account information and preferences</p>
            
            <% if (session.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <%= session.getAttribute("success") %>
                <% session.removeAttribute("success"); %>
            </div>
            <% } %>
            
            <% if (session.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= session.getAttribute("error") %>
                <% session.removeAttribute("error"); %>
            </div>
            <% } %>
        </div>

        <div class="profile-grid">
            <div class="profile-card">
                <div class="card-header">
                    <h3><span class="card-icon">👤</span> Account Information</h3>
                    <a href="<%= request.getContextPath() %>/editProfile" class="edit-profile-btn">
                        <span style="margin-right: 5px;">✏️</span> Edit Profile
                    </a>
                </div>
                <div class="card-body">
                    <div class="user-header-section">
                        <% if (user.getProfileImageUrl() != null && !user.getProfileImageUrl().trim().isEmpty()) { %>
                        <img src="<%= user.getProfileImageUrl() %>" alt="Profile" class="profile-avatar" style="object-fit: cover; border: 3px solid white; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                        <% } else { %>
                        <div class="profile-avatar">👤</div>
                        <% } %>
                        <div class="user-name-section">
                            <h4><%= user.getFirstName() != null ? user.getFirstName() : "" %> <%= user.getLastName() != null ? user.getLastName() : "" %></h4>
                            <div class="user-role"><%= user.getRole() != null ? user.getRole().name() : "MEMBER" %></div>
                        </div>
                    </div>

                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Username</div>
                            <div class="info-value"><%= user.getUsername() != null ? user.getUsername() : "N/A" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Email Address</div>
                            <div class="info-value"><%= user.getEmail() != null ? user.getEmail() : "N/A" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">First Name</div>
                            <div class="info-value"><%= user.getFirstName() != null ? user.getFirstName() : "N/A" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Last Name</div>
                            <div class="info-value"><%= user.getLastName() != null ? user.getLastName() : "N/A" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Account Status</div>
                            <div class="info-value">
                                <span class="status-badge <%= user.isActive() ? "active" : "inactive" %>">
                                    <%= user.isActive() ? "ACTIVE" : "INACTIVE" %>
                                </span>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Email Verified</div>
                            <div class="info-value">
                                <span class="status-badge <%= user.isEmailVerified() ? "active" : "inactive" %>">
                                    <%= user.isEmailVerified() ? "VERIFIED" : "NOT VERIFIED" %>
                                </span>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Two-Factor Auth</div>
                            <div class="info-value">
                                <span class="status-badge <%= user.isTwoFactorEnabled() ? "active" : "inactive" %>">
                                    <%= user.isTwoFactorEnabled() ? "ENABLED" : "DISABLED" %>
                                </span>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Login Count</div>
                            <div class="info-value"><%= user.getLoginCount() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Last Login</div>
                            <div class="info-value"><%= user.getLastLogin() != null ? datetimeFormat.format(user.getLastLogin()) : "Never" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Account Created</div>
                            <div class="info-value"><%= user.getCreatedAt() != null ? datetimeFormat.format(user.getCreatedAt()) : "N/A" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Last Updated</div>
                            <div class="info-value"><%= user.getUpdatedAt() != null ? datetimeFormat.format(user.getUpdatedAt()) : "N/A" %></div>
                        </div>
                        <% if (user.getBio() != null && !user.getBio().trim().isEmpty()) { %>
                        <div class="info-item" style="grid-column: 1 / -1;">
                            <div class="info-label">Bio</div>
                            <div class="info-value"><%= user.getBio() %></div>
                        </div>
                        <% } %>
                        <% if (user.getPreferences() != null && !user.getPreferences().trim().isEmpty()) { %>
                        <div class="info-item" style="grid-column: 1 / -1; border-top: 1px solid #e5e7eb; padding-top: 1rem; margin-top: 0.5rem;">
                            <div class="info-label">Preferences (JSON)</div>
                            <div class="info-value" style="font-family: monospace; font-size: 0.875rem; background-color: #f9fafb; padding: 0.5rem; border-radius: 4px; overflow-x: auto;">
                                <%= user.getPreferences() %>
                            </div>
                        </div>
                        <% } %>
                        <% if (user.getNotificationSettings() != null && !user.getNotificationSettings().trim().isEmpty()) { %>
                        <div class="info-item" style="grid-column: 1 / -1;">
                            <div class="info-label">Notification Settings (JSON)</div>
                            <div class="info-value" style="font-family: monospace; font-size: 0.875rem; background-color: #f9fafb; padding: 0.5rem; border-radius: 4px; overflow-x: auto;">
                                <%= user.getNotificationSettings() %>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <% if (member != null) { %>
            <div class="profile-card">
                <div class="card-header">
                    <h3><span class="card-icon">🎫</span> Membership Details</h3>
                </div>
                <div class="card-body">
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Member ID</div>
                            <div class="info-value"><%= member.getMemberId() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Membership Number</div>
                            <div class="info-value"><%= member.getMembershipNumber() != null ? member.getMembershipNumber() : "N/A" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Membership Type</div>
                            <div class="info-value"><%= member.getMembershipType() != null ? member.getMembershipType().name() : "N/A" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Join Date</div>
                            <div class="info-value"><%= member.getJoinDate() != null ? dateFormat.format(member.getJoinDate()) : "N/A" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Expiry Date</div>
                            <div class="info-value"><%= member.getExpiryDate() != null ? dateFormat.format(member.getExpiryDate()) : "N/A" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Membership Status</div>
                            <div class="info-value">
                                <% 
                                    String statusClass = "";
                                    String statusName = "";
                                    if (member.isActive()) {
                                        statusClass = "active";
                                        statusName = "ACTIVE";
                                    } else {
                                        statusClass = "inactive";
                                        statusName = "INACTIVE";
                                    }
                                %>
                                <span class="status-badge <%= statusClass %>">
                                    <%= statusName %>
                                </span>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Max Books Allowed</div>
                            <div class="info-value"><%= member.getMaxBooksAllowed() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Max Days Allowed</div>
                            <div class="info-value"><%= member.getMaxDaysAllowed() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Total Books Borrowed</div>
                            <div class="info-value"><%= member.getTotalBooksBorrowed() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Total Fines Paid</div>
                            <div class="info-value">$<%= member.getTotalFinesPaid() != null ? member.getTotalFinesPaid().toString() : "0.00" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Outstanding Fines</div>
                            <div class="info-value">$<%= member.getOutstandingFines() != null ? member.getOutstandingFines().toString() : "0.00" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Blacklist Status</div>
                            <div class="info-value">
                                <% if (member.isBlacklisted()) { %>
                                <span class="status-badge inactive">BLACKLISTED</span>
                                <% } else { %>
                                <span class="status-badge active">NOT BLACKLISTED</span>
                                <% } %>
                            </div>
                        </div>
                        <% if (member.isBlacklisted() && member.getBlacklistReason() != null && !member.getBlacklistReason().trim().isEmpty()) { %>
                        <div class="info-item" style="grid-column: 1 / -1;">
                            <div class="info-label">Blacklist Reason</div>
                            <div class="info-value" style="color: #dc2626;"><%= member.getBlacklistReason() %></div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Membership Upgrade Section -->
            <div class="profile-card upgrade-card">
                <div class="card-header" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <h3 style="color: white;"><span class="card-icon">⭐</span> Upgrade Membership</h3>
                </div>
                <div class="card-body">
                    <div class="current-tier">
                        <span class="tier-label">Current Tier:</span>
                        <span class="tier-badge tier-<%= member.getMembershipType().name().toLowerCase() %>">
                            <%= member.getMembershipType().name() %>
                        </span>
                    </div>
                    <p class="tier-benefits"><%= com.library.entity.Member.getMembershipBenefits(member.getMembershipType()) %></p>
                    
                    <% if (member.getMembershipType() != com.library.entity.Member.MembershipType.PLATINUM) { %>
                    <div class="upgrade-options">
                        <h4 style="margin: 1.5rem 0 1rem; font-size: 1rem; font-weight: 600;">Upgrade Options:</h4>
                        
                        <% if (member.getMembershipType() != com.library.entity.Member.MembershipType.GOLD && 
                               member.getMembershipType() != com.library.entity.Member.MembershipType.PLATINUM) { %>
                        <div class="tier-card">
                            <div class="tier-card-header">
                                <h5>🥇 Gold Membership</h5>
                                <span class="tier-price">$90<span style="font-size: 0.875rem; font-weight: normal;">/year</span></span>
                            </div>
                            <ul class="tier-features">
                                <li>✓ 10 books at a time</li>
                                <li>✓ 30 days borrowing period</li>
                                <li>✓ Priority support</li>
                                <li>✓ No late fees for 3 days grace period</li>
                            </ul>
                            <form action="<%= request.getContextPath() %>/upgradeMembership" method="post" style="margin-top: 1rem;">
                                <input type="hidden" name="newTier" value="GOLD">
                                <button type="submit" class="upgrade-btn">Upgrade to Gold</button>
                            </form>
                        </div>
                        <% } %>
                        
                        <% if (member.getMembershipType() != com.library.entity.Member.MembershipType.PLATINUM) { %>
                        <div class="tier-card">
                            <div class="tier-card-header">
                                <h5>💎 Platinum Membership</h5>
                                <span class="tier-price">$120<span style="font-size: 0.875rem; font-weight: normal;">/year</span></span>
                            </div>
                            <ul class="tier-features">
                                <li>✓ 20 books at a time</li>
                                <li>✓ 60 days borrowing period</li>
                                <li>✓ VIP support</li>
                                <li>✓ No late fees for 7 days grace period</li>
                                <li>✓ Free book reservations</li>
                                <li>✓ Exclusive events access</li>
                            </ul>
                            <form action="<%= request.getContextPath() %>/upgradeMembership" method="post" style="margin-top: 1rem;">
                                <input type="hidden" name="newTier" value="PLATINUM">
                                <button type="submit" class="upgrade-btn upgrade-btn-platinum">Upgrade to Platinum</button>
                            </form>
                        </div>
                        <% } %>
                    </div>
                    <% } else { %>
                    <div style="text-align: center; padding: 2rem; background: #f0fdf4; border-radius: 8px; margin-top: 1rem;">
                        <h4 style="color: #059669; margin-bottom: 0.5rem;">🎉 You're on our highest tier!</h4>
                        <p style="color: #047857; margin: 0;">Enjoy all premium benefits and exclusive access.</p>
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="profile-card">
                <div class="card-header">
                    <h3><span class="card-icon">📍</span> Contact Information</h3>
                </div>
                <div class="card-body">
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Phone Number</div>
                            <div class="info-value <%= member.getPhone() == null || member.getPhone().trim().isEmpty() ? "empty" : "" %>">
                                <%= member.getPhone() != null && !member.getPhone().trim().isEmpty() ? member.getPhone() : "—" %>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Alternate Phone</div>
                            <div class="info-value <%= member.getAlternatePhone() == null || member.getAlternatePhone().trim().isEmpty() ? "empty" : "" %>">
                                <%= member.getAlternatePhone() != null && !member.getAlternatePhone().trim().isEmpty() ? member.getAlternatePhone() : "—" %>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Address</div>
                            <div class="info-value <%= member.getAddress() == null || member.getAddress().trim().isEmpty() ? "empty" : "" %>">
                                <%= member.getAddress() != null && !member.getAddress().trim().isEmpty() ? member.getAddress() : "—" %>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">City</div>
                            <div class="info-value <%= member.getCity() == null || member.getCity().trim().isEmpty() ? "empty" : "" %>">
                                <%= member.getCity() != null && !member.getCity().trim().isEmpty() ? member.getCity() : "—" %>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">State</div>
                            <div class="info-value <%= member.getState() == null || member.getState().trim().isEmpty() ? "empty" : "" %>">
                                <%= member.getState() != null && !member.getState().trim().isEmpty() ? member.getState() : "—" %>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Zip Code</div>
                            <div class="info-value <%= member.getZipCode() == null || member.getZipCode().trim().isEmpty() ? "empty" : "" %>">
                                <%= member.getZipCode() != null && !member.getZipCode().trim().isEmpty() ? member.getZipCode() : "—" %>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Country</div>
                            <div class="info-value <%= member.getCountry() == null || member.getCountry().trim().isEmpty() ? "empty" : "" %>">
                                <%= member.getCountry() != null && !member.getCountry().trim().isEmpty() ? member.getCountry() : "—" %>
                            </div>
                        </div>
                        <div class="info-item" style="grid-column: 1 / -1; border-top: 1px solid #e5e7eb; padding-top: 1rem; margin-top: 0.5rem;">
                            <div class="info-label">Emergency Contact Name</div>
                            <div class="info-value <%= member.getEmergencyContactName() == null || member.getEmergencyContactName().trim().isEmpty() ? "empty" : "" %>">
                                <%= member.getEmergencyContactName() != null && !member.getEmergencyContactName().trim().isEmpty() ? member.getEmergencyContactName() : "—" %>
                            </div>
                        </div>
                        <div class="info-item" style="grid-column: 1 / -1;">
                            <div class="info-label">Emergency Contact Phone</div>
                            <div class="info-value <%= member.getEmergencyContactPhone() == null || member.getEmergencyContactPhone().trim().isEmpty() ? "empty" : "" %>">
                                <%= member.getEmergencyContactPhone() != null && !member.getEmergencyContactPhone().trim().isEmpty() ? member.getEmergencyContactPhone() : "—" %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="profile-card">
                <div class="card-header">
                    <h3><span class="card-icon">ℹ️</span> Personal Information</h3>
                </div>
                <div class="card-body">
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Date of Birth</div>
                            <div class="info-value"><%= member.getDateOfBirth() != null ? dateFormat.format(member.getDateOfBirth()) : "—" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Gender</div>
                            <div class="info-value"><%= member.getGender() != null ? member.getGender().name() : "—" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Occupation</div>
                            <div class="info-value <%= member.getOccupation() == null || member.getOccupation().trim().isEmpty() ? "empty" : "" %>">
                                <%= member.getOccupation() != null && !member.getOccupation().trim().isEmpty() ? member.getOccupation() : "—" %>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Organization</div>
                            <div class="info-value <%= member.getOrganization() == null || member.getOrganization().trim().isEmpty() ? "empty" : "" %>">
                                <%= member.getOrganization() != null && !member.getOrganization().trim().isEmpty() ? member.getOrganization() : "—" %>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Member Created</div>
                            <div class="info-value"><%= member.getCreatedAt() != null ? datetimeFormat.format(member.getCreatedAt()) : "N/A" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Last Updated</div>
                            <div class="info-value"><%= member.getUpdatedAt() != null ? datetimeFormat.format(member.getUpdatedAt()) : "N/A" %></div>
                        </div>
                    </div>
                </div>
            </div>
            <% } else { %>
            <div class="profile-card">
                <div class="card-header">
                    <h3><span class="card-icon">⚠️</span> Membership Not Found</h3>
                </div>
                <div class="card-body">
                    <p style="color: #6b7280;">No membership information found for this account. Please contact the library administrator.</p>
                </div>
            </div>
            <% } %>
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