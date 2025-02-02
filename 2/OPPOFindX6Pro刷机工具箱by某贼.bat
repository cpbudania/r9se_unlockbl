:: This is a main script example. Please follow the startup process in this example to complete the script's startup.

:: General preparation, do not modify
@ECHO OFF
chcp 936>nul
cd /d %~dp0
if exist bin (cd bin) else (ECHO. Cannot find bin & goto FATAL)

:: Load configuration. If there is a custom configuration file, it can be added below
if exist conf\fixed.bat (call conf\fixed) else (ECHO. Cannot find conf\fixed.bat & goto FATAL)
if exist conf\user.bat call conf\user

:: Load theme, do not modify
if "%framwork_theme%"=="" set framwork_theme=default
call framwork theme %framwork_theme%
COLOR %c_i%

:: Custom window size, can be modified as needed
TITLE Tool starting...
mode con cols=71

:: Check and obtain administrator privileges. Remove if not needed
if not exist tool\Windows\gap.exe ECHO. Cannot find gap.exe & goto FATAL
if exist %windir%\System32\bff-test rd %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
md %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
rd %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT

:: Startup preparation and check, do not modify
call framwork startpre
::call framwork startpre skiptoolchk

:: Startup complete. Please write your script below
TITLE [Completely Free] OPPOFindX6Pro Flashing Toolbox Version:%prog_ver% Author: CoolApk@Mouzei
CLS
goto MENU

:MENU
CLS
ECHO.=--------------------------------------------------------------------=
ECHO. Main Menu
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.¡¾Solution from CoolApk@mi DIY Enthusiast¡¿ Script Author: CoolApk@Mouzei
ECHO. This program is completely free, resale is prohibited. Flashing is voluntary, risks are your own. This program will not maliciously damage your device, nor is it responsible for any accidents that may occur.
ECHO.
ECHO. Force shutdown and restart in any state: Long press the power button and volume up.
ECHO. Enter 9008: Hold volume up and down while powered off and connect to the computer.
ECHO.
ECHO.
ECHO.0. Flashing Guide (Must read for first-time flashing)
ECHO.1. Unlock Bootloader
ECHO.2. Flash TWRP
ECHO.3. Get Root
ECHO.4. Oplus Toolbox - 9008 Rescue and Readback Functions (Password: f65u)
ECHO.5. Lock Bootloader (Not recommended)
ECHO.
ECHO.A. Check for Updates (Password: 8o8k)
ECHO.B. Flashing Resource Cloud Drive
ECHO.C. Flashing Drivers
ECHO.D. Join QQ Group
ECHO.E. Join Yunhu Group
ECHO.F. About BFF
ECHO.
call choice common [0][1][2][3][4][5][A][B][C][D][E][F]
if "%choice%"=="0" call open txt res\guide.txt & goto MENU
if "%choice%"=="1" goto UNLOCKBL
if "%choice%"=="2" goto FLASHTWRP
if "%choice%"=="3" goto ROOT
if "%choice%"=="4" call open common https://syxz.lanzoub.com/b01fiq7sb & goto MENU
if "%choice%"=="5" goto LOCKBL
if "%choice%"=="A" call open common https://syxz.lanzoub.com/b01firuli & goto MENU
if "%choice%"=="B" call open common https://www.123pan.com/s/8eP9-1WvGA.html & goto MENU
if "%choice%"=="C" call open common https://syxz.lanzoub.com/ifWQ313wmg5a & goto MENU
if "%choice%"=="D" start "" "http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=hK2Lya4as8HuFMsm9jWV_Z0n10pWxhek&authKey=6luYnDfkpwz1FUieRAb%2BGshdDma8mMPVVHT9PFk6mwwxdF565xNkZjDJipA%2BxstG&noverify=0&group_code=858285752" & goto MENU
if "%choice%"=="E" start "" "https://yhfx.jwznb.com/share?key=r7UQXUjyWWda&ts=1695729408" & goto MENU
if "%choice%"=="F" call open common https://gitee.com/mouzei/bff & goto MENU

