@echo off
cls

set WorkingDir=%~dp0

:: Check if running with elevated privileges
net session >nul 2>&1
IF %ERRORLEVEL% EQU 2 (
	echo Install script requires to be ran as Administrator...
	goto :End
)

:: Check if OpenSSH was downloaded and is present in the same directory
IF NOT EXIST "%WorkingDir%OpenSSH\" (
	echo OpenSSH Folder is missing.
	echo Download the latest release from https://github.com/PowerShell/Win32-OpenSSH/releases 
	echo Extract its contents as an OpenSSH folder in the same directory as this script.
	goto :End
)

:: Store current ExecutionPolicy to set it back at the end
for /f "delims=" %%a in (' powershell "Get-ExecutionPolicy" ') do set "OriginalExecutionPolicy=%%a"
call powershell -noprofile -command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"

:: Copy OpenSSH folder into Program Files and create .ssh in the User Directory
robocopy "%WorkingDir%OpenSSH" "%PROGRAMFILES%\OpenSSH" /COPYALL /E
IF NOT EXIST "%USERPROFILE%\.ssh" (
	mkdir "%USERPROFILE%\.ssh"
)

:: Perform OpenSSH Installation, Service configuration and Firewall entries
chdir /d "%PROGRAMFILES%\OpenSSH"
call powershell -ExecutionPolicy Bypass -File install-sshd.ps1
netsh advfirewall firewall delete rule name="OpenSSH Server (sshd)"
call powershell "New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22"
echo off > "%USERPROFILE%\.ssh\authorized_keys"
call powershell -ExecutionPolicy Bypass -File FixHostFilePermissions.ps1
call powershell -ExecutionPolicy Bypass -File FixUserFilePermissions.ps1
call powershell -noprofile -command "Set-Service -Name sshd -StartupType Automatic"
call powershell -noprofile -command "Start-Service -Name sshd"

:: Set ExecutionPolicy back to its original value
call powershell -noprofile -command "Set-ExecutionPolicy -ExecutionPolicy %OriginalExecutionPolicy% -Force"

:Complete
echo.
echo Execution complete.
echo If everything went well you can personalize your SSH settings in the configuration file under:
echo %PROGRAMDATA%\ssh\sshd_config

:End
chdir /d "%WorkingDir%"
echo.
echo Press any key to exit or wait 60 seconds...
timeout 60 >nul
