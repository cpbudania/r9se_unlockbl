:: The following script has been modified:
:: framwork.bat

:: This is a main script example. Please follow the startup process in this example to complete the script's startup.

:: General preparation, do not modify
@ECHO OFF
chcp 936>nul
cd /d %~dp0
if exist bin (cd bin) else (ECHO. Cannot find bin & goto FATAL)

:: Load configuration. If there is a custom configuration file, it can be added below
if exist conf\fixed.bat (call conf\fixed) else (ECHO. Cannot find conf\fixed.bat & goto FATAL)
if exist conf\user.bat call conf\user
if not "%product%"=="" (if exist conf\dev-%product%.bat call conf\dev-%product%.bat)

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
::call framwork startpre
call framwork startpre skiptoolchk

:: Startup complete. Please write your script below
TITLE [No Model Selected] Oplus 9008 Tool Version:%prog_ver%
if "%product%"=="" goto SELDEV
if not exist conf\dev-%product%.bat goto SELDEV
if "%chkddr_fh%"=="y" (if "%ddrtype%"=="" goto SELDEV)
if "%chkddr_img%"=="y" (if "%ddrtype%"=="" goto SELDEV)
goto MENU

:MENU
TITLE [%model%] Oplus 9008 Tool Version:%prog_ver% [Free Tool, Resale Prohibited]
CLS
ECHO.=--------------------------------------------------------------------=
ECHO. Main Menu
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.¡¾Solution from CoolApk@mi DIY Enthusiast¡¿ Script Author: CoolApk@Mouzei
ECHO. To enter 9008: Hold volume up and down while powered off and connect to the computer, or enter the official Recovery and tap the version number repeatedly.
ECHO. Force restart: Long press the power button or long press the power button and volume up.
ECHO. If 9008 sending bootloader gets stuck or fails, force restart, re-enter 9008, and retry.
ECHO. 9008 will not lock the bootloader. All readback backup functions do not involve the bootloader unlock status or user data-related partitions.
ECHO.
if "%method%"=="special-token" (if "%flash_pk%"=="" ECHOC {%c_e%} You have not set the flashing key. Some functions may not work properly. Please use the "Input Flashing Key" function first.{%c_i%}{\n})
ECHO. Current model: %model%   If the model is incorrect, please select and change the model first, otherwise, you will bear the consequences.
if "%chkddr_fh%"=="y" ECHO. DDR type: %ddrtype%
ECHO.
ECHO.
ECHO.0. Test sending bootloader
ECHO.1. Flash - Full Package (Flash 9008 package)
ECHO.2. Flash - Full Partition Backup (Restore firmware)
ECHO.3. Flash - Specific Partition
ECHO.4. Erase - Specific Partition
ECHO.A. Readback - Full Package (Create 9008 package)
ECHO.B. Readback - Full Partition Backup (Backup firmware)
ECHO.C. Readback - Specific Partition
ECHO.
ECHO.11. Download 9008 Flash Package
ECHO.22. ADB Screen Mirroring
ECHO.33. Input Flashing Key
if "%chkddr_fh%"=="y" (ECHO.44. Select/Change Model, Change DDR Type) else (ECHO.44. Select/Change Model)
ECHO.55. Check for Updates (Password: f65u)
ECHO.66. Flashing Drivers
ECHO.77. About BFF
ECHO.88. Join Group Chat
ECHO.
call choice common [0][1][2][3][4][A][B][C][11][22][33][44][55][66]#[77][88]
if "%choice%"=="0" goto TESTFH
if "%choice%"=="1" goto WRITE-ALL
if "%choice%"=="2" goto WRITE-FULLBAK
if "%choice%"=="3" goto WRITE-CUSTOM
if "%choice%"=="4" goto ERASE-CUSTOM
if "%choice%"=="A" goto READ-ALL
if "%choice%"=="B" goto READ-FULLBAK
if "%choice%"=="C" goto READ-CUSTOM
if "%choice%"=="11" call open common https://www.123pan.com/s/8eP9-EWvGA.html
if "%choice%"=="22" call scrcpy Oplus 9008 Tool-ADB Screen Mirroring
if "%choice%"=="33" goto INPUTTOKEN
if "%choice%"=="44" goto SELDEV
if "%choice%"=="55" call open common https://syxz.lanzoub.com/b01fiq7sb
if "%choice%"=="66" call open common https://syxz.lanzoub.com/ifWQ313wmg5a
if "%choice%"=="77" call open common https://gitee.com/mouzei/bff
if "%choice%"=="88" start "" "https://yhfx.jwznb.com/share?key=wPyOzElOuJvM&ts=1697018610"
goto MENU

