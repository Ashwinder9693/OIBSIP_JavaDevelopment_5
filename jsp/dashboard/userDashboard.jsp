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
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');

        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --primary-light: #818cf8;
            --accent: #ec4899;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --dark: #0f172a;
            --gray: #64748b;
            --light: #f8fafc;
            --border: #e2e8f0;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: var(--dark);
            min-height: 100vh;
            overflow-x: hidden;
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
                radial-gradient(circle at 20% 50%, rgba(99, 102, 241, 0.15) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(236, 72, 153, 0.15) 0%, transparent 50%),
                radial-gradient(circle at 40% 20%, rgba(139, 92, 246, 0.15) 0%, transparent 50%);
            pointer-events: none;
            animation: gradientShift 15s ease infinite;
        }

        @keyframes gradientShift {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.8; }
        }

        /* Floating particles */
        .particle {
            position: fixed;
            width: 4px;
            height: 4px;
            background: rgba(255, 255, 255, 0.5);
            border-radius: 50%;
            pointer-events: none;
            animation: float 20s infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0) translateX(0) scale(1);
                opacity: 0;
            }
            10% { opacity: 0.8; }
            90% { opacity: 0.8; }
            100% {
                transform: translateY(-100vh) translateX(50px) scale(0.5);
                opacity: 0;
            }
        }

        /* Navbar */
        .navbar {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            padding: 1rem clamp(1rem, 5vw, 3rem);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .navbar.scrolled {
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .logo-container {
            position: relative;
            width: 48px;
            height: 48px;
        }

        .logo-mini {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            box-shadow: 0 8px 24px rgba(102, 126, 234, 0.4);
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
            box-shadow: 0 12px 32px rgba(102, 126, 234, 0.6);
        }

        .navbar-brand a {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
            color: inherit;
            cursor: pointer;
        }

        .navbar-brand a:hover {
            opacity: 0.9;
        }

        .navbar-brand h1 {
            font-size: clamp(1.25rem, 3vw, 1.5rem);
            font-weight: 900;
            background: linear-gradient(135deg, #fff, #f0f0f0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: -0.03em;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin: 0;
        }

        .navbar-user {
            display: flex;
            align-items: center;
            gap: clamp(0.75rem, 2vw, 1.5rem);
        }

        .user-greeting {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.625rem 1.25rem;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 50px;
            transition: all 0.3s ease;
        }

        .user-greeting:hover {
            background: rgba(255, 255, 255, 0.25);
            border-color: rgba(255, 255, 255, 0.5);
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #ec4899, #f472b6);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            box-shadow: 0 4px 12px rgba(236, 72, 153, 0.4);
            animation: avatarPulse 2s ease-in-out infinite;
        }

        @keyframes avatarPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .user-name {
            font-weight: 700;
            color: white;
            font-size: clamp(0.875rem, 2vw, 1rem);
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .logout-btn {
            padding: 0.75rem 1.5rem;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 50px;
            color: white;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.9375rem;
            transition: all 0.3s ease;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .logout-btn:hover {
            background: rgba(239, 68, 68, 0.9);
            border-color: rgba(239, 68, 68, 1);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(239, 68, 68, 0.4);
        }

        /* Dashboard Container */
        .dashboard-container {
            padding: clamp(1.5rem, 4vw, 2.5rem) clamp(1rem, 5vw, 3rem);
            max-width: 1400px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        /* Welcome Panel */
        .welcome-panel {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 24px;
            padding: clamp(2rem, 5vw, 3rem);
            margin-bottom: clamp(2rem, 4vw, 3rem);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            position: relative;
            overflow: hidden;
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

        .welcome-panel::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(102, 126, 234, 0.15) 0%, transparent 70%);
            border-radius: 50%;
            animation: float 10s ease-in-out infinite;
        }

        .welcome-panel::after {
            content: '';
            position: absolute;
            bottom: -30%;
            left: -10%;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(236, 72, 153, 0.1) 0%, transparent 70%);
            border-radius: 50%;
            animation: float 12s ease-in-out infinite reverse;
        }

        .welcome-panel h2 {
            font-size: clamp(1.75rem, 4vw, 2.5rem);
            font-weight: 900;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.75rem;
            letter-spacing: -0.03em;
            position: relative;
            z-index: 1;
        }

        .welcome-panel p {
            color: var(--gray);
            font-size: clamp(1rem, 2vw, 1.125rem);
            font-weight: 500;
            position: relative;
            z-index: 1;
        }

        /* Stats Bar */
        .stats-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(min(100%, 240px), 1fr));
            gap: clamp(1rem, 3vw, 1.5rem);
            margin-bottom: clamp(2rem, 4vw, 3rem);
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 20px;
            padding: clamp(1.5rem, 3vw, 2.5rem);
            text-align: center;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            cursor: pointer;
            position: relative;
            overflow: hidden;
            animation: popIn 0.5s ease-out backwards;
        }

        @keyframes popIn {
            from {
                opacity: 0;
                transform: scale(0.8) translateY(20px);
            }
            to {
                opacity: 1;
                transform: scale(1) translateY(0);
            }
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            transition: left 0.5s ease;
        }

        .stat-card:hover::before {
            left: 100%;
        }

        .stat-card:hover {
            transform: translateY(-10px) scale(1.05);
            box-shadow: 0 25px 50px rgba(102, 126, 234, 0.3);
            border-color: rgba(102, 126, 234, 0.5);
        }

        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stat-card:nth-child(4) { animation-delay: 0.4s; }
        .stat-card:nth-child(5) { animation-delay: 0.5s; }

        .stat-icon {
            font-size: clamp(2rem, 5vw, 3rem);
            margin-bottom: 1rem;
            display: inline-block;
            animation: bounce 2s ease-in-out infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .stat-number {
            font-size: clamp(2.5rem, 6vw, 3.5rem);
            font-weight: 900;
            background: linear-gradient(135deg, #667eea, #764ba2, #ec4899);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
            letter-spacing: -0.03em;
            display: block;
        }

        .stat-label {
            color: var(--gray);
            font-size: clamp(0.875rem, 2vw, 1rem);
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }

        /* Action Grid */
        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(min(100%, 280px), 1fr));
            gap: clamp(1.5rem, 3vw, 2rem);
            margin-bottom: clamp(2rem, 4vw, 3rem);
        }

        .action-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 24px;
            padding: clamp(2rem, 4vw, 3rem);
            text-align: center;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out backwards;
        }

        .action-card:nth-child(1) { animation-delay: 0.2s; }
        .action-card:nth-child(2) { animation-delay: 0.3s; }
        .action-card:nth-child(3) { animation-delay: 0.4s; }
        .action-card:nth-child(4) { animation-delay: 0.5s; }

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

        .action-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(102, 126, 234, 0.15) 0%, transparent 70%);
            transition: transform 0.6s ease;
        }

        .action-card:hover::before {
            transform: translate(25%, 25%);
        }

        .action-card:hover {
            transform: translateY(-15px) rotate(-2deg);
            box-shadow: 0 30px 60px rgba(102, 126, 234, 0.4);
            border-color: rgba(102, 126, 234, 0.6);
        }

        .card-icon-box {
            width: clamp(80px, 18vw, 100px);
            height: clamp(80px, 18vw, 100px);
            margin: 0 auto 1.5rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: clamp(2.5rem, 6vw, 3.5rem);
            transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
            position: relative;
            overflow: hidden;
        }

        .card-icon-box::before {
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

        .action-card:hover .card-icon-box {
            transform: scale(1.2) rotate(10deg);
            box-shadow: 0 20px 50px rgba(102, 126, 234, 0.6);
        }

        .action-card h3 {
            font-size: clamp(1.125rem, 3vw, 1.5rem);
            font-weight: 800;
            color: var(--dark);
            margin-bottom: 1rem;
            letter-spacing: -0.02em;
            transition: all 0.3s ease;
            position: relative;
            z-index: 1;
        }

        .action-card:hover h3 {
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            transform: scale(1.05);
        }

        .action-card p {
            color: var(--gray);
            font-size: clamp(0.9375rem, 2vw, 1.0625rem);
            line-height: 1.7;
            font-weight: 500;
            position: relative;
            z-index: 1;
        }

        /* Quick Actions */
        .quick-actions {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 24px;
            padding: clamp(2rem, 4vw, 3rem);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            animation: fadeInUp 0.6s ease-out 0.6s backwards;
            position: relative;
            overflow: hidden;
        }

        .quick-actions::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(236, 72, 153, 0.1) 0%, transparent 70%);
            animation: float 15s ease-in-out infinite;
        }

        .quick-actions h3 {
            font-size: clamp(1.25rem, 3vw, 1.5rem);
            font-weight: 800;
            background: linear-gradient(135deg, #667eea, #ec4899);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1.5rem;
            letter-spacing: -0.02em;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            position: relative;
            z-index: 1;
        }

        .quick-actions h3::before {
            content: '⚡';
            font-size: 2rem;
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.2); }
        }

        .quick-btn-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(min(100%, 200px), 1fr));
            gap: 1.25rem;
            position: relative;
            z-index: 1;
        }

        .quick-btn {
            padding: 1.25rem 1.5rem;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            border: 2px solid rgba(102, 126, 234, 0.3);
            border-radius: 16px;
            color: var(--dark);
            font-weight: 700;
            font-size: clamp(0.9375rem, 2vw, 1rem);
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
        }

        .quick-btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            transform: translate(-50%, -50%);
            transition: width 0.4s ease, height 0.4s ease;
            z-index: 0;
        }

        .quick-btn:hover::before {
            width: 300%;
            height: 300%;
        }

        .quick-btn:hover {
            color: white;
            border-color: #667eea;
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
        }

        .quick-btn span {
            position: relative;
            z-index: 1;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .user-name {
                display: none;
            }

            .stats-bar {
                grid-template-columns: repeat(2, 1fr);
            }

            .action-grid {
                grid-template-columns: 1fr;
            }

            .quick-btn-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 480px) {
            .stats-bar {
                grid-template-columns: 1fr;
            }

            .navbar {
                padding: 1rem;
            }

            .user-greeting {
                padding: 0.5rem 0.75rem;
            }

            .logout-btn {
                padding: 0.625rem 1rem;
                font-size: 0.875rem;
            }
        }

        html {
            scroll-behavior: smooth;
        }

        /* Enrollment Banner */
        .enrollment-banner {
            background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 50%, #d97706 100%);
            border: 3px solid #f59e0b;
            border-radius: 20px;
            padding: 2rem 2.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 20px 60px rgba(245, 158, 11, 0.4);
            animation: slideDown 0.6s ease-out, pulse 2s ease-in-out 1s infinite;
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
            background: radial-gradient(circle, rgba(255, 255, 255, 0.2) 0%, transparent 70%);
            border-radius: 50%;
            animation: float 8s ease-in-out infinite;
        }

        .enrollment-banner-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 2rem;
            position: relative;
            z-index: 1;
            flex-wrap: wrap;
        }

        .enrollment-banner-left {
            flex: 1;
            min-width: 300px;
        }

        .enrollment-banner-icon {
            font-size: 3rem;
            margin-bottom: 0.5rem;
            display: inline-block;
            animation: bounce 2s ease-in-out infinite;
        }

        .enrollment-banner h3 {
            font-size: clamp(1.5rem, 4vw, 2rem);
            font-weight: 900;
            color: white;
            margin-bottom: 0.75rem;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
            letter-spacing: -0.02em;
        }

        .enrollment-banner p {
            color: rgba(255, 255, 255, 0.95);
            font-size: clamp(1rem, 2vw, 1.125rem);
            font-weight: 500;
            line-height: 1.6;
            margin-bottom: 0.5rem;
        }

        .enrollment-benefits {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 1rem;
        }

        .enrollment-benefit {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(10px);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            color: white;
            font-weight: 600;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .enrollment-banner-right {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            align-items: flex-end;
        }

        .enrollment-btn {
            padding: 1.25rem 2.5rem;
            background: white;
            color: #d97706;
            border: none;
            border-radius: 50px;
            font-size: 1.125rem;
            font-weight: 800;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .enrollment-btn:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.3);
            background: linear-gradient(135deg, #ffffff, #f0f0f0);
        }

        .enrollment-btn-icon {
            font-size: 1.5rem;
            animation: bounce 1s ease-in-out infinite;
        }

        .enrollment-dismiss {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            border: 1px solid rgba(255, 255, 255, 0.4);
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .enrollment-dismiss:hover {
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.6);
        }

        @keyframes pulse {
            0%, 100% {
                box-shadow: 0 20px 60px rgba(245, 158, 11, 0.4);
            }
            50% {
                box-shadow: 0 20px 60px rgba(245, 158, 11, 0.6), 0 0 0 10px rgba(245, 158, 11, 0.1);
            }
        }

        @media (max-width: 768px) {
            .enrollment-banner-content {
                flex-direction: column;
                text-align: center;
            }

            .enrollment-banner-right {
                align-items: center;
                width: 100%;
            }

            .enrollment-btn {
                width: 100%;
                justify-content: center;
            }

            .enrollment-benefits {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Animated particles -->
    <div class="particle" style="left: 10%; animation-delay: 0s;"></div>
    <div class="particle" style="left: 25%; animation-delay: 3s;"></div>
    <div class="particle" style="left: 40%; animation-delay: 6s;"></div>
    <div class="particle" style="left: 55%; animation-delay: 9s;"></div>
    <div class="particle" style="left: 70%; animation-delay: 12s;"></div>
    <div class="particle" style="left: 85%; animation-delay: 15s;"></div>

    <nav class="navbar" id="navbar">
        <div class="navbar-brand">
            <a href="${pageContext.request.contextPath}/index.html">
                <div class="logo-container">
                    <div class="logo-mini">📚</div>
                </div>
                <h1>LibraryHub</h1>
            </a>
        </div>
        <div class="navbar-user">
            <div class="user-greeting">
                <div class="user-avatar">👤</div>
                <span class="user-name"><%= user.getUsername() %></span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        </div>
    </nav>

    <div class="dashboard-container">
        <div class="welcome-panel">
            <h2>Welcome back, <%= user.getUsername() %>! 🎉</h2>
            <p>Your gateway to endless knowledge and discovery</p>
        </div>

        <% if (member == null) { %>
        <!-- Enrollment Banner - Only shows if user has no membership -->
        <div class="enrollment-banner">
            <div class="enrollment-banner-content">
                <div class="enrollment-banner-left">
                    <div class="enrollment-banner-icon">🎉</div>
                    <h3>Complete Your Library Membership!</h3>
                    <p>You're almost there! Activate your <strong>FREE SILVER membership</strong> to start borrowing books and enjoy full library access.</p>
                    <div class="enrollment-benefits">
                        <div class="enrollment-benefit">
                            <span>📚</span> 3 Books at a Time
                        </div>
                        <div class="enrollment-benefit">
                            <span>📅</span> 14-Day Borrowing
                        </div>
                        <div class="enrollment-benefit">
                            <span>💎</span> FREE - No Charges
                        </div>
                    </div>
                </div>
                <div class="enrollment-banner-right">
                    <a href="<%= request.getContextPath() %>/membershipEnrollment" class="enrollment-btn">
                        <span class="enrollment-btn-icon">✨</span>
                        <span>Enroll Now</span>
                    </a>
                    <small style="color: rgba(255, 255, 255, 0.9);">Takes less than 2 minutes</small>
                </div>
            </div>
        </div>
        <% } %>

        <div class="stats-bar">
            <div class="stat-card">
                <div class="stat-icon">📚</div>
                <div class="stat-number" data-target="<%= booksBorrowed %>"><%= booksBorrowed %></div>
                <div class="stat-label">Books Borrowed</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📖</div>
                <div class="stat-number" data-target="<%= activeLoans %>"><%= activeLoans %></div>
                <div class="stat-label">Active Loans</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">💰</div>
                <div class="stat-number" data-target="<%= pendingFines.doubleValue() %>">$<%= String.format("%.2f", pendingFines) %></div>
                <div class="stat-label">Pending Fines</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">⭐</div>
                <div class="stat-number" data-target="<%= reservations %>"><%= reservations %></div>
                <div class="stat-label">Reservations</div>
            </div>
            <div class="stat-card wallet-card" onclick="location.href='${pageContext.request.contextPath}/wallet?action=topup'" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; cursor: pointer;">
                <div class="stat-icon" style="filter: drop-shadow(0 2px 8px rgba(0,0,0,0.2));">💳</div>
                <div class="stat-number" style="-webkit-text-fill-color: white; color: white;">$<%= String.format("%.2f", user.getWalletBalance()) %></div>
                <div class="stat-label" style="color: rgba(255,255,255,0.9);">Wallet Balance</div>
                <% if (user.getWalletPendingBalance().compareTo(BigDecimal.ZERO) > 0) { %>
                    <div style="margin-top: 0.5rem; padding: 0.25rem 0.75rem; background: rgba(255,255,255,0.2); border-radius: 20px; display: inline-block; font-size: 0.75rem; color: white; font-weight: 600;">
                        ⏳ $<%= String.format("%.2f", user.getWalletPendingBalance()) %> Pending
                    </div>
                <% } %>
                <div style="margin-top: 0.75rem; font-size: 0.875rem; color: rgba(255,255,255,0.9); font-weight: 600;">
                    <span style="background: rgba(255,255,255,0.15); padding: 0.5rem 1rem; border-radius: 8px; display: inline-block;">
                        ➕ Click to Add Money
                    </span>
                </div>
            </div>
        </div>

        <div class="action-grid">
            <div class="action-card" onclick="location.href='${pageContext.request.contextPath}/browseBooks'">
                <div class="card-icon-box">📚</div>
                <h3>Browse Books</h3>
                <p>Explore our vast collection of literature and discover your next favorite read</p>
            </div>

            <div class="action-card" onclick="location.href='${pageContext.request.contextPath}/myBooks'">
                <div class="card-icon-box">📖</div>
                <h3>My Books</h3>
                <p>Track your borrowed books and stay on top of return dates</p>
            </div>

            <div class="action-card" onclick="location.href='${pageContext.request.contextPath}/myFines'">
                <div class="card-icon-box">💰</div>
                <h3>My Fines</h3>
                <p>View and manage your outstanding library fines</p>
            </div>

            <div class="action-card" onclick="location.href='${pageContext.request.contextPath}/profile'">
                <div class="card-icon-box">👤</div>
                <h3>My Profile</h3>
                <p>Customize your account and manage preferences</p>
            </div>
        </div>

        <div class="quick-actions">
            <h3>Quick Actions</h3>
            <div class="quick-btn-grid">
                <a href="${pageContext.request.contextPath}/search" class="quick-btn">
                    <span>🔍 Search Catalog</span>
                </a>
                <a href="${pageContext.request.contextPath}/reservations" class="quick-btn">
                    <span>📋 My Reservations</span>
                </a>
                <a href="${pageContext.request.contextPath}/history" class="quick-btn">
                    <span>📊 Borrowing History</span>
                </a>
                <a href="${pageContext.request.contextPath}/recommendations" class="quick-btn">
                    <span>✨ Recommendations</span>
                </a>
            </div>
        </div>
    </div>

    <script>
        // Enhanced navbar scroll
        window.addEventListener('scroll', () => {
            const navbar = document.getElementById('navbar');
            navbar.classList.toggle('scrolled', window.scrollY > 20);
        });

        // Counter animation
        function animateValue(element, start, end, duration, isCurrency = false, prefix = '') {
            let startTime = null;
            
            const step = (timestamp) => {
                if (!startTime) startTime = timestamp;
                const progress = Math.min((timestamp - startTime) / duration, 1);
                const easeOutCubic = 1 - Math.pow(1 - progress, 3);
                const current = Math.floor(easeOutCubic * (end - start) + start);
                
                if (isCurrency) {
                    element.textContent = `${current}.00`;
                } else {
                    element.textContent = prefix + current;
                }
                
                if (progress < 1) {
                    requestAnimationFrame(step);
                }
            };
            
            requestAnimationFrame(step);
        }

        // Intersection Observer for animations
        const observerOptions = {
            threshold: 0.2,
            rootMargin: '0px 0px -100px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.animationPlayState = 'running';
                }
            });
        }, observerOptions);

        // Initialize animations
        document.addEventListener('DOMContentLoaded', () => {
            // Observe animated elements
            const animatedElements = document.querySelectorAll('.stat-card, .action-card, .quick-actions');
            animatedElements.forEach(el => observer.observe(el));

            // Example stat animations (replace with real data from backend)
            // Uncomment when you have actual data:
            /*
            setTimeout(() => {
                const statNumbers = document.querySelectorAll('.stat-number');
                animateValue(statNumbers[0], 0, 12, 2000);
                animateValue(statNumbers[1], 0, 3, 2000);
                animateValue(statNumbers[2], 0, 15, 2000, true);
                animateValue(statNumbers[3], 0, 2, 2000);
            }, 500);
            */
        });

        // 3D tilt effect for cards
        document.querySelectorAll('.action-card').forEach(card => {
            card.addEventListener('mousemove', (e) => {
                const rect = card.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                
                const centerX = rect.width / 2;
                const centerY = rect.height / 2;
                
                const rotateX = (y - centerY) / 10;
                const rotateY = (centerX - x) / 10;
                
                card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-15px)`;
            });
            
            card.addEventListener('mouseleave', () => {
                card.style.transform = '';
            });
        });

        // Click ripple effect
        document.querySelectorAll('.action-card, .quick-btn, .stat-card').forEach(element => {
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
                    background: rgba(255, 255, 255, 0.6);
                    top: ${y}px;
                    left: ${x}px;
                    pointer-events: none;
                    animation: ripple 0.6s ease-out;
                `;
                
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

        // Parallax effect for welcome panel
        window.addEventListener('scroll', () => {
            const scrolled = window.pageYOffset;
            const welcomePanel = document.querySelector('.welcome-panel');
            if (welcomePanel) {
                welcomePanel.style.transform = `translateY(${scrolled * 0.3}px)`;
            }
        });

        // Random particle positions
        document.querySelectorAll('.particle').forEach((particle, index) => {
            const randomDelay = Math.random() * 20;
            const randomDuration = 15 + Math.random() * 15;
            particle.style.animationDelay = `${randomDelay}s`;
            particle.style.animationDuration = `${randomDuration}s`;
            particle.style.left = `${Math.random() * 100}%`;
        });

        // Smooth card entrance on load
        window.addEventListener('load', () => {
            document.body.style.opacity = '1';
        });

        // Prevent text selection on rapid clicks
        document.querySelectorAll('.action-card, .stat-card').forEach(card => {
            card.addEventListener('mousedown', (e) => {
                e.preventDefault();
            });
        });

        // Enhanced hover effects for icons
        document.querySelectorAll('.stat-icon').forEach(icon => {
            icon.addEventListener('mouseenter', function() {
                this.style.transform = 'scale(1.3) rotate(15deg)';
            });
            
            icon.addEventListener('mouseleave', function() {
                this.style.transform = '';
            });
        });
    </script>
</body>
</html>