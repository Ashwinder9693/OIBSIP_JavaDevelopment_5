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
    <title>Membership Enrollment - LibraryHub</title>
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
            --warning: #F59E0B;
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
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.15) 0%, transparent 70%);
            top: -200px;
            right: -150px;
            animation: float 20s ease-in-out infinite;
        }

        .bg-decoration-2 {
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(16, 185, 129, 0.12) 0%, transparent 70%);
            bottom: -150px;
            left: -100px;
            animation: float 15s ease-in-out infinite reverse;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            33% { transform: translate(40px, -40px) rotate(120deg); }
            66% { transform: translate(-30px, 30px) rotate(240deg); }
        }

        /* Container */
        .container {
            max-width: 1000px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        /* Header */
        .header {
            text-align: center;
            margin-bottom: 2.5rem;
            animation: fadeIn 0.6s ease-out;
        }

        .header-icon {
            width: 100px;
            height: 100px;
            margin: 0 auto 1.5rem;
            background: linear-gradient(135deg, var(--success), #34D399);
            border-radius: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            box-shadow: 0 10px 15px -3px rgba(16, 185, 129, 0.3);
            animation: logoFloat 3s ease-in-out infinite;
        }

        @keyframes logoFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .header h1 {
            font-family: 'Poppins', sans-serif;
            font-size: 2.5rem;
            font-weight: 900;
            background: linear-gradient(135deg, var(--success), #34D399);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.75rem;
            letter-spacing: -0.03em;
        }

        .header p {
            color: var(--gray-600);
            font-size: 1.125rem;
            font-weight: 500;
        }

        /* Form Card */
        .form-card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            border: 1px solid var(--gray-200);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            animation: slideUp 0.6s ease-out;
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

        /* Benefits Banner */
        .membership-banner {
            background: linear-gradient(135deg, #F0FDF4, #DCFCE7);
            padding: 2rem 2.5rem;
            border-bottom: 1px solid #BBF7D0;
            position: relative;
            overflow: hidden;
        }

        .membership-banner::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(16, 185, 129, 0.15) 0%, transparent 70%);
            pointer-events: none;
        }

        .membership-banner h3 {
            color: #166534;
            font-size: 1.375rem;
            font-weight: 800;
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            position: relative;
            z-index: 1;
        }

        .membership-banner h3 i {
            font-size: 1.75rem;
        }

        .benefits-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1rem;
            position: relative;
            z-index: 1;
        }

        .benefit-item {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            padding: 1rem 1.25rem;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 0.875rem;
            border: 1px solid rgba(16, 185, 129, 0.2);
            transition: all 0.3s ease;
        }

        .benefit-item:hover {
            transform: translateX(5px);
            border-color: var(--success);
            box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.2);
        }

        .benefit-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--success), #34D399);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-size: 1.125rem;
            flex-shrink: 0;
        }

        .benefit-text {
            color: #166534;
            font-weight: 600;
            font-size: 0.9375rem;
        }

        /* Form Sections */
        .form-section {
            padding: 2.5rem;
            border-bottom: 1px solid var(--gray-200);
        }

        .form-section:last-of-type {
            border-bottom: none;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--gray-900);
            margin-bottom: 1.75rem;
            letter-spacing: -0.02em;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--gray-200);
        }

        .section-title i {
            color: var(--primary);
            font-size: 1.5rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 1.75rem;
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
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .required {
            color: var(--danger);
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 2px solid var(--gray-200);
            border-radius: 12px;
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

        .helper-text {
            font-size: 0.8125rem;
            color: var(--gray-500);
            margin-top: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .helper-text i {
            font-size: 0.75rem;
        }

        /* Alert */
        .alert {
            padding: 1.125rem 1.5rem;
            border-radius: 12px;
            margin: 2rem 2.5rem 0;
            font-size: 0.9375rem;
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

        .alert-error {
            background: #FEF2F2;
            color: #991B1B;
            border: 1px solid #FECACA;
        }

        .alert i {
            font-size: 1.25rem;
        }

        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 1.25rem;
            justify-content: flex-end;
            padding: 2rem 2.5rem;
            background: var(--gray-50);
            border-top: 1px solid var(--gray-200);
        }

        .btn {
            padding: 1rem 2rem;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
            display: inline-flex;
            align-items: center;
            gap: 0.625rem;
            position: relative;
            overflow: hidden;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--success), #34D399);
            color: var(--white);
            box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.3);
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
            box-shadow: 0 10px 15px -3px rgba(16, 185, 129, 0.4);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .btn-secondary {
            background: var(--white);
            color: var(--gray-700);
            border: 2px solid var(--gray-300);
        }

        .btn-secondary:hover {
            background: var(--gray-50);
            border-color: var(--gray-400);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 0 1rem;
            }

            .header h1 {
                font-size: 2rem;
            }

            .form-section {
                padding: 2rem 1.5rem;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column-reverse;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .benefits-grid {
                grid-template-columns: 1fr;
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

    <!-- Container -->
    <div class="container">
        <!-- Header -->
        <div class="header">
            <div class="header-icon">🎉</div>
            <h1>Silver Membership Enrollment</h1>
            <p>Complete your profile to activate your FREE library membership</p>
        </div>

        <!-- Form Card -->
        <form action="<%= request.getContextPath() %>/membershipEnrollment" method="post" class="form-card">
            <input type="hidden" name="action" value="enroll">
            
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= request.getAttribute("error") %></span>
            </div>
            <% } %>

            <!-- Membership Benefits Banner -->
            <div class="membership-banner">
                <h3>
                    <i class="fas fa-crown"></i>
                    Your Silver Membership Includes:
                </h3>
                <div class="benefits-grid">
                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-book"></i>
                        </div>
                        <span class="benefit-text">3 books at a time</span>
                    </div>
                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-calendar"></i>
                        </div>
                        <span class="benefit-text">14-day borrowing period</span>
                    </div>
                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-star"></i>
                        </div>
                        <span class="benefit-text">FREE - No charges</span>
                    </div>
                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-arrow-up"></i>
                        </div>
                        <span class="benefit-text">Upgrade anytime</span>
                    </div>
                </div>
            </div>

            <!-- Contact Information -->
            <div class="form-section">
                <h2 class="section-title">
                    <i class="fas fa-phone"></i>
                    Contact Information
                </h2>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="phone">
                            Phone Number <span class="required">*</span>
                        </label>
                        <input type="tel" id="phone" name="phone" required placeholder="(555) 123-4567">
                        <span class="helper-text">
                            <i class="fas fa-info-circle"></i>
                            We'll use this for important notifications
                        </span>
                    </div>
                    <div class="form-group">
                        <label for="alternatePhone">Alternate Phone</label>
                        <input type="tel" id="alternatePhone" name="alternatePhone" placeholder="(555) 987-6543">
                    </div>
                    <div class="form-group full-width">
                        <label for="address">
                            Street Address <span class="required">*</span>
                        </label>
                        <input type="text" id="address" name="address" required placeholder="123 Main Street, Apt 4B">
                    </div>
                    <div class="form-group">
                        <label for="city">
                            City <span class="required">*</span>
                        </label>
                        <input type="text" id="city" name="city" required placeholder="New York">
                    </div>
                    <div class="form-group">
                        <label for="state">
                            State <span class="required">*</span>
                        </label>
                        <input type="text" id="state" name="state" required placeholder="NY">
                    </div>
                    <div class="form-group">
                        <label for="zipCode">
                            Zip Code <span class="required">*</span>
                        </label>
                        <input type="text" id="zipCode" name="zipCode" required placeholder="10001">
                    </div>
                    <div class="form-group">
                        <label for="country">Country</label>
                        <input type="text" id="country" name="country" value="USA" placeholder="USA">
                    </div>
                </div>
            </div>

            <!-- Personal Information -->
            <div class="form-section">
                <h2 class="section-title">
                    <i class="fas fa-user"></i>
                    Personal Information
                </h2>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="dateOfBirth">Date of Birth</label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth">
                    </div>
                    <div class="form-group">
                        <label for="gender">Gender</label>
                        <select id="gender" name="gender">
                            <option value="">Select...</option>
                            <option value="MALE">Male</option>
                            <option value="FEMALE">Female</option>
                            <option value="OTHER">Other</option>
                            <option value="PREFER_NOT_TO_SAY" selected>Prefer not to say</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="occupation">Occupation</label>
                        <input type="text" id="occupation" name="occupation" placeholder="Software Engineer">
                    </div>
                    <div class="form-group">
                        <label for="organization">Organization</label>
                        <input type="text" id="organization" name="organization" placeholder="Tech Company Inc.">
                    </div>
                </div>
            </div>

            <!-- Emergency Contact -->
            <div class="form-section">
                <h2 class="section-title">
                    <i class="fas fa-heart"></i>
                    Emergency Contact <span style="color: var(--gray-500); font-size: 0.875rem; font-weight: 500;">(Optional)</span>
                </h2>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="emergencyContactName">Contact Name</label>
                        <input type="text" id="emergencyContactName" name="emergencyContactName" placeholder="John Doe">
                    </div>
                    <div class="form-group">
                        <label for="emergencyContactPhone">Contact Phone</label>
                        <input type="tel" id="emergencyContactPhone" name="emergencyContactPhone" placeholder="(555) 000-0000">
                    </div>
                </div>
            </div>

            <!-- Form Actions -->
            <div class="form-actions">
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-secondary">
                    <i class="fas fa-times"></i>
                    <span>Cancel</span>
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-check"></i>
                    <span>Complete Enrollment</span>
                </button>
            </div>
        </form>
    </div>

    <script>
        // Auto-dismiss alerts
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.animation = 'slideUp 0.4s ease-out reverse';
                setTimeout(() => alert.remove(), 400);
            });
        }, 5000);

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const phone = document.getElementById('phone').value;
            const address = document.getElementById('address').value;
            const city = document.getElementById('city').value;
            const state = document.getElementById('state').value;
            const zipCode = document.getElementById('zipCode').value;

            if (!phone || !address || !city || !state || !zipCode) {
                e.preventDefault();
                alert('Please fill in all required fields marked with *');
                return false;
            }
        });
    </script>
</body>
</html>