:INPUTTOKEN
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] Input Flashing Key
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
if not "%method%"=="special-token" ECHOC {%c_i%}%model% does not require this function. {%c_h%} Press any key to return to the main menu...{%c_i%}{\n}& pause>nul & goto MENU
ECHO. For some OnePlus models, you need to obtain the flashing key to use the Oplus 9008 tool. Theoretically, each device has a unique key that can be used long-term.
ECHO.
ECHO.
ECHO.1. Manual Input
::ECHO.2. Automatic Retrieval (Not yet implemented)
ECHO.A. How to Manually Capture the Flashing Key (Must-read for Beginners)
ECHO.B. Return to Main Menu
ECHO.
call choice common [1][A][B]
if "%choice%"=="1" goto INPUTTOKEN-INPUT
::if "%choice%"=="2" goto INPUTTOKEN-AUTO
if "%choice%"=="A" call open common https://kdocs.cn/l/cqXtzYpZya0g?f=201 & goto INPUTTOKEN
if "%choice%"=="B" goto MENU
:INPUTTOKEN-AUTO
goto INPUTTOKEN
:INPUTTOKEN-INPUT
if exist tmp\token.bat del tmp\token.bat
ECHO. Please enter the flashing key in the pop-up window... & start /wait opredl_token.exe
if not exist tmp\token.bat ECHOC {%c_e%} The program did not start successfully or was not closed properly. {%c_h%} Press any key to retry...{%c_i%}{\n}& pause>nul & ECHO. Retrying... & goto INPUTTOKEN-INPUT
ECHO. Writing flashing key...
call tmp\token.bat
if not "%demacia_token%"=="" (
        busybox.exe sed -i "s/\"/#/g" res\firehose\special\%product%\demacia.xml
        busybox.exe sed -i "s/ token=#[^#]*#/ token=#%demacia_token%#/g" res\firehose\special\%product%\demacia.xml
        busybox.exe sed -i "s/#/\"/g" res\firehose\special\%product%\demacia.xml
        call framwork conf dev-%product%.bat demacia_token %demacia_token%
    ) else (ECHO. No demacia_token entered. Skipping...)
if not "%demacia_pk%"=="" (
        busybox.exe sed -i "s/\"/#/g" res\firehose\special\%product%\demacia.xml
        busybox.exe sed -i "s/ pk=#[^#]*#/ pk=#%demacia_pk%#/g" res\firehose\special\%product%\demacia.xml
        busybox.exe sed -i "s/#/\"/g" res\firehose\special\%product%\demacia.xml
        call framwork conf dev-%product%.bat demacia_pk %demacia_pk%
    ) else (ECHO. No demacia_pk entered. Skipping...)
if not "%setprojmodel_token%"=="" (
        busybox.exe sed -i "s/\"/#/g" res\firehose\special\%product%\setprojmodel.xml
        busybox.exe sed -i "s/ token=#[^#]*#/ token=#%setprojmodel_token%#/g" res\firehose\special\%product%\setprojmodel.xml
        busybox.exe sed -i "s/#/\"/g" res\firehose\special\%product%\setprojmodel.xml
        call framwork conf dev-%product%.bat setprojmodel_token %setprojmodel_token%
    ) else (ECHO. No setprojmodel_token entered. Skipping...)
if not "%setprojmodel_pk%"=="" (
        busybox.exe sed -i "s/\"/#/g" res\firehose\special\%product%\setprojmodel.xml
        busybox.exe sed -i "s/ pk=#[^#]*#/ pk=#%setprojmodel_pk%#/g" res\firehose\special\%product%\setprojmodel.xml
        busybox.exe sed -i "s/#/\"/g" res\firehose\special\%product%\setprojmodel.xml
        call framwork conf dev-%product%.bat setprojmodel_pk %setprojmodel_pk%
    ) else (ECHO. No setprojmodel_pk entered. Skipping...)
if not "%flash_token%"=="" (
        if exist res\rom\%product%\rawprogram0.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram0.xml
            busybox.exe sed -i "s/ token=#[^#]*#/ token=#%flash_token%#/g" res\rom\%product%\rawprogram0.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram0.xml
            )
        if exist res\rom\%product%\rawprogram1.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram1.xml
            busybox.exe sed -i "s/ token=#[^#]*#/ token=#%flash_token%#/g" res\rom\%product%\rawprogram1.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram1.xml
            )
        if exist res\rom\%product%\rawprogram2.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram2.xml
            busybox.exe sed -i "s/ token=#[^#]*#/ token=#%flash_token%#/g" res\rom\%product%\rawprogram2.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram2.xml
            )
        if exist res\rom\%product%\rawprogram3.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram3.xml
            busybox.exe sed -i "s/ token=#[^#]*#/ token=#%flash_token%#/g" res\rom\%product%\rawprogram3.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram3.xml
            )
        if exist res\rom\%product%\rawprogram4.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram4.xml
            busybox.exe sed -i "s/ token=#[^#]*#/ token=#%flash_token%#/g" res\rom\%product%\rawprogram4.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram4.xml
            )
        if exist res\rom\%product%\rawprogram5.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram5.xml
            busybox.exe sed -i "s/ token=#[^#]*#/ token=#%flash_token%#/g" res\rom\%product%\rawprogram5.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram5.xml
            )
        if exist res\rom\%product%\rawprogram_ddr1.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram_ddr1.xml
            busybox.exe sed -i "s/ token=#[^#]*#/ token=#%flash_token%#/g" res\rom\%product%\rawprogram_ddr1.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram_ddr1.xml
            )
        if exist res\rom\%product%\rawprogram_ddr2.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram_ddr2.xml
            busybox.exe sed -i "s/ token=#[^#]*#/ token=#%flash_token%#/g" res\rom\%product%\rawprogram_ddr2.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram_ddr2.xml
            )
        call framwork conf dev-%product%.bat flash_token %flash_token%
    ) else (ECHO. No flash_token entered. Skipping...)
