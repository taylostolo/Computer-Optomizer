@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "%~s0", "%params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
exit /B

:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
color 1F
CLS
:MENU

ECHO ........................................................
ECHO . PRESS 1, 2, 3 or 4 to select your task, or 5 to EXIT .
ECHO ........................................................
ECHO 1 - Create disk task
ECHO 2 - Fix disk right now
ECHO 3 - Do both now
ECHO 4 - Install product key as well as tasks
ECHO 5 - EXIT
SET /P M=Type 1, 2, 3, 4, or 5 then press ENTER:
IF %M%==1 GOTO NOTE
IF %M%==2 GOTO CALC
IF %M%==3 GOTO BOTH
IF %M%==4 GOTO PROD
IF %M%==5 GOTO EOF
:NOTE
*put if exist here taylor for that shit on the next 2 lines
del C:\"Disk Files"
md C:\"Disk Files"
SCHTASKS /DELETE /TN "diskfix" /f
SCHTASKS /CREATE /SC ONLOGON /TN "disk files\diskfix" /TR "C:\Disk Files\Diskfix.bat" /RU admin /f
(
 echo net stop SysMain 
 echo net stop Superfetch 
 echo net stop WSearch 
) >> C:\"Disk Files"\Diskfix.bat
GOTO MENU
:CALC
net stop SysMain 
net stop Superfetch 
net stop WSearch 
GOTO MENU
:BOTH
md C:\"Disk Files"
SCHTASKS /DELETE /TN "diskfix" /f
SCHTASKS /CREATE /SC ONLOGON /TN "disk files\diskfix" /TR "C:\Disk Files\Diskfix.bat" /RU admin /f
(
 echo net stop SysMain
 echo net stop Superfetch
 echo net stop WSearch
) >> C:\"Disk Files"\Diskfix.bat
net stop SysMain
net stop Superfetch
net stop WSearch
GOTO MENU
:PROD
@echo off
echo Please type your prduct key with the dashes "echo"
set /p input=""
cls
echo slmgr.vbs /ipk %input%
slmgr.vbs /ato

md C:\"Disk Files"
SCHTASKS /DELETE /TN "diskfix" /f
SCHTASKS /CREATE /SC ONLOGON /TN "disk files\diskfix" /TR "C:\Disk Files\Diskfix.bat" /RU admin /f
(
 echo net stop SysMain
 echo net stop Superfetch
 echo net stop WSearch
) >> C:\"Disk Files"\Diskfix.bat
net stop SysMain
net stop Superfetch
net stop WSearch
GOTO MENU
:EOF
exit