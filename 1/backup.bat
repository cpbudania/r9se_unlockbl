:: Modified the following script:
:: framwork.bat

:: This is a sample main script. Please follow the startup process in this example to complete the script's startup.

:: General preparation, do not modify
@ECHO OFF
chcp 936>nul
cd /d %~dp0
if exist bin (cd bin) else (ECHO. Cannot find bin & goto FATAL)

:: Load configuration. If there are custom configuration files, they can be added below.
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

:: Check and obtain administrator privileges. Remove if not needed.
if not exist tool\Windows\gap.exe ECHO. Cannot find gap.exe & goto FATAL
if exist %windir%\System32\bff-test rd %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
md %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
rd %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT

:: Startup preparation and checks, do not modify
:: call framwork startpre
call framwork startpre skiptoolchk

:: Startup complete. Please write your script below.
TITLE [No device selected] Oplus Real 9008 Tool Version:%prog_ver%
if "%product%"=="" goto SELDEV
if not exist conf\dev-%product%.bat goto SELDEV
if "%chkddr_fh%"=="y" (if "%ddrtype%"=="" goto SELDEV)
if "%chkddr_img%"=="y" (if "%ddrtype%"=="" goto SELDEV)
goto MENU

:MENU
TITLE [%model%] Oplus Real 9008 Tool Version:%prog_ver% [Free tool, resale prohibited]
CLS
ECHO.=--------------------------------------------------------------------=
ECHO. Main Menu
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.【Solution from Coolapk@mi搞机爱好者】 Script author: Coolapk@某贼
ECHO. To enter 9008 mode: Hold Volume Up + Volume Down while connecting to the PC, or tap the version number repeatedly in the official Recovery.
ECHO. To force restart: Hold the Power button or hold Power + Volume Up.
ECHO. If sending the loader gets stuck or fails: Force restart, re-enter 9008, and retry.
ECHO. 9008 mode will not lock the bootloader. All backup functions do not involve the bootloader state or user data partitions.
ECHO.
if "%method%"=="special-token" (if "%flash_pk%"=="" ECHOC {%c_e%} You have not set the flash key. Some features may not work. Please use the "Enter Flash Key" function first. {%c_i%}{\n})
ECHO. Current device: %model% If the device is incorrect, please select the correct device first, otherwise proceed at your own risk.
if "%chkddr_fh%"=="y" ECHO. DDR type: %ddrtype%
ECHO.
ECHO.
ECHO.0. Test sending loader
ECHO.1. Flash - Full package (Flash 9008 package)
ECHO.2. Flash - Full partition backup (Restore NAND)
ECHO.3. Flash - Specific partition
ECHO.4. Erase - Specific partition
ECHO.A. Backup - Full package (Create 9008 package)
ECHO.B. Backup - Full partition backup (Backup NAND)
ECHO.C. Backup - Specific partition
ECHO.
ECHO.11. Download 9008 firmware package
ECHO.22. ADB screen mirroring
ECHO.33. Enter flash key
if "%chkddr_fh%"=="y" (ECHO.44. Select/Change device, change DDR type) else (ECHO.44. Select/Change device)
ECHO.55. Check for updates (Password: f65u)
ECHO.66. Flash drivers
ECHO.77. About BFF
ECHO.88. Join group chat
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
if "%choice%"=="22" call scrcpy Oplus Real 9008 Tool-ADB screen mirroring
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
ECHO.[%model%] Enter Flash Key
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
if not "%method%"=="special-token" ECHOC {%c_i%}%model% does not require this feature. {%c_h%} Press any key to return to the main menu... {%c_i%}{\n}& pause>nul & goto MENU
ECHO. For some OnePlus devices, a flash key is required to use the Oplus Real 9008 tool. Each device's key is theoretically unique and can be used long-term.
ECHO.
ECHO.
ECHO.1. Manual input
::ECHO.2. Auto fetch (not yet implemented)
ECHO.A. How to manually capture the flash key (Beginners must read)
ECHO.B. Return to main menu
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
ECHO. Please enter the flash key in the pop-up window... & start /wait opredl_token.exe
if not exist tmp\token.bat ECHOC {%c_e%} The program did not start successfully or was not closed properly. {%c_h%} Press any key to retry... {%c_i%}{\n}& pause>nul & ECHO. Retrying... & goto INPUTTOKEN-INPUT
ECHO. Writing flash key...
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
            busybox.exe sed -i "