if not "%flash_pk%"=="" (
        if exist res\rom\%product%\rawprogram0.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram0.xml
            busybox.exe sed -i "s/ pk=#[^#]*#/ pk=#%flash_pk%#/g" res\rom\%product%\rawprogram0.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram0.xml
            )
        if exist res\rom\%product%\rawprogram1.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram1.xml
            busybox.exe sed -i "s/ pk=#[^#]*#/ pk=#%flash_pk%#/g" res\rom\%product%\rawprogram1.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram1.xml
            )
        if exist res\rom\%product%\rawprogram2.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram2.xml
            busybox.exe sed -i "s/ pk=#[^#]*#/ pk=#%flash_pk%#/g" res\rom\%product%\rawprogram2.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram2.xml
            )
        if exist res\rom\%product%\rawprogram3.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram3.xml
            busybox.exe sed -i "s/ pk=#[^#]*#/ pk=#%flash_pk%#/g" res\rom\%product%\rawprogram3.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram3.xml
            )
        if exist res\rom\%product%\rawprogram4.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram4.xml
            busybox.exe sed -i "s/ pk=#[^#]*#/ pk=#%flash_pk%#/g" res\rom\%product%\rawprogram4.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram4.xml
            )
        if exist res\rom\%product%\rawprogram5.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram5.xml
            busybox.exe sed -i "s/ pk=#[^#]*#/ pk=#%flash_pk%#/g" res\rom\%product%\rawprogram5.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram5.xml
            )
        if exist res\rom\%product%\rawprogram_ddr1.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram_ddr1.xml
            busybox.exe sed -i "s/ pk=#[^#]*#/ pk=#%flash_pk%#/g" res\rom\%product%\rawprogram_ddr1.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram_ddr1.xml
            )
        if exist res\rom\%product%\rawprogram_ddr2.xml (
            busybox.exe sed -i "s/\"/#/g" res\rom\%product%\rawprogram_ddr2.xml
            busybox.exe sed -i "s/ pk=#[^#]*#/ pk=#%flash_pk%#/g" res\rom\%product%\rawprogram_ddr2.xml
            busybox.exe sed -i "s/#/\"/g" res\rom\%product%\rawprogram_ddr2.xml
            )
        call framwork conf dev-%product%.bat flash_pk %flash_pk%
    ) else (ECHO. No flash_pk entered. Skipping...)
ECHO. Done. Press any key to return to the main menu... & pause>nul & goto MENU

:WRITE-FULLBAK
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] Flash - Full Partition Backup
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO. Warning: Since this involves special partitions like the baseband, the full partition backup can only be used on the original device that created the backup. Do not mix or distribute backups, and do not use backups from other devices. Otherwise, you will bear the consequences.
ECHO.
ECHO.
ECHO. Please select the folder containing the backup (the folder must not contain files with the same partition names, otherwise it will fail)... & call sel folder s %framwork_workspace%\..
set imgpath=%sel__folder_path%
if not exist %imgpath%\rawprogram0.xml ECHO. No rawprogram0.xml found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist %imgpath%\rawprogram1.xml ECHO. No rawprogram1.xml found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist %imgpath%\rawprogram2.xml ECHO. No rawprogram2.xml found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist %imgpath%\rawprogram3.xml ECHO. No rawprogram3.xml found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist %imgpath%\rawprogram4.xml ECHO. No rawprogram4.xml found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist %imgpath%\rawprogram5.xml ECHO. No rawprogram5.xml found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist %imgpath%\patch0.xml ECHO. No patch0.xml found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist %imgpath%\patch1.xml ECHO. No patch1.xml found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist %imgpath%\patch2.xml ECHO. No patch2.xml found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist %imgpath%\patch3.xml ECHO. No patch3.xml found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist %imgpath%\patch4.xml ECHO. No patch4.xml found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist %imgpath%\patch5.xml ECHO. No patch5.xml found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
ECHO. Please enter 9008 mode... & call chkdev edl rechk 1
start framwork logviewer start %logfile%
call opredl sendfh %chkdev__edl__port%
ECHO. Starting recovery...
call write edl %chkdev__edl__port% UFS %imgpath% rawprogram0.xml/rawprogram1.xml/rawprogram2.xml/rawprogram3.xml/rawprogram4.xml/rawprogram5.xml/patch0.xml/patch1.xml/patch2.xml/patch3.xml/patch4.xml/patch5.xml
call write edl %chkdev__edl__port% UFS %imgpath% %framwork_workspace%\res\setbootablestoragedrive.xml
ECHO.
ECHO.1. Return to Main Menu   2. Reboot Device
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto MENU