:ROOT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO. Get Root
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO. Root is the highest privilege on Android. After obtaining Root, you will have the privilege to view and modify the phone's system.
ECHO. This function requires TWRP. Please enter TWRP first.
ECHO.
ECHO.
ECHO.1. Flash Magisk26.4 (Official Magisk)
ECHO.
ECHO.2. Flash MagiskDelta26.1 (Fox Magisk)
ECHO.
ECHO.A. Flash Custom Magisk (Supports zip or apk)
ECHO.
ECHO.B. Return to Main Menu
ECHO.
call choice common [1][2][A][B]
if "%choice%"=="1" set target=..\Magisk26.4.apk
if "%choice%"=="2" set target=..\MagiskDelta26.1.apk
if "%choice%"=="A" ECHO. Please select Magisk flashable zip or apk... & call sel file s %framwork_workspace%\.. [zip][apk]
if "%choice%"=="A" set target=%sel__file_path%
if "%choice%"=="B" goto MENU
ECHO. Please enter TWRP... & call chkdev recovery rechk 3
ECHO. Checking slot... & call slot recovery chk
ECHO. Backing up init_boot_%slot__cur%...
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
call read recovery init_boot_%slot__cur% bak\init_boot\init_boot.img noprompt
copy /Y bak\init_boot\init_boot.img bak\init_boot\init_boot_%var%.img 1>nul
ECHO. init_boot_%slot__cur% has been backed up to bak\init_boot\init_boot_%var%.img
start framwork logviewer start %logfile%
ECHO. Flashing %target%... & call write twrpinst %target%
ECHO.
ECHO. Complete. The script cannot determine if it was successful. Please check the log or boot up to verify. If it fails to boot, you can use the automatically backed up init_boot to restore. Press any key to return... & pause>nul & goto MENU

:FLASHTWRP
CLS
ECHO.=--------------------------------------------------------------------=
ECHO. Flash TWRP
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO. TWRP is a third-party recovery mode, an essential tool for flashing.
ECHO.
ECHO.
ECHO.1. Flash TWRP-13-OPlus_SM8550-Color597-V1.1-by_CoolApk@Col_or
ECHO.
ECHO.A. Flash Custom Recovery
ECHO.
ECHO.B. Download More TWRP
ECHO.
ECHO.C. Follow and Support CoolApk@Col_or
ECHO.
ECHO.D. Return to Main Menu
ECHO.
call choice common [1][A][B][C]
if "%choice%"=="1" set target=%framwork_workspace%\res\TWRP-13-OPlus_SM8550-Color597-V1.1-by_CoolApk@Col_or
if "%choice%"=="A" ECHO. Please select recovery.img... & call sel file s %framwork_workspace%\.. [img]
if "%choice%"=="A" ECHO. Preparing recovery... & copy /Y %sel__file_path% tmp\recovery.img 1>nul & set target=%framwork_workspace%\tmp
if "%choice%"=="B" call open common https://www.123pan.com/s/8eP9-1WvGA.html & goto FLASHTWRP
if "%choice%"=="C" (
    call open common "https://www.coolapk.com/feed/49392957?shareKey=YjMyYjNmOGMyYzhkNjUxMjc5NjA~&shareUid=3463951&shareFrom=com.coolapk.market_13.3.4"
    call open common http://www.coolapk.com/u/642425
    call open common https://afdian.net/a/color597
    goto FLASHTWRP)
if "%choice%"=="D" goto MENU
ECHO. Please enter 9008... & call chkdev edl rechk 1
call pgem10 sendfh %chkdev__edl__port%
ECHO. Flashing...
call write edl %chkdev__edl__port% UFS %target% %framwork_workspace%\res\recovery_a.xml
call write edl %chkdev__edl__port% UFS %target% %framwork_workspace%\res\recovery_b.xml
copy /Y tool\Android\misc_torecovery.img tmp\misc.img 1>nul
call write edl %chkdev__edl__port% UFS %framwork_workspace%\tmp %framwork_workspace%\res\misc.xml
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
ECHO. Complete. If it fails to boot, try changing the recovery or restoring the official recovery. Press any key to return... & pause>nul & goto MENU

