@echo off
cls

set WorkingDir=%~dp0

:: Check if running with elevated privileges
net session >nul 2>&1
IF %ERRORLEVEL% EQU 2 (
	echo Uninstall script requires to be ran as Administrator...
	goto :End
)

:: Ask if sure
:AskUninstall
CHOICE /C YC /M "All OpenSSH files, services and configurations will be deleted, are you sure? Press Y for Yes or C for Cancel."
IF NOT errorlevel 1 goto AskUninstall
IF errorlevel 2 goto :End

:: Store current ExecutionPolicy to set it back at the end
for /f "delims=" %%a in (' powershell "Get-ExecutionPolicy" ') do set "OriginalExecutionPolicy=%%a"
call powershell -noprofile -command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"

:: Perform OpenSSH Uninstall, Remove .ssh Folder, OpenSSH Folder and Firewall entries
chdir /d "%PROGRAMFILES%\OpenSSH"
call powershell -ExecutionPolicy Bypass -File uninstall-sshd.ps1
netsh advfirewall firewall delete rule name="OpenSSH Server (sshd)"
chdir /d "%USERPROFILE%\Desktop"
rmdir /S /Q "%PROGRAMFILES%\OpenSSH"
rmdir /S /Q "%PROGRAMDATA%\ssh"
rmdir /S /Q "%USERPROFILE%\.ssh"

:: Set ExecutionPolicy back to its original value
call powershell -noprofile -command "Set-ExecutionPolicy -ExecutionPolicy %OriginalExecutionPolicy% -Force"

:Complete
echo.
echo Execution complete, the following was done:
echo - Removed OpenSSH Services and Firewall entries
echo - Deleted %PROGRAMFILES%\OpenSSH
echo - Deleted %PROGRAMDATA%\ssh
echo - Deleted %USERPROFILE%\.ssh

:End
chdir /d "%WorkingDir%"
echo.
echo Press any key to exit or wait 60 seconds...
timeout 60 >nul