:READ-FULLBAK
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] Readback - Full Partition Backup
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO. Warning: Since this involves special partitions like the baseband, the full partition backup can only be used on the original device that created the backup. Do not mix or distribute backups, and do not use backups from other devices. Otherwise, you will bear the consequences.
ECHO.
ECHO.
if not exist res\rom\%product%\rawprogram0.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram1.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram2.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram3.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram4.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram5.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
ECHO. Please select the save folder (the folder must not contain files with the same partition names, otherwise it will fail)... & call sel folder s %framwork_workspace%\..
set imgpath=%sel__folder_path%
ECHO. The following partitions will be backed up...
:: Merge
echo.{?xml version=#1.0# ?}>tmp\par.xml
echo.{data}>>tmp\par.xml
type res\rom\%product%\rawprogram0.xml | find "program " 1>>tmp\par.xml
type res\rom\%product%\rawprogram1.xml | find "program " 1>>tmp\par.xml
type res\rom\%product%\rawprogram2.xml | find "program " 1>>tmp\par.xml
type res\rom\%product%\rawprogram3.xml | find "program " 1>>tmp\par.xml
type res\rom\%product%\rawprogram4.xml | find "program " 1>>tmp\par.xml
type res\rom\%product%\rawprogram5.xml | find "program " 1>>tmp\par.xml
echo.{/data}>>tmp\par.xml
busybox.exe sed -i "s/\"/#/g" tmp\par.xml
busybox.exe sed -i "s/</{/g" tmp\par.xml
busybox.exe sed -i "s/>/}/g" tmp\par.xml
:: Add a space to empty partition names
busybox.exe sed -i "s/ filename=## / filename=# # /g" tmp\par.xml
:: Remove unwanted partitions
type tmp\par.xml | find /v " label=#last_parti# " | find /v " label=#BackupGPT# " | find /v " label=#PrimaryGPT# " | find /v " label=#userdata# " 1>tmp\par2.xml
:: Add line numbers
type tmp\par2.xml | find /N "{" 1>tmp\par.xml
:: Replace filenames
set num=1
:READ-FULLBAK-1
find "[%num%]" "tmp\par.xml" 1>nul 2>nul || ECHO. && goto READ-FULLBAK-2
for /f "tokens=8 delims=#" %%a in ('type tmp\par.xml ^| find "[%num%]"') do ECHOC {%c_we%}%%a {%c_i%}& busybox.exe sed -i "%num%s/ filename=#[^#]*# / filename=#%%a.bin# /" tmp\par.xml
set /a num+=1
goto READ-FULLBAK-1
:READ-FULLBAK-2
:: Remove line numbers
busybox.exe sed -i "s/\[[^#]*\]//g" tmp\par.xml
ECHO. Preparing files...
set num=0
:READ-FULLBAK-3
    echo.{?xml version=#1.0# ?}>%imgpath%\rawprogram%num%.xml
    echo.{data}>>%imgpath%\rawprogram%num%.xml
    type tmp\par.xml | find " physical_partition_number=#%num%# " 1>>%imgpath%\rawprogram%num%.xml
    type res\rom\%product%\rawprogram%num%.xml | find "gpt_main%num%.bin" 1>>%imgpath%\rawprogram%num%.xml
    type res\rom\%product%\rawprogram%num%.xml | find "gpt_backup%num%.bin" 1>>%imgpath%\rawprogram%num%.xml
    echo.{/data}>>%imgpath%\rawprogram%num%.xml
    busybox.exe sed -i "s/#/\"/g" %imgpath%\rawprogram%num%.xml
    busybox.exe sed -i "s/{/</g" %imgpath%\rawprogram%num%.xml
    busybox.exe sed -i "s/}/>/g" %imgpath%\rawprogram%num%.xml
if "%num%"=="5" goto READ-FULLBAK-4
set /a num+=1& goto READ-FULLBAK-3
:READ-FULLBAK-4
copy /Y res\rom\%product%\gpt_*.bin %imgpath% 1>>%logfile% 2>&1
copy /Y res\rom\%product%\patch*.xml %imgpath% 1>>%logfile% 2>&1
busybox.exe sed -i "s/#/\"/g" tmp\par.xml
busybox.exe sed -i "s/{/</g" tmp\par.xml
busybox.exe sed -i "s/}/>/g" tmp\par.xml
ECHO. Please enter 9008 mode... & call chkdev edl rechk 1
start framwork logviewer start %logfile%
call opredl sendfh %chkdev__edl__port%
ECHO. Starting backup...
call read edl %chkdev__edl__port% UFS %imgpath% %framwork_workspace%\tmp\par.xml
ECHO.
ECHO.1. Return to Main Menu   2. Reboot Device
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto MENU

:ERASE-CUSTOM
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] Erase - Specific Partition
ECHO.=--------------------------------------------------------------------=
ECHO.
if not exist res\rom\%product%\rawprogram0.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram1.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram2.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram3.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram4.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram5.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if exist tmp\par.txt del tmp\par.txt 1>nul
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram0.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 0 sda>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram1.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 1 sdb>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram2.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 2 sdc>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram3.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 3 sdd>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram4.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 4 sde>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram5.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 5 sdf>>tmp\par.txt
busybox.exe sed -i "s/\"//g" tmp\par.txt
sort tmp\par.txt 1>tmp\par2.txt
type tmp\par2.txt | find /N " " 1>tmp\par.txt
ECHO.[Index] Partition Name   (Corresponding File) Partition Size rawprogram lun
ECHO.
type tmp\par.txt
ECHO.[A] Return to Main Menu
ECHO.
call choice common
if "%choice%"=="A" goto MENU
find "[%choice%] " "tmp\par.txt" 1>nul 2>nul || goto ERASE-CUSTOM
for /f "tokens=2,5 delims=[] " %%a in ('type tmp\par.txt ^| find "[%choice%] "') do set parname=%%a& set rawprogram=rawprogram%%b.xml
ECHO.
ECHO. Should the bootloader be sent? If it has already been sent, there is no need to send it again.
ECHO.1. Send (Default)   2. Do Not Send
call choice common #[1][2]
if "%choice%"=="1" (set sendfh=y) else (set sendfh=n)
ECHO.
ECHO. Generating XML...
copy /Y res\rom\%product%\%rawprogram% tmp\rawprogram.xml 1>nul
busybox.exe sed -i "s/\"/#/g" tmp\rawprogram.xml
busybox.exe sed -i "s/</{/g" tmp\rawprogram.xml
busybox.exe sed -i "s/>/}/g" tmp\rawprogram.xml
:: Start generating the XML for this partition
echo.{?xml version=#1.0# ?}>tmp\targetpar.xml
echo.{data}>>tmp\targetpar.xml
type tmp\rawprogram.xml | find " label=#%parname%# " 1>>tmp\targetpar.xml
echo.{/data}>>tmp\targetpar.xml
busybox.exe sed -i "s/{program /{erase /" tmp\targetpar.xml
::busybox.exe sed -i "s/ sparse=#true# / sparse=#false# /" tmp\targetpar.xml
busybox.exe sed -i "s/#/\"/g" tmp\targetpar.xml
busybox.exe sed -i "s/{/</g" tmp\targetpar.xml
busybox.exe sed -i "s/}/>/g" tmp\targetpar.xml
ECHO. Please enter 9008 mode... & call chkdev edl
::start framwork logviewer start %logfile%
if "%sendfh%"=="y" call opredl sendfh %chkdev__edl__port%
ECHO. Erasing %parname% ... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\tmp targetpar.xml
ECHO.
ECHO.1. Return   2. Reboot Device
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto ERASE-CUSTOM

:WRITE-CUSTOM
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] Flash - Specific Partition
ECHO.=--------------------------------------------------------------------=
ECHO.
if not exist res\rom\%product%\rawprogram0.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram1.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram2.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram3.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram4.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram5.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if exist tmp\par.txt del tmp\par.txt 1>nul
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram0.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 0 sda>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram1.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 1 sdb>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram2.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 2 sdc>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram3.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 3 sdd>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram4.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 4 sde>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram5.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 5 sdf>>tmp\par.txt
busybox.exe sed -i "s/\"//g" tmp\par.txt
sort tmp\par.txt 1>tmp\par2.txt
type tmp\par2.txt | find /N " " 1>tmp\par.txt
ECHO.[Index] Partition Name   (Corresponding File) Partition Size rawprogram lun
ECHO.
type tmp\par.txt
ECHO.[A] Return to Main Menu
ECHO.
call choice common
if "%choice%"=="A" goto MENU
find "[%choice%] " "tmp\par.txt" 1>nul 2>nul || goto WRITE-CUSTOM
for /f "tokens=2,5 delims=[] " %%a in ('type tmp\par.txt ^| find "[%choice%] "') do set parname=%%a& set rawprogram=rawprogram%%b.xml
:: Select file
ECHO.
ECHO. Please select the file to flash into %parname% ... & call sel file s %framwork_workspace%\..
set imgpath=%sel__file_path%& set imgfolder=%sel__file_folder%& set imgname=%sel__file_fullname%
ECHO.
ECHO. Should the bootloader be sent? If it has already been sent, there is no need to send it again.
ECHO.1. Send (Default)   2. Do Not Send
call choice common #[1][2]
if "%choice%"=="1" (set sendfh=y) else (set sendfh=n)
ECHO.
ECHO. Generating XML...
copy /Y res\rom\%product%\%rawprogram% tmp\rawprogram.xml 1>nul
busybox.exe sed -i "s/\"/#/g" tmp\rawprogram.xml
busybox.exe sed -i "s/</{/g" tmp\rawprogram.xml
busybox.exe sed -i "s/>/}/g" tmp\rawprogram.xml
:: Start generating the XML for this partition
echo.{?xml version=#1.0# ?}>tmp\targetpar.xml
echo.{data}>>tmp\targetpar.xml
type tmp\rawprogram.xml | find " label=#%parname%# " 1>>tmp\targetpar.xml
echo.{/data}>>tmp\targetpar.xml
busybox.exe sed -i "s/ filename=#[^#]*# / filename=#%imgname%# /" tmp\targetpar.xml
::busybox.exe sed -i "s/ sparse=#true# / sparse=#false# /" tmp\targetpar.xml
busybox.exe sed -i "s/#/\"/g" tmp\targetpar.xml
busybox.exe sed -i "s/{/</g" tmp\targetpar.xml
busybox.exe sed -i "s/}/>/g" tmp\targetpar.xml
ECHO. Please enter 9008 mode... & call chkdev edl
::start framwork logviewer start %logfile%
if "%sendfh%"=="y" call opredl sendfh %chkdev__edl__port%
ECHO. Flashing %imgname% into %parname% ... & call write edl %chkdev__edl__port% UFS %imgfolder% %framwork_workspace%\tmp\targetpar.xml
ECHO.
ECHO.1. Return   2. Reboot Device
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto WRITE-CUSTOM

:READ-CUSTOM
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] Readback - Specific Partition
ECHO.=--------------------------------------------------------------------=
ECHO.
if not exist res\rom\%product%\rawprogram0.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram1.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram2.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram3.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram4.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram5.xml ECHO. No %model% XML found. Please contact 1330250642 on QQ. Press any key to return... & pause>nul & goto MENU
if exist tmp\par.txt del tmp\par.txt 1>nul
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram0.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 0 sda>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram1.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 1 sdb>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram2.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 2 sdc>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram3.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 3 sdd>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram4.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 4 sde>>tmp\par.txt
for /f "tokens=9,7,19 delims== " %%a in ('type res\rom\%product%\rawprogram5.xml ^| find "program SECTOR_SIZE_IN_BYTES"') do ECHO. %%b           (%%a) %%cKB 5 sdf>>tmp\par.txt
busybox.exe sed -i "s/\"//g" tmp\par.txt
sort tmp\par.txt 1>tmp\par2.txt
type tmp\par2.txt | find /N " " 1>tmp\par.txt
ECHO.[Index] Partition Name   (Corresponding File) Partition Size rawprogram lun
ECHO.
type tmp\par.txt
ECHO.[A] Return to Main Menu
ECHO.
call choice common
if "%choice%"=="A" goto MENU
find "[%choice%] " "tmp\par.txt" 1>nul 2>nul || goto READ-CUSTOM
for /f "tokens=2,3,5 delims=[] " %%a in ('type tmp\par.txt ^| find "[%choice%] "') do set parname=%%a& set imgname=%%b& set rawprogram=rawprogram%%c.xml
:: Select directory
ECHO.
set imgname=%imgname:~1,-1%
if "%imgname%"=="" set imgname=%parname%.img
ECHO. Please select the save directory for %imgname% (must not contain files with the same name, otherwise it will fail)... & call sel folder s %framwork_workspace%\..
set imgfolder=%sel__folder_path%
ECHO.
ECHO. Should the bootloader be sent? If it has already been sent, there is no need to send it again.
ECHO.1. Send (Default)   2. Do Not Send
call choice common #[1][2]
if "%choice%"=="1" (set sendfh=y) else (set sendfh=n)
ECHO.
ECHO. Generating XML...
copy /Y res\rom\%product%\%rawprogram% tmp\rawprogram.xml 1>nul
busybox.exe sed -i "s/\"/#/g" tmp\rawprogram.xml
busybox.exe sed -i "s/</{/g" tmp\rawprogram.xml
busybox.exe sed -i "s/>/}/g" tmp\rawprogram.xml
:: Start generating the XML for this partition
echo.{?xml version=#1.0# ?}>tmp\targetpar.xml
echo.{data}>>tmp\targetpar.xml
type tmp\rawprogram.xml | find " label=#%parname%# " 1>>tmp\targetpar.xml
echo.{/data}>>tmp\targetpar.xml
busybox.exe sed -i "s/ filename=#[^#]*# / filename=#%imgname%# /" tmp\targetpar.xml
busybox.exe sed -i "s/ sparse=#true# / sparse=#false# /" tmp\targetpar.xml
busybox.exe sed -i "s/#/\"/g" tmp\targetpar.xml
busybox.exe sed -i "s/{/</g" tmp\targetpar.xml
busybox.exe sed -i "s/}/>/g" tmp\targetpar.xml
ECHO. Please enter 9008 mode... & call chkdev edl
::start framwork logviewer start %logfile%
if "%sendfh%"=="y" call opredl sendfh %chkdev__edl__port%
ECHO. Reading back %parname% to %imgfolder%\%imgname% ... & call read edl %chkdev__edl__port% UFS %imgfolder% %framwork_workspace%\tmp\targetpar.xml
ECHO.
ECHO.1. Return   2. Reboot Device
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto READ-CUSTOM

:READ-ALL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] Readback - Full Package
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO. Please select the folder to save the partition files (must not contain files with the same name, otherwise it will fail)... & call sel folder s %framwork_workspace%\..
set imgpath=%sel__folder_path%
if "%parlayout%"=="aonly" set targetxmlname=readback_all& goto READ-ALL-2
:READ-ALL-1
ECHO.
ECHO.1. Readback Slot A   2. Readback Slot B   3. Check which slot to readback
call choice common [1][2][3]
ECHO.
if "%choice%"=="3" start opredl getcurrentslot& goto READ-ALL-1
if "%choice%"=="1" set targetxmlname=readback_all_a& goto READ-ALL-2
if "%choice%"=="2" set targetxmlname=readback_all_b& goto READ-ALL-2
:READ-ALL-2
set rawprogram=%framwork_workspace%\res\rom\%product%\%targetxmlname%.xml
if not exist %rawprogram% ECHOC {%c_e%} Cannot find the readback script. Please contact 1330250642 on QQ to report this issue.{%c_i%}{\n}& goto FATAL
ECHO. Please enter 9008 mode... & call chkdev edl rechk 1
start framwork logviewer start %logfile%
call opredl sendfh %chkdev__edl__port%
call read edl %chkdev__edl__port% UFS %imgpath% %rawprogram%
:: Distinguish DDR
if "%chkddr_img%"=="y" (if "%ddrtype%"=="auto" call opredl chkddr %chkdev__edl__port%)
if "%chkddr_img%"=="y" (if "%ddrtype%"=="auto" set read_all_ddrtype=%chkddr__type%)
if "%chkddr_img%"=="y" (if not "%ddrtype%"=="auto" set read_all_ddrtype=%ddrtype%)
if "%chkddr_img%"=="y" call read edl %chkdev__edl__port% UFS %imgpath% %framwork_workspace%\res\rom\%product%\%targetxmlname%_ddr%read_all_ddrtype%.xml
ECHO. Adding files...
copy /Y res\rom\%product%\rawprogram*.xml %imgpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%} Failed to copy res\rom\%product%\rawprogram?.xml to %imgpath%{%c_i%}{\n}&& ECHO. Continuing...
if exist res\rom\%product%\patch*.xml copy /Y res\rom\%product%\patch?.xml %imgpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%} Failed to copy res\rom\%product%\patch?.xml to %imgpath%{%c_i%}{\n}&& ECHO. Continuing...
if exist res\rom\%product%\gpt_*.bin copy /Y res\rom\%product%\gpt_*.bin %imgpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%} Failed to copy res\rom\%product%\gpt_*.bin to %imgpath%{%c_i%}{\n}&& ECHO. Continuing...
ECHO.
ECHO.1. Return to Main Menu   2. Reboot Device
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto MENU

