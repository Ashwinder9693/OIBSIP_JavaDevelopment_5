<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.entity.User" %>
<%@ page import="com.library.entity.Book" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    List<Book> books = (List<Book>) request.getAttribute("books");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Books - LibraryHub</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f8f9fa;
            color: #1a1a1a;
            min-height: 100vh;
        }

        .navbar {
            background: white;
            border-bottom: 1px solid #e5e7eb;
            padding: 1rem 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
            position: sticky;
            top: 0;
            z-index: 1000;
            transition: box-shadow 0.3s ease;
        }

        .navbar.scrolled {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 0.875rem;
        }

        .logo-mini {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            transition: transform 0.3s ease;
        }

        .navbar-brand a {
            display: flex;
            align-items: center;
            gap: 0.875rem;
            text-decoration: none;
            color: inherit;
            cursor: pointer;
        }

        .navbar-brand a:hover {
            opacity: 0.8;
        }

        .navbar-brand h1 {
            font-size: 1.375rem;
            font-weight: 700;
            color: #1a1a1a;
            letter-spacing: -0.025em;
            margin: 0;
        }

        .navbar-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .nav-btn {
            padding: 0.625rem 1.25rem;
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            color: #374151;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            display: inline-block;
        }

        .nav-btn:hover {
            background: #f8f9fa;
            border-color: #d1d5db;
            color: #1a1a1a;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .nav-btn-primary {
            background: #2563eb;
            border-color: #2563eb;
            color: white;
        }

        .nav-btn-primary:hover {
            background: #1d4ed8;
            border-color: #1d4ed8;
            color: white;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2.5rem 3rem;
        }

        .page-header {
            margin-bottom: 2rem;
        }

        .page-header h2 {
            font-size: 2rem;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 0.5rem;
            letter-spacing: -0.025em;
        }

        .page-header p {
            color: #6b7280;
            font-size: 1rem;
        }

        .search-section {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .search-form {
            display: flex;
            gap: 0.75rem;
        }

        .search-input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.9375rem;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .search-input:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .search-btn {
            padding: 0.75rem 2rem;
            background: #2563eb;
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 500;
            font-size: 0.9375rem;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .search-btn:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(37, 99, 235, 0.2);
        }

        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1.5rem;
        }

        .book-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 1.75rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .book-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.02), rgba(29, 78, 216, 0.02));
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
            z-index: 0;
        }

        .book-card:hover::before {
            opacity: 1;
        }

        .book-card:hover {
            transform: translateY(-4px);
            border-color: #2563eb;
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.12);
        }

        .book-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 1rem;
            letter-spacing: -0.025em;
            line-height: 1.4;
            position: relative;
            z-index: 1;
        }

        .book-details {
            margin-bottom: 1rem;
            position: relative;
            z-index: 1;
        }

        .book-detail-item {
            display: flex;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }

        .book-detail-label {
            font-weight: 600;
            color: #374151;
            min-width: 90px;
        }

        .book-detail-value {
            color: #6b7280;
        }

        .book-description {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #f3f4f6;
            font-size: 0.875rem;
            color: #6b7280;
            line-height: 1.6;
            position: relative;
            z-index: 1;
        }

        .availability-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
            padding: 0.375rem 0.75rem;
            background: #f0fdf4;
            border: 1px solid #86efac;
            border-radius: 6px;
            font-size: 0.8125rem;
            font-weight: 500;
            color: #16a34a;
            margin-top: 1rem;
            position: relative;
            z-index: 1;
        }

        .availability-badge.limited {
            background: #fef3c7;
            border-color: #fcd34d;
            color: #ca8a04;
        }

        .availability-badge.unavailable {
            background: #fee2e2;
            border-color: #fca5a5;
            color: #dc2626;
        }

        .reserve-btn {
            display: block;
            text-align: center;
            padding: 0.75rem 1.5rem;
            background: #2563eb;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9375rem;
            transition: all 0.3s ease;
            margin-top: 1rem;
            position: relative;
            z-index: 10;
            cursor: pointer;
        }

        .reserve-btn:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        .reserve-btn:active {
            transform: translateY(0);
        }

        .no-results {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 3rem;
            text-align: center;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .no-results-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .no-results h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.5rem;
        }

        .no-results p {
            color: #6b7280;
            font-size: 0.9375rem;
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

        .book-card {
            animation: fadeIn 0.4s ease-out forwards;
        }

        .book-card:nth-child(1) { animation-delay: 0.05s; }
        .book-card:nth-child(2) { animation-delay: 0.1s; }
        .book-card:nth-child(3) { animation-delay: 0.15s; }
        .book-card:nth-child(4) { animation-delay: 0.2s; }
        .book-card:nth-child(5) { animation-delay: 0.25s; }
        .book-card:nth-child(6) { animation-delay: 0.3s; }

        @media (max-width: 768px) {
            .navbar {
                padding: 1rem 1.5rem;
                flex-wrap: wrap;
            }

            .navbar-actions {
                width: 100%;
                margin-top: 1rem;
                justify-content: flex-end;
            }

            .container {
                padding: 1.5rem;
            }

            .books-grid {
                grid-template-columns: 1fr;
            }

            .search-form {
                flex-direction: column;
            }

            .search-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar" id="navbar">
        <div class="navbar-brand">
            <a href="${pageContext.request.contextPath}/index.html">
                <div class="logo-mini">📚</div>
                <h1>LibraryHub</h1>
            </a>
        </div>
        <div class="navbar-actions">
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-btn nav-btn-primary">Dashboard</a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-btn">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <h2>Browse Books</h2>
            <p>Explore our collection and find your next great read</p>
        </div>

        <div class="search-section">
            <form method="get" action="${pageContext.request.contextPath}/browseBooks" class="search-form">
                <input 
                    type="text" 
                    class="search-input" 
                    name="search" 
                    placeholder="Search by title, author, ISBN, or publisher..." 
                    value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>"
                >
                <button class="search-btn" type="submit">🔍 Search</button>
            </form>
        </div>

        <% if (books != null && !books.isEmpty()) { %>
            <div class="books-grid">
                <% for (Book book : books) { 
                    int availableCopies = book.getAvailableCopies();
                    int totalCopies = book.getTotalCopies();
                    String availabilityClass = "";
                    String availabilityText = "";
                    
                    if (availableCopies == 0) {
                        availabilityClass = "unavailable";
                        availabilityText = "Unavailable";
                    } else if (availableCopies <= totalCopies * 0.3) {
                        availabilityClass = "limited";
                        availabilityText = "Limited Availability";
                    } else {
                        availabilityClass = "";
                        availabilityText = "Available";
                    }
                %>
                    <div class="book-card">
                        <h3 class="book-title"><%= book.getTitle() %></h3>
                        
                        <div class="book-details">
                            <div class="book-detail-item">
                                <span class="book-detail-label">ISBN:</span>
                                <span class="book-detail-value"><%= book.getIsbn() != null ? book.getIsbn() : "N/A" %></span>
                            </div>
                            <div class="book-detail-item">
                                <span class="book-detail-label">Publication Year:</span>
                                <span class="book-detail-value"><%= book.getPublicationYear() != null ? book.getPublicationYear() : "N/A" %></span>
                            </div>
                            <div class="book-detail-item">
                                <span class="book-detail-label">Format:</span>
                                <span class="book-detail-value"><%= book.getFormat() != null ? book.getFormat().name() : "N/A" %></span>
                            </div>
                            <div class="book-detail-item">
                                <span class="book-detail-label">Copies:</span>
                                <span class="book-detail-value"><%= availableCopies %> available of <%= totalCopies %> total</span>
                            </div>
                        </div>

                        <% if (book.getDescription() != null && !book.getDescription().trim().isEmpty()) { %>
                            <div class="book-description">
                                <%= book.getDescription() %>
                            </div>
                        <% } %>

                        <div class="availability-badge <%= availabilityClass %>">
                            <% if (availableCopies > 0) { %>
                                ✓ <%= availabilityText %>
                            <% } else { %>
                                ✕ <%= availabilityText %>
                            <% } %>
                        </div>
                        
                        <% if (availableCopies > 0) { %>
                            <a href="${pageContext.request.contextPath}/reservation?action=show&bookId=<%= book.getBookId() %>" 
                               class="reserve-btn">
                                Reserve Book
                            </a>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="no-results">
                <div class="no-results-icon">📚</div>
                <h3>No books found</h3>
                <p>Try adjusting your search terms or browse all available books</p>
            </div>
        <% } %>
    </div>

    <script>
        // Add scroll effect to navbar
        window.addEventListener('scroll', function() {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 10) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });

        // Focus search input on page load if no search was performed
        window.addEventListener('load', function() {
            const searchInput = document.querySelector('.search-input');
            if (searchInput && !searchInput.value) {
                searchInput.focus();
            }
        });
    </script>
</body>
</html>