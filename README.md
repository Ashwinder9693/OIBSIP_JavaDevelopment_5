# Library Management System

A modern, full-featured library management system built with Java. This application helps libraries manage their day-to-day operations, from tracking books and members to handling reservations, fines, and everything in between.

## What This System Does

Think of this as a complete digital solution for running a library. Librarians can manage the entire book inventory, track who has what books, handle returns, process fines, and generate reports. Members can browse the catalog, reserve books, view their borrowing history, pay fines, and manage their accounts—all through an intuitive web interface.

## Key Features

### For Administrators

Administrators have full control over the system. You can add new books to the catalog, update book information, remove outdated titles, and search through the entire collection. Managing members is straightforward—view all registered members, see their borrowing history, check their membership status, and handle any account-related tasks.

The system also handles the traditional library workflow: issuing books to members, processing returns, calculating fines for overdue items, and managing payments. There's even a comprehensive reporting dashboard that gives you insights into library operations, popular books, member activity, and financial transactions.

What makes this system special is the wallet feature. Members can add funds to their account, and administrators can approve these top-ups or directly credit member accounts. This makes it easy to handle payments for reservations, fines, or membership upgrades.

### For Members

Members get a clean, user-friendly interface to explore the library. You can browse available books, see detailed information about each title, and reserve books for a specific rental period. The system supports different membership tiers (Silver, Gold, and Platinum), each with its own benefits and rental rates.

Your personal dashboard shows everything at a glance: currently borrowed books, active reservations, outstanding fines, and your wallet balance. You can view your complete borrowing history, see which books you've reserved, and manage your profile information.

The wallet system makes payments seamless. Add money to your account, and once approved by an administrator, you can use it to pay for book reservations or fines without dealing with cash or credit cards every time.

## Technology Behind It

This is a Java web application using the Jakarta EE 10 specification. The backend is built with Java Servlets, which handle all the business logic and database interactions. The frontend uses JSP (JavaServer Pages) for dynamic content, along with HTML5, CSS3, and JavaScript. Bootstrap 5 is used for responsive, modern styling that works well on both desktop and mobile devices.

The database is MySQL 8.0, and the schema is well-normalized with 29 tables covering everything from books and members to transactions, fines, and wallet operations. Security is a priority—passwords are hashed using PBKDF2-SHA256 with 10,000 iterations, making them resistant to common attacks.

The application follows the MVC (Model-View-Controller) architecture pattern, which keeps the code organized and maintainable. Data access is handled through DAO (Data Access Object) classes, business logic lives in service classes, and servlets act as controllers that handle HTTP requests and responses.

## Getting Started

### What You'll Need

Before you can run this application, make sure you have a few things installed:

- **Java Development Kit (JDK)** version 11 or higher (JDK 17 is recommended for the best experience)
- **Apache Tomcat 11.0** or a newer version to run the web application
- **MySQL Server 8.0** or higher for the database
- **MySQL JDBC Driver** (the JAR file that lets Java talk to MySQL)

### Setting Up the Database

First, create a new database in MySQL. You can do this through MySQL Workbench, the command line, or any MySQL client you prefer:

```sql
CREATE DATABASE library_management;
```

Next, you'll need to run the SQL script that creates all the necessary tables. The script is in the file `library_management.sql`. This script sets up all 29 tables with their relationships, indexes, and constraints. If you're using MySQL Workbench, you can simply open the file and run it. If you're using the command line, you can import it like this:

```bash
mysql -u root -p library_management < library_management.sql
```

After the database is set up, you'll need to configure the connection. Open the file `src/com/library/util/DatabaseConnection.java` and update the connection details to match your MySQL setup:

```java
public static final String URL = "jdbc:mysql://localhost:3306/library_management";
public static final String USERNAME = "root";
public static final String PASSWORD = "your_password_here";
```

### Installing the MySQL Driver

You'll need to download the MySQL Connector/J driver from the official MySQL website (https://dev.mysql.com/downloads/connector/j/). Once downloaded, copy the JAR file (something like `mysql-connector-j-8.0.x.jar`) into the `WEB-INF/lib/` directory of your project.

### Building and Running

Compiling the Java source files is straightforward. From the project root directory, run:

```bash
javac -cp "WEB-INF/lib/*" -d WEB-INF/classes src/com/library/**/*.java
```

On Windows, you might need to adjust the path separators, or you can use the provided `compile.bat` script if you're on Windows.

Once compiled, you need to deploy the application to Tomcat. Simply copy the entire `LibraryManagement` folder to Tomcat's `webapps` directory. The exact path depends on where you installed Tomcat, but it's typically something like `C:\Program Files\Apache Software Foundation\Tomcat 11.0\webapps\` on Windows or `/opt/tomcat/webapps/` on Linux.

Start the Tomcat server by running the startup script:

```bash
# On Linux/Mac
/path/to/tomcat/bin/startup.sh

