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
    <title>Join LibraryHub - Membership Enrollment</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        .container {
            max-width: 700px;
            width: 100%;
        }

        .invitation-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 3rem 2rem;
            text-align: center;
            color: white;
        }

        .header-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .header h1 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .header p {
            font-size: 1.1rem;
            opacity: 0.95;
        }

        .content {
            padding: 3rem 2.5rem;
        }

        .welcome-message {
            text-align: center;
            margin-bottom: 2rem;
        }

        .welcome-message h2 {
            color: #1a1a1a;
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        .welcome-message p {
            color: #6b7280;
            font-size: 1rem;
        }

        .membership-info {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            border: 2px solid #3b82f6;
            border-radius: 12px;
            padding: 2rem;
            margin: 2rem 0;
        }

        .tier-badge {
            display: inline-block;
            background: linear-gradient(135deg, #94a3b8, #cbd5e1);
            color: #1e293b;
            padding: 0.5rem 1.25rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 1rem;
        }

        .benefits-list {
            list-style: none;
            padding: 0;
            margin: 1.5rem 0;
        }

        .benefits-list li {
            padding: 0.75rem 0;
            color: #1e40af;
            font-size: 1.05rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .benefits-list li::before {
            content: "✓";
            background: #3b82f6;
            color: white;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            flex-shrink: 0;
        }

        .price-tag {
            text-align: center;
            padding: 1.5rem;
            background: white;
            border-radius: 8px;
            margin-top: 1.5rem;
        }

        .price-tag .price {
            font-size: 3rem;
            font-weight: 700;
            color: #059669;
            margin-bottom: 0.5rem;
        }

        .price-tag .period {
            color: #6b7280;
            font-size: 1.1rem;
        }

        .actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            flex: 1;
            padding: 1rem 2rem;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            text-decoration: none;
            display: block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #1d4ed8, #1e40af);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.4);
        }

        .btn-secondary {
            background: white;
            color: #374151;
            border: 2px solid #e5e7eb;
        }

        .btn-secondary:hover {
            background: #f9fafb;
            border-color: #d1d5db;
        }

        .note {
            text-align: center;
            margin-top: 2rem;
            padding: 1rem;
            background: #fef3c7;
            border-radius: 8px;
            color: #92400e;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="invitation-card">
            <div class="header">
                <div class="header-icon">🎉</div>
                <h1>Welcome to LibraryHub!</h1>
                <p>One more step to unlock your reading journey</p>
            </div>

            <div class="content">
                <div class="welcome-message">
                    <h2>Hi <%= user.getFirstName() != null ? user.getFirstName() : user.getUsername() %>!</h2>
                    <p>Your account is ready. Now let's set up your library membership.</p>
                </div>

                <div class="membership-info">
                    <span class="tier-badge">🥈 SILVER MEMBERSHIP</span>
                    <h3 style="color: #1e40af; margin: 1rem 0;">Included FREE with your account!</h3>
                    
                    <ul class="benefits-list">
                        <li>Borrow up to <strong>3 books</strong> at a time</li>
                        <li><strong>14-day</strong> borrowing period per book</li>
                        <li>Access to entire library catalog</li>
                        <li>Standard support from our team</li>
                        <li>Book reservations available</li>
                        <li>Reading history tracking</li>
                    </ul>

                    <div class="price-tag">
                        <div class="price">FREE</div>
                        <div class="period">No credit card required</div>
                    </div>
                </div>

                <div class="note">
                    💡 <strong>Quick Setup:</strong> Fill in a short form with your contact information to activate your membership. Takes less than 2 minutes!
                </div>

                <div class="actions">
                    <a href="<%= request.getContextPath() %>/membershipEnrollment?action=form" class="btn btn-primary">
                        ✓ Yes, Enroll Me Now!
                    </a>
                    <a href="<%= request.getContextPath() %>/logout" class="btn btn-secondary">
                        Maybe Later
                    </a>
                </div>

                <p style="text-align: center; margin-top: 1.5rem; color: #6b7280; font-size: 0.9rem;">
                    ⭐ You can upgrade to GOLD ($90/year) or PLATINUM ($120/year) anytime later!
                </p>
            </div>
        </div>
    </div>
</body>
</html>


