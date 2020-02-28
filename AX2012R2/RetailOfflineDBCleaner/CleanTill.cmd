@echo off

REM blank if currently used "time" envrionment variable
set time=

REM putting the current time into an environment variable
set h=%TIME:~0,2%
set m=%TIME:~3,2%
set s=%TIME:~6,2%
set time=%h%-%m%-%s%

REM skipping the script if there was no Till hostname passed to the script
if %1.==. goto noargs

REM the main event:
REM Writing to a log file:
echo Going to kill AX Offline Service on %1 at %time% hours >> s:\it\scripts\AXTillAutoClean\logs\%1.txt
REM Writing to the screen:
echo Going to kill AX Offline Service on %1 at %time% hours

REM killing the process which locks the log file:
taskkill /s \\%1 /IM "Microsoft.Dynamics.Retail.Offline.Service.exe" >> s:\it\scripts\AXTillAutoClean\logs\%1.txt

REM writing a blank line to the log file and screen
echo.
echo. >> s:\it\scripts\AXTillAutoClean\logs\%1.txt

REM wait a while
ping 127.0.0.1 -n 2 > nul

REM deleting the naughty log file
echo Deleting the log file. This takes a long time please wait at %time% hours
echo Starting the deleting of the log file. This takes a long time please wait at %time% hours>> s:\it\scripts\AXTillAutoClean\logs\%1.txt
del "\\%1\c$\Program Files (x86)\Microsoft Dynamics AX\60\Retail POS\RetailOffline\RetailOfflineSyncTrace.log" >> s:\it\scripts\AXTillAutoClean\logs\%1.txt

REM refreshing the time in the environment variable, and marking the log
set time=
set h=%TIME:~0,2%
set m=%TIME:~3,2%
set s=%TIME:~6,2%
set time=%h%-%m%-%s%
echo Finished deleting the log at %time% hours.
echo Finished deleting the log at %time% hours. >> s:\it\scripts\AXTillAutoClean\logs\%1.txt
set time=
set h=%TIME:~0,2%
set m=%TIME:~3,2%
set s=%TIME:~6,2%
set time=%h%-%m%-%s%
echo REBOOTING %1! at %time% hours
echo REBOOTING %1! at %time% hours >> s:\it\scripts\AXTillAutoClean\logs\%1.txt

REM Reboot command
shutdown /r /m \\%1 /c "Retail trace log deleted" >> s:\it\scripts\AXTillAutoClean\logs\%1.txt

goto end

:noargs
echo you forgot to tell me which till to work on at %time% hours
echo you forgot to tell me which till to work on at %time% hours >> s:\it\scripts\AXTillAutoClean\logs\TILL_NOT_NOT_SPECIFIED_AT_%TIME%.txt

:end
