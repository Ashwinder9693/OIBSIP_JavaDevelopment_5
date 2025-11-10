@echo off
echo Compiling Library Management System...
echo.

cd /d "%~dp0"

set CLASSPATH=WEB-INF/lib/*;WEB-INF/classes

echo Step 1: Compiling utility classes...
javac -cp "%CLASSPATH%" -d WEB-INF/classes src/com/library/util/*.java
if errorlevel 1 goto :error

echo Step 2: Compiling entity classes...
javac -cp "%CLASSPATH%" -d WEB-INF/classes src/com/library/entity/*.java
if errorlevel 1 goto :error

echo Step 3: Compiling DAO classes...
javac -cp "%CLASSPATH%" -d WEB-INF/classes src/com/library/dao/*.java
if errorlevel 1 goto :error

echo Step 4: Compiling service classes...
javac -cp "%CLASSPATH%" -d WEB-INF/classes src/com/library/service/*.java
if errorlevel 1 goto :error

echo Step 5: Compiling servlet classes...
javac -cp "%CLASSPATH%" -d WEB-INF/classes src/com/library/servlet/*.java
if errorlevel 1 goto :error

echo Step 6: Compiling test classes...
javac -cp "%CLASSPATH%" -d WEB-INF/classes src/com/library/test/*.java
if errorlevel 1 goto :error

echo.
echo Compilation complete!
echo.
pause
exit /b 0

:error
echo.
echo Compilation failed! Please check the errors above.
echo Make sure MySQL JDBC driver is in WEB-INF/lib/
pause
exit /b 1

