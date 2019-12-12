Run, calc.exe
WinWait, Calculator
WinMove, 0, 0 ; Move the window found by WinWait to the upper-left corner of the screen.

SplashTextOn, 400, 300, Clipboard, The clipboard contains:`n%clipboard%
WinMove, Clipboard, , 0, 0 ; Move the splash window to the top left corner.
Msgbox, Press OK to dismiss the SplashText
SplashTextOff

; The following function centers the specified window on the screen:
CenterWindow(WinTitle)
{
    WinGetPos,,, Width, Height, %WinTitle%
    WinMove, %WinTitle%,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
}