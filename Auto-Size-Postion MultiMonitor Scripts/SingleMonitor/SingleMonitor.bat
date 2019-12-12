@echo off
REM ----- GIVE THIS CONSOLE WINDOW TITLE A UNIQUE STRING ID
title OPEN-2-EXPLORER-WINDOWS-SIDE-BY-SIDE-AND-CENTERED-ON-SCREEN-AT-THE-PRIMARY-MONITOR___20131209084355
pushd %~dp0

REM ----- HIDE THIS CONSOLE WINDOW (HOOKS THE WINDOW TITLE)
nircmd.exe win hide ititle "OPEN-2-EXPLORER-WINDOWS-SIDE-BY-SIDE-AND-CENTERED-ON-SCREEN-AT-THE-PRIMARY-MONITOR___20131209084355"

REM ********************** DESCRIPTION ************************************
REM ** This script opens one or more windows with specified screen properties
REM ** at the primary monitor (containing the taskbar). The "X/Y position" and
REM ** "W/H size" of the windows are auto-set by this script and the monitor
REM ** resolution is auto-calculated to suit.
REM ** 'MonitorInfoView.exe' is the helper tool used to capture the resolution
REM ** info of the monitor. 
REM ** 'nircmd.exe' is the tool performing all the display trickery.
REM **
REM ** To tweak this script, go to the code section named:
REM ** >>>>> USER INPUT/PREFERENCES ARE ALL SET HERE <<<<<
REM ***********************************************************************

REM ----- CLEAR ANY PREVIOUS JOB OUTPUTS IF THEY EXIST
if exist ~TMP.TXT type NUL > ~TMP.TXT

REM ----- OUTPUT THE PRIMARY MONITOR INFORMATION TO A TEXT FILE
MonitorInfoView.exe /hideinactivemonitors 1 /stext ~TMP.TXT

REM ----- ISOLATE THE RESOLUTION LINE, REMOVING ALL THE OTHER LINES IN THE TEXT FILE
for /f "delims=" %%A in ('type "~TMP.TXT" ^|find.exe /i "Maximum Resolution"') do echo %%A>~TMP.TXT

REM ----- GET THE RESOLUTION NUMBERS, AND SET THEM AS VARIABLES
for /f "tokens=3,4 delims=:X " %%A in ('type "~TMP.TXT"') do set _SCREENW_=%%A& set _SCREENH_=%%B


REM >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
REM >>>>>>>>>> USER INPUT/PREFERENCES ARE ALL SET HERE [BEGIN] <<<<<<<<<<<<

REM ----- LEFT WINDOW PROPERTIES

    set _WINLEFT_=%SYSTEMDRIVE%
    set /a _WINLEFTW_=(%_SCREENW_% / 3) + 50
    set /a _WINLEFTH_=(%_SCREENH_% / 2) + 200
    set /a _WINLEFTX_=(%_SCREENW_% - %_WINLEFTW_%) / 5
    set /a _WINLEFTY_=(%_SCREENH_% - %_WINLEFTH_%) / 2

REM ----- RIGHT WINDOW PROPERTIES

    set _WINRIGHT_=%USERPROFILE%
    set /a _WINRIGHTW_=(%_SCREENW_% / 3) + 50
    set /a _WINRIGHTH_=(%_SCREENH_% / 2) + 200
    set /a _WINRIGHTX_=(%_WINLEFTX_%) + (%_WINLEFTW_%)
    set /a _WINRIGHTY_=(%_SCREENH_% - %_WINRIGHTH_%) / 2

REM ----- ADJUST THE WAIT TIME (MILLISECONDS) BETWEEN EACH WINDOW LAUNCH.
REM ----- IF TOO QUICK, THE FOLLOWING WINDOW WILL NOT SET IN THE CORRECT SCREEN POSITION.
REM ----- | FOR FAST SYSTEM: TRY 200 | NORMAL SYSTEM: TRY 400-600 | BLOATED SYSTEM: TRY 800-1200+

    set _WAITTIME_=400

