<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LibraryHub - Quantum Access Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Sign-In API -->
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;500;700;900&family=Space+Grotesk:wght@300;400;600;700&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Space Grotesk', sans-serif;
            background: #000;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            overflow-x: hidden;
            position: relative;
        }

        .quantum-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at 20% 50%, rgba(120, 119, 198, 0.3), transparent 50%),
                        radial-gradient(circle at 80% 80%, rgba(255, 68, 153, 0.3), transparent 50%),
                        radial-gradient(circle at 40% 20%, rgba(0, 212, 255, 0.2), transparent 50%);
            animation: quantumShift 20s ease-in-out infinite;
        }

        @keyframes quantumShift {
            0%, 100% { transform: scale(1) rotate(0deg); }
            50% { transform: scale(1.1) rotate(5deg); }
        }

        .matrix-rain {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1;
        }

        .matrix-column {
            position: absolute;
            top: -100%;
            font-size: 14px;
            color: rgba(0, 255, 170, 0.3);
            font-family: 'Courier New', monospace;
            animation: matrixFall linear infinite;
        }

        @keyframes matrixFall {
            to { top: 100%; }
        }

        .scan-line {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 2px;
            background: linear-gradient(90deg, transparent, rgba(0, 255, 170, 0.8), transparent);
            animation: scan 4s linear infinite;
            z-index: 100;
        }

        @keyframes scan {
            0% { top: 0; }
            100% { top: 100%; }
        }

        .hexagon-grid {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                linear-gradient(30deg, rgba(0, 255, 170, 0.02) 12%, transparent 12.5%, transparent 87%, rgba(0, 255, 170, 0.02) 87.5%, rgba(0, 255, 170, 0.02)),
                linear-gradient(150deg, rgba(0, 255, 170, 0.02) 12%, transparent 12.5%, transparent 87%, rgba(0, 255, 170, 0.02) 87.5%, rgba(0, 255, 170, 0.02)),
                linear-gradient(30deg, rgba(0, 255, 170, 0.02) 12%, transparent 12.5%, transparent 87%, rgba(0, 255, 170, 0.02) 87.5%, rgba(0, 255, 170, 0.02)),
                linear-gradient(150deg, rgba(0, 255, 170, 0.02) 12%, transparent 12.5%, transparent 87%, rgba(0, 255, 170, 0.02) 87.5%, rgba(0, 255, 170, 0.02));
            background-size: 80px 140px;
            z-index: 0;
        }

        /* Home Button */
        .home-btn {
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1000;
            padding: 0.8rem 1.5rem;
            background: rgba(0, 20, 40, 0.8);
            backdrop-filter: blur(10px);
            border: 2px solid rgba(0, 255, 170, 0.5);
            border-radius: 50px;
            color: #00ffaa;
            text-decoration: none;
            font-family: 'Orbitron', sans-serif;
            font-weight: 700;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            box-shadow: 0 0 20px rgba(0, 255, 170, 0.3);
        }

        .home-btn:hover {
            background: rgba(0, 255, 170, 0.2);
            border-color: #00ffaa;
            color: #00ffaa;
            transform: translateY(-2px);
            box-shadow: 0 0 30px rgba(0, 255, 170, 0.6);
        }

        .home-btn .icon {
            font-size: 1.2rem;
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }

        .portal-container {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 480px;
        }

        .glow-orb {
            position: absolute;
            width: 300px;
            height: 300px;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.4;
            animation: orbFloat 8s ease-in-out infinite;
        }

        .orb-1 {
            background: linear-gradient(135deg, #00ffaa, #4facfe);
            top: -150px;
            left: -150px;
            animation-delay: 0s;
        }

        .orb-2 {
            background: linear-gradient(135deg, #ff0080, #ff8c00);
            bottom: -150px;
            right: -150px;
            animation-delay: 2s;
        }

        @keyframes orbFloat {
            0%, 100% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(20px, 20px) scale(1.1); }
        }

        .login-portal {
            background: rgba(10, 10, 30, 0.7);
            backdrop-filter: blur(20px) saturate(180%);
            border: 2px solid rgba(0, 255, 170, 0.3);
            border-radius: 25px;
            padding: 3rem 2.5rem;
            box-shadow: 
                0 0 60px rgba(0, 255, 170, 0.2),
                inset 0 0 60px rgba(0, 255, 170, 0.05),
                0 20px 80px rgba(0, 0, 0, 0.8);
            position: relative;
            overflow: hidden;
            animation: portalEntry 1s ease-out;
        }

        @keyframes portalEntry {
            from {
                opacity: 0;
                transform: scale(0.8) rotateX(20deg);
            }
            to {
                opacity: 1;
                transform: scale(1) rotateX(0);
            }
        }

        .portal-glow {
            position: absolute;
            top: -2px;
            left: -2px;
            right: -2px;
            bottom: -2px;
            background: linear-gradient(45deg, #00ffaa, #4facfe, #ff0080, #ff8c00);
            border-radius: 25px;
            z-index: -1;
            opacity: 0;
            filter: blur(10px);
            animation: portalPulse 3s ease-in-out infinite;
        }

        @keyframes portalPulse {
            0%, 100% { opacity: 0.3; }
            50% { opacity: 0.6; }
        }

        .header-section {
            text-align: center;
            margin-bottom: 2.5rem;
            position: relative;
        }

        .logo-quantum {
            width: 90px;
            height: 90px;
            margin: 0 auto 1.5rem;
            background: linear-gradient(135deg, #00ffaa, #4facfe);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            box-shadow: 
                0 0 30px rgba(0, 255, 170, 0.6),
                0 0 60px rgba(0, 255, 170, 0.3),
                inset 0 0 30px rgba(255, 255, 255, 0.2);
            position: relative;
            animation: logoSpin 10s linear infinite;
        }

        @keyframes logoSpin {
            0% { transform: rotate(0deg); box-shadow: 0 0 30px rgba(0, 255, 170, 0.6); }
            50% { transform: rotate(180deg); box-shadow: 0 0 50px rgba(79, 172, 254, 0.8); }
            100% { transform: rotate(360deg); box-shadow: 0 0 30px rgba(0, 255, 170, 0.6); }
        }

        .logo-quantum::before {
            content: '';
            position: absolute;
            top: -5px;
            left: -5px;
            right: -5px;
            bottom: -5px;
            background: linear-gradient(45deg, transparent, rgba(0, 255, 170, 0.5), transparent);
            border-radius: 20px;
            animation: borderRotate 3s linear infinite;
        }

        @keyframes borderRotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .header-section h1 {
            font-family: 'Orbitron', sans-serif;
            font-size: 2rem;
            font-weight: 900;
            background: linear-gradient(135deg, #00ffaa, #4facfe, #ff0080);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 3px;
            text-shadow: 0 0 30px rgba(0, 255, 170, 0.5);
        }

        .header-section p {
            color: rgba(0, 255, 170, 0.8);
            font-size: 0.9rem;
            font-weight: 300;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .input-container {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .input-label {
            color: rgba(0, 255, 170, 0.9);
            font-size: 0.75rem;
            font-weight: 600;
            margin-bottom: 0.6rem;
            display: block;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-family: 'Orbitron', sans-serif;
        }

        .input-wrapper {
            position: relative;
        }

        .cyber-input {
            width: 100%;
            padding: 1rem 1.2rem;
            background: rgba(0, 20, 40, 0.6);
            border: 2px solid rgba(0, 255, 170, 0.3);
            border-radius: 12px;
            color: #00ffaa;
            font-size: 1rem;
            font-family: 'Space Grotesk', sans-serif;
            transition: all 0.3s ease;
            box-shadow: inset 0 0 20px rgba(0, 255, 170, 0.1);
        }

        .cyber-input::placeholder {
            color: rgba(0, 255, 170, 0.3);
        }

        .cyber-input:focus {
            outline: none;
            background: rgba(0, 30, 60, 0.8);
            border-color: #00ffaa;
            box-shadow: 
                0 0 20px rgba(0, 255, 170, 0.4),
                inset 0 0 20px rgba(0, 255, 170, 0.2);
        }

        .input-icon {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(0, 255, 170, 0.6);
            font-size: 1.2rem;
            cursor: pointer;
            transition: all 0.3s;
            z-index: 10;
        }

        .input-icon:hover {
            color: #00ffaa;
            transform: translateY(-50%) scale(1.2);
        }

        .controls-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.8rem;
        }

        .cyber-checkbox {
            display: flex;
            align-items: center;
            gap: 0.6rem;
            color: rgba(0, 255, 170, 0.7);
            font-size: 0.85rem;
            cursor: pointer;
            font-family: 'Orbitron', sans-serif;
        }

        .cyber-checkbox input {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #00ffaa;
        }

        .cyber-link {
            color: #4facfe;
            text-decoration: none;
            font-size: 0.85rem;
            font-family: 'Orbitron', sans-serif;
            transition: all 0.3s;
            text-shadow: 0 0 10px rgba(79, 172, 254, 0.5);
        }

        .cyber-link:hover {
            color: #00ffaa;
            text-shadow: 0 0 20px rgba(0, 255, 170, 0.8);
        }

        .quantum-btn {
            width: 100%;
            padding: 1.1rem;
            background: linear-gradient(135deg, #00ffaa, #4facfe);
            border: none;
            border-radius: 12px;
            color: #000;
            font-size: 1.05rem;
            font-weight: 700;
            font-family: 'Orbitron', sans-serif;
            text-transform: uppercase;
            letter-spacing: 2px;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 
                0 0 30px rgba(0, 255, 170, 0.5),
                0 10px 40px rgba(0, 0, 0, 0.5);
        }

        .quantum-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.5), transparent);
            transition: left 0.5s;
        }

        .quantum-btn:hover::before {
            left: 100%;
        }

        .quantum-btn:hover {
            transform: translateY(-3px);
            box-shadow: 
                0 0 50px rgba(0, 255, 170, 0.8),
                0 15px 50px rgba(0, 0, 0, 0.6);
        }

        .quantum-btn:active {
            transform: translateY(0);
        }

        .divider-line {
            text-align: center;
            margin: 2rem 0;
            position: relative;
        }

        .divider-line::before,
        .divider-line::after {
            content: '';
            position: absolute;
            top: 50%;
            width: 40%;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(0, 255, 170, 0.5), transparent);
        }

        .divider-line::before { left: 0; }
        .divider-line::after { right: 0; }

        .divider-line span {
            color: rgba(0, 255, 170, 0.5);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 2px;
            font-family: 'Orbitron', sans-serif;
            padding: 0 1rem;
            background: rgba(10, 10, 30, 0.8);
        }

        .social-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .social-quantum {
            padding: 0.9rem;
            background: rgba(0, 20, 40, 0.6);
            border: 1.5px solid rgba(0, 255, 170, 0.3);
            border-radius: 12px;
            color: #00ffaa;
            font-size: 0.85rem;
            font-weight: 600;
            font-family: 'Orbitron', sans-serif;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            position: relative;
            overflow: hidden;
        }

        .social-quantum::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(0, 255, 170, 0.2);
            transform: translate(-50%, -50%);
            transition: width 0.5s, height 0.5s;
        }

        .social-quantum:hover::before {
            width: 300px;
            height: 300px;
        }

        .social-quantum:hover {
            border-color: #00ffaa;
            box-shadow: 0 0 20px rgba(0, 255, 170, 0.4);
            transform: translateY(-2px);
        }

        .footer-link {
            text-align: center;
            color: rgba(0, 255, 170, 0.6);
            font-size: 0.85rem;
            margin-top: 1.5rem;
            font-family: 'Orbitron', sans-serif;
        }

        .footer-link a {
            color: #4facfe;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
            text-shadow: 0 0 10px rgba(79, 172, 254, 0.5);
        }

        .footer-link a:hover {
            color: #00ffaa;
            text-shadow: 0 0 20px rgba(0, 255, 170, 0.8);
        }

        .alert-quantum {
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            font-family: 'Orbitron', sans-serif;
            animation: alertSlide 0.6s ease-out;
            border: 1px solid;
        }

        @keyframes alertSlide {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-quantum.error {
            background: rgba(255, 0, 80, 0.1);
            border-color: rgba(255, 0, 80, 0.5);
            color: #ff5588;
            box-shadow: 0 0 20px rgba(255, 0, 80, 0.3);
        }

        .alert-quantum.success {
            background: rgba(0, 255, 170, 0.1);
            border-color: rgba(0, 255, 170, 0.5);
            color: #00ffaa;
            box-shadow: 0 0 20px rgba(0, 255, 170, 0.3);
        }

        @media (max-width: 520px) {
            .login-portal {
                padding: 2.5rem 2rem;
            }

            .header-section h1 {
                font-size: 1.5rem;
            }

            .logo-quantum {
                width: 70px;
                height: 70px;
                font-size: 2rem;
            }

            .home-btn {
                top: 10px;
                left: 10px;
                padding: 0.6rem 1rem;
                font-size: 0.8rem;
            }

            .home-btn .icon {
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="quantum-bg"></div>
    <div class="hexagon-grid"></div>
    <div class="matrix-rain" id="matrix"></div>
    <div class="scan-line"></div>

    <!-- Home Button -->
    <a href="${pageContext.request.contextPath}/index.html" class="home-btn">
        <span class="icon">🏠</span>
        <span>HOME</span>
    </a>

    <div class="portal-container">
        <div class="glow-orb orb-1"></div>
        <div class="glow-orb orb-2"></div>

        <div class="login-portal">
            <div class="portal-glow"></div>

            <div class="header-section">
                <div class="logo-quantum">📚</div>
                <h1>LibraryHub</h1>
                <p>Quantum Access Portal</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert-quantum error">
                    ⚠ <%= request.getAttribute("error") %>
                </div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert-quantum success">
                    ✓ <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
                <div class="input-container">
                    <label class="input-label">User ID</label>
                    <div class="input-wrapper">
                        <input type="text" class="cyber-input" name="username" 
                               placeholder="Enter quantum identifier" required autocomplete="username">
                    </div>
                </div>

                <div class="input-container">
                    <label class="input-label">Passkey</label>
                    <div class="input-wrapper">
                        <input type="password" class="cyber-input" id="pass" name="password" 
                               placeholder="Enter secure passkey" required autocomplete="current-password">
                        <span class="input-icon" onclick="togglePass()">👁</span>
                    </div>
                </div>

                <div class="controls-row">
                    <label class="cyber-checkbox">
                        <input type="checkbox" name="remember">
                        <span>Remember</span>
                    </label>
                    <a href="#" class="cyber-link">Recovery</a>
                </div>

                <button type="submit" class="quantum-btn">Initialize Access</button>
            </form>

            <div class="divider-line">
                <span>Alternative Access</span>
            </div>

            <div class="social-grid">
                <div id="google-signin-wrapper" style="width: 100%;">
                    <!-- Google Sign-In button will be rendered here -->
                </div>
                <button class="social-quantum" onclick="alert('Microsoft Quantum Link initializing...')">
                    <span>🟦</span> Microsoft
                </button>
            </div>

            <div class="footer-link">
                New user? <a href="${pageContext.request.contextPath}/jsp/register.jsp">Register Now</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Matrix rain effect
        const matrix = document.getElementById('matrix');
        const chars = '01アイウエオカキクケコサシスセソタチツテト';
        
        for (let i = 0; i < 30; i++) {
            const column = document.createElement('div');
            column.className = 'matrix-column';
            column.style.left = Math.random() * 100 + '%';
            column.style.animationDuration = (Math.random() * 3 + 2) + 's';
            column.style.animationDelay = Math.random() * 5 + 's';
            
            let text = '';
            for (let j = 0; j < 20; j++) {
                text += chars[Math.floor(Math.random() * chars.length)] + '<br>';
            }
            column.innerHTML = text;
            matrix.appendChild(column);
        }

        // Toggle password
        function togglePass() {
            const pass = document.getElementById('pass');
            const icon = document.querySelector('.input-icon');
            if (pass.type === 'password') {
                pass.type = 'text';
                icon.textContent = '🙈';
            } else {
                pass.type = 'password';
                icon.textContent = '👁';
            }
        }

        // Auto-dismiss alerts
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert-quantum');
            alerts.forEach(alert => {
                alert.style.animation = 'alertSlide 0.6s ease-out reverse';
                setTimeout(() => alert.remove(), 600);
            });
        }, 5000);

        // Form validation with cyber effect
        document.querySelector('form').addEventListener('submit', (e) => {
            const inputs = document.querySelectorAll('.cyber-input');
            let valid = true;

            inputs.forEach(input => {
                if (!input.value.trim()) {
                    valid = false;
                    input.style.borderColor = '#ff0080';
                    input.style.boxShadow = '0 0 20px rgba(255, 0, 128, 0.6)';
                    input.style.animation = 'shake 0.5s';
                    setTimeout(() => {
                        input.style.animation = '';
                        input.style.borderColor = '';
                        input.style.boxShadow = '';
                    }, 500);
                }
            });

            if (!valid) e.preventDefault();
        });

        // Add shake animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                25% { transform: translateX(-10px); }
                75% { transform: translateX(10px); }
            }
        `;
        document.head.appendChild(style);

        // Google Sign-In initialization
        window.addEventListener('load', function() {
            initializeGoogleSignIn();
        });
        
        function initializeGoogleSignIn() {
            const GOOGLE_CLIENT_ID = '188267589561-ri4h6k8do3h6nq6tj8493eupjoeugrmh.apps.googleusercontent.com';
            
            // Debug: Log the current origin
            console.log('Current origin:', window.location.origin);
            console.log('Client ID:', GOOGLE_CLIENT_ID);
            
            // Wait for Google API to load
            if (typeof google === 'undefined' || !google.accounts) {
                // Retry after a short delay
                setTimeout(initializeGoogleSignIn, 100);
                return;
            }
            
            try {
                // Initialize Google Identity Services
                google.accounts.id.initialize({
                    client_id: GOOGLE_CLIENT_ID,
                    callback: handleCredentialResponse,
                    auto_select: false,
                    cancel_on_tap_outside: true
                });
                
                // Render the Google Sign-In button
                const wrapper = document.getElementById('google-signin-wrapper');
                if (wrapper) {
                    google.accounts.id.renderButton(wrapper, {
                        theme: 'filled_blue',
                        size: 'large',
                        type: 'standard',
                        text: 'signin_with',
                        shape: 'rectangular',
                        width: '100%'
                    });
                }
                
                // Don't show One Tap automatically to avoid errors
                // google.accounts.id.prompt();
            } catch (error) {
                console.error('Error initializing Google Sign-In:', error);
                const wrapper = document.getElementById('google-signin-wrapper');
                if (wrapper) {
                    wrapper.innerHTML = '<div style="padding: 10px; color: #ff5588; text-align: center;">Error: ' + error.message + '<br/>Make sure http://' + window.location.host + ' is added to Authorized JavaScript origins in Google Cloud Console</div>';
                }
            }
        }
        
        function handleCredentialResponse(response) {
            // Decode the JWT token to get user info
            try {
                console.log('Google credential response received');
                
                if (!response || !response.credential) {
                    console.error('No credential in response:', response);
                    alert('Invalid response from Google. Please try again.');
                    return;
                }
                
                // Decode JWT payload (second part of the token)
                const parts = response.credential.split('.');
                if (parts.length !== 3) {
                    console.error('Invalid JWT format');
                    alert('Invalid token format. Please try again.');
                    return;
                }
                
                // Decode base64url (Google uses base64url encoding)
                const payload = JSON.parse(atob(parts[1].replace(/-/g, '+').replace(/_/g, '/')));
                
                console.log('Decoded payload:', payload);
                
                // Extract user info
                const userInfo = {
                    email: payload.email || '',
                    givenName: payload.given_name || '',
                    familyName: payload.family_name || '',
                    name: payload.name || '',
                    picture: payload.picture || '',
                    idToken: response.credential
                };
                
                console.log('Extracted user info:', userInfo);
                
                // Validate email is present
                if (!userInfo.email || userInfo.email.trim() === '') {
                    console.error('Email not found in payload');
                    alert('Email not found in Google account. Please ensure your Google account has an email address.');
                    return;
                }
                
                sendGoogleUserInfo(userInfo, response.credential);
            } catch (error) {
                console.error('Error parsing credential:', error);
                console.error('Error details:', error.message, error.stack);
                alert('Failed to process Google sign-in: ' + error.message);
            }
        }
        
        function sendGoogleUserInfo(userInfo, idToken) {
            // Show loading state
            const wrapper = document.getElementById('google-signin-wrapper');
            if (wrapper) {
                wrapper.innerHTML = '<div style="text-align: center; padding: 10px; color: #00ffaa;">⏳ Authenticating...</div>';
            }
            
            // Validate email before sending
            if (!userInfo.email || userInfo.email.trim() === '') {
                console.error('Email is empty, cannot proceed');
                alert('Email is required but not found. Please try signing in again.');
                initializeGoogleSignIn();
                return;
            }
            
            // Prepare URL-encoded form data (easier for servlet to parse)
            const params = new URLSearchParams();
            params.append('email', userInfo.email.trim());
            params.append('givenName', (userInfo.givenName || userInfo.given_name || '').trim());
            params.append('familyName', (userInfo.familyName || userInfo.family_name || '').trim());
            params.append('name', (userInfo.name || '').trim());
            params.append('idToken', idToken || '');
            
            console.log('Sending to server:', {
                email: userInfo.email,
                givenName: userInfo.givenName || userInfo.given_name,
                familyName: userInfo.familyName || userInfo.family_name,
                name: userInfo.name
            });
            
            const contextPath = '${pageContext.request.contextPath}';
            const servletUrl = contextPath + '/GoogleOAuthServlet';
            
            console.log('Sending request to:', servletUrl);
            
            fetch(servletUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: params.toString()
            })
            .then(response => {
                console.log('Response status:', response.status);
                if (!response.ok) {
                    return response.text().then(text => {
                        console.error('Server error response:', text);
                        throw new Error('Server error: ' + response.status);
                    });
                }
                return response.json();
            })
            .then(data => {
                console.log('Server response:', data);
                if (data.success) {
                    // Redirect to dashboard
                    window.location.href = data.redirect;
                } else {
                    alert('Authentication failed: ' + (data.error || 'Unknown error'));
                    // Reinitialize Google Sign-In button
                    initializeGoogleSignIn();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to authenticate with Google: ' + error.message);
                // Reinitialize Google Sign-In button
                initializeGoogleSignIn();
            });
        }
    </script>
</body>
</html>