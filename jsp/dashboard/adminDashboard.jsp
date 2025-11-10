<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !user.getRole().name().equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - LibraryHub</title>
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
            --danger: #EF4444;
            --info: #06B6D4;
            --dark: #1E293B;
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
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            --shadow-2xl: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #F8FAFC 0%, #EEF2FF 50%, #F1F5F9 100%);
            color: var(--gray-900);
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        /* Animated Background Elements */
        .bg-decoration {
            position: fixed;
            border-radius: 50%;
            pointer-events: none;
            z-index: 0;
            filter: blur(80px);
            opacity: 0.6;
        }

        .bg-decoration-1 {
            width: 800px;
            height: 800px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.15) 0%, transparent 70%);
            top: -400px;
            right: -200px;
            animation: float 25s ease-in-out infinite;
        }

        .bg-decoration-2 {
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(139, 92, 246, 0.12) 0%, transparent 70%);
            bottom: -200px;
            left: -150px;
            animation: float 20s ease-in-out infinite reverse;
        }

        .bg-decoration-3 {
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(236, 72, 153, 0.1) 0%, transparent 70%);
            top: 40%;
            right: 10%;
            animation: pulse 15s ease-in-out infinite;
        }

        .bg-decoration-4 {
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(6, 182, 212, 0.1) 0%, transparent 70%);
            top: 20%;
            left: 20%;
            animation: float 18s ease-in-out infinite;
        }

        /* Floating Orbs */
        .floating-orb {
            position: fixed;
            border-radius: 50%;
            pointer-events: none;
            z-index: 0;
            opacity: 0.4;
        }

        .orb-1 {
            width: 300px;
            height: 300px;
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.3), rgba(139, 92, 246, 0.3));
            top: 10%;
            left: 5%;
            animation: floatOrb 20s ease-in-out infinite;
        }

        .orb-2 {
            width: 200px;
            height: 200px;
            background: linear-gradient(135deg, rgba(236, 72, 153, 0.3), rgba(239, 68, 68, 0.3));
            bottom: 15%;
            right: 10%;
            animation: floatOrb 15s ease-in-out infinite reverse;
        }

        .orb-3 {
            width: 250px;
            height: 250px;
            background: linear-gradient(135deg, rgba(6, 182, 212, 0.3), rgba(16, 185, 129, 0.3));
            top: 60%;
            right: 5%;
            animation: floatOrb 18s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { 
                transform: translate(0, 0) rotate(0deg); 
            }
            33% { 
                transform: translate(50px, -50px) rotate(120deg); 
            }
            66% { 
                transform: translate(-30px, 30px) rotate(240deg); 
            }
        }

        @keyframes floatOrb {
            0%, 100% { 
                transform: translate(0, 0) scale(1); 
            }
            33% { 
                transform: translate(80px, -80px) scale(1.2); 
            }
            66% { 
                transform: translate(-50px, 50px) scale(0.8); 
            }
        }

        @keyframes pulse {
            0%, 100% { 
                transform: scale(1); 
                opacity: 0.5; 
            }
            50% { 
                transform: scale(1.3); 
                opacity: 0.8; 
            }
        }

        /* Navbar */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--gray-200);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: var(--shadow-sm);
            transition: all 0.3s ease;
        }

        .navbar.scrolled {
            box-shadow: var(--shadow-lg);
            background: rgba(255, 255, 255, 0.98);
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 1rem;
            text-decoration: none;
            color: inherit;
            transition: transform 0.3s ease;
        }

        .navbar-brand:hover {
            transform: translateX(-5px);
        }

        .logo-container {
            position: relative;
            width: 52px;
            height: 52px;
        }

        .logo-mini {
            width: 52px;
            height: 52px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            box-shadow: var(--shadow-lg);
            position: relative;
            overflow: hidden;
        }

        .logo-mini::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transform: rotate(45deg);
            animation: logoShine 3s infinite;
        }

        @keyframes logoShine {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
        }

        .logo-mini:hover {
            transform: rotate(360deg) scale(1.1);
            box-shadow: var(--shadow-xl);
        }

        .navbar-brand h1 {
            font-family: 'Poppins', sans-serif;
            font-size: 1.75rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: -0.03em;
            margin: 0;
        }

        .navbar-user {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 0.875rem;
            padding: 0.625rem 1.25rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: 1.5px solid var(--primary-light);
            border-radius: 50px;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-md);
        }

        .user-info:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-xl);
        }

        .admin-badge {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(10px);
            padding: 0.375rem 0.875rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--white);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
        }

        .user-avatar {
            width: 42px;
            height: 42px;
            background: rgba(255, 255, 255, 0.3);
            backdrop-filter: blur(10px);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            box-shadow: var(--shadow-md);
            transition: transform 0.3s ease;
        }

        .user-info:hover .user-avatar {
            transform: scale(1.1) rotate(5deg);
        }

        .user-details {
            display: flex;
            flex-direction: column;
            gap: 0.125rem;
        }

        .user-name {
            font-weight: 700;
            color: var(--white);
            font-size: 0.9375rem;
            line-height: 1.2;
        }

        .user-role {
            font-size: 0.75rem;
            color: rgba(255, 255, 255, 0.85);
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .logout-btn {
            padding: 0.75rem 1.75rem;
            background: var(--white);
            border: 2px solid var(--gray-300);
            border-radius: 50px;
            color: var(--gray-700);
            text-decoration: none;
            font-weight: 700;
            font-size: 0.9375rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: var(--shadow-sm);
        }

        .logout-btn:hover {
            background: var(--danger);
            border-color: var(--danger);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        /* Dashboard Container */
        .dashboard-container {
            padding: 2.5rem 2rem;
            max-width: 1600px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        /* Welcome Section */
        .welcome-section {
            background: var(--white);
            border-radius: 28px;
            padding: 3.5rem;
            margin-bottom: 2.5rem;
            box-shadow: var(--shadow-xl);
            position: relative;
            overflow: hidden;
            border: 1px solid var(--gray-200);
            animation: slideDown 0.6s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .welcome-section::before {
            content: '';
            position: absolute;
            top: -100px;
            right: -100px;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.1) 0%, transparent 70%);
            pointer-events: none;
            animation: float 12s ease-in-out infinite;
        }

        .welcome-section::after {
            content: '';
            position: absolute;
            bottom: -80px;
            left: -80px;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(139, 92, 246, 0.08) 0%, transparent 70%);
            pointer-events: none;
            animation: float 15s ease-in-out infinite reverse;
        }

        .welcome-content {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 2rem;
        }

        .welcome-left {
            flex: 1;
            min-width: 300px;
        }

        .welcome-title {
            font-family: 'Poppins', sans-serif;
            font-size: 2.75rem;
            font-weight: 900;
            background: linear-gradient(135deg, var(--primary), var(--secondary), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.75rem;
            letter-spacing: -0.03em;
            line-height: 1.2;
        }

        .welcome-subtitle {
            color: var(--gray-600);
            font-size: 1.25rem;
            font-weight: 500;
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        .welcome-stats {
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
        }

        .welcome-stat {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .welcome-stat-value {
            font-size: 2rem;
            font-weight: 800;
            color: var(--primary);
            line-height: 1;
        }

        .welcome-stat-label {
            font-size: 0.875rem;
            color: var(--gray-500);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .welcome-icon {
            font-size: 10rem;
            opacity: 0.1;
            position: absolute;
            right: 2rem;
            bottom: -2rem;
            pointer-events: none;
        }

        /* Admin Cards Grid */
        .admin-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 2rem;
            margin-bottom: 2.5rem;
        }

        .admin-card {
            background: var(--white);
            border: 1px solid var(--gray-200);
            border-radius: 24px;
            padding: 2.5rem;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out backwards;
            box-shadow: var(--shadow);
        }

        .admin-card:nth-child(1) { animation-delay: 0.1s; }
        .admin-card:nth-child(2) { animation-delay: 0.15s; }
        .admin-card:nth-child(3) { animation-delay: 0.2s; }
        .admin-card:nth-child(4) { animation-delay: 0.25s; }
        .admin-card:nth-child(5) { animation-delay: 0.3s; }
        .admin-card:nth-child(6) { animation-delay: 0.35s; }
        .admin-card:nth-child(7) { animation-delay: 0.4s; }
        .admin-card:nth-child(8) { animation-delay: 0.45s; }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .admin-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(99, 102, 241, 0.05), transparent);
            transition: left 0.5s ease;
        }

        .admin-card:hover::before {
            left: 100%;
        }

        .admin-card:hover {
            transform: translateY(-12px) scale(1.02);
            box-shadow: var(--shadow-2xl);
            border-color: var(--primary-light);
        }

        .admin-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1.5rem;
        }

        .admin-icon-box {
            width: 80px;
            height: 80px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            box-shadow: var(--shadow-md);
            position: relative;
            overflow: hidden;
        }

        .admin-icon-box::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            transform: rotate(45deg);
            animation: iconShine 3s infinite;
        }

        @keyframes iconShine {
            0% { transform: translateX(-100%) rotate(45deg); }
            100% { transform: translateX(100%) rotate(45deg); }
        }

        .admin-card:hover .admin-icon-box {
            transform: scale(1.15) rotate(-5deg);
            box-shadow: var(--shadow-xl);
        }

        /* Color themes for different admin cards */
        .theme-primary { background: linear-gradient(135deg, #EEF2FF, #E0E7FF); color: var(--primary); }
        .theme-success { background: linear-gradient(135deg, #F0FDF4, #DCFCE7); color: var(--success); }
        .theme-warning { background: linear-gradient(135deg, #FFFBEB, #FEF3C7); color: var(--warning); }
        .theme-danger { background: linear-gradient(135deg, #FEF2F2, #FEE2E2); color: var(--danger); }
        .theme-info { background: linear-gradient(135deg, #ECFEFF, #CFFAFE); color: var(--info); }
        .theme-secondary { background: linear-gradient(135deg, #FAF5FF, #F3E8FF); color: var(--secondary); }
        .theme-accent { background: linear-gradient(135deg, #FDF4FF, #FCE7F3); color: var(--accent); }

        .admin-card-title {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--gray-900);
            margin-bottom: 0.75rem;
            letter-spacing: -0.02em;
            transition: all 0.3s ease;
            line-height: 1.3;
        }

        .admin-card:hover .admin-card-title {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .admin-card-description {
            color: var(--gray-600);
            font-size: 1rem;
            line-height: 1.6;
            font-weight: 500;
        }

        .admin-card-badge {
            position: absolute;
            top: 1.5rem;
            right: 1.5rem;
            padding: 0.375rem 0.875rem;
            background: rgba(99, 102, 241, 0.1);
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        /* Special Cards */
        .special-card {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            border: none;
            color: var(--white);
        }

        .special-card .admin-icon-box {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            color: var(--white);
        }

        .special-card .admin-card-title {
            color: var(--white);
        }

        .special-card:hover .admin-card-title {
            color: var(--white);
            -webkit-text-fill-color: var(--white);
        }

        .special-card .admin-card-description {
            color: rgba(255, 255, 255, 0.9);
        }

        .special-card-accent {
            background: linear-gradient(135deg, var(--accent) 0%, #F472B6 100%);
        }

        /* Responsive Design */
        @media (max-width: 1400px) {
            .admin-cards-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            }
        }

        @media (max-width: 1024px) {
            .welcome-title {
                font-size: 2.25rem;
            }

            .admin-cards-grid {
                grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 1rem;
            }

            .user-details {
                display: none;
            }

            .dashboard-container {
                padding: 1.5rem 1rem;
            }

            .welcome-section {
                padding: 2rem 1.5rem;
            }

            .welcome-title {
                font-size: 1.875rem;
            }

            .welcome-subtitle {
                font-size: 1rem;
            }

            .admin-cards-grid {
                grid-template-columns: 1fr;
            }

            .welcome-icon {
                font-size: 6rem;
                right: 1rem;
                bottom: -1rem;
            }
        }

        @media (max-width: 480px) {
            .navbar-brand h1 {
                font-size: 1.25rem;
            }

            .logout-btn {
                padding: 0.625rem 1.25rem;
                font-size: 0.875rem;
            }

            .logout-btn span {
                display: none;
            }

            .welcome-stats {
                gap: 1rem;
            }
        }

        html {
            scroll-behavior: smooth;
        }

        /* Loading Animation */
        @keyframes shimmer {
            0% { background-position: -1000px 0; }
            100% { background-position: 1000px 0; }
        }

        /* Pulse Animation for Special Elements */
        @keyframes subtlePulse {
            0%, 100% { 
                box-shadow: 0 0 0 0 rgba(99, 102, 241, 0.4);
            }
            50% { 
                box-shadow: 0 0 0 20px rgba(99, 102, 241, 0);
            }
        }

        .special-card {
            animation: subtlePulse 3s ease-in-out infinite;
        }
    </style>
</head>
<body>
    <!-- Animated Background Elements -->
    <div class="bg-decoration bg-decoration-1"></div>
    <div class="bg-decoration bg-decoration-2"></div>
    <div class="bg-decoration bg-decoration-3"></div>
    <div class="bg-decoration bg-decoration-4"></div>
    
    <!-- Floating Orbs -->
    <div class="floating-orb orb-1"></div>
    <div class="floating-orb orb-2"></div>
    <div class="floating-orb orb-3"></div>

    <!-- Navbar -->
    <nav class="navbar" id="navbar">
        <a href="${pageContext.request.contextPath}/index.html" class="navbar-brand">
            <div class="logo-container">
                <div class="logo-mini">📚</div>
            </div>
            <h1>LibraryHub Admin</h1>
        </a>
        <div class="navbar-user">
            <div class="user-info">
                <div class="user-avatar">👨‍💼</div>
                <div class="user-details">
                    <div class="user-name"><%= user.getUsername() %></div>
                    <div class="user-role">
                        <i class="fas fa-shield-halved"></i> Administrator
                    </div>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </div>
    </nav>

    <!-- Dashboard Container -->
    <div class="dashboard-container">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="welcome-content">
                <div class="welcome-left">
                    <h2 class="welcome-title">Admin Control Center 🎯</h2>
                    <p class="welcome-subtitle">Manage and oversee all library operations from your central dashboard</p>
                    <div class="welcome-stats">
                        <div class="welcome-stat">
                            <div class="welcome-stat-value">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="welcome-stat-label">System Active</div>
                        </div>
                        <div class="welcome-stat">
                            <div class="welcome-stat-value">8</div>
                            <div class="welcome-stat-label">Features</div>
                        </div>
                        <div class="welcome-stat">
                            <div class="welcome-stat-value">
                                <i class="fas fa-bolt"></i>
                            </div>
                            <div class="welcome-stat-label">Quick Access</div>
                        </div>
                    </div>
                </div>
                <div class="welcome-icon">⚙️</div>
            </div>
        </div>

        <!-- Admin Cards Grid -->
        <div class="admin-cards-grid">
            <!-- Manage Books -->
            <div class="admin-card" onclick="location.href='${pageContext.request.contextPath}/bookList'">
                <div class="admin-card-header">
                    <div class="admin-icon-box theme-primary">
                        <i class="fas fa-book"></i>
                    </div>
                </div>
                <h3 class="admin-card-title">Manage Books</h3>
                <p class="admin-card-description">Add, edit, delete, and organize your library's book collection with ease</p>
            </div>

            <!-- Manage Members -->
            <div class="admin-card" onclick="location.href='${pageContext.request.contextPath}/memberList'">
                <div class="admin-card-header">
                    <div class="admin-icon-box theme-success">
                        <i class="fas fa-users"></i>
                    </div>
                </div>
                <h3 class="admin-card-title">Manage Members</h3>
                <p class="admin-card-description">View member profiles, track activity, and manage membership details</p>
            </div>

            <!-- Issue Books -->
            <div class="admin-card" onclick="location.href='${pageContext.request.contextPath}/issueBook'">
                <div class="admin-card-header">
                    <div class="admin-icon-box theme-info">
                        <i class="fas fa-book-open"></i>
                    </div>
                </div>
                <h3 class="admin-card-title">Issue Books</h3>
                <p class="admin-card-description">Process book checkouts and issue books to library members</p>
            </div>

            <!-- Return Books -->
            <div class="admin-card" onclick="location.href='${pageContext.request.contextPath}/returnBook'">
                <div class="admin-card-header">
                    <div class="admin-icon-box theme-warning">
                        <i class="fas fa-undo"></i>
                    </div>
                </div>
                <h3 class="admin-card-title">Return Books</h3>
                <p class="admin-card-description">Handle book returns, calculate fines, and update inventory status</p>
            </div>

            <!-- Fine Management -->
            <div class="admin-card" onclick="location.href='${pageContext.request.contextPath}/fineManagement'">
                <div class="admin-card-header">
                    <div class="admin-icon-box theme-danger">
                        <i class="fas fa-money-bill-wave"></i>
                    </div>
                </div>
                <h3 class="admin-card-title">Fine Management</h3>
                <p class="admin-card-description">Manage overdue fines, process payments, and waive penalties</p>
            </div>

            <!-- Reports -->
            <div class="admin-card" onclick="location.href='${pageContext.request.contextPath}/reports'">
                <div class="admin-card-header">
                    <div class="admin-icon-box theme-secondary">
                        <i class="fas fa-chart-line"></i>
                    </div>
                </div>
                <h3 class="admin-card-title">Reports & Analytics</h3>
                <p class="admin-card-description">Generate comprehensive reports and view library statistics</p>
            </div>

            <!-- Wallet Approvals -->
            <div class="admin-card special-card" onclick="location.href='${pageContext.request.contextPath}/admin/wallet?action=approvals'">
                <div class="admin-card-header">
                    <div class="admin-icon-box">
                        <i class="fas fa-wallet"></i>
                    </div>
                </div>
                <h3 class="admin-card-title">Wallet Approvals</h3>
                <p class="admin-card-description">Review and approve pending wallet top-up requests from members</p>
                <span class="admin-card-badge" style="background: rgba(255,255,255,0.2); color: white;">Featured</span>
            </div>

            <!-- Credit Wallet -->
            <div class="admin-card special-card special-card-accent" onclick="location.href='${pageContext.request.contextPath}/admin/wallet?action=credit'">
                <div class="admin-card-header">
                    <div class="admin-icon-box">
                        <i class="fas fa-plus-circle"></i>
                    </div>
                </div>
                <h3 class="admin-card-title">Credit Wallet</h3>
                <p class="admin-card-description">Directly add funds to member wallet accounts for reservations and fines</p>
                <span class="admin-card-badge" style="background: rgba(255,255,255,0.2); color: white;">Featured</span>
            </div>
        </div>
    </div>

    <script>
        // Enhanced navbar scroll effect
        window.addEventListener('scroll', () => {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 20) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });

        // Smooth entrance animation on load
        window.addEventListener('load', () => {
            document.body.style.opacity = '1';
        });

        // 3D tilt effect for admin cards
        document.querySelectorAll('.admin-card').forEach(card => {
            card.addEventListener('mousemove', (e) => {
                const rect = card.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                
                const centerX = rect.width / 2;
                const centerY = rect.height / 2;
                
                const rotateX = (y - centerY) / 20;
                const rotateY = (centerX - x) / 20;
                
                card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-12px) scale(1.02)`;
            });
            
            card.addEventListener('mouseleave', () => {
                card.style.transform = '';
            });
        });

        // Click ripple effect
        document.querySelectorAll('.admin-card').forEach(element => {
            element.addEventListener('click', function(e) {
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.cssText = `
                    position: absolute;
                    width: ${size}px;
                    height: ${size}px;
                    border-radius: 50%;
                    background: rgba(99, 102, 241, 0.3);
                    top: ${y}px;
                    left: ${x}px;
                    pointer-events: none;
                    animation: ripple 0.6s ease-out;
                `;
                
                this.style.position = 'relative';
                this.style.overflow = 'hidden';
                this.appendChild(ripple);
                
                setTimeout(() => ripple.remove(), 600);
            });
        });

        // Add ripple animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes ripple {
                from {
                    transform: scale(0);
                    opacity: 1;
                }
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);

        // Parallax effect for background decorations
        window.addEventListener('scroll', () => {
            const scrolled = window.pageYOffset;
            const decorations = document.querySelectorAll('.bg-decoration, .floating-orb');
            decorations.forEach((decoration, index) => {
                const speed = (index + 1) * 0.05;
                decoration.style.transform = `translateY(${scrolled * speed}px)`;
            });
        });

        // Prevent text selection on rapid clicks
        document.querySelectorAll('.admin-card').forEach(card => {
            card.addEventListener('mousedown', (e) => {
                e.preventDefault();
            });
        });

        // Random floating animation delays for orbs
        document.querySelectorAll('.floating-orb').forEach((orb, index) => {
            const randomDelay = Math.random() * 5;
            orb.style.animationDelay = `${randomDelay}s`;
        });

        // Dynamic background color shift
        let hue = 0;
        setInterval(() => {
            hue = (hue + 0.1) % 360;
            document.querySelectorAll('.bg-decoration').forEach((decoration, index) => {
                const offset = index * 30;
                decoration.style.filter = `blur(80px) hue-rotate(${hue + offset}deg)`;
            });
        }, 50);
    </script>
</body>
</html>
