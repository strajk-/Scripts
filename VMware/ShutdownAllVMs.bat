@echo on
setlocal enableDelayedExpansion

::build "array" of running VMs
set vmCount=0
for /f "skip=1 eol=: delims=" %%F in ('vmrun list') do (
	set /a vmCount+=1
	set "vmPath!vmCount!=%%F"
)

:: shutdown VMs and clear caches folder
for /l %%N in (1 1 %vmCount%) do (
	vmrun stop ^"!vmPath%%N!^" soft
	timeout 5
	
	set "fullPath=!vmPath%%N!"
	set "escapedPath=!fullPath:\=\\!"

	:: Call PowerShell to get the directory path
	for /f "usebackq delims=" %%D in (`powershell -NoProfile -Command "[System.IO.Path]::GetDirectoryName(\"!escapedPath!\") + '\'"`) do (
		set "dirPath=%%D"
	)

	:: Define the path to the "caches" folder
	set "cachesPath=!dirPath!caches"
	if exist "!cachesPath!" (
		:: Delete caches folder if it exists
		rd /s /q "!cachesPath!"
	)
)
