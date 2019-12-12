@echo off
REM ----- GIVE THIS CONSOLE WINDOW TITLE A UNIQUE STRING ID
title OPEN-2-EXPLORER-WINDOWS-SIDE-BY-SIDE-AND-CENTERED-ON-SCREEN-AT-MONITOR-2-OF-A-MULTI-MONITOR-DESKTOP___20140101024519
pushd %~dp0

REM ----- HIDE THIS CONSOLE WINDOW (HOOKS THE WINDOW TITLE)
nircmd.exe win hide ititle "OPEN-2-EXPLORER-WINDOWS-SIDE-BY-SIDE-AND-CENTERED-ON-SCREEN-AT-MONITOR-2-OF-A-MULTI-MONITOR-DESKTOP___20140101024519"

REM ********************** DESCRIPTION ************************************
REM ** This script opens one or more windows with specified screen properties
REM ** at a chosen monitor of a multi-monitor desktop. The "X/Y position" and
REM ** "W/H size" of the windows are auto-set by this script and the monitor
REM ** resolutions are auto-calculated to suit. 
REM ** 'MonitorInfoView.exe' is the helper tool used to isolate the resolution
REM ** info of the primary monitor (containing the taskbar).
REM ** 'MultiMonitorTool.exe' is the helper tool used to capture the 
REM ** resolution info of all monitors and for isolating the resolution info
REM ** of the other (non-primary) monitor.
REM ** 'nircmd.exe' is the tool performing all the display trickery.
REM **
REM ** To tweak this script, go to the code section named:
REM ** >>>>> USER INPUT/PREFERENCES ARE ALL SET HERE <<<<<
REM ***********************************************************************

REM ----- CLEAR ANY PREVIOUS JOB OUTPUTS IF THEY EXIST
if exist ~TMP.TXT type NUL > ~TMP.TXT
if exist ~TMP2.TXT type NUL > ~TMP2.TXT

REM ----- OUTPUT THE PRIMARY MONITOR (MONITOR-1) INFORMATION TO A TEXT FILE
MonitorInfoView.exe /hideinactivemonitors 1 /stext ~TMP.TXT

REM ----- ISOLATE THE RESOLUTION LINE OF MONITOR-1, REMOVING ALL THE OTHER LINES IN THE TEXT FILE
for /f "delims=" %%A in ('type "~TMP.TXT" ^|find.exe /i "Maximum Resolution"') do echo %%A>~TMP.TXT

REM ----- GET THE RESOLUTION NUMBERS OF MONITOR-1, AND SET THEM AS VARIABLES
for /f "tokens=3,4 delims=:X " %%A in ('type "~TMP.TXT"') do (
set _M1_SCREENW_=%%A
set _M1_SCREENH_=%%B
)

REM ----- OUTPUT INFO OF ALL MONITORS TO TEXT FILE
MultiMonitorTool.exe /stext ~TMP.TXT

REM ----- TRY REMOVING MONITOR-1 RESOLUTION LINE (KEEPING MONITOR-2 RESOLUTION LINE)
find.exe /i /v "%_M1_SCREENW_% X %_M1_SCREENH_%" < ~TMP.TXT > ~TMP2.TXT

REM ----- TRY ISOLATING MONITOR-2 RESOLUTION LINE (REMOVING ALL THE OTHER LINES IN THE TEXT FILE)
for /f "delims=" %%A in ('type "~TMP2.TXT" ^|find.exe /i "Maximum Resolution"') do echo %%A>~TMP2.TXT

REM ----- CONDITIONALLY GET THE RESOLUTION NUMBERS OF MONITOR-2, AND SET THEM AS VARIABLES ...
REM ----- CASE(A): IF MONITORS HAVE SAME RESOLUTION, ASSUME NO LINES HAVE STRING "Maximum Resolution". 
REM ----- CASE(B): IF MONITORS HAVE DIFFERENT RESOLUTION, ASSUME ONE LINE HAS STRING "Maximum Resolution".
find.exe /i /c "Maximum Resolution" ~TMP2.TXT
if %ERRORLEVEL% equ 1 (
set _M2_SCREENW_=%_M1_SCREENW_%&set _M2_SCREENH_=%_M1_SCREENH_%
) else (
for /f "tokens=3,4 delims=:X " %%A in ('type "~TMP2.TXT"') do set _M2_SCREENW_=%%A&set _M2_SCREENH_=%%B
)    


