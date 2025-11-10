<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.Book" %>
<%@ page import="com.library.entity.Member" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    Book book = (Book) request.getAttribute("book");
    if(book == null) {
        response.sendRedirect(request.getContextPath() + "/browseBooks");
        return;
    }
    Member member = (Member) request.getAttribute("member");
    
    // Get membership type (default to SILVER if not a member)
    Member.MembershipType membershipType = (member != null && member.getMembershipType() != null) 
        ? member.getMembershipType() 
        : Member.MembershipType.SILVER;
    
    // Get book base price
    java.math.BigDecimal basePrice = (book.getPrice() != null && book.getPrice().compareTo(java.math.BigDecimal.ZERO) > 0) 
        ? book.getPrice() 
        : new java.math.BigDecimal("25.00");
    
    // Calculate price per day based on membership tier
    java.math.BigDecimal rentalRate = Member.getRentalRatePercentage(membershipType);
    java.math.BigDecimal pricePerDay = basePrice.multiply(rentalRate);
    
    // Calculate discount information
    java.math.BigDecimal baseSilverRate = basePrice.multiply(new java.math.BigDecimal("0.20"));
    java.math.BigDecimal discountPerDay = baseSilverRate.subtract(pricePerDay);
    int discountPercentage = Member.getDiscountPercentage(membershipType);
    
    // Set minimum date to today
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String minDate = sdf.format(new Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reserve Book - LibraryHub</title>
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
            max-width: 1000px;
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

        .reservation-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .membership-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.625rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.875rem;
            margin-bottom: 1rem;
        }
        
        .badge-silver {
            background: linear-gradient(135deg, #94a3b8, #cbd5e1);
            color: #1e293b;
        }
        
        .badge-gold {
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            color: #78350f;
        }
        
        .badge-platinum {
            background: linear-gradient(135deg, #818cf8, #6366f1);
            color: white;
        }
        
        .discount-banner {
            background: #f0fdf4;
            border: 2px solid #86efac;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .discount-icon {
            font-size: 1.5rem;
        }
        
        .discount-text {
            flex: 1;
        }
        
        .discount-title {
            font-weight: 700;
            color: #166534;
            margin-bottom: 0.25rem;
        }
        
        .discount-description {
            font-size: 0.875rem;
            color: #15803d;
        }
        
        .book-info {
            border-bottom: 1px solid #e5e7eb;
            padding-bottom: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .book-info h3 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 0.75rem;
        }

        .book-detail {
            display: flex;
            margin-bottom: 0.5rem;
            font-size: 0.9375rem;
        }

        .book-detail-label {
            font-weight: 600;
            color: #374151;
            min-width: 100px;
        }

        .book-detail-value {
            color: #6b7280;
        }

        .price-highlight {
            font-size: 1.25rem;
            font-weight: 700;
            color: #2563eb;
            margin-top: 0.5rem;
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

        .form-input {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.9375rem;
            font-family: inherit;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.9375rem;
            font-family: inherit;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .form-select:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .summary-box {
            background: #f8f9fa;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            font-size: 0.9375rem;
        }

        .summary-row:last-child {
            margin-bottom: 0;
            padding-top: 0.75rem;
            border-top: 2px solid #e5e7eb;
            font-size: 1.125rem;
            font-weight: 700;
            color: #1a1a1a;
        }

        .summary-label {
            color: #6b7280;
        }

        .summary-value {
            font-weight: 600;
            color: #1a1a1a;
        }

        .summary-row:last-child .summary-value {
            font-size: 1.5rem;
            color: #2563eb;
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

        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.9375rem;
        }

        .alert-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #991b1b;
        }

        .alert-success {
            background: #f0fdf4;
            border: 1px solid #86efac;
            color: #166534;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1.5rem;
            }

            .form-actions {
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
        <div class="page-header">
            <h2>Reserve Book</h2>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <div class="reservation-card">
            <div class="membership-badge badge-<%= membershipType.name().toLowerCase() %>">
                ⭐ <%= membershipType.name() %> Member
            </div>
            
            <% if (discountPercentage > 0) { %>
            <div class="discount-banner">
                <div class="discount-icon">🎉</div>
                <div class="discount-text">
                    <div class="discount-title"><%= discountPercentage %>% Member Discount Applied!</div>
                    <div class="discount-description">You're saving $<%= String.format("%.2f", discountPerDay) %>/day with your <%= membershipType.name() %> membership</div>
                </div>
            </div>
            <% } %>
            
            <div class="book-info">
                <h3><%= book.getTitle() %></h3>
                <div class="book-detail">
                    <span class="book-detail-label">Publication Year:</span>
                    <span class="book-detail-value"><%= book.getPublicationYear() != null ? book.getPublicationYear() : "N/A" %></span>
                </div>
                <div class="book-detail">
                    <span class="book-detail-label">ISBN:</span>
                    <span class="book-detail-value"><%= book.getIsbn() %></span>
                </div>
                <div class="book-detail">
                    <span class="book-detail-label">Price per day:</span>
                    <span class="book-detail-value price-highlight">$<%= String.format("%.2f", pricePerDay) %></span>
                </div>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/reservation">
                <input type="hidden" name="action" value="create">
                <input type="hidden" name="bookId" value="<%= book.getBookId() %>">

                <div class="form-group">
                    <label class="form-label" for="startDate">Start Date</label>
                    <input type="date" id="startDate" name="startDate" class="form-input" 
                           min="<%= minDate %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="numberOfDays">Number of Days</label>
                    <input type="number" id="numberOfDays" name="numberOfDays" class="form-input" 
                           min="1" max="30" value="7" required>
                    <small style="color: #6b7280; font-size: 0.875rem; margin-top: 0.25rem; display: block;">
                        Maximum 30 days per reservation
                    </small>
                </div>

                <div class="form-group">
                    <label class="form-label" for="paymentMethod">Payment Method</label>
                    <select id="paymentMethod" name="paymentMethod" class="form-select" required onchange="togglePaymentReference()">
                        <option value="">Select payment method</option>
                        <option value="Wallet">💳 Wallet (Balance: $<%= String.format("%.2f", user.getWalletBalance()) %>)</option>
                        <option value="Credit Card">Credit Card</option>
                        <option value="Debit Card">Debit Card</option>
                        <option value="PayPal">PayPal</option>
                        <option value="Cash">Cash</option>
                        <option value="Bank Transfer">Bank Transfer</option>
                    </select>
                </div>

                <div class="form-group" id="paymentReferenceGroup">
                    <label class="form-label" for="paymentReference">Payment Reference (Optional)</label>
                    <input type="text" id="paymentReference" name="paymentReference" class="form-input" 
                           placeholder="Transaction ID, receipt number, etc.">
                </div>

                <div class="summary-box">
                    <% if (discountPercentage > 0) { %>
                    <div class="summary-row">
                        <span class="summary-label">Regular price/day:</span>
                        <span class="summary-value" style="text-decoration: line-through; color: #9ca3af;">$<%= String.format("%.2f", baseSilverRate) %></span>
                    </div>
                    <% } %>
                    <div class="summary-row">
                        <span class="summary-label">Your price/day<% if (discountPercentage > 0) { %> (<%= discountPercentage %>% off)<% } %>:</span>
                        <span class="summary-value" id="pricePerDay">$<%= String.format("%.2f", pricePerDay) %></span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Number of days:</span>
                        <span class="summary-value" id="daysDisplay">7</span>
                    </div>
                    <% if (discountPercentage > 0) { %>
                    <div class="summary-row">
                        <span class="summary-label">Subtotal:</span>
                        <span class="summary-value" style="text-decoration: line-through; color: #9ca3af;" id="subtotalAmount">$<%= String.format("%.2f", baseSilverRate.multiply(new java.math.BigDecimal("7"))) %></span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Member discount (<%= discountPercentage %>%):</span>
                        <span class="summary-value" style="color: #16a34a;" id="discountAmount">-$<%= String.format("%.2f", discountPerDay.multiply(new java.math.BigDecimal("7"))) %></span>
                    </div>
                    <% } %>
                    <div class="summary-row">
                        <span class="summary-label">Total Amount:</span>
                        <span class="summary-value" id="totalAmount">$<%= String.format("%.2f", pricePerDay.multiply(new java.math.BigDecimal("7"))) %></span>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/browseBooks" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Reserve & Pay</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const pricePerDay = <%= pricePerDay != null ? pricePerDay.doubleValue() : 5.00 %>;
        const baseSilverRate = <%= baseSilverRate.doubleValue() %>;
        const discountPerDay = <%= discountPerDay.doubleValue() %>;
        const hasDiscount = <%= discountPercentage > 0 ? "true" : "false" %>;
        
        const daysInput = document.getElementById('numberOfDays');
        const daysDisplay = document.getElementById('daysDisplay');
        const totalAmountDisplay = document.getElementById('totalAmount');
        const subtotalDisplay = document.getElementById('subtotalAmount');
        const discountDisplay = document.getElementById('discountAmount');

        function calculateTotal() {
            const days = parseInt(daysInput.value) || 1;
            daysDisplay.textContent = days;
            
            const total = (pricePerDay * days).toFixed(2);
            totalAmountDisplay.textContent = '$' + total;
            
            if (hasDiscount && subtotalDisplay && discountDisplay) {
                const subtotal = (baseSilverRate * days).toFixed(2);
                const discount = (discountPerDay * days).toFixed(2);
                subtotalDisplay.textContent = '$' + subtotal;
                discountDisplay.textContent = '-$' + discount;
            }
        }

        daysInput.addEventListener('input', calculateTotal);
        
        // Toggle payment reference visibility based on payment method
        function togglePaymentReference() {
            const paymentMethod = document.getElementById('paymentMethod').value;
            const referenceGroup = document.getElementById('paymentReferenceGroup');
            
            // Hide payment reference field for wallet payments
            if (paymentMethod === 'Wallet') {
                referenceGroup.style.display = 'none';
                document.getElementById('paymentReference').removeAttribute('required');
            } else {
                referenceGroup.style.display = 'block';
            }
        }
        
        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('startDate').setAttribute('min', today);
        
        // Initialize payment reference visibility
        togglePaymentReference();
    </script>
</body>
</html>

