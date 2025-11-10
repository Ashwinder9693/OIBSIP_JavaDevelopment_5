<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - LibraryHub</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(to bottom, #fafafa 0%, #f5f5f5 100%);
            min-height: 100vh;
            position: relative;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 20%, rgba(100, 100, 100, 0.03) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(100, 100, 100, 0.03) 0%, transparent 50%);
            pointer-events: none;
            z-index: 0;
        }

        /* Navbar */
        .navbar {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px) saturate(180%);
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            padding: 1rem 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.02);
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
        }

        .logo-mini {
            width: 44px;
            height: 44px;
            background: linear-gradient(135deg, #2c2c2c 0%, #1a1a1a 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s ease;
        }

        .logo-mini:hover {
            transform: translateY(-2px);
        }

        .navbar-brand h1 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1a1a1a;
            letter-spacing: -0.02em;
        }

        .navbar-links {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        .navbar-links a {
            color: #525252;
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: all 0.2s ease;
            font-size: 0.95rem;
        }

        .navbar-links a:hover {
            background: rgba(0, 0, 0, 0.04);
            color: #1a1a1a;
        }

        /* Container */
        .container {
            max-width: 920px;
            margin: 3rem auto;
            padding: 0 2rem;
            position: relative;
            z-index: 1;
        }

        /* Registration Card */
        .register-card {
            background: white;
            border-radius: 16px;
            box-shadow: 
                0 1px 3px rgba(0, 0, 0, 0.05),
                0 20px 40px rgba(0, 0, 0, 0.03);
            overflow: hidden;
            animation: slideUp 0.5s cubic-bezier(0.16, 1, 0.3, 1);
            border: 1px solid rgba(0, 0, 0, 0.04);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .register-header {
            text-align: center;
            padding: 3rem 2rem 2rem;
            background: linear-gradient(to bottom, #fafafa 0%, #ffffff 100%);
            border-bottom: 1px solid rgba(0, 0, 0, 0.04);
        }

        .register-header h2 {
            font-size: 2rem;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 0.5rem;
            letter-spacing: -0.03em;
        }

        .register-header p {
            color: #737373;
            font-size: 1rem;
            font-weight: 400;
        }

        /* Role Selection */
        .role-selector-container {
            padding: 2rem 2rem 1.5rem;
            background: white;
            border-bottom: 1px solid rgba(0, 0, 0, 0.06);
        }

        .role-selector-label {
            display: block;
            font-weight: 600;
            color: #262626;
            margin-bottom: 0.75rem;
            font-size: 0.875rem;
            letter-spacing: -0.01em;
        }

        #roleSelector {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 1.5px solid #e5e5e5;
            border-radius: 10px;
            font-size: 0.95rem;
            font-weight: 500;
            color: #1a1a1a;
            background: white;
            cursor: pointer;
            appearance: none;
            background-image: url('data:image/svg+xml;charset=UTF-8,%3csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 24 24%27 fill=%27none%27 stroke=%27%23525252%27 stroke-width=%272%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27%3e%3cpolyline points=%276 9 12 15 18 9%27%3e%3c/polyline%3e%3c/svg%3e');
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1.2rem;
            transition: all 0.2s ease;
        }

        #roleSelector:hover {
            border-color: #a3a3a3;
        }

        #roleSelector:focus {
            outline: none;
            border-color: #525252;
            box-shadow: 0 0 0 3px rgba(0, 0, 0, 0.04);
        }

        /* Form Container */
        .form-container {
            padding: 2rem;
            background: white;
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
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Role Description */
        .role-description {
            background: #fafafa;
            padding: 1rem 1.25rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            font-size: 0.875rem;
            color: #525252;
            border: 1px solid rgba(0, 0, 0, 0.04);
            line-height: 1.6;
        }

        .role-description strong {
            color: #1a1a1a;
            font-weight: 600;
        }

        /* Form Sections */
        .form-section {
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1rem;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 1.25rem;
            letter-spacing: -0.01em;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.06);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.25rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            font-weight: 500;
            color: #262626;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
            letter-spacing: -0.01em;
        }

        .required {
            color: #dc2626;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1.5px solid #e5e5e5;
            border-radius: 8px;
            font-size: 0.95rem;
            transition: all 0.2s ease;
            font-family: 'Inter', sans-serif;
            color: #1a1a1a;
            background: white;
        }

        .form-group input::placeholder {
            color: #a3a3a3;
        }

        .form-group input:hover,
        .form-group select:hover {
            border-color: #a3a3a3;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #525252;
            box-shadow: 0 0 0 3px rgba(0, 0, 0, 0.04);
        }

        .form-group small {
            color: #737373;
            font-size: 0.8rem;
            margin-top: 0.375rem;
        }

        /* Alert Messages */
        .alert {
            padding: 1rem 1.25rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            line-height: 1.5;
        }

        .alert-success {
            background: #f0fdf4;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .alert-error {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        /* Buttons */
        .btn {
            width: 100%;
            padding: 0.875rem 1rem;
            border: none;
            border-radius: 10px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            font-family: 'Inter', sans-serif;
            letter-spacing: -0.01em;
        }

        .btn-primary {
            background: #1a1a1a;
            color: white;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .btn-primary:hover {
            background: #0a0a0a;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        /* Footer Links */
        .form-footer {
            text-align: center;
            padding: 1.5rem;
            border-top: 1px solid rgba(0, 0, 0, 0.06);
            background: #fafafa;
        }

        .form-footer p {
            color: #525252;
            font-size: 0.9rem;
        }

        .form-footer a {
            color: #1a1a1a;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s ease;
        }

        .form-footer a:hover {
            color: #525252;
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .navbar {
                padding: 1rem 1.5rem;
            }

            .container {
                margin: 2rem auto;
                padding: 0 1rem;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .register-header h2 {
                font-size: 1.75rem;
            }

            .role-selector-container,
            .form-container {
                padding: 1.5rem;
            }
        }

        /* Smooth scrolling */
        html {
            scroll-behavior: smooth;
        }

        /* Focus visible for accessibility */
        *:focus-visible {
            outline: 2px solid #525252;
            outline-offset: 2px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/index.html" class="navbar-brand">
            <div class="logo-mini">📚</div>
            <h1>LibraryHub</h1>
        </a>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/index.html">Home</a>
            <a href="${pageContext.request.contextPath}/jsp/login.jsp">Login</a>
        </div>
    </nav>

    <!-- Registration Container -->
    <div class="container">
        <div class="register-card">
            <!-- Header -->
            <div class="register-header">
                <h2>Create Your Account</h2>
                <p>Join LibraryHub and start your reading journey</p>
            </div>

            <!-- Role Selection Dropdown -->
            <div class="role-selector-container">
                <label class="role-selector-label">
                    Register As <span class="required">*</span>
                </label>
                <select id="roleSelector">
                    <option value="member" selected>Member - Borrow Books (Free Account)</option>
                    <option value="librarian">Librarian - Library Staff</option>
                    <option value="admin">Administrator - Full System Access</option>
                </select>
            </div>

            <!-- Form Container -->
            <div class="form-container">
                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>
                <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("success") %>
                </div>
                <% } %>
                
                <!-- Member Registration Form -->
                <form class="role-form" id="member-form" action="${pageContext.request.contextPath}/RegisterServlet" method="post">
                    <input type="hidden" name="role" value="MEMBER">
                    
                    <div class="role-description">
                        <strong>Member Account:</strong> Register as a library member to borrow books, make reservations, and enjoy our full catalog. Get FREE SILVER membership with 3 books for 14 days!
                    </div>

                    <div class="form-section">
                        <div class="section-title">Account Information</div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Username <span class="required">*</span></label>
                                <input type="text" name="username" required placeholder="Choose a username">
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
                                <input type="password" name="confirmPassword" required placeholder="Re-enter password">
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">Personal Information</div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>First Name <span class="required">*</span></label>
                                <input type="text" name="firstName" required placeholder="First name">
                            </div>
                            <div class="form-group">
                                <label>Last Name <span class="required">*</span></label>
                                <input type="text" name="lastName" required placeholder="Last name">
                            </div>
                            <div class="form-group">
                                <label>Phone <span class="required">*</span></label>
                                <input type="tel" name="phone" required placeholder="(555) 123-4567">
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">Address Information</div>
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

                    <button type="submit" class="btn btn-primary">Create Member Account</button>
                </form>

                <!-- Librarian Registration Form -->
                <form class="role-form" id="librarian-form" action="${pageContext.request.contextPath}/RegisterServlet" method="post">
                    <input type="hidden" name="role" value="LIBRARIAN">
                    
                    <div class="role-description">
                        <strong>Librarian Account:</strong> Register as a librarian to manage library operations, assist members, issue/return books, and handle reservations.
                    </div>

                    <div class="form-section">
                        <div class="section-title">Account Information</div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Username <span class="required">*</span></label>
                                <input type="text" name="username" required placeholder="Choose a username">
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
                                <input type="password" name="confirmPassword" required placeholder="Re-enter password">
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">Personal Information</div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>First Name <span class="required">*</span></label>
                                <input type="text" name="firstName" required placeholder="First name">
                            </div>
                            <div class="form-group">
                                <label>Last Name <span class="required">*</span></label>
                                <input type="text" name="lastName" required placeholder="Last name">
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

                    <button type="submit" class="btn btn-primary">Create Librarian Account</button>
                </form>

                <!-- Admin Registration Form -->
                <form class="role-form" id="admin-form" action="${pageContext.request.contextPath}/RegisterServlet" method="post">
                    <input type="hidden" name="role" value="ADMIN">
                    
                    <div class="role-description">
                        <strong>Administrator Account:</strong> Register as an administrator to have full system access, manage users, configure settings, and oversee all library operations.
                    </div>

                    <div class="form-section">
                        <div class="section-title">Account Information</div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Username <span class="required">*</span></label>
                                <input type="text" name="username" required placeholder="Choose a username">
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
                                <input type="password" name="confirmPassword" required placeholder="Re-enter password">
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="section-title">Personal Information</div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>First Name <span class="required">*</span></label>
                                <input type="text" name="firstName" required placeholder="First name">
                            </div>
                            <div class="form-group">
                                <label>Last Name <span class="required">*</span></label>
                                <input type="text" name="lastName" required placeholder="Last name">
                            </div>
                            <div class="form-group full-width">
                                <label>Admin Access Code <span class="required">*</span></label>
                                <input type="text" name="adminCode" required placeholder="Enter admin authorization code">
                                <small>Contact system administrator for access code</small>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">Create Admin Account</button>
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
            console.log('Switching to role:', role);
            
            // Hide all forms first
            const allForms = document.querySelectorAll('.role-form');
            allForms.forEach(form => {
                form.classList.remove('active');
            });
            
            // Show the selected form
            const selectedForm = document.getElementById(role + '-form');
            if (selectedForm) {
                selectedForm.classList.add('active');
                console.log('Activated form:', role + '-form');
            } else {
                console.error('Form not found:', role + '-form');
            }
        }

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded, initializing...');
            
            // Get the role selector
            const roleSelector = document.getElementById('roleSelector');
            
            if (roleSelector) {
                // Set up change event listener
                roleSelector.addEventListener('change', function() {
                    switchRole(this.value);
                });
                
                // Show initial form (member)
                const initialRole = roleSelector.value;
                console.log('Initial role:', initialRole);
                switchRole(initialRole);
            } else {
                console.error('Role selector not found!');
            }
            
            // Password validation for all forms
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
    </script>
</body>
</html>