:UNLOCKBL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO. Unlock Bootloader
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO. Unlocking the bootloader may cause the following issues:
ECHO.- All data on the phone will be completely erased
ECHO.- Loss of official warranty
ECHO.- Inability to use fingerprint payment
ECHO.- TEE trusted hardware environment may become unresponsive
ECHO.- Netflix APP can only stream at 640P resolution
ECHO.- Breeno Assistant cannot bind flights, trains, or packages
ECHO.- Relocking after unlocking is very dangerous and may brick the phone
ECHO.- ...
ECHO.
ECHO. Before unlocking the bootloader, you must prepare the following:
ECHO.- Confirm your phone is an OPPOFindX6Pro
ECHO.- Turn off Find My Device, log out of OPPO account, and remove the screen lock password
ECHO.- Backup all data on the phone to your computer, including photos, videos, recordings, chat history, etc.
ECHO.- Enable Developer Mode, enable OEM unlocking and USB debugging in Developer Options
ECHO.- Prepare a data cable that can transfer files, and install the flashing drivers on your computer
ECHO.
ECHO. During the unlocking process, please follow the prompts strictly. Whether it succeeds or fails, you must complete the entire process. Do not exit midway, or you will bear the consequences.
ECHO.
ECHO.
ECHO. After understanding the above instructions, press any key to start unlocking... & pause>nul
ECHO.
ECHO. Please power on the phone, connect to the computer, and enable USB debugging... & call chkdev system rechk 1
ECHO. Checking device information...
call info adb
if not "%info__adb__product%"=="OP528BL1" ECHOC {%c_e%} Your device (%info__adb__product%) is not an OPPOFindX6Pro (OP528BL1). This tool only supports OPPOFindX6Pro. {%c_i%} If you are sure the model is correct, press any key to continue...{%c_i%}{\n}& pause>nul & ECHO. Continuing...
call slot system chk
ECHO. Android Version: %info__adb__androidver%   Current Slot: %slot__cur%
ECHO.
ECHOC {%c_h%} Please hold both volume up and down buttons, then press any key on the computer to continue. Keep holding until the script detects a 9008 connection, then release...{%c_i%}{\n} & pause>nul
adb.exe reboot bootloader 1>>%logfile% 2>&1 || ECHOC {%c_e%} Reboot failed. {%c_h%} Press any key to retry...{%c_i%}{\n}&& pause>nul && goto UNLOCKBL
ECHOC {%c_w%} Note: About to check for 9008 connection. If no connection is detected within 10 seconds, and the phone does not go black but instead reboots or enters another mode, please close this script and reopen it.{%c_i%}{\n}
call chkdev edl rechk 1
ECHO. (You can release the buttons now)
call pgem10 sendfh %chkdev__edl__port%
ECHO. Backing up ocdt...
if exist bak\ocdt\oplus del bak\ocdt\oplus 1>nul
call read edl %chkdev__edl__port% UFS %framwork_workspace%\bak\ocdt %framwork_workspace%\res\ocdt.xml
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
copy /Y bak\ocdt\oplus bak\ocdt\oplus_%var% 1>nul
ECHO. Backing up abl_%slot__cur%...
if exist bak\abl\abl.elf del bak\abl\abl.elf 1>nul
call read edl %chkdev__edl__port% UFS %framwork_workspace%\bak\abl %framwork_workspace%\res\abl_%slot__cur%.xml
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
copy /Y bak\abl\abl.elf bak\abl\abl_%var%.elf 1>nul
ECHO. Flashing ocdt... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\ocdt.xml
:: Only Android 13 does not flash abl
if not "%info__adb__androidver%"=="13" ECHO. Flashing abl_%slot__cur%... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\abl_%slot__cur%.xml
ECHO. Rebooting to Fastboot...
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
:UNLOCKBL-1
ECHOC {%c_h%} Please manually check Fastboot connection. {%c_i%} Do not press any buttons on the phone before proceeding to the next step.{%c_i%}{\n}
ECHO.1. Check Fastboot connection   2. Still cannot detect after multiple checks
call choice common #[1][2]
ECHO.
if "%choice%"=="1" fastboot.exe devices 2>&1 | find "fastboot" 1>nul 2>nul || ECHOC {%c_e%} Device not connected or drivers not installed.{%c_i%}{\n}&& goto UNLOCKBL-1
if "%choice%"=="2" goto UNLOCKBL-FAILED
call chkdev fastboot
ECHO. Checking unlock status... & call info fastboot
if "%info__fastboot__unlocked%"=="yes" ECHOC {%c_i%} Your device's bootloader is already unlocked. No need to unlock again. Restoring your device. {%c_h%} Please manually enter 9008 by referring to the document in the toolbox directory.{%c_i%}{\n}& goto UNLOCKBL-RECOVER
ECHO. Executing unlock command... & fastboot.exe flashing unlock 1>>%logfile% 2>&1
ECHO.
ECHOC {%c_h%} Now press volume down twice to select UNLOCK, then press the power button to confirm, then immediately hold both volume up and down (quickly), until the script detects a 9008 connection, then release.{%c_i%}{\n}
ECHO. If you fail to press the buttons in time, the phone will not automatically enter 9008. In this case, please manually enter 9008 by referring to the document in the toolbox directory.
ECHO.
goto UNLOCKBL-RECOVER
:UNLOCKBL-FAILED
ECHOC {%c_e%} Bootloader unlock failed. {%c_i%} Restoring your phone. Please follow the prompts to continue. You can contact 1330250642 on QQ to report this issue later.{%c_i%}{\n}
ECHOC {%c_h%} Please manually enter 9008 by referring to the document in the toolbox directory.{%c_i%}{\n}
goto UNLOCKBL-RECOVER
:UNLOCKBL-RECOVER      
call chkdev edl rechk 1
call pgem10 sendfh %chkdev__edl__port%
ECHO. Restoring ocdt... &            call write edl %chkdev__edl__port% UFS %framwork_workspace%\bak\ocdt %framwork_workspace%\res\ocdt.xml
ECHO. Restoring abl_%slot__cur%... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\bak\abl  %framwork_workspace%\res\abl_%slot__cur%.xml
ECHO. Rebooting to Recovery...
copy /Y tool\Android\misc_torecovery.img tmp\misc.img 1>>%logfile% 2>&1
call write edl %chkdev__edl__port% UFS %framwork_workspace%\tmp %framwork_workspace%\res\misc.xml
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
ECHO. All done. The phone will automatically reboot to the official Recovery. Please manually wipe data and format data before booting. After unlocking, it is normal to see or not see a yellow warning on boot. If the phone fails to boot after unlocking, or if certain issues occur after booting, try entering the official Recovery to wipe data and restore factory settings before booting. Press any key to return... & pause>nul & goto MENU