REM ----- ON WINDOWS NT5 (XP, 2000), RUNNING EXPLORER WITH THE 'N' SWITCH WOULD RELIABLY GIVE
REM ----- YOU 1-PANE VIEW (HIDDEN LEFT NAV PANE). ALSO, SHOWING/HIDING OF THE LEFT NAV PANE WAS
REM ----- INSTANTLY TOGGLED BY AN ICON ON THE EXPLORER GUI TOOLBAR.
REM ----- ON WINDOWS NT6 (VISTA, 7), EXPLORER WILL NOT OBEY YOUR COMMANDS AT ALL TIMES AND IT
REM ----- IS A "PITA" TO CONTROL THE GRAPHIC USER INTERFACE. 
REM ----- THIS INPUT SECTION IS A WORKAROUND TO FORCE AN INSTANCE OF NT6 EXPLORER TO BE
REM ----- TOGGLED TO A SPECIFIED VIEW.
REM ----- |
REM ----- | INSERT ONE OF THESE VALUES INTO THE VARIABLE _EXPLORER_VIEW_MYPREF_
REM ----- | | FOR EXPLORER 2-PANE VIEW (SHOW LEFT NAVPANE):  150100000100000000000000E5010000
REM ----- | | FOR EXPLORER 1-PANE VIEW (HIDE LEFT NAVPANE):  1501000000000000000000007B020000

    set _EXPLORER_VIEW_MYPREF_=1501000000000000000000007B020000

REM >>>>>>>>>> USER INPUT/PREFERENCES ARE ALL SET HERE [END] <<<<<<<<<<<<<<
REM >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


REM ----- RUN THE TASK . . .

REM ----- REGKEY 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Modules' DOES NOT EXIST IN NT5 OR EARLIER
REM ----- BUT TO ELIMINATE DOUBT WE WILL PERFORM A CONDITIONAL VERSION CHECK
for /f "tokens=2 delims=[]" %%A in ('ver') do set _THIS_OS_VERSTRING_=%%A
set _THIS_OS_VERSTRING_=%_THIS_OS_VERSTRING_:Version =%
for /f "tokens=1,2,3* delims=." %%A in ("%_THIS_OS_VERSTRING_%") do set _THIS_OS_MAJORVERSION_=%%A
if %_THIS_OS_MAJORVERSION_% leq 5 goto SKIP1

set _EXPLORER_VIEW_REGKEY_=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer
set _EXPLORER_VIEW_REGVAL_=PageSpaceControlSizer
if exist ~TMP.TXT type NUL > ~TMP.TXT
reg.exe query %_EXPLORER_VIEW_REGKEY_% > ~TMP.TXT
if %ERRORLEVEL% equ 1 goto SKIP1
for /f "delims=" %%A in ('type "~TMP.TXT" ^|find.exe /i "%_EXPLORER_VIEW_REGVAL_%"') do echo %%A>~TMP.TXT
for /f "tokens=1-3 delims= " %%A in ('type "~TMP.TXT"') do set _EXPLORER_VIEW_SYSTEMPREF_=%%C
reg.exe add %_EXPLORER_VIEW_REGKEY_% /v %_EXPLORER_VIEW_REGVAL_% /t REG_BINARY /d %_EXPLORER_VIEW_MYPREF_% /f 2>nul >nul
nircmd.exe wait %_WAITTIME_%

:SKIP1
nircmd.exe exec show "explorer.exe" /n,%_WINLEFT_%
nircmd.exe wait %_WAITTIME_%
nircmd.exe win setsize foreground %_WINLEFTX_% %_WINLEFTY_% %_WINLEFTW_% %_WINLEFTH_%
nircmd.exe wait %_WAITTIME_%
nircmd.exe exec show "explorer.exe" /n,%_WINRIGHT_%
nircmd.exe wait %_WAITTIME_%
nircmd.exe win setsize foreground %_WINRIGHTX_% %_WINRIGHTY_% %_WINRIGHTW_% %_WINRIGHTH_%

REM ----- RESET SYSTEM PREF, CLEAR MEMORY, CLEANUP, QUIT . . .

find.exe /i /c "%_EXPLORER_VIEW_REGVAL_%" ~TMP.TXT
if %ERRORLEVEL% equ 1 goto SKIP2
nircmd.exe wait %_WAITTIME_%
nircmd.exe wait %_WAITTIME_%
reg.exe add %_EXPLORER_VIEW_REGKEY_% /v %_EXPLORER_VIEW_REGVAL_% /t REG_BINARY /d %_EXPLORER_VIEW_SYSTEMPREF_% /f 2>nul >nul
:SKIP2
set _SCREENW_=
set _SCREENH_=
set _WINLEFTX_=
set _WINLEFTY_=
set _WINLEFTW_=
set _WINLEFTH_=
set _WINRIGHTX_=
set _WINRIGHTY_=
set _WINRIGHTW_=
set _WINRIGHTH_=
set _WAITTIME_=
set _THIS_OS_VERSTRING_=
set _THIS_OS_MAJORVERSION_=
set _EXPLORER_VIEW_REGKEY_=
set _EXPLORER_VIEW_REGVAL_=
set _EXPLORER_VIEW_MYPREF_=
set _EXPLORER_VIEW_SYSTEMPREF_=
del /f /q ~TMP.TXT
popd
exit