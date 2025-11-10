<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - LibraryHub</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://accounts.google.com/gsi/client" async defer></script>
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
        }

        /* Animated Background */
        .bg-decoration {
            position: fixed;
            border-radius: 50%;
            pointer-events: none;
            z-index: 0;
            filter: blur(80px);
            opacity: 0.6;
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
            background: radial-gradient(circle, rgba(139, 92, 246, 0.12) 0%, transparent 70%);
            bottom: -150px;
            left: -100px;
            animation: float 15s ease-in-out infinite reverse;
        }

        .bg-decoration-3 {
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(236, 72, 153, 0.1) 0%, transparent 70%);
            top: 40%;
            right: 10%;
            animation: pulse 12s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            33% { transform: translate(40px, -40px) rotate(120deg); }
            66% { transform: translate(-30px, 30px) rotate(240deg); }
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.5; }
            50% { transform: scale(1.2); opacity: 0.8; }
        }

        /* Home Button */
        .home-btn {
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1000;
            padding: 0.75rem 1.5rem;
            background: var(--white);
            border: 2px solid var(--gray-200);
            border-radius: 50px;
            color: var(--gray-700);
            text-decoration: none;
            font-weight: 700;
            font-size: 0.9375rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .home-btn:hover {
            background: var(--primary);
            border-color: var(--primary);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(99, 102, 241, 0.3);
        }

        /* Login Container */
        .login-container {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 480px;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            border: 1px solid var(--gray-200);
            border-radius: 24px;
            padding: 3rem 2.5rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            position: relative;
            overflow: hidden;
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

        .login-card::before {
            content: '';
            position: absolute;
            top: -100px;
            right: -100px;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.08) 0%, transparent 70%);
            pointer-events: none;
        }

        /* Header */
        .login-header {
            text-align: center;
            margin-bottom: 2.5rem;
            position: relative;
            z-index: 1;
        }

        .logo-box {
            width: 80px;
            height: 80px;
            margin: 0 auto 1.5rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            box-shadow: 0 10px 15px -3px rgba(99, 102, 241, 0.3);
            animation: logoFloat 3s ease-in-out infinite;
            position: relative;
            overflow: hidden;
        }

        .logo-box::before {
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

        @keyframes logoFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        @keyframes logoShine {
            0% { transform: translateX(-100%) rotate(45deg); }
            100% { transform: translateX(100%) rotate(45deg); }
        }

        .login-title {
            font-family: 'Poppins', sans-serif;
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
            letter-spacing: -0.03em;
        }

        .login-subtitle {
            color: var(--gray-600);
            font-size: 1rem;
            font-weight: 500;
        }

        /* Alerts */
        .alert {
            padding: 1rem 1.25rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            font-size: 0.9375rem;
            font-weight: 500;
            animation: slideDown 0.4s ease-out;
            display: flex;
            align-items: center;
            gap: 0.75rem;
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

        .alert-success {
            background: #F0FDF4;
            color: #166534;
            border: 1px solid #BBF7D0;
        }

        /* Form */
        .login-form {
            position: relative;
            z-index: 1;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
            letter-spacing: -0.01em;
        }

        .input-wrapper {
            position: relative;
        }

        .form-input {
            width: 100%;
            padding: 0.875rem 1rem;
            padding-left: 3rem;
            border: 2px solid var(--gray-200);
            border-radius: 12px;
            font-size: 1rem;
            font-family: 'Inter', sans-serif;
            color: var(--gray-900);
            background: var(--white);
            transition: all 0.3s ease;
        }

        .form-input::placeholder {
            color: var(--gray-400);
        }

        .form-input:hover {
            border-color: var(--gray-300);
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 1.125rem;
            pointer-events: none;
        }

        .toggle-password {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 1.125rem;
            cursor: pointer;
            transition: color 0.3s ease;
            z-index: 10;
        }

        .toggle-password:hover {
            color: var(--primary);
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.75rem;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--gray-600);
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
        }

        .checkbox-label input {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: var(--primary);
        }

        .forgot-link {
            color: var(--primary);
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .forgot-link:hover {
            color: var(--primary-dark);
        }

        .btn-login {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            border: none;
            border-radius: 12px;
            color: var(--white);
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px -1px rgba(99, 102, 241, 0.3);
            position: relative;
            overflow: hidden;
        }

        .btn-login::before {
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

        .btn-login:hover::before {
            width: 300%;
            height: 300%;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(99, 102, 241, 0.4);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        /* Divider */
        .divider {
            text-align: center;
            margin: 2rem 0;
            position: relative;
        }

        .divider::before,
        .divider::after {
            content: '';
            position: absolute;
            top: 50%;
            width: 40%;
            height: 1px;
            background: var(--gray-200);
        }

        .divider::before { left: 0; }
        .divider::after { right: 0; }

        .divider span {
            color: var(--gray-500);
            font-size: 0.875rem;
            font-weight: 600;
            background: var(--white);
            padding: 0 1rem;
            position: relative;
        }

        /* Social Login */
        .social-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .social-btn {
            padding: 0.875rem 1rem;
            background: var(--white);
            border: 2px solid var(--gray-200);
            border-radius: 12px;
            color: var(--gray-700);
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            position: relative;
            overflow: hidden;
        }

        .social-btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: var(--gray-50);
            transform: translate(-50%, -50%);
            transition: width 0.4s ease, height 0.4s ease;
        }

        .social-btn:hover::before {
            width: 300%;
            height: 300%;
        }

        .social-btn:hover {
            border-color: var(--primary);
            transform: translateY(-2px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .social-btn i {
            font-size: 1.25rem;
            position: relative;
            z-index: 1;
        }

        .social-btn span {
            position: relative;
            z-index: 1;
        }

        /* Footer */
        .login-footer {
            text-align: center;
            color: var(--gray-600);
            font-size: 0.9375rem;
        }

        .login-footer a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 700;
            transition: color 0.3s ease;
        }

        .login-footer a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .login-card {
                padding: 2.5rem 2rem;
            }

            .login-title {
                font-size: 1.75rem;
            }

            .social-grid {
                grid-template-columns: 1fr;
            }

            .home-btn {
                top: 10px;
                left: 10px;
                padding: 0.625rem 1.25rem;
                font-size: 0.875rem;
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
    <div class="bg-decoration bg-decoration-3"></div>

    <!-- Home Button -->
    <a href="${pageContext.request.contextPath}/index.html" class="home-btn">
        <i class="fas fa-home"></i>
        <span>Home</span>
    </a>

    <!-- Login Container -->
    <div class="login-container">
        <div class="login-card">
            <!-- Header -->
            <div class="login-header">
                <div class="logo-box">📚</div>
                <h1 class="login-title">Welcome Back</h1>
                <p class="login-subtitle">Sign in to continue to LibraryHub</p>
            </div>

            <!-- Alerts -->
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

            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/LoginServlet" method="post" class="login-form">
                <div class="form-group">
                    <label class="form-label">Username</label>
                    <div class="input-wrapper">
                        <i class="fas fa-user input-icon"></i>
                        <input type="text" class="form-input" name="username" placeholder="Enter your username" required autocomplete="username">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" class="form-input" id="password" name="password" placeholder="Enter your password" required autocomplete="current-password">
                        <i class="fas fa-eye toggle-password" id="togglePassword"></i>
                    </div>
                </div>

                <div class="form-options">
                    <label class="checkbox-label">
                        <input type="checkbox" name="remember">
                        <span>Remember me</span>
                    </label>
                    <a href="#" class="forgot-link">Forgot password?</a>
                </div>

                <button type="submit" class="btn-login">
                    <span>Sign In</span>
                </button>
            </form>

            <!-- Divider -->
            <div class="divider">
                <span>Or continue with</span>
            </div>

            <!-- Social Login -->
            <div class="social-grid">
                <div id="google-signin-wrapper" style="width: 100%;"></div>
                <button class="social-btn" onclick="alert('Microsoft sign-in coming soon...')">
                    <i class="fab fa-microsoft" style="color: #00A4EF;"></i>
                    <span>Microsoft</span>
                </button>
            </div>

            <!-- Footer -->
            <div class="login-footer">
                Don't have an account? <a href="${pageContext.request.contextPath}/jsp/register.jsp">Sign up now</a>
            </div>
        </div>
    </div>

    <script>
        // Toggle password visibility
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('password');

        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });

        // Auto-dismiss alerts
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.animation = 'slideUp 0.4s ease-out reverse';
                setTimeout(() => alert.remove(), 400);
            });
        }, 5000);

        // Google Sign-In initialization
        window.addEventListener('load', function() {
            initializeGoogleSignIn();
        });
        
        function initializeGoogleSignIn() {
            const GOOGLE_CLIENT_ID = '188267589561-ri4h6k8do3h6nq6tj8493eupjoeugrmh.apps.googleusercontent.com';
            
            if (typeof google === 'undefined' || !google.accounts) {
                setTimeout(initializeGoogleSignIn, 100);
                return;
            }
            
            try {
                google.accounts.id.initialize({
                    client_id: GOOGLE_CLIENT_ID,
                    callback: handleCredentialResponse,
                    auto_select: false,
                    cancel_on_tap_outside: true
                });
                
                const wrapper = document.getElementById('google-signin-wrapper');
                if (wrapper) {
                    google.accounts.id.renderButton(wrapper, {
                        theme: 'outline',
                        size: 'large',
                        type: 'standard',
                        text: 'signin_with',
                        shape: 'rectangular',
                        width: '100%'
                    });
                }
            } catch (error) {
                console.error('Error initializing Google Sign-In:', error);
            }
        }
        
        function handleCredentialResponse(response) {
            try {
                if (!response || !response.credential) {
                    alert('Invalid response from Google. Please try again.');
                    return;
                }
                
                const parts = response.credential.split('.');
                if (parts.length !== 3) {
                    alert('Invalid token format. Please try again.');
                    return;
                }
                
                const payload = JSON.parse(atob(parts[1].replace(/-/g, '+').replace(/_/g, '/')));
                
                const userInfo = {
                    email: payload.email || '',
                    givenName: payload.given_name || '',
                    familyName: payload.family_name || '',
                    name: payload.name || '',
                    idToken: response.credential
                };
                
                if (!userInfo.email || userInfo.email.trim() === '') {
                    alert('Email not found in Google account.');
                    return;
                }
                
                sendGoogleUserInfo(userInfo, response.credential);
            } catch (error) {
                console.error('Error parsing credential:', error);
                alert('Failed to process Google sign-in: ' + error.message);
            }
        }
        
        function sendGoogleUserInfo(userInfo, idToken) {
            const wrapper = document.getElementById('google-signin-wrapper');
            if (wrapper) {
                wrapper.innerHTML = '<div style="text-align: center; padding: 10px; color: var(--primary);">⏳ Authenticating...</div>';
            }
            
            if (!userInfo.email || userInfo.email.trim() === '') {
                alert('Email is required but not found.');
                initializeGoogleSignIn();
                return;
            }
            
            const params = new URLSearchParams();
            params.append('email', userInfo.email.trim());
            params.append('givenName', (userInfo.givenName || '').trim());
            params.append('familyName', (userInfo.familyName || '').trim());
            params.append('name', (userInfo.name || '').trim());
            params.append('idToken', idToken || '');
            
            const contextPath = '${pageContext.request.contextPath}';
            const servletUrl = contextPath + '/GoogleOAuthServlet';
            
            fetch(servletUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: params.toString()
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error('Server error: ' + response.status);
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    window.location.href = data.redirect;
                } else {
                    alert('Authentication failed: ' + (data.error || 'Unknown error'));
                    initializeGoogleSignIn();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to authenticate with Google: ' + error.message);
                initializeGoogleSignIn();
            });
        }
    </script>
</body>
</html>