:TESTFH
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] Test Sending Bootloader
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO. Please enter 9008 mode... & call chkdev edl rechk 1
start framwork logviewer start %logfile%
call opredl sendfh %chkdev__edl__port%
ECHO.
ECHO.1. Return to Main Menu   2. Reboot Device
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto MENU

:WRITE-ALL
set rawprogram_folder=
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] Flash - Full Package
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO. Please select the folder containing the partition images for the flash package... & call sel folder s %framwork_workspace%\..
set imgpath=%sel__folder_path%
set rawprogram0=None& set rawprogram1=None& set rawprogram2=None& set rawprogram3=None& set rawprogram4=None& set rawprogram5=None
if exist %imgpath%\rawprogram0.xml set rawprogram0=rawprogram0.xml
if exist %imgpath%\rawprogram1.xml set rawprogram1=rawprogram1.xml
if exist %imgpath%\rawprogram2.xml set rawprogram2=rawprogram2.xml
if exist %imgpath%\rawprogram3.xml set rawprogram3=rawprogram3.xml
if exist %imgpath%\rawprogram4.xml set rawprogram4=rawprogram4.xml
if exist %imgpath%\rawprogram5.xml set rawprogram5=rawprogram5.xml
set patch0=None& set patch1=None& set patch2=None& set patch3=None& set patch4=None& set patch5=None
if exist %imgpath%\patch0.xml set patch0=patch0.xml
if exist %imgpath%\patch1.xml set patch1=patch1.xml
if exist %imgpath%\patch2.xml set patch2=patch2.xml
if exist %imgpath%\patch3.xml set patch3=patch3.xml
if exist %imgpath%\patch4.xml set patch4=patch4.xml
if exist %imgpath%\patch5.xml set patch5=patch5.xml
ECHO.
ECHO.1. Use the toolbox's built-in rawprogram (Default)
ECHO.2. Automatically detect rawprogram
ECHO.  [%rawprogram0%]
ECHO.  [%rawprogram1%]
ECHO.  [%rawprogram2%]
ECHO.  [%rawprogram3%]
ECHO.  [%rawprogram4%]
ECHO.  [%rawprogram5%]
ECHO.3. Manually select rawprogram
call choice common #[1][2][3]
if "%choice%"=="1" set rawprogram_folder=%framwork_workspace%\res\rom\%product%& set rawprogram=%framwork_workspace%\res\rom\%product%\rawprogram0.xml/%framwork_workspace%\res\rom\%product%\rawprogram1.xml/%framwork_workspace%\res\rom\%product%\rawprogram2.xml/%framwork_workspace%\res\rom\%product%\rawprogram3.xml/%framwork_workspace%\res\rom\%product%\rawprogram4.xml/%framwork_workspace%\res\rom\%product%\rawprogram5.xml
if "%choice%"=="2" set rawprogram_folder=%imgpath%& set rawprogram=%rawprogram0%/%rawprogram1%/%rawprogram2%/%rawprogram3%/%rawprogram4%/%rawprogram5%
if "%choice%"=="3" ECHO. Please select rawprogram (multiple selections allowed)... & call sel file m %imgpath% [xml]
if "%choice%"=="3" set rawprogram=%sel__files%
goto WRITE-ALL-1
:WRITE-ALL-1
ECHO.
ECHO.1. Use the toolbox's built-in patch (Default)
ECHO.2. Automatically detect patch
ECHO.  [%patch0%]
ECHO.  [%patch1%]
ECHO.  [%patch2%]
ECHO.  [%patch3%]
ECHO.  [%patch4%]
ECHO.  [%patch5%]
ECHO.3. Manually select patch
ECHO.4. Do not use patch
call choice common #[1][2][3][4]
if "%choice%"=="1" set patch=%framwork_workspace%\res\rom\%product%\patch0.xml/%framwork_workspace%\res\rom\%product%\patch1.xml/%framwork_workspace%\res\rom\%product%\patch2.xml/%framwork_workspace%\res\rom\%product%\patch3.xml/%framwork_workspace%\res\rom\%product%\patch4.xml/%framwork_workspace%\res\rom\%product%\patch5.xml
if "%choice%"=="2" set patch=%patch0%/%patch1%/%patch2%/%patch3%/%patch4%/%patch5%
if "%choice%"=="3" ECHO. Please select patch (multiple selections allowed)... & call sel file m %imgpath% [xml]
if "%choice%"=="3" set patch=%sel__files%
if "%choice%"=="4" set patch=
goto WRITE-ALL-2
:WRITE-ALL-2
ECHO.
ECHO. Please enter 9008 mode... & call chkdev edl rechk 1
start framwork logviewer start %logfile%
call opredl sendfh %chkdev__edl__port%
call write edl %chkdev__edl__port% UFS %imgpath% %rawprogram%/%patch%
:: Distinguish DDR
if not "%chkddr_img%"=="y" goto WRITE-ALL-3
if "%rawprogram_folder%"=="" goto WRITE-ALL-3
call opredl chkddr %chkdev__edl__port%
if not exist %rawprogram_folder%\rawprogram_ddr%chkddr__type%.xml ECHOC {%c_w%} Warning: Cannot find %rawprogram_folder%\rawprogram_ddr%chkddr__type%.xml. Skipping flashing related partitions...{%c_i%}{\n}& goto WRITE-ALL-3
call write edl %chkdev__edl__port% UFS %imgpath% %rawprogram_folder%\rawprogram_ddr%chkddr__type%.xml
:WRITE-ALL-3
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\setbootablestoragedrive.xml
ECHO.
ECHO.1. Return to Main Menu   2. Reboot Device
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto MENU

