@ECHO OFF
mode con cols=71
COLOR 0F
TITLE BFF-命令行

cd /d %~dp0 1>nul 2>nul
if exist bin (cd bin) else (ECHO.找不到bin & goto FATAL)
if not exist tmp ECHO.找不到tmp & goto FATAL
set path=%cd%;%cd%\tool\Windows;%path%
set framwork_workspace=%cd%

::ECHO.检查ECHOC...
if not exist %framwork_workspace%\tool\Windows\ECHOC.exe ECHO.找不到ECHOC.exe& goto FATAL
ECHOC | find "Usage" 1>nul 2>nul || ECHO.ECHOC.exe无法运行&& goto FATAL
::ECHO.检查strtofile...
if not exist %framwork_workspace%\tool\Windows\strtofile.exe ECHOC {%c_e%}找不到strtofile.exe{%c_i%}{\n}& goto FATAL
if exist %framwork_workspace%\tmp\bff-test.txt del %framwork_workspace%\tmp\bff-test.txt 1>nul
echo.bff-test|strtofile.exe %framwork_workspace%\tmp\bff-test.txt || ECHOC {%c_e%}strtofile.exe无法运行{%c_i%}{\n}&& goto FATAL
for /f %%a in (%framwork_workspace%\tmp\bff-test.txt) do (if not "%%a"=="bff-test" ECHOC {%c_e%}strtofile.exe无法运行{%c_i%}{\n}& goto FATAL)
del %framwork_workspace%\tmp\bff-test.txt 1>nul


:CMD
CLS
ECHOC {0E}=--------------------------------------------------------------------={0F}{\n}
ECHO.
ECHO.                              BFF-命令行
ECHO.
ECHOC {0E}=--------------------------------------------------------------------={0F}{\n}
ECHO.
ECHOC {0E} 已配置ADB和Fastboot环境. 请输入命令, 按Enter执行. 下面是一些预置命令.{0F}{\n}
ECHO.
ECHOC {0E} cc{0F}  检查ADB和Fastboot连接  {0E}kil{0F} 结束所有ADB和Fastboot进程{0F}{\n}
ECHOC {0E} pre{0F} 一键准备ADB Shell环境  {0E}cfg{0F} 加载并显示配置信息{0F}{\n}
ECHOC {0E} mmc{0F} 启动设备管理器         {0E}cls{0F} 清空屏幕{0F}{\n}
ECHO. 
:CMD-CONTINUE
ECHOC {0E}=--------------------------------------------------------------------={0F}{\n}
ECHOC {0E}[命令]{0F} & call strtofile.exe %framwork_workspace%\tmp\cmd.bat
for /f %%a in (%framwork_workspace%\tmp\cmd.bat) do set cmd=%%a
if "%cmd%"=="" ECHOC {0C}                                                        [没有输入命令]{0F}{\n}& goto CMD-CONTINUE
if "%cmd%"=="cls" goto CMD
if "%cmd%"=="CLS" goto CMD
if "%cmd%"=="cc" (
    ECHO.检查ADB连接...& adb.exe devices | findstr /v "attached"
    ECHO.检查Fastboot连接...& fastboot.exe devices & goto CMD-CONTINUE)
if "%cmd%"=="mmc" (
    tasklist | find "mmc.exe" 1>nul 2>nul && ECHOC {0A}设备管理器已在运行！{0F}{\n}&& goto CMD-CONTINUE
    start %windir%\system32\devmgmt.msc & goto CMD-CONTINUE)
if "%cmd%"=="kil" (
    tasklist | find "adb.exe" 1>nul 2>nul && taskkill /f /im adb.exe
    tasklist | find "fastboot.exe" 1>nul 2>nul && taskkill /f /im fastboot.exe
    goto CMD-CONTINUE)
if "%cmd%"=="pre" (
    ECHO.所有工具均会被推送到根目录并授权
    ECHO.bootctl...& call :pushlinuxtool bootctl
    ECHO.busybox...& call :pushlinuxtool busybox
    ECHO.dmsetup...& call :pushlinuxtool dmsetup
    ECHO.blktool...& call :pushlinuxtool blktool
    ECHO.mke2fs...& call :pushlinuxtool mke2fs
    ECHO.mkfs.exfat...& call :pushlinuxtool mkfs.exfat
    ECHO.mkfs.fat...& call :pushlinuxtool mkfs.fat
    ECHO.mkntfs...& call :pushlinuxtool mkntfs
    ECHO.parted...& call :pushlinuxtool parted
	ECHO.sgdisk...& call :pushlinuxtool sgdisk
    goto CMD-CONTINUE)
if "%cmd%"=="cfg" (
    ECHOC {0F}固定配置:{07}{\n}& @ECHO ON & prompt $_& call %framwork_workspace%\conf\fixed|findstr "set" & prompt & @ECHO OFF
    ECHOC {0F}用户配置:{07}{\n}& @ECHO ON & prompt $_& call %framwork_workspace%\conf\user|findstr "set" & prompt & @ECHO OFF
    goto CMD-CONTINUE)
call %framwork_workspace%\tmp\cmd.bat || ECHOC {0C}                                                          [好像出错了]{0F}{\n}
goto CMD-CONTINUE


:pushlinuxtool
if not exist %framwork_workspace%\tool\Android\%1 ECHOC {0C}找不到%framwork_workspace%\tool\Android\%1{0F}{\n}& goto :eof
adb.exe push %framwork_workspace%\tool\Android\%1 ./%1 1>nul || ECHOC {0C}推送%framwork_workspace%\tool\Android\%1到./%1失败{0F}{\n}&& goto :eof
adb.exe shell chmod +x ./%1 1>nul || ECHOC {0C}授权./%1失败{0F}{\n}&& goto :eof
goto :eof


:NODEV
ECHOC {0C}                                                    [设备未(正确)连接]{0F}{\n}
goto CMD-CONTINUE






:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)
