@echo on
setlocal enableDelayedExpansion

::build "array" of running VMs
set vmCount=0
for /f "skip=1 eol=: delims=" %%F in ('vmrun list') do (
	set /a vmCount+=1
	set "vmPath!vmCount!=%%F"
)

::suspend VMs
for /l %%N in (1 1 %vmCount%) do (
	set escapedPath=^"!vmPath%%N!^"
	vmrun stop !escapedPath! soft
)