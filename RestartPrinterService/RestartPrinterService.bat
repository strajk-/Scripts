@echo off
cls

:: Check if running with elevated privileges
net session >nul 2>&1
IF %ERRORLEVEL% EQU 2 (
	echo To reset the service this script needs to be ran as Administrator...
	echo Press any key to exit or wait 10 seconds...
	timeout 10 >nul
	goto :End
)

net stop spooler
del /Q /F /S "%systemroot%\System32\Spool\Printers\*.*"
net start spooler

:End