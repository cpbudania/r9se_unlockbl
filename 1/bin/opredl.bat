::call opredl confdevpre
::            sendfh      端口号
::            chkddr      端口号  引导完整路径(可选, 不填则不发送)

::start opredl getcurrentslot


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%






:GETCURRENTSLOT
::这是一个主脚本示例,请按照此示例中的启动过程完成脚本的启动.
::常规准备,请勿改动
chcp 936>nul
::加载配置,如果有自定义的配置文件也可以加在下面
if exist conf\fixed.bat (call conf\fixed) else (ECHO.找不到conf\fixed.bat & goto FATAL)
if exist conf\user.bat call conf\user
if not "%product%"=="" (if exist conf\dev-%product%.bat call conf\dev-%product%.bat)
::加载主题,请勿改动
if "%framwork_theme%"=="" set framwork_theme=default
call framwork theme %framwork_theme%
COLOR %c_i%
::自定义窗口大小,可以按照需要改动
TITLE 工具启动中...
mode con cols=71
::检查和获取管理员权限,如不需要可以去除
if not exist tool\Windows\gap.exe ECHO.找不到gap.exe & goto FATAL
if exist %windir%\System32\bff-test rd %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
md %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
rd %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
::启动准备和检查,请勿改动
::call framwork startpre
call framwork startpre skiptoolchk
::完成启动.请在下面编写你的脚本
TITLE [查看当前槽位] 欧加真9008工具 版本:%prog_ver% [免费工具 禁止倒卖]
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.查看当前槽位
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHOC {%c_h%}请将设备开机进入系统并开启USB调试...{%c_i%}{\n}& call chkdev system rechk 3
call slot system chk
ECHO.
ECHO.当前设备处于 %slot__cur% 槽位. 你应该选择回读 %slot__cur% 槽位.
ECHO.
ECHO.完成. 按任意键返回... & pause>nul & goto WRITE-CUSTOM


:SENDFH
SETLOCAL
set logger=opredl.bat-sendfh
set port=%var2%
call log %logger% I 接收变量:port:%port%
if "%method:~0,7%"=="common-" set workfolder=%framwork_workspace%\res\firehose\common& goto SENDFH-COMMON
if "%method%"=="8gen2" set workfolder=%framwork_workspace%\res\firehose\8gen2& goto SENDFH-8GEN2
if "%method%"=="special" set workfolder=%framwork_workspace%\res\firehose\special& goto SENDFH-SPECIAL
if "%method%"=="special-token" set workfolder=%framwork_workspace%\res\firehose\special\%product%& goto SENDFH-SPECIAL-TOKEN
goto FATAL
:SENDFH-SPECIAL-TOKEN
call log %logger% I 设备专用引导-需token
if "%chkddr_fh%"=="n" set fh=%workfolder%\firehose.elf
if "%chkddr_fh%"=="y" (if "%ddrtype%"=="auto" call opredl chkddr %port% %workfolder%\firehose_lite.elf)
if "%chkddr_fh%"=="y" (if "%ddrtype%"=="auto" set fh=%workfolder%\firehose_ddr%chkddr__type%.elf)
if "%chkddr_fh%"=="y" (if not "%ddrtype%"=="auto" set fh=%workfolder%\firehose_ddr%ddrtype%.elf)
ECHO.正在发送引导... & call log %logger% I 正在发送引导:%fh%
QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送引导失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 发送引导失败&& pause>nul && ECHO.重试... && goto SENDFH-SPECIAL-TOKEN
if exist %workfolder%\configure.xml (
    ECHO.正在发送configure.xml... & call log %logger% I 正在发送configure.xml
    fh_loader.exe --port=\\.\COM%port% --memoryname=UFS --search_path=%workfolder% --sendxml=configure.xml --noprompt 1>>%logfile% 2>&1 || call log %logger% E 发送configure.xml失败)
if exist %workfolder%\demacia.xml (
    ECHO.正在发送demacia.xml... & call log %logger% I 正在发送demacia.xml
    fh_loader.exe --port=\\.\COM%port% --memoryname=UFS --search_path=%workfolder% --sendxml=demacia.xml --noprompt 1>>%logfile% 2>&1 || call log %logger% E 发送demacia.xml失败)
if exist %workfolder%\setprojmodel.xml (
    ECHO.正在发送setprojmodel.xml... & call log %logger% I 正在发送setprojmodel.xml
    fh_loader.exe --port=\\.\COM%port% --memoryname=UFS --search_path=%workfolder% --sendxml=setprojmodel.xml --noprompt 1>>%logfile% 2>&1 || call log %logger% E 发送setprojmodel.xml失败)