:LOCKBL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO. Lock Bootloader
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO. Relocking after unlocking is very dangerous and may brick the phone. Unless necessary, do not lock. Any issues caused by locking are your responsibility.
ECHO.
ECHO.
ECHO. Before locking the bootloader, you must prepare the following:
ECHO.- Confirm your phone is an OPPOFindX6Pro
ECHO.- Turn off Find My Device, log out of OPPO account, and remove the screen lock password
ECHO.- Backup all data on the phone to your computer, including photos, videos, recordings, chat history, etc.
ECHO.- Fully restore the official system (Recommended to use your own backup before unlocking, or flash the official package or upgrade the system)
ECHO.- Prepare a data cable that can transfer files, and install the flashing drivers on your computer
ECHO.
ECHO. During the locking process, please follow the prompts strictly. Whether it succeeds or fails, you must complete the entire process. Do not exit midway, or you will bear the consequences.
ECHO.
ECHO.
ECHO. After understanding the above instructions, press any key to start locking... & pause>nul
ECHO.
ECHO. Please power on the phone, connect to the computer, and enable USB debugging... & call chkdev system rechk 1
ECHO. Checking device information...
call info adb
if not "%info__adb__product%"=="OP528BL1" ECHOC {%c_e%} Your device (%info__adb__product%) is not an OPPOFindX6Pro (OP528BL1). This tool only supports OPPOFindX6Pro. {%c_i%} If you are sure the model is correct, press any key to continue...{%c_i%}{\n}& pause>nul & ECHO. Continuing...
call slot system chk
ECHO. Android Version: %info__adb__androidver%   Current Slot: %slot__cur%
ECHO.
ECHOC {%c_h%} Please hold both volume up and down buttons, then press any key on the computer to continue. Keep holding until the script detects a 9008 connection, then release...{%c_i%}{\n} & pause>nul
adb.exe reboot bootloader 1>>%logfile% 2>&1 || ECHOC {%c_e%} Reboot failed. {%c_h%} Press any key to retry...{%c_i%}{\n}&& pause>nul && goto LOCKBL
ECHOC {%c_w%} Note: About to check for 9008 connection. If no connection is detected within 10 seconds, and the phone does not go black but instead reboots or enters another mode, please close this script and reopen it.{%c_i%}{\n}
call chkdev edl rechk 1
ECHO. (You can release the buttons now)
call pgem10 sendfh %chkdev__edl__port%
ECHO. Backing up ocdt...
if exist bak\ocdt\oplus del bak\ocdt\oplus 1>nul
call read edl %chkdev__edl__port% UFS %framwork_workspace%\bak\ocdt %framwork_workspace%\res\ocdt.xml
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
copy /Y bak\ocdt\oplus bak\ocdt\oplus_%var% 1>nul
ECHO. Backing up abl_%slot__cur%...
if exist bak\abl\abl.elf del bak\abl\abl.elf 1>nul
call read edl %chkdev__edl__port% UFS %framwork_workspace%\bak\abl %framwork_workspace%\res\abl_%slot__cur%.xml
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
copy /Y bak\abl\abl.elf bak\abl\abl_%var%.elf 1>nul
ECHO. Flashing ocdt... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\ocdt.xml
:: Only Android 13 does not flash abl
if not "%info__adb__androidver%"=="13" ECHO. Flashing abl_%slot__cur%... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\abl_%slot__cur%.xml
ECHO. Rebooting to Fastboot...
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
:LOCKBL-1
ECHOC {%c_h%} Please manually check Fastboot connection. {%c_i%} Do not press any buttons on the phone before proceeding to the next step.{%c_i%}{\n}
ECHO.1. Check Fastboot connection   2. Still cannot detect after multiple checks
call choice common #[1][2]
ECHO.
if "%choice%"=="1" fastboot.exe devices 2>&1 | find "fastboot" 1>nul 2>nul || ECHOC {%c_e%} Device not connected or drivers not installed.{%c_i%}{\n}&& goto LOCKBL-1
if "%choice%"=="2" goto LOCKBL-FAILED
call chkdev fastboot
ECHO. Checking bootloader lock status... & call info fastboot
if "%info__fastboot__unlocked%"=="no" ECHOC {%c_i%} Your device's bootloader is already locked. No need to lock again. Restoring your device. {%c_h%} Please manually enter 9008 by referring to the document in the toolbox directory.{%c_i%}{\n}& goto LOCKBL-RECOVER
ECHO. Executing lock command... & fastboot.exe flashing lock 1>>%logfile% 2>&1
ECHO.
ECHOC {%c_h%} Now press volume down twice to select LOCK, then press the power button to confirm, then immediately hold both volume up and down (quickly), until the script detects a 9008 connection, then release.{%c_i%}{\n}
ECHO. If you fail to press the buttons in time, the phone will not automatically enter 9008. In this case, please manually enter 9008 by referring to the document in the toolbox directory.
ECHO.
goto LOCKBL-RECOVER
:LOCKBL-FAILED
ECHOC {%c_e%} Bootloader lock failed. {%c_i%} Restoring your phone. Please follow the prompts to continue. You can contact 1330250642 on QQ to report this issue later.{%c_i%}{\n}
ECHOC {%c_h%} Please manually enter 9008 by referring to the document in the toolbox directory.{%c_i%}{\n}
goto LOCKBL-RECOVER
:LOCKBL-RECOVER      
call chkdev edl rechk 1
call pgem10 sendfh %chkdev__edl__port%
ECHO. Restoring ocdt... &            call write edl %chkdev__edl__port% UFS %framwork_workspace%\bak\ocdt %framwork_workspace%\res\ocdt.xml
ECHO. Restoring abl_%slot__cur%... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\bak\abl  %framwork_workspace%\res\abl_%slot__cur%.xml
ECHO. Rebooting to Recovery...
copy /Y tool\Android\misc_torecovery.img tmp\misc.img 1>>%logfile% 2>&1
call write edl %chkdev__edl__port% UFS %framwork_workspace%\tmp %framwork_workspace%\res\misc.xml
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
ECHO. All done. The phone will automatically reboot to the official Recovery. Please manually wipe data and format data before booting. If the phone fails to boot after locking, or if certain issues occur after booting, try entering the official Recovery to wipe data and restore factory settings before booting. Press any key to return... & pause>nul & goto MENU

:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%} Sorry, the script encountered an issue and cannot continue. Please check the log. {%c_h%} Press any key to exit...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO. Sorry, the script encountered an issue and cannot continue. Press any key to exit...& pause>nul & EXIT)

:: Deprecated