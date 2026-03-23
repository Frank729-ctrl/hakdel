@echo off
REM HakDel Local Dev — run from hakdel\ root

echo.
echo  =================================
echo   HAKDEL - Local Dev Environment
echo  =================================
echo.

echo [1/2] Starting Scanner API on http://localhost:8000 ...
start "HakDel API" cmd /k "cd api && python -m uvicorn main:app --reload --port 8000"

timeout /t 2 /nobreak >nul

echo [2/2] Starting PHP frontend on http://localhost:8080 ...
start "HakDel Frontend" cmd /k "cd frontend && php -S localhost:8080"

echo.
echo  Both servers starting in separate windows.
echo    Frontend : http://localhost:8080/auth/login.php
echo    API docs : http://localhost:8000/docs
echo.
pause