:SELDEV
type conf\dev.csv | find /v "[product]" | find "[" | find /N "]" 1>tmp\dev.txt
CLS
ECHO.=--------------------------------------------------------------------=
ECHO. Select/Change Model
ECHO.=--------------------------------------------------------------------=
ECHO.
for /f "tokens=1,3 delims=[]," %%a in (tmp\dev.txt) do ECHO.%%a.%%b
ECHO.
call choice common
if "%choice%"=="" goto SELDEV
find "[%choice%][" "tmp\dev.txt" 1>nul 2>nul || goto SELDEV
ECHO. Switching models. Please do not close the window...
for /f "tokens=2 delims=[]," %%a in ('type tmp\dev.txt ^| find "[%choice%]["') do set product=%%a
call opredl confdevpre
call framwork conf user.bat product %product%
call conf\dev-%product%.bat
if "%chkddr_fh%"=="y" goto SELDEV-1
if "%chkddr_img%"=="y" goto SELDEV-1
goto MENU
:SELDEV-1
ECHO.
ECHO. Please select the device's DDR type (incorrect selection may cause commands to fail after sending the bootloader).
ECHO. You can still change this setting from the main menu later.
ECHO.
ECHO.1. Auto-detect (may fail)
ECHO.2. DDR4 (Type 1)
ECHO.3. DDR5 (Type 2)
ECHO.
call choice common [1][2][3]
if "%choice%"=="1" set ddrtype=auto
if "%choice%"=="2" set ddrtype=1
if "%choice%"=="3" set ddrtype=2
call framwork conf dev-%product%.bat ddrtype %ddrtype%
goto MENU

:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%} Sorry, the script encountered an issue and cannot continue. Please check the log. {%c_h%} Press any key to exit...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO. Sorry, the script encountered an issue and cannot continue. Press any key to exit...& pause>nul & EXIT)