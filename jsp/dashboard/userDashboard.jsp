<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.Member" %>
<%@ page import="java.math.BigDecimal" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get member from request (to check if enrollment banner should show)
    Member member = (Member) request.getAttribute("member");
    
    // Get stats from request attributes (set by DashboardServlet)
    Integer booksBorrowed = (Integer) request.getAttribute("booksBorrowed");
    Integer activeLoans = (Integer) request.getAttribute("activeLoans");
    BigDecimal pendingFines = (BigDecimal) request.getAttribute("pendingFines");
    Integer reservations = (Integer) request.getAttribute("reservations");
    
    // If accessed directly (not through servlet), redirect to servlet
    if (booksBorrowed == null && activeLoans == null && pendingFines == null && reservations == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
    
    // Set defaults if not set (shouldn't happen if servlet is working)
    if (booksBorrowed == null) booksBorrowed = 0;
    if (activeLoans == null) activeLoans = 0;
    if (pendingFines == null) pendingFines = BigDecimal.ZERO;
    if (reservations == null) reservations = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - LibraryHub</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Poppins:wght@300;400;500;600;700;800;900&display=swap');

        :root {
            --primary: #4F46E5;
            --primary-dark: #4338CA;
            --primary-light: #818CF8;
            --secondary: #06B6D4;
            --accent: #EC4899;
            --success: #10B981;
            --warning: #F59E0B;
            --danger: #EF4444;
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
        }

        .bg-decoration-1 {
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(79, 70, 229, 0.08) 0%, transparent 70%);
            top: -300px;
            right: -200px;
            animation: float 20s ease-in-out infinite;
        }

        .bg-decoration-2 {
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(236, 72, 153, 0.06) 0%, transparent 70%);
            bottom: -100px;
            left: -100px;
            animation: float 15s ease-in-out infinite reverse;
        }

        .bg-decoration-3 {
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(6, 182, 212, 0.07) 0%, transparent 70%);
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            animation: pulse 10s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            33% { transform: translate(30px, -30px) rotate(5deg); }
            66% { transform: translate(-20px, 20px) rotate(-5deg); }
        }

        @keyframes pulse {
            0%, 100% { transform: translate(-50%, -50%) scale(1); opacity: 0.5; }
            50% { transform: translate(-50%, -50%) scale(1.2); opacity: 0.8; }
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
            background: var(--white);
            border: 1.5px solid var(--gray-200);
            border-radius: 50px;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }

        .user-info:hover {
            border-color: var(--primary);
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }

        .user-avatar {
            width: 42px;
            height: 42px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            box-shadow: var(--shadow-md);
            transition: transform 0.3s ease;
        }

        .user-info:hover .user-avatar {
            transform: scale(1.1);
        }

        .user-details {
            display: flex;
            flex-direction: column;
            gap: 0.125rem;
        }

        .user-name {
            font-weight: 700;
            color: var(--gray-900);
            font-size: 0.9375rem;
            line-height: 1.2;
        }

        .user-role {
            font-size: 0.75rem;
            color: var(--gray-500);
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
            max-width: 1400px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        /* Welcome Section */
        .welcome-section {
            background: var(--white);
            border-radius: 24px;
            padding: 3rem;
            margin-bottom: 2.5rem;
            box-shadow: var(--shadow-lg);
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
            top: 0;
            right: 0;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(79, 70, 229, 0.08) 0%, transparent 70%);
            pointer-events: none;
        }

        .welcome-content {
            position: relative;
            z-index: 1;
        }

        .welcome-title {
            font-family: 'Poppins', sans-serif;
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.75rem;
            letter-spacing: -0.03em;
            line-height: 1.2;
        }

        .welcome-subtitle {
            color: var(--gray-600);
            font-size: 1.125rem;
            font-weight: 500;
            line-height: 1.6;
        }

        /* Enrollment Banner */
        .enrollment-banner {
            background: linear-gradient(135deg, #FEF3C7 0%, #FDE68A 50%, #FCD34D 100%);
            border: 2px solid #F59E0B;
            border-radius: 20px;
            padding: 2rem 2.5rem;
            margin-bottom: 2.5rem;
            box-shadow: var(--shadow-xl);
            animation: slideDown 0.6s ease-out 0.2s backwards;
            position: relative;
            overflow: hidden;
        }

        .enrollment-banner::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.4) 0%, transparent 70%);
            border-radius: 50%;
            animation: float 8s ease-in-out infinite;
        }

        .enrollment-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 2rem;
            position: relative;
            z-index: 1;
            flex-wrap: wrap;
        }

        .enrollment-left {
            flex: 1;
            min-width: 300px;
        }

        .enrollment-icon {
            font-size: 3rem;
            margin-bottom: 0.75rem;
            display: inline-block;
            animation: bounce 2s ease-in-out infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .enrollment-title {
            font-size: 1.75rem;
            font-weight: 800;
            color: var(--gray-900);
            margin-bottom: 0.75rem;
            line-height: 1.3;
        }

        .enrollment-text {
            color: var(--gray-700);
            font-size: 1.0625rem;
            font-weight: 500;
            line-height: 1.6;
            margin-bottom: 1rem;
        }

        .enrollment-benefits {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
        }

        .benefit-badge {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(10px);
            padding: 0.5rem 1rem;
            border-radius: 50px;
            color: var(--gray-800);
            font-weight: 600;
            font-size: 0.875rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: 1px solid rgba(245, 158, 11, 0.3);
            box-shadow: var(--shadow-sm);
        }

        .enrollment-btn {
            padding: 1.125rem 2.5rem;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            border: none;
            border-radius: 50px;
            font-size: 1.0625rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            box-shadow: var(--shadow-lg);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .enrollment-btn:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: var(--shadow-2xl);
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }

        .stat-card {
            background: var(--white);
            border: 1px solid var(--gray-200);
            border-radius: 20px;
            padding: 2rem;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            cursor: pointer;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out backwards;
            box-shadow: var(--shadow);
        }

        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stat-card:nth-child(4) { animation-delay: 0.4s; }
        .stat-card:nth-child(5) { animation-delay: 0.5s; }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(79, 70, 229, 0.05), transparent);
            transition: left 0.5s ease;
        }

        .stat-card:hover::before {
            left: 100%;
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-xl);
            border-color: var(--primary-light);
        }

        .stat-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.25rem;
        }

        .stat-icon-wrapper {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            transition: all 0.3s ease;
        }

        .stat-card:hover .stat-icon-wrapper {
            transform: scale(1.15) rotate(5deg);
        }

        .stat-icon-books { background: linear-gradient(135deg, #EFF6FF, #DBEAFE); color: var(--primary); }
        .stat-icon-loans { background: linear-gradient(135deg, #F0FDF4, #DCFCE7); color: var(--success); }
        .stat-icon-fines { background: linear-gradient(135deg, #FEF2F2, #FEE2E2); color: var(--danger); }
        .stat-icon-reservations { background: linear-gradient(135deg, #FDF4FF, #FCE7F3); color: var(--accent); }
        .stat-icon-wallet { background: linear-gradient(135deg, #ECFEFF, #CFFAFE); color: var(--secondary); }

        .stat-value {
            font-size: 2.75rem;
            font-weight: 900;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
            letter-spacing: -0.03em;
            line-height: 1;
        }

        .stat-label {
            color: var(--gray-600);
            font-size: 0.9375rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        /* Wallet Card Special Styling */
        .wallet-card {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            border: none;
            color: var(--white);
        }

        .wallet-card .stat-icon-wrapper {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            color: var(--white);
        }

        .wallet-card .stat-value {
            color: var(--white);
        }

        .wallet-card .stat-label {
            color: rgba(255, 255, 255, 0.95);
        }

        .wallet-pending {
            margin-top: 0.75rem;
            padding: 0.5rem 1rem;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: 50px;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--white);
        }

        .wallet-cta {
            margin-top: 1rem;
            padding: 0.625rem 1.25rem;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
            font-weight: 700;
            color: var(--white);
            transition: all 0.3s ease;
        }

        .wallet-card:hover .wallet-cta {
            background: rgba(255, 255, 255, 0.3);
            transform: scale(1.05);
        }

        /* Action Cards Grid */
        .action-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin-bottom: 2.5rem;
        }

        .action-card {
            background: var(--white);
            border: 1px solid var(--gray-200);
            border-radius: 24px;
            padding: 2.5rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out backwards;
            box-shadow: var(--shadow);
        }

        .action-card:nth-child(1) { animation-delay: 0.2s; }
        .action-card:nth-child(2) { animation-delay: 0.3s; }
        .action-card:nth-child(3) { animation-delay: 0.4s; }
        .action-card:nth-child(4) { animation-delay: 0.5s; }

        .action-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(79, 70, 229, 0.08) 0%, transparent 70%);
            transition: transform 0.6s ease;
        }

        .action-card:hover::before {
            transform: translate(25%, 25%);
        }

        .action-card:hover {
            transform: translateY(-12px);
            box-shadow: var(--shadow-2xl);
            border-color: var(--primary-light);
        }

        .action-icon-box {
            width: 100px;
            height: 100px;
            margin: 0 auto 1.5rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            box-shadow: var(--shadow-lg);
            position: relative;
            overflow: hidden;
        }

        .action-icon-box::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transform: rotate(45deg);
            animation: iconShine 3s infinite;
        }

        @keyframes iconShine {
            0% { transform: translateX(-100%) rotate(45deg); }
            100% { transform: translateX(100%) rotate(45deg); }
        }

        .action-card:hover .action-icon-box {
            transform: scale(1.15) rotate(5deg);
            box-shadow: var(--shadow-xl);
        }

        .action-card h3 {
            font-size: 1.375rem;
            font-weight: 800;
            color: var(--gray-900);
            margin-bottom: 0.875rem;
            letter-spacing: -0.02em;
            transition: all 0.3s ease;
            position: relative;
            z-index: 1;
        }

        .action-card:hover h3 {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .action-card p {
            color: var(--gray-600);
            font-size: 1rem;
            line-height: 1.7;
            font-weight: 500;
            position: relative;
            z-index: 1;
        }

        /* Quick Actions Section */
        .quick-actions-section {
            background: var(--white);
            border: 1px solid var(--gray-200);
            border-radius: 24px;
            padding: 2.5rem;
            box-shadow: var(--shadow-lg);
            animation: fadeInUp 0.6s ease-out 0.6s backwards;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1.75rem;
            letter-spacing: -0.02em;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .section-title-icon {
            font-size: 2rem;
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.15); }
        }

        .quick-actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.25rem;
        }

        .quick-action-btn {
            padding: 1.25rem 1.5rem;
            background: linear-gradient(135deg, var(--gray-50), var(--white));
            border: 2px solid var(--gray-200);
            border-radius: 16px;
            color: var(--gray-800);
            font-weight: 700;
            font-size: 0.9375rem;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            text-align: center;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
        }

        .quick-action-btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            transform: translate(-50%, -50%);
            transition: width 0.4s ease, height 0.4s ease;
            z-index: 0;
        }

        .quick-action-btn:hover::before {
            width: 300%;
            height: 300%;
        }

        .quick-action-btn:hover {
            color: var(--white);
            border-color: var(--primary);
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }

        .quick-action-btn span {
            position: relative;
            z-index: 1;
        }

        .quick-action-btn i {
            position: relative;
            z-index: 1;
            font-size: 1.25rem;
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .welcome-title {
                font-size: 2rem;
            }

            .stat-value {
                font-size: 2.25rem;
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
                font-size: 1.75rem;
            }

            .welcome-subtitle {
                font-size: 1rem;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .action-cards-grid {
                grid-template-columns: 1fr;
            }

            .quick-actions-grid {
                grid-template-columns: 1fr;
            }

            .enrollment-content {
                flex-direction: column;
                text-align: center;
            }

            .enrollment-benefits {
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }

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
        }

        html {
            scroll-behavior: smooth;
        }

        /* Loading Animation */
        @keyframes shimmer {
            0% { background-position: -1000px 0; }
            100% { background-position: 1000px 0; }
        }

        /* Hover Effects */
        .hover-lift {
            transition: transform 0.3s ease;
        }

        .hover-lift:hover {
            transform: translateY(-4px);
        }
    </style>
</head>
<body>
    <!-- Background Decorations -->
    <div class="bg-decoration bg-decoration-1"></div>
    <div class="bg-decoration bg-decoration-2"></div>
    <div class="bg-decoration bg-decoration-3"></div>

    <!-- Navbar -->
    <nav class="navbar" id="navbar">
        <a href="${pageContext.request.contextPath}/index.html" class="navbar-brand">
            <div class="logo-container">
                <div class="logo-mini">📚</div>
            </div>
            <h1>LibraryHub</h1>
        </a>
        <div class="navbar-user">
            <div class="user-info">
                <div class="user-avatar">👤</div>
                <div class="user-details">
                    <div class="user-name"><%= user.getUsername() %></div>
                    <div class="user-role">Member</div>
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
                <h2 class="welcome-title">Welcome back, <%= user.getUsername() %>! 🎉</h2>
                <p class="welcome-subtitle">Your gateway to endless knowledge and discovery awaits</p>
            </div>
        </div>

        <!-- Enrollment Banner (if no membership) -->
        <% if (member == null) { %>
        <div class="enrollment-banner">
            <div class="enrollment-content">
                <div class="enrollment-left">
                    <div class="enrollment-icon">🎉</div>
                    <h3 class="enrollment-title">Complete Your Library Membership!</h3>
                    <p class="enrollment-text">You're almost there! Activate your <strong>FREE SILVER membership</strong> to start borrowing books and enjoy full library access.</p>
                    <div class="enrollment-benefits">
                        <div class="benefit-badge">
                            <span>📚</span> 3 Books at a Time
                        </div>
                        <div class="benefit-badge">
                            <span>📅</span> 14-Day Borrowing
                        </div>
                        <div class="benefit-badge">
                            <span>💎</span> FREE - No Charges
                        </div>
                    </div>
                </div>
                <div>
                    <a href="<%= request.getContextPath() %>/membershipEnrollment" class="enrollment-btn">
                        <i class="fas fa-rocket"></i>
                        <span>Enroll Now</span>
                    </a>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon-wrapper stat-icon-books">
                        <i class="fas fa-book"></i>
                    </div>
                </div>
                <div class="stat-value"><%= booksBorrowed %></div>
                <div class="stat-label">Books Borrowed</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon-wrapper stat-icon-loans">
                        <i class="fas fa-book-open"></i>
                    </div>
                </div>
                <div class="stat-value"><%= activeLoans %></div>
                <div class="stat-label">Active Loans</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon-wrapper stat-icon-fines">
                        <i class="fas fa-money-bill-wave"></i>
                    </div>
                </div>
                <div class="stat-value">$<%= String.format("%.2f", pendingFines) %></div>
                <div class="stat-label">Pending Fines</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon-wrapper stat-icon-reservations">
                        <i class="fas fa-bookmark"></i>
                    </div>
                </div>
                <div class="stat-value"><%= reservations %></div>
                <div class="stat-label">Reservations</div>
            </div>

            <div class="stat-card wallet-card" onclick="location.href='${pageContext.request.contextPath}/wallet?action=topup'">
                <div class="stat-header">
                    <div class="stat-icon-wrapper">
                        <i class="fas fa-wallet"></i>
                    </div>
                </div>
                <div class="stat-value">$<%= String.format("%.2f", user.getWalletBalance()) %></div>
                <div class="stat-label">Wallet Balance</div>
                <% if (user.getWalletPendingBalance().compareTo(BigDecimal.ZERO) > 0) { %>
                    <div class="wallet-pending">
                        <i class="fas fa-clock"></i>
                        $<%= String.format("%.2f", user.getWalletPendingBalance()) %> Pending
                    </div>
                <% } %>
                <div class="wallet-cta">
                    <i class="fas fa-plus-circle"></i>
                    Click to Add Money
                </div>
            </div>
        </div>

        <!-- Action Cards -->
        <div class="action-cards-grid">
            <div class="action-card" onclick="location.href='${pageContext.request.contextPath}/browseBooks'">
                <div class="action-icon-box">📚</div>
                <h3>Browse Books</h3>
                <p>Explore our vast collection of literature and discover your next favorite read</p>
            </div>

            <div class="action-card" onclick="location.href='${pageContext.request.contextPath}/myBooks'">
                <div class="action-icon-box">📖</div>
                <h3>My Books</h3>
                <p>Track your borrowed books and stay on top of return dates</p>
            </div>

            <div class="action-card" onclick="location.href='${pageContext.request.contextPath}/myFines'">
                <div class="action-icon-box">💰</div>
                <h3>My Fines</h3>
                <p>View and manage your outstanding library fines</p>
            </div>

            <div class="action-card" onclick="location.href='${pageContext.request.contextPath}/profile'">
                <div class="action-icon-box">👤</div>
                <h3>My Profile</h3>
                <p>Customize your account and manage preferences</p>
            </div>
        </div>

        <!-- Quick Actions Section -->
        <div class="quick-actions-section">
            <h3 class="section-title">
                <span class="section-title-icon">⚡</span>
                Quick Actions
            </h3>
            <div class="quick-actions-grid">
                <a href="${pageContext.request.contextPath}/search" class="quick-action-btn">
                    <i class="fas fa-search"></i>
                    <span>Search Catalog</span>
                </a>
                <a href="${pageContext.request.contextPath}/reservations" class="quick-action-btn">
                    <i class="fas fa-clipboard-list"></i>
                    <span>My Reservations</span>
                </a>
                <a href="${pageContext.request.contextPath}/history" class="quick-action-btn">
                    <i class="fas fa-history"></i>
                    <span>Borrowing History</span>
                </a>
                <a href="${pageContext.request.contextPath}/recommendations" class="quick-action-btn">
                    <i class="fas fa-star"></i>
                    <span>Recommendations</span>
                </a>
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

        // 3D tilt effect for action cards
        document.querySelectorAll('.action-card').forEach(card => {
            card.addEventListener('mousemove', (e) => {
                const rect = card.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                
                const centerX = rect.width / 2;
                const centerY = rect.height / 2;
                
                const rotateX = (y - centerY) / 15;
                const rotateY = (centerX - x) / 15;
                
                card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-12px)`;
            });
            
            card.addEventListener('mouseleave', () => {
                card.style.transform = '';
            });
        });

        // Click ripple effect
        document.querySelectorAll('.stat-card, .action-card, .quick-action-btn').forEach(element => {
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
                    background: rgba(79, 70, 229, 0.3);
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

        // Counter animation for stats
        function animateCounter(element) {
            const target = parseInt(element.textContent.replace(/[^0-9]/g, ''));
            const duration = 2000;
            const increment = target / (duration / 16);
            let current = 0;
            
            const timer = setInterval(() => {
                current += increment;
                if (current >= target) {
                    element.textContent = element.textContent.includes('$') 
                        ? '$' + target.toFixed(2) 
                        : target;
                    clearInterval(timer);
                } else {
                    element.textContent = element.textContent.includes('$') 
                        ? '$' + Math.floor(current).toFixed(2) 
                        : Math.floor(current);
                }
            }, 16);
        }

        // Initialize counter animations when stat cards come into view
        const observerOptions = {
            threshold: 0.5,
            rootMargin: '0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const valueElement = entry.target.querySelector('.stat-value');
                    if (valueElement && !valueElement.dataset.animated) {
                        animateCounter(valueElement);
                        valueElement.dataset.animated = 'true';
                    }
                }
            });
        }, observerOptions);

        document.querySelectorAll('.stat-card').forEach(card => {
            observer.observe(card);
        });

        // Parallax effect for background decorations
        window.addEventListener('scroll', () => {
            const scrolled = window.pageYOffset;
            const decorations = document.querySelectorAll('.bg-decoration');
            decorations.forEach((decoration, index) => {
                const speed = (index + 1) * 0.1;
                decoration.style.transform = `translateY(${scrolled * speed}px)`;
            });
        });

        // Prevent text selection on rapid clicks
        document.querySelectorAll('.action-card, .stat-card').forEach(card => {
            card.addEventListener('mousedown', (e) => {
                e.preventDefault();
            });
        });
    </script>
</body>
</html>
