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
            padding: 2rem;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
        }

        .header {
            text-align: center;
            color: white;
            margin-bottom: 2rem;
        }

        .header h1 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .header p {
            opacity: 0.9;
        }

        .form-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .form-section {
            padding: 2rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .form-section:last-child {
            border-bottom: none;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
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
            font-weight: 500;
            color: #374151;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }

        .form-group input,
        .form-group select {
            padding: 0.75rem 1rem;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 0.9375rem;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .required {
            color: #dc2626;
        }

        .helper-text {
            font-size: 0.8125rem;
            color: #6b7280;
            margin-top: 0.25rem;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            padding: 2rem;
            background: #f9fafb;
        }

        .btn {
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #1d4ed8, #1e40af);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.4);
        }

        .btn-secondary {
            background: white;
            color: #374151;
            border: 1px solid #d1d5db;
        }

        .btn-secondary:hover {
            background: #f9fafb;
        }

        .membership-summary {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            border: 2px solid #3b82f6;
        }

        .membership-summary h3 {
            color: #1e40af;
            margin-bottom: 1rem;
        }

        .membership-summary ul {
            list-style: none;
            padding: 0;
        }

        .membership-summary li {
            padding: 0.5rem 0;
            color: #1e40af;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .membership-summary li::before {
            content: "✓";
            font-weight: bold;
        }

        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎉 Silver Membership Enrollment</h1>
            <p>Complete your profile to activate your FREE library membership</p>
        </div>

        <form action="<%= request.getContextPath() %>/membershipEnrollment" method="post" class="form-card">
            <input type="hidden" name="action" value="enroll">
            
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <div class="form-section">
                <div class="membership-summary">
                    <h3>Your Silver Membership Includes:</h3>
                    <ul>
                        <li>3 books at a time</li>
                        <li>14-day borrowing period</li>
                        <li>FREE - No charges</li>
                        <li>Upgrade to GOLD or PLATINUM anytime</li>
                    </ul>
                </div>
            </div>

            <!-- Contact Information -->
            <div class="form-section">
                <h2 class="section-title">📞 Contact Information</h2>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="phone">Phone Number <span class="required">*</span></label>
                        <input type="tel" id="phone" name="phone" required>
                        <span class="helper-text">We'll use this for important notifications</span>
                    </div>
                    <div class="form-group">
                        <label for="alternatePhone">Alternate Phone</label>
                        <input type="tel" id="alternatePhone" name="alternatePhone">
                    </div>
                    <div class="form-group full-width">
                        <label for="address">Street Address <span class="required">*</span></label>
                        <input type="text" id="address" name="address" required>
                    </div>
                    <div class="form-group">
                        <label for="city">City <span class="required">*</span></label>
                        <input type="text" id="city" name="city" required>
                    </div>
                    <div class="form-group">
                        <label for="state">State <span class="required">*</span></label>
                        <input type="text" id="state" name="state" required>
                    </div>
                    <div class="form-group">
                        <label for="zipCode">Zip Code <span class="required">*</span></label>
                        <input type="text" id="zipCode" name="zipCode" required>
                    </div>
                    <div class="form-group">
                        <label for="country">Country</label>
                        <input type="text" id="country" name="country" value="USA">
                    </div>
                </div>
            </div>

            <!-- Personal Information -->
            <div class="form-section">
                <h2 class="section-title">ℹ️ Personal Information</h2>
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
                        <input type="text" id="occupation" name="occupation">
                    </div>
                    <div class="form-group">
                        <label for="organization">Organization</label>
                        <input type="text" id="organization" name="organization">
                    </div>
                </div>
            </div>

            <!-- Emergency Contact -->
            <div class="form-section">
                <h2 class="section-title">🚨 Emergency Contact (Optional)</h2>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="emergencyContactName">Contact Name</label>
                        <input type="text" id="emergencyContactName" name="emergencyContactName">
                    </div>
                    <div class="form-group">
                        <label for="emergencyContactPhone">Contact Phone</label>
                        <input type="tel" id="emergencyContactPhone" name="emergencyContactPhone">
                    </div>
                </div>
            </div>

            <!-- Actions -->
            <div class="form-actions">
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">Complete Enrollment</button>
            </div>
        </form>
    </div>
</body>
</html>


