<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.Member" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    Member member = (Member) request.getAttribute("member");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - LibraryHub</title>
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
        .form-group select,
        .form-group textarea {
            padding: 0.75rem 1rem;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 0.9375rem;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
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
            text-decoration: none;
            display: inline-block;
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

        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
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

        .helper-text {
            font-size: 0.8125rem;
            color: #6b7280;
            margin-top: 0.25rem;
        }

        .required {
            color: #dc2626;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>✏️ Edit Profile</h1>
            <p>Update your account information and keep your profile complete</p>
        </div>

        <form action="<%= request.getContextPath() %>/editProfile" method="post" class="form-card">
            <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("success") %>
            </div>
            <% } %>
            
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <!-- Personal Information Section -->
            <div class="form-section">
                <h2 class="section-title">👤 Personal Information</h2>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="firstName">First Name <span class="required">*</span></label>
                        <input type="text" id="firstName" name="firstName" 
                               value="<%= user.getFirstName() != null ? user.getFirstName() : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label for="lastName">Last Name <span class="required">*</span></label>
                        <input type="text" id="lastName" name="lastName" 
                               value="<%= user.getLastName() != null ? user.getLastName() : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email Address <span class="required">*</span></label>
                        <input type="email" id="email" name="email" 
                               value="<%= user.getEmail() != null ? user.getEmail() : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" 
                               value="<%= user.getUsername() != null ? user.getUsername() : "" %>" disabled>
                        <span class="helper-text">Username cannot be changed</span>
                    </div>
                    <div class="form-group full-width">
                        <label for="bio">Bio</label>
                        <textarea id="bio" name="bio"><%= user.getBio() != null ? user.getBio() : "" %></textarea>
                        <span class="helper-text">Tell us about yourself</span>
                    </div>
                </div>
            </div>

            <% if (member != null) { %>
            <!-- Contact Information Section -->
            <div class="form-section">
                <h2 class="section-title">📞 Contact Information</h2>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" 
                               value="<%= member.getPhone() != null ? member.getPhone() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="alternatePhone">Alternate Phone</label>
                        <input type="tel" id="alternatePhone" name="alternatePhone" 
                               value="<%= member.getAlternatePhone() != null ? member.getAlternatePhone() : "" %>">
                    </div>
                    <div class="form-group full-width">
                        <label for="address">Address</label>
                        <input type="text" id="address" name="address" 
                               value="<%= member.getAddress() != null ? member.getAddress() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="city">City</label>
                        <input type="text" id="city" name="city" 
                               value="<%= member.getCity() != null ? member.getCity() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="state">State</label>
                        <input type="text" id="state" name="state" 
                               value="<%= member.getState() != null ? member.getState() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="zipCode">Zip Code</label>
                        <input type="text" id="zipCode" name="zipCode" 
                               value="<%= member.getZipCode() != null ? member.getZipCode() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="country">Country</label>
                        <input type="text" id="country" name="country" 
                               value="<%= member.getCountry() != null ? member.getCountry() : "USA" %>">
                    </div>
                </div>
            </div>

            <!-- Personal Details Section -->
            <div class="form-section">
                <h2 class="section-title">ℹ️ Personal Details</h2>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="dateOfBirth">Date of Birth</label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" 
                               value="<%= member.getDateOfBirth() != null ? member.getDateOfBirth().toString() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="gender">Gender</label>
                        <select id="gender" name="gender">
                            <option value="">Select Gender</option>
                            <option value="MALE" <%= member.getGender() != null && member.getGender().name().equals("MALE") ? "selected" : "" %>>Male</option>
                            <option value="FEMALE" <%= member.getGender() != null && member.getGender().name().equals("FEMALE") ? "selected" : "" %>>Female</option>
                            <option value="OTHER" <%= member.getGender() != null && member.getGender().name().equals("OTHER") ? "selected" : "" %>>Other</option>
                            <option value="PREFER_NOT_TO_SAY" <%= member.getGender() != null && member.getGender().name().equals("PREFER_NOT_TO_SAY") ? "selected" : "" %>>Prefer not to say</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="occupation">Occupation</label>
                        <input type="text" id="occupation" name="occupation" 
                               value="<%= member.getOccupation() != null ? member.getOccupation() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="organization">Organization</label>
                        <input type="text" id="organization" name="organization" 
                               value="<%= member.getOrganization() != null ? member.getOrganization() : "" %>">
                    </div>
                </div>
            </div>

            <!-- Emergency Contact Section -->
            <div class="form-section">
                <h2 class="section-title">🚨 Emergency Contact</h2>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="emergencyContactName">Emergency Contact Name</label>
                        <input type="text" id="emergencyContactName" name="emergencyContactName" 
                               value="<%= member.getEmergencyContactName() != null ? member.getEmergencyContactName() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="emergencyContactPhone">Emergency Contact Phone</label>
                        <input type="tel" id="emergencyContactPhone" name="emergencyContactPhone" 
                               value="<%= member.getEmergencyContactPhone() != null ? member.getEmergencyContactPhone() : "" %>">
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Form Actions -->
            <div class="form-actions">
                <a href="<%= request.getContextPath() %>/profile" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</body>
</html>