REM >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
REM >>>>>>>>>> USER INPUT/PREFERENCES ARE ALL SET HERE [BEGIN] <<<<<<<<<<<<

REM ----- MONITOR-2 LEFT WINDOW PROPERTIES

    set _M2_WINLEFT_=%SYSTEMDRIVE%
    set /a _M2_WINLEFTW_=(%_M2_SCREENW_% / 3) + 50
    set /a _M2_WINLEFTH_=(%_M2_SCREENH_% / 2) + 200
    set /a _M2_WINLEFTX_=(%_M1_SCREENW_%) + (%_M2_SCREENW_% - %_M2_WINLEFTW_%) / 5
    set /a _M2_WINLEFTY_=(%_M2_SCREENH_% - %_M2_WINLEFTH_%) / 2

REM ----- MONITOR-2 RIGHT WINDOW PROPERTIES

    set _M2_WINRIGHT_=%USERPROFILE%
    set /a _M2_WINRIGHTW_=(%_M2_SCREENW_% / 3) + 50
    set /a _M2_WINRIGHTH_=(%_M2_SCREENH_% / 2) + 200
    set /a _M2_WINRIGHTX_=(%_M2_WINLEFTX_%) + (%_M2_WINLEFTW_%)
    set /a _M2_WINRIGHTY_=(%_M2_SCREENH_% - %_M2_WINRIGHTH_%) / 2

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
nircmd.exe exec show "explorer.exe" /n,%_M2_WINLEFT_%
nircmd.exe wait %_WAITTIME_%
nircmd.exe win setsize foreground %_M2_WINLEFTX_% %_M2_WINLEFTY_% %_M2_WINLEFTW_% %_M2_WINLEFTH_%
nircmd.exe wait %_WAITTIME_%
nircmd.exe exec show "explorer.exe" /n,%_M2_WINRIGHT_%
nircmd.exe wait %_WAITTIME_%
nircmd.exe win setsize foreground %_M2_WINRIGHTX_% %_M2_WINRIGHTY_% %_M2_WINRIGHTW_% %_M2_WINRIGHTH_%

 
REM ----- RESET SYSTEM PREF, CLEAR MEMORY, CLEANUP, QUIT . . .

find.exe /i /c "%_EXPLORER_VIEW_REGVAL_%" ~TMP.TXT
if %ERRORLEVEL% equ 1 goto SKIP2
nircmd.exe wait %_WAITTIME_%
nircmd.exe wait %_WAITTIME_%
reg.exe add %_EXPLORER_VIEW_REGKEY_% /v %_EXPLORER_VIEW_REGVAL_% /t REG_BINARY /d %_EXPLORER_VIEW_SYSTEMPREF_% /f 2>nul >nul
:SKIP2
set _M1_SCREENW_=
set _M1_SCREENH_=
set _M2_SCREENW_=
set _M2_SCREENH_=
set _M2_WINLEFT_=
set _M2_WINLEFTX_=
set _M2_WINLEFTY_=
set _M2_WINLEFTW_=
set _M2_WINLEFTH_=
set _M2_WINRIGHT_=
set _M2_WINRIGHTX_=
set _M2_WINRIGHTY_=
set _M2_WINRIGHTW_=
set _M2_WINRIGHTH_=
set _WAITTIME_=
set _THIS_OS_VERSTRING_=
set _THIS_OS_MAJORVERSION_=
set _EXPLORER_VIEW_REGKEY_=
set _EXPLORER_VIEW_REGVAL_=
set _EXPLORER_VIEW_MYPREF_=
set _EXPLORER_VIEW_SYSTEMPREF_=
del /f /q ~TMP.TXT
del /f /q ~TMP2.TXT
popd

rem pause 
rem exit