# On Windows
C:\path\to\tomcat\bin\startup.bat
```

Once Tomcat is running, open your web browser and navigate to:

```
http://localhost:8080/LibraryManagement
```

You should see the library management system homepage. If everything is set up correctly, you're ready to go!

### Default Login

For testing purposes, there's a default administrator account:
- **Username**: `admin`
- **Password**: `admin123`

**Important**: Make sure to change this password in a production environment! The system also requires an admin code (`ADMIN2024`) when registering new administrator accounts, which you should update in the `RegisterServlet.java` file for security.

## Project Structure

The project is organized in a clear, logical structure that makes it easy to navigate and maintain:

- **`src/com/library/`** - All Java source code lives here
  - **`dao/`** - Data Access Objects that handle database operations
  - **`entity/`** - Java classes that represent database tables (Book, Member, User, etc.)
  - **`service/`** - Business logic layer that processes requests and coordinates between DAOs
  - **`servlet/`** - Controllers that handle HTTP requests and responses
  - **`util/`** - Utility classes for database connections, password hashing, etc.

- **`jsp/`** - JavaServer Pages for the user interface
  - **`admin/`** - Pages only accessible to administrators
  - **`user/`** - Pages for regular members
  - **`dashboard/`** - Dashboard pages for both admins and users
  - **`login.jsp`** and **`register.jsp`** - Authentication pages

- **`WEB-INF/`** - Configuration and dependencies
  - **`web.xml`** - Web application configuration
  - **`lib/`** - JAR files for dependencies (MySQL driver, servlet API, etc.)

## Database Schema

The database is designed with normalization in mind, which means data is organized efficiently and redundancies are minimized. There are 29 tables in total, covering every aspect of library operations.

**Core entities** include users, members, books, authors, and publishers. The `users` table stores account information with securely hashed passwords, while the `members` table holds detailed member profiles including membership tiers, contact information, and borrowing statistics.

**Inventory management** is handled through tables like `book_copies` (individual physical copies of books), `branches` (different library locations), and `shelves` (organization within branches).

**Transactions** are tracked through `issue_return` (book borrowing and returning), `reservations` (book reservations with rental periods), `invoices` (financial records), and `fines` (overdue charges).

**Categorization** is supported through `languages`, `genres`, and many-to-many relationship tables like `book_authors` and `book_genres` that allow books to have multiple authors and genres.

**Advanced features** include book reviews, reading lists, notifications, library events, book requests, awards, and wishlists. There are also audit logs and reading history tables for analytics and tracking.

All of this is defined in the `library_management.sql` file, which includes table definitions, foreign key constraints, indexes for performance, and even some sample data to get you started.

## Security Features

Security is taken seriously in this application. Passwords are never stored in plain text. Instead, they're hashed using PBKDF2-SHA256, which is a strong, industry-standard algorithm. Each password gets a unique 16-byte salt, and the hashing process runs 10,000 iterations, making it computationally expensive for attackers to crack passwords even if they get access to the database.

The hash is stored in a specific format: `$pbkdf2$10000$[salt]$[hash]`, where the salt and hash are Base64-encoded. This makes it easy to verify passwords during login without ever storing the actual password.

Role-based access control ensures that users can only access features appropriate for their role. Administrators can't accidentally access user-only features, and regular members can't access admin pages. This is enforced at the servlet level, so even if someone tries to access a URL directly, they'll be redirected if they don't have the proper permissions.

Session management is implemented to automatically log users out after a period of inactivity, and the system requires an admin code for registering new administrator accounts.

## Business Rules

The system implements several business rules that reflect real-world library operations:

**Membership Tiers**: There are three membership levels. Silver is free and gives you a 14-day loan period. Gold costs $90 per year and extends loans to 30 days with a 3-day grace period. Platinum costs $120 per year and offers 60-day loans with a 7-day grace period.

**Rental Pricing**: When members reserve books, they pay a daily rental rate. Silver members pay the base rate (20% of book price), Gold members get a 15% discount, and Platinum members get a 10% discount. The discount is clearly shown on invoices.

**Fines**: If a book is returned after its due date, fines are calculated at $1.00 per day. The grace period (if applicable based on membership tier) is taken into account before fines start accumulating.

**Automatic Updates**: Books are automatically marked as overdue when they pass their due date, and the system tracks how many days overdue each item is.

## Common Issues and Solutions

### Can't Connect to the Database

If you're having trouble connecting to MySQL, first make sure the MySQL server is actually running. You can check this by trying to connect with a MySQL client. Next, verify that the database credentials in `DatabaseConnection.java` are correct. Make sure the database name, username, and password match what you've set up in MySQL. Also, ensure that the MySQL JDBC driver JAR file is in the `WEB-INF/lib/` directory.

### Compilation Errors

If you're seeing compilation errors, the most common cause is missing dependencies. Make sure all required JAR files are in `WEB-INF/lib/`, including the MySQL connector and the servlet API. Also, check that you're using a compatible Java version (JDK 11 or higher). If you're still having issues, verify that your package structure matches your directory structure—Java is case-sensitive and requires exact matches.

### Application Won't Start

If Tomcat starts but the application doesn't load, check the Tomcat logs. They're usually in the `logs/` directory of your Tomcat installation. Look for error messages that might indicate what's wrong. Common issues include missing database tables, incorrect database credentials, or missing JAR files.

### Pages Show Errors

If pages are loading but showing errors, check the browser's developer console (F12) for JavaScript errors, and check the Tomcat logs for server-side errors. Make sure all database tables were created correctly by running the SQL script again if necessary.

## Production Considerations

If you're planning to deploy this in a production environment, there are a few things you should do:

1. **Change the default admin password** - Don't use `admin123` in production!
2. **Update the admin code** - Change `ADMIN2024` in `RegisterServlet.java` to something more secure
3. **Use HTTPS** - Encrypt traffic between the browser and server
4. **Set up database backups** - Regularly backup your MySQL database
5. **Configure proper session timeouts** - Adjust session timeout values based on your security requirements
6. **Review database credentials** - Make sure database passwords are strong and stored securely
7. **Monitor logs** - Set up log monitoring to catch issues early

## License

This project was created for educational purposes. Feel free to use it as a learning resource, modify it for your own projects, or adapt it to your needs.

## Final Notes

This library management system is designed to be robust, secure, and user-friendly. It handles the complexities of library operations while providing a smooth experience for both administrators and members. Whether you're managing a small community library or a larger institution, this system provides the tools you need to keep everything organized and running smoothly.

If you run into any issues or have questions, the code is well-commented and follows Java best practices, so it should be relatively straightforward to understand and modify. Happy coding!
