@echo off
echo ========================================
echo BCrypt Password Hash Generator
echo ========================================
echo.

cd /d "%~dp0"

java -cp "WEB-INF\classes;WEB-INF\lib\*" com.library.util.PasswordUtils

pause

