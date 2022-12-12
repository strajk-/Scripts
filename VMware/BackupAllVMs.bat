@echo off
setlocal enableDelayedExpansion enableextensions

set OutputDirectory=%1

IF "%2"=="1" (
	set guiMode=nogui
) ELSE (
	set guiMode=gui
)
echo !guiMode!
goto :EndOfFile

::build "array" of running VMs
set vmCount=0
for /f "skip=1 eol=: delims=" %%F in ('vmrun list') do (
	set /a vmCount+=1
	set "vmPath!vmCount!=%%F"
)

::suspend VMs
for /l %%N in (1 1 %vmCount%) do (
	set escapedPath=^"!vmPath%%N!^"
	vmrun suspend !escapedPath!
)

::Wait 5 seconds just to be sure nothing is running there
timeout 5 >nul

::copy VM Folders to Output Directory
for /l %%N in (1 1 %vmCount%) do (
	call :folderPath_from_fullPath vmFolderPath ^"!vmPath%%N!^"
	for %%a in ("!vmPath%%N!") do for %%b in ("%%~dpa\.") do set "vmFolderName=%%~nxb"
	robocopy ^"!vmFolderPath:~0,-1!^" ^"!OutputDirectory!\!vmFolderName!^" /E
)

::start VMs
for /l %%N in (1 1 %vmCount%) do (
	set escapedPath=^"!vmPath%%N!^"
	vmrun start !escapedPath! !guiMode!
)

goto :EndOfFile
:folderPath_from_fullPath <resultVar> <pathVar>
(
	set "%~1=%~dp2"
	exit /b
)

:EndOfFile
endlocal