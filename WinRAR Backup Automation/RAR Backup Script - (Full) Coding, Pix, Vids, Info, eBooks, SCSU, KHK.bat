@echo off
echo "Beginning Full Backup of Ryan Docs HDD"

"C:\Program Files\WinRar\rar.exe" a -rr5p -v4G -ac -ag+B_YYYY.MM.DD -k -m4 -ri4 -r -s -msMov;Avi;Mp4:Mpeg;Jpeg;Jpg;Png;Mp3;Rar;Zip;7z;Cab;Gz;Taz "H:\B_Script [R.Shaughnessy] - Coding\ (full) [Shaughnessy] Coding" "@RAR Backup Script - Coding.txt"
IF NOT %ERRORLEVEL% == 0 GOTO Failed_Backup

"C:\Program Files\WinRar\rar.exe" a -rr5p -v4G -ac -ag+B_YYYY.MM.DD -k -m0 -ri4 -r   "H:\B_Script [R.Shaughnessy] - Pictures\ (full) [Shaughnessy] Pictures" "@RAR Backup Script - Pictures.txt"
IF NOT %ERRORLEVEL% == 0 GOTO Failed_Backup

"C:\Program Files\WinRar\rar.exe" a -rr5p -v4G -ac -ag+B_YYYY.MM.DD -k -m1 -ri4 -r    -msMov;Avi;Mp4:Mpeg;Jpeg;Jpg;Png;Mp3;Rar;Zip;7z;Cab;Gz;Taz "H:\B_Script [R.Shaughnessy] - Videos\ (full) [Shaughnessy] Videos" "@RAR Backup Script - Videos.txt"
IF NOT %ERRORLEVEL% == 0 GOTO Failed_Backup

"C:\Program Files\WinRar\rar.exe" a -rr5p -v4G -ac -ag+B_YYYY.MM.DD -k -m3 -ri4 -r -s -ms "H:\B_Script [R.Shaughnessy] - Info\ (full) [Shaughnessy] Info" "@RAR Backup Script - Info.txt"
IF NOT %ERRORLEVEL% == 0 GOTO Failed_Backup

"C:\Program Files\WinRar\rar.exe" a -rr5p -v4G -ac -ag+B_YYYY.MM.DD -k -m3 -ri4 -r -s -ms "H:\B_Script [R.Shaughnessy] - eBooks\ (full) [Shaughnessy] eBooks" "@RAR Backup Script - eBooks.txt"
IF NOT %ERRORLEVEL% == 0 GOTO Failed_Backup

"C:\Program Files\WinRar\rar.exe" a -rr5p -v4G -ac -ag+B_YYYY.MM.DD -k -m3 -ri4 -r -s -ms "H:\B_Script [R.Shaughnessy] - KHK\ (full) [Shaughnessy] KHK" "@RAR Backup Script - KHK.txt"
IF NOT %ERRORLEVEL% == 0 GOTO Failed_Backup

GOTO End


:Failed_Backup
	echo "Cannot Save Full Backup Routine"
	echo "Ext Backup HDD Disconnected Parhaps?" 
        GOTO End


:End
pause