goto SENDFH-DONE
:SENDFH-SPECIAL
call log %logger% I 设备专用引导
if "%chkddr_fh%"=="n" set fh=%workfolder%\%product%.elf
if "%chkddr_fh%"=="y" (if "%ddrtype%"=="auto" call opredl chkddr %port% %workfolder%\%product%_lite.elf)
if "%chkddr_fh%"=="y" (if "%ddrtype%"=="auto" set fh=%workfolder%\%product%_ddr%chkddr__type%.elf)
if "%chkddr_fh%"=="y" (if not "%ddrtype%"=="auto" set fh=%workfolder%\%product%_ddr%ddrtype%.elf)
ECHO.正在发送引导... & call log %logger% I 正在发送引导:%fh%
QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送引导失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 发送引导失败&& pause>nul && ECHO.重试... && goto SENDFH-SPECIAL
goto SENDFH-DONE
:SENDFH-COMMON
call log %logger% I 通用方案
set fh=%workfolder%\%method:~7,999%.elf
ECHO.正在发送引导... & call log %logger% I 正在发送引导:%fh%
QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送引导失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 发送引导失败&& pause>nul && ECHO.重试... && goto SENDFH-COMMON
goto SENDFH-DONE
:SENDFH-8GEN2
call log %logger% I 8Gen2方案
ECHO.正在发送引导... & call log %logger% I 正在发送引导
QSaharaServer.exe -p \\.\COM%port% -s 13:%workfolder%\firehose.elf --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=ufs --testvipimpact 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送引导失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 发送引导失败&& pause>nul && ECHO.重试... && goto SENDFH-8GEN2
ECHO.正在发送Digest... & call log %logger% I 正在发送Digest
fh_loader.exe --port=\\.\COM%port% --signeddigests=%workfolder%\Digest.mbn --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=ufs --testvipimpact 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送Digest失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 发送Digest失败&& pause>nul && ECHO.重试... && goto SENDFH-8GEN2
ECHO.正在发送配置... & call log %logger% I 正在发送配置
fh_loader.exe --port=\\.\COM%port% --sendxml=%workfolder%\conf.xml 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送配置失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 发送配置失败&& pause>nul && ECHO.重试... && goto SENDFH-8GEN2
ECHO.正在发送签名... & call log %logger% I 正在发送签名
fh_loader.exe --port=\\.\COM%port% --signeddigests=%workfolder%\sig.dat --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=ufs --testvipimpact 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送签名失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 发送签名失败&& pause>nul && ECHO.重试... && goto SENDFH-8GEN2
goto SENDFH-DONE
:SENDFH-DONE
call log %logger% I 开启自由读写完成
ENDLOCAL
goto :eof


:CHKDDR
SETLOCAL
set logger=opredl.bat-chkddr
set port=%var2%& set fh=%var3%
call log %logger% I 接收变量:port:%port%.fh:%fh%
:CHKDDR-1
ECHO.开始检查ddr & call log %logger% I 开始检查ddr
if not "%fh%"=="" (
    ECHO.正在发送引导... & call log %logger% I 正在发送引导
    QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送引导失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 发送引导失败&& pause>nul && ECHO.重试... && goto CHKDDR-1)
ECHO.正在获取ddr类型... & call log %logger% I 正在获取ddr类型
::fh_loader.exe --port=\\.\COM%port% --memoryname=UFS --search_path=%framwork_workspace%\res --sendxml=%framwork_workspace%\res\chkddr.xml --noprompt 1>tmp\output.txt 2>&1 || type tmp\output.txt>>%logfile% && ECHOC {%c_e%}获取ddr类型失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 获取ddr类型失败&& pause>nul && ECHO.重试... && goto CHKDDR-1
edlcommand.exe COM%port% res\chkddr.xml 1>tmp\output.txt 2>&1 || type tmp\output.txt>>%logfile% && ECHOC {%c_e%}获取ddr类型失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 获取ddr类型失败&& pause>nul && ECHO.重试... && goto CHKDDR-1
type tmp\output.txt>>%logfile%
for /f "tokens=5 delims== " %%i in ('find " ddr_type=" "tmp\output.txt"') do set var=%%i
if "%var%"=="" ECHOC {%c_e%}获取ddr类型失败.{%c_h%}按任意键重试...{%c_i%}{\n}& call log %logger% E 获取ddr类型失败& pause>nul & ECHO.重试... & goto CHKDDR-1
set chkddrtype=%var:~1,1%
ECHO.ddr类型:%chkddrtype% & call log %logger% I ddr类型:%chkddrtype%
if not "%fh%"=="" (
    ECHO.重启9008... & call log %logger% I 重启9008
    ::edlcommand.exe COM%port% res\rebootedl.xml 1>>%logfile% 2>&1 || ECHOC {%c_e%}重启9008失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 重启9008失败&& pause>nul && ECHO.重试... && goto CHKDDR-1
    fh_loader.exe --port=\\.\COM%port% --memoryname=UFS --search_path=%framwork_workspace%\res --sendxml=rebootedl.xml --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}重启9008失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 重启9008失败&& pause>nul && ECHO.重试... && goto CHKDDR-1
    ::ECHO.重启9008按任意键继续... & pause
    call chkdev edl)
ENDLOCAL & set chkddr__type=%chkddrtype%
goto :eof


:CONFDEVPRE
SETLOCAL
set logger=opredl.bat-confdevpre
set num=2
if not exist ..\(*-*) copy /Y tool\Windows\ECHOC.exe tool\Windows\QSaharaServer.exe 1>nul 2>nul
:CONFDEVPRE-1
if %num% GTR 31 ECHOC {%c_e%}配置项目过多, 超出可容纳范围. 请QQ联系1330250642报告此问题.{%c_i%}{\n}& goto FATAL
for /f "tokens=%num% delims=[]," %%i in ('find "[product]" "conf\dev.csv"') do set name=%%i
if "%name%"=="done" goto CONFDEVPRE-2
for /f "tokens=%num% delims=," %%i in ('find "[%product%]" "conf\dev.csv"') do set value=%%i
call framwork conf dev-%product%.bat %name% %value%
set /a num+=1
goto CONFDEVPRE-1
:CONFDEVPRE-2
ENDLOCAL
call conf\dev-%product%.bat
goto :eof










:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)















::弃用


ECHO.请选择ddr类型.
ECHO.1.类型1   2.类型2
if not "%ddrtype%"=="1" (if not "%ddrtype%"=="2" call choice common [1][2])
if "%ddrtype%"=="1" call choice common #[1][2]
if "%ddrtype%"=="2" call choice common [1]#[2]
set ddrtype=%choice%
call framwork conf user.bat ddrtype %choice%








