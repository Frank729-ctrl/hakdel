#!/bin/bash
# HakDel Local Dev — run from hakdel/ root: bash start-dev.sh

echo ""
echo " ================================="
echo "  HAKDEL — Local Dev Environment"
echo " ================================="
echo ""

echo "[1/2] Starting Scanner API on http://localhost:8000 ..."
cd api
python3 -m uvicorn main:app --reload --port 8000 &
API_PID=$!
cd ..

sleep 1

echo "[2/2] Starting PHP frontend on http://localhost:8080 ..."
cd frontend
php -S localhost:8080 &
PHP_PID=$!
cd ..

echo ""
echo " Both servers running:"
echo "   Frontend : http://localhost:8080/auth/login.php"
echo "   API docs : http://localhost:8000/docs"
echo ""
echo " Press Ctrl+C to stop both servers."
echo ""

trap "kill $API_PID $PHP_PID 2>/dev/null; echo 'Servers stopped.'" EXIT
wait
