#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

 ; Automatic Word Substitution ^_^ 
::btw::by the way                          ; Replaces "btw" with "By the way" as soon as you press an EndChar.
::bc::because
::iirc::if I recall correctly
::vs::visual studio

 ; Media Keys 
+F7::Media_Prev
+F8::Media_Play_Pause
+F9::Media_Next
+F10::Volume_Mute
+F11::Volume_Down
+F12::Volume_Up



Return                                     ; This ends the hotkey. The code below this point will not get triggered.

/*

!: Sends the ALT key. For example, Send This is text!a would send the keys "This is text" and then press ALT+a. Note: !A produces a different effect in some programs than !a. This is because !A presses ALT+SHIFT+A and !a presses ALT+a. If in doubt, use lowercase.

+: Sends the SHIFT key. For example, Send +abC would send the text "AbC", and Send !+a would press ALT+SHIFT+a.

^: Sends the CONTROL (Ctrl) key. For example, Send ^!a would press CTRL+ALT+a, and Send ^{Home} would send CONTROL+HOME. Note: ^A produces a different effect in some programs than ^a. This is because ^A presses CONTROL+SHIFT+A and ^a presses CONTROL+a. If in doubt, use lowercase.

#: Sends the WIN key (the key with the Windows logo) therefore Send #e would hold down the Windows key and then press the letter "e".
The modifiers !+^# affect only the very next key. To send the corresponding modifier key on its own, enclose the key name in braces. To just press (hold down) or release the key, follow the key name with the word "down" or "up" as shown below.

{Up}	Up-arrow key on main keyboard
{Down}	Down-arrow down key on main keyboard
{Left}	Left-arrow key on main keyboard
{Right}	Right-arrow key on main keyboard
{Home}	Home key on main keyboard
{End}	End key on main keyboard
{PgUp}	Page-up key on main keyboard
{PgDn}	Page-down key on main keyboard
{Control} or {Ctrl}	CONTROL (technical info: sends the neutral virtual key but the left scan code)
{LControl} or {LCtrl}	Left CONTROL key (technical info: sends the left virtual key rather than the neutral one)
{RControl} or {RCtrl}	Right CONTROL key
{Control Down} or {Ctrl Down}	Holds the CONTROL key down until {Ctrl Up} is sent. To hold down the left or right key instead, use {RCtrl Down} and {RCtrl Up}.
{LWin}	Left Windows key
{RWin}	Right Windows key
{LWin Down}	Holds the left Windows key down until {LWin Up} is sent
{RWin Down}	Holds the right Windows key down until {RWin Up} is sent

*/