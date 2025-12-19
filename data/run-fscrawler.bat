@echo off
REM FSCrawler Startup Script for Windows

echo Starting FSCrawler...
echo.

REM Change to FSCrawler directory (adjust path if needed)
cd /d "%~dp0"

REM Run FSCrawler with the my_docs job
bin\fscrawler my_docs

pause
