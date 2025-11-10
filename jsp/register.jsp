<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - LibraryHub</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Poppins:wght@300;400;500;600;700;800;900&display=swap');

        :root {
            --primary: #6366F1;
            --primary-dark: #4F46E5;
            --primary-light: #818CF8;
            --secondary: #8B5CF6;
            --accent: #EC4899;
            --success: #10B981;
            --danger: #EF4444;
            --gray-900: #0F172A;
            --gray-800: #1E293B;
            --gray-700: #334155;
            --gray-600: #475569;
            --gray-500: #64748B;
            --gray-400: #94A3B8;
            --gray-300: #CBD5E1;
            --gray-200: #E2E8F0;
            --gray-100: #F1F5F9;
            --gray-50: #F8FAFC;
            --white: #FFFFFF;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #F8FAFC 0%, #EEF2FF 50%, #F1F5F9 100%);
            min-height: 100vh;
            padding: 20px;
            position: relative;
        }

        /* Animated Background */
        .bg-decoration {
            position: fixed;
            border-radius: 50%;
            pointer-events: none;
            z-index: 0;
            filter: blur(80px);
            opacity: 0.5;
        }

        .bg-decoration-1 {
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.15) 0%, transparent 70%);
            top: -100px;
            right: -100px;
            animation: float 20s ease-in-out infinite;
        }

        .bg-decoration-2 {
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(139, 92, 246, 0.12) 0%, transparent 70%);
            bottom: -100px;
            left: -80px;
            animation: float 15s ease-in-out infinite reverse;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0); }
            33% { transform: translate(30px, -30px); }
            66% { transform: translate(-20px, 20px); }
        }

        /* Navbar */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--gray-200);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            margin: -20px -20px 20px;
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
            transition: transform 0.3s ease;
        }

        .navbar-brand:hover {
            transform: translateX(-5px);
        }

        .logo-mini {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            box-shadow: 0 4px 6px -1px rgba(99, 102, 241, 0.3);
            transition: transform 0.3s ease;
        }

        .navbar-brand:hover .logo-mini {
            transform: rotate(5deg) scale(1.05);
        }

        .navbar-brand h1 {
            font-family: 'Poppins', sans-serif;
            font-size: 1.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: -0.03em;
        }

        .navbar-links {
            display: flex;
            gap: 0.75rem;
            align-items: center;
        }

        .navbar-links a {
            color: var(--gray-600);
            text-decoration: none;
            font-weight: 600;
            padding: 0.625rem 1.25rem;
            border-radius: 50px;
            transition: all 0.3s ease;
            font-size: 0.9375rem;
        }

        .navbar-links a:hover {
            background: var(--gray-100);
            color: var(--gray-900);
        }

        /* Container */
        .container {
            max-width: 920px;
            margin: 2rem auto;
            position: relative;
            z-index: 1;
        }

        /* Registration Card */
        .register-card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            border: 1px solid var(--gray-200);
            border-radius: 24px;
            overflow: hidden;
            animation: slideUp 0.6s ease-out;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
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

        .register-header {
            text-align: center;
            padding: 3rem 2rem 2rem;
            background: linear-gradient(to bottom, var(--gray-50) 0%, var(--white) 100%);
            border-bottom: 1px solid var(--gray-200);
            position: relative;
            overflow: hidden;
        }

        .register-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.08) 0%, transparent 70%);
            pointer-events: none;
        }

        .register-header h2 {
            font-family: 'Poppins', sans-serif;
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
            letter-spacing: -0.03em;
            position: relative;
            z-index: 1;
        }

        .register-header p {
            color: var(--gray-600);
            font-size: 1.0625rem;
            font-weight: 500;
            position: relative;
            z-index: 1;
        }

        /* Role Selector */
        .role-selector-container {
            padding: 2rem 2rem 1.5rem;
            background: var(--white);
            border-bottom: 1px solid var(--gray-200);
        }

        .role-selector-label {
            display: block;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: 0.875rem;
            font-size: 0.9375rem;
            letter-spacing: -0.01em;
        }

        #roleSelector {
            width: 100%;
            padding: 1rem 1.25rem;
            border: 2px solid var(--gray-200);
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            color: var(--gray-900);
            background: var(--white);
            cursor: pointer;
            appearance: none;
            background-image: url('data:image/svg+xml;charset=UTF-8,%3csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 24 24%27 fill=%27none%27 stroke=%27%236366F1%27 stroke-width=%272%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27%3e%3cpolyline points=%276 9 12 15 18 9%27%3e%3c/polyline%3e%3c/svg%3e');
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1.25rem;
            transition: all 0.3s ease;
        }

        #roleSelector:hover {
            border-color: var(--gray-300);
        }

        #roleSelector:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
        }

        /* Form Container */
        .form-container {
            padding: 2.5rem 2rem;
            background: var(--white);
        }

        .role-form {
            display: none;
            animation: fadeIn 0.4s ease-out;
        }

        .role-form.active {
            display: block;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(15px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Role Description */
        .role-description {
            background: linear-gradient(135deg, var(--gray-50), var(--white));
            padding: 1.25rem 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            font-size: 0.9375rem;
            color: var(--gray-700);
            border: 1px solid var(--gray-200);
            line-height: 1.7;
            display: flex;
            align-items: start;
            gap: 1rem;
        }

        .role-description i {
            font-size: 1.5rem;
            color: var(--primary);
            margin-top: 0.125rem;
        }

        .role-description strong {
            color: var(--gray-900);
            font-weight: 700;
        }

        /* Form Sections */
        .form-section {
            margin-bottom: 2.5rem;
        }

        .section-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 1.5rem;
            letter-spacing: -0.01em;
            padding-bottom: 0.875rem;
            border-bottom: 2px solid var(--gray-200);
            display: flex;
            align-items: center;
            gap: 0.625rem;
        }

        .section-title i {
            color: var(--primary);
            font-size: 1.25rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 0.625rem;
            font-size: 0.875rem;
            letter-spacing: -0.01em;
        }

        .required {
            color: var(--danger);
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 2px solid var(--gray-200);
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
            color: var(--gray-900);
            background: var(--white);
        }

        .form-group input::placeholder {
            color: var(--gray-400);
        }

        .form-group input:hover,
        .form-group select:hover {
            border-color: var(--gray-300);
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
        }

        .form-group small {
            color: var(--gray-500);
            font-size: 0.8125rem;
            margin-top: 0.5rem;
            line-height: 1.5;
        }

        /* Alerts */
        .alert {
            padding: 1.125rem 1.5rem;
            border-radius: 12px;
            margin-bottom: 1.75rem;
            font-size: 0.9375rem;
            line-height: 1.6;
            animation: slideDown 0.4s ease-out;
            display: flex;
            align-items: center;
            gap: 0.875rem;
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
            background: #F0FDF4;
            color: #166534;
            border: 1px solid #BBF7D0;
        }

        .alert-error {
            background: #FEF2F2;
            color: #991B1B;
            border: 1px solid #FECACA;
        }

        .alert i {
            font-size: 1.25rem;
        }

        /* Button */
        .btn {
            width: 100%;
            padding: 1rem 1.5rem;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
            letter-spacing: -0.01em;
            position: relative;
            overflow: hidden;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            box-shadow: 0 4px 6px -1px rgba(99, 102, 241, 0.3);
        }

        .btn-primary::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            transform: translate(-50%, -50%);
            transition: width 0.4s ease, height 0.4s ease;
        }

        .btn-primary:hover::before {
            width: 300%;
            height: 300%;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(99, 102, 241, 0.4);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        /* Footer */
        .form-footer {
            text-align: center;
            padding: 1.75rem;
            border-top: 1px solid var(--gray-200);
            background: var(--gray-50);
        }

        .form-footer p {
            color: var(--gray-600);
            font-size: 0.9375rem;
        }

        .form-footer a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 700;
            transition: color 0.3s ease;
        }

        .form-footer a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .navbar {
                padding: 1rem 1.5rem;
            }

            .container {
                margin: 1.5rem auto;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .register-header h2 {
                font-size: 1.75rem;
            }

            .role-selector-container,
            .form-container {
                padding: 1.75rem 1.5rem;
            }
        }

        html {
            scroll-behavior: smooth;
        }
    </style>
</head>
<body>
    <!-- Background Decorations -->
    <div class="bg-decoration bg-decoration-1"></div>
    <div class="bg-decoration bg-decoration-2"></div>

    <!-- Navbar -->
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/index.html" class="navbar-brand">
            <div class="logo-mini">📚</div>
            <h1>LibraryHub</h1>
        </a>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/index.html"><i class="fas fa-home"></i> Home</a>
            <a href="${pageContext.request.contextPath}/jsp/login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a>
        </div>
    </nav>

    <!-- Registration Container -->
    <div class="container">
        <div class="register-card">
            <!-- Header -->
            <div class="register-header">
                <h2>Create Your Account</h2>
                <p>Join LibraryHub and start your reading journey today</p>
            </div>

            <!-- Role Selection -->
            <div class="role-selector-container">
                <label class="role-selector-label">
                    Register As <span class="required">*</span>
                </label>
                <select id="roleSelector">
                    <option value="member" selected>👤 Member - Borrow Books (Free Account)</option>
                    <option value="librarian">📖 Librarian - Library Staff</option>
                    <option value="admin">⚙️ Administrator - Full System Access</option>
                </select>
            </div>

            <!-- Form Container -->
            <div class="form-container">
                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= request.getAttribute("error") %></span>
                </div>
                <% } %>
                <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span><%= request.getAttribute("success") %></span>
                </div>
                <% } %>
                
                <!-- Member Registration Form -->
                <form class="role-form" id="member-form" action="${pageContext.request.contextPath}/RegisterServlet" method="post">
                    <input type="hidden" name="role" value="MEMBER">
                    
                    <div class="role-description">
                        <i class="fas fa-info-circle"></i>
                        <div>
                            <strong>Member Account:</strong> Register as a library member to borrow books, make reservations, and enjoy our full catalog. Get FREE SILVER membership with 3 books for 14 days!
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-user-lock"></i>
                            Account Information
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Username <span class="required">*</span></label>
                                <input type="text" name="username" required placeholder="Choose a unique username">
                            </div>
                            <div class="form-group">
                                <label>Email <span class="required">*</span></label>
                                <input type="email" name="email" required placeholder="your@email.com">
                            </div>
                            <div class="form-group">
                                <label>Password <span class="required">*</span></label>
                                <input type="password" name="password" required minlength="6" placeholder="At least 6 characters">
                            </div>
                            <div class="form-group">
                                <label>Confirm Password <span class="required">*</span></label>
                                <input type="password" name="confirmPassword" required placeholder="Re-enter your password">
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-user"></i>
                            Personal Information
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>First Name <span class="required">*</span></label>
                                <input type="text" name="firstName" required placeholder="Your first name">
                            </div>
                            <div class="form-group">
                                <label>Last Name <span class="required">*</span></label>
                                <input type="text" name="lastName" required placeholder="Your last name">
                            </div>
                            <div class="form-group">
                                <label>Phone <span class="required">*</span></label>
                                <input type="tel" name="phone" required placeholder="(555) 123-4567">
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-map-marker-alt"></i>
                            Address Information
                        </div>
                        <div class="form-group full-width">
                            <label>Street Address <span class="required">*</span></label>
                            <input type="text" name="address" required placeholder="123 Main Street">
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>City <span class="required">*</span></label>
                                <input type="text" name="city" required placeholder="City">
                            </div>
                            <div class="form-group">
                                <label>State <span class="required">*</span></label>
                                <input type="text" name="state" required placeholder="State">
                            </div>
                            <div class="form-group">
                                <label>Zip Code <span class="required">*</span></label>
                                <input type="text" name="zipCode" required placeholder="12345">
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <span>Create Member Account</span>
                    </button>
                </form>

                <!-- Librarian Registration Form -->
                <form class="role-form" id="librarian-form" action="${pageContext.request.contextPath}/RegisterServlet" method="post">
                    <input type="hidden" name="role" value="LIBRARIAN">
                    
                    <div class="role-description">
                        <i class="fas fa-info-circle"></i>
                        <div>
                            <strong>Librarian Account:</strong> Register as a librarian to manage library operations, assist members, issue/return books, and handle reservations.
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-user-lock"></i>
                            Account Information
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Username <span class="required">*</span></label>
                                <input type="text" name="username" required placeholder="Choose a unique username">
                            </div>
                            <div class="form-group">
                                <label>Email <span class="required">*</span></label>
                                <input type="email" name="email" required placeholder="librarian@email.com">
                            </div>
                            <div class="form-group">
                                <label>Password <span class="required">*</span></label>
                                <input type="password" name="password" required minlength="6" placeholder="At least 6 characters">
                            </div>
                            <div class="form-group">
                                <label>Confirm Password <span class="required">*</span></label>
                                <input type="password" name="confirmPassword" required placeholder="Re-enter your password">
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-user"></i>
                            Personal Information
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>First Name <span class="required">*</span></label>
                                <input type="text" name="firstName" required placeholder="Your first name">
                            </div>
                            <div class="form-group">
                                <label>Last Name <span class="required">*</span></label>
                                <input type="text" name="lastName" required placeholder="Your last name">
                            </div>
                            <div class="form-group">
                                <label>Phone <span class="required">*</span></label>
                                <input type="tel" name="phone" required placeholder="(555) 123-4567">
                            </div>
                            <div class="form-group">
                                <label>Employee ID (Optional)</label>
                                <input type="text" name="employeeId" placeholder="LIB-0001">
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <span>Create Librarian Account</span>
                    </button>
                </form>

                <!-- Admin Registration Form -->
                <form class="role-form" id="admin-form" action="${pageContext.request.contextPath}/RegisterServlet" method="post">
                    <input type="hidden" name="role" value="ADMIN">
                    
                    <div class="role-description">
                        <i class="fas fa-info-circle"></i>
                        <div>
                            <strong>Administrator Account:</strong> Register as an administrator to have full system access, manage users, configure settings, and oversee all library operations.
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-user-lock"></i>
                            Account Information
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Username <span class="required">*</span></label>
                                <input type="text" name="username" required placeholder="Choose a unique username">
                            </div>
                            <div class="form-group">
                                <label>Email <span class="required">*</span></label>
                                <input type="email" name="email" required placeholder="admin@library.com">
                            </div>
                            <div class="form-group">
                                <label>Password <span class="required">*</span></label>
                                <input type="password" name="password" required minlength="8" placeholder="At least 8 characters">
                            </div>
                            <div class="form-group">
                                <label>Confirm Password <span class="required">*</span></label>
                                <input type="password" name="confirmPassword" required placeholder="Re-enter your password">
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-user"></i>
                            Personal Information
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>First Name <span class="required">*</span></label>
                                <input type="text" name="firstName" required placeholder="Your first name">
                            </div>
                            <div class="form-group">
                                <label>Last Name <span class="required">*</span></label>
                                <input type="text" name="lastName" required placeholder="Your last name">
                            </div>
                            <div class="form-group full-width">
                                <label>Admin Access Code <span class="required">*</span></label>
                                <input type="text" name="adminCode" required placeholder="Enter admin authorization code">
                                <small>Contact system administrator for the access code</small>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <span>Create Admin Account</span>
                    </button>
                </form>
            </div>

            <!-- Footer -->
            <div class="form-footer">
                <p>Already have an account? <a href="${pageContext.request.contextPath}/jsp/login.jsp">Login here</a></p>
            </div>
        </div>
    </div>

    <script>
        function switchRole(role) {
            const allForms = document.querySelectorAll('.role-form');
            allForms.forEach(form => form.classList.remove('active'));
            
            const selectedForm = document.getElementById(role + '-form');
            if (selectedForm) {
                selectedForm.classList.add('active');
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const roleSelector = document.getElementById('roleSelector');
            
            if (roleSelector) {
                roleSelector.addEventListener('change', function() {
                    switchRole(this.value);
                });
                
                switchRole(roleSelector.value);
            }
            
            // Password validation
            document.querySelectorAll('form').forEach(form => {
                form.addEventListener('submit', function(e) {
                    const password = this.querySelector('input[name="password"]');
                    const confirmPassword = this.querySelector('input[name="confirmPassword"]');
                    
                    if (password && confirmPassword) {
                        if (password.value !== confirmPassword.value) {
                            e.preventDefault();
                            alert('Passwords do not match!');
                            return false;
                        }
                        
                        if (password.value.length < 6) {
                            e.preventDefault();
                            alert('Password must be at least 6 characters long!');
                            return false;
                        }
                    }
                });
            });
        });

        // Auto-dismiss alerts
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.animation = 'slideUp 0.4s ease-out reverse';
                setTimeout(() => alert.remove(), 400);
            });
        }, 5000);
    </script>
</body>
</html>
