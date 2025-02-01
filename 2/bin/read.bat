::call read system        分区名  文件保存路径(包括文件名)  noprompt(可选)
::          recovery      分区名  文件保存路径(包括文件名)  noprompt(可选)
::          edl           端口号  存储类型                img存放文件夹    xml路径  firehose完整路径(可选,不填不发送)


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:EDL
SETLOCAL
set logger=read.bat-edl
::接收变量
set port=%var2%& set memory=%var3%& set imgpath=%var4%& set xml=%var5%& set fh=%var6%
call log %logger% I 接收变量:port:%port%.memory:%memory%.imgpath:%imgpath%.xml:%xml%.fh:%fh%
:EDL-1
::检查img和firehose是否存在
if not exist %imgpath% ECHOC {%c_e%}找不到%imgpath%{%c_i%}{\n}& call log %logger% F 找不到%imgpath%& goto FATAL
if not "%fh%"=="" (if not exist %fh% ECHOC {%c_e%}找不到%fh%{%c_i%}{\n}& call log %logger% F 找不到%fh%& goto FATAL)
::处理xml
echo.%xml%>tmp\output.txt
for /f %%a in ('busybox.exe sed "s/\//,/g" tmp\output.txt') do set xml=%%a
call log %logger% I xml参数更新为:
echo.%xml%>>%logfile%
::发送引导
if not "%fh%"=="" (
    call log %logger% I 正在发送引导
    QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送引导失败.{%c_h%}按任意键继续...{%c_i%}{\n}&& call log %logger% E 发送引导失败&& pause>nul)
::开始回读
call log %logger% I 正在9008回读
cd /d %imgpath% || ECHOC {%c_e%}进入%imgpath%失败.{%c_i%}{\n}&& call log %logger% F 进入%imgpath%失败&& goto FATAL
fh_loader.exe --port=\\.\COM%port% --memoryname=%memory% --sendxml=%xml% --convertprogram2read --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}9008回读失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 9008回读失败&& xcopy /Y port_trace.txt %framwork_workspace%\log 1>nul && del port_trace.txt 1>nul && cd /d %framwork_workspace% && pause>nul && ECHO.重试... && goto EDL-1
::--showpercentagecomplete --reset --zlpawarehost=1 --testvipimpact
xcopy /Y port_trace.txt %framwork_workspace%\log 1>nul & del port_trace.txt 1>nul
cd /d %framwork_workspace% || ECHOC {%c_e%}进入%framwork_workspace%失败.{%c_i%}{\n}&& call log %logger% F 进入%framwork_workspace%失败&& goto FATAL
call log %logger% I 9008回读完成
ENDLOCAL
goto :eof


:SYSTEM
SETLOCAL
set logger=read.bat-system
set target=./sdcard
goto ADBDD


:RECOVERY
SETLOCAL
set logger=read.bat-recovery
set target=./tmp
goto ADBDD


:ADBDD
::接收变量
set parname=%var2%& set filepath=%var3%& set mode=%var4%
call log %logger% I 接收变量:parname:%parname%.filepath:%filepath%.noprompt:%noprompt%
:ADBDD-1
::检查目录
::if not exist %filepath% ECHOC {%c_e%}找不到%filepath%{%c_i%}{\n}& call log %logger% F 找不到%filepath%& goto FATAL
if exist %filepath% (if not "%mode%"=="noprompt" ECHOC {%c_w%}已存在%filepath%, 继续将覆盖此文件. {%c_h%}按任意键继续...{%c_i%}{\n}& call log %logger% W 已存在%filepath%.继续将覆盖此文件& pause>nul & ECHO.继续...)
::系统下要检查Root
if "%target%"=="./sdcard" (
    call log %logger% I 开始检查Root
    echo.su>tmp\cmd.txt& echo.exit>>tmp\cmd.txt& echo.exit>>tmp\cmd.txt
    adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}获取Root失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 获取Root失败&& pause>nul && ECHO.重试... && goto ADBDD-1)
::获取分区路径
call info par %parname%
::读出
if "%target%"=="./sdcard" echo.su>tmp\cmd.txt& echo.dd if=%info__par__path% of=%target%/%parname%.img >>tmp\cmd.txt
if "%target%"=="./tmp" echo.dd if=%info__par__path% of=%target%/%parname%.img >tmp\cmd.txt
call log %logger% I 开始读出%parname%到%target%/%parname%.img
adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}读出%parname%到%target%/%parname%.img失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 读出%parname%到%target%/%parname%.img失败&& pause>nul && ECHO.重试... && goto ADBDD-1
::拉取
call log %logger% I 开始拉取%target%/%parname%.img到%filepath%
adb.exe pull %target%/%parname%.img %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}拉取%target%/%parname%.img到%filepath%失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 拉取%target%/%parname%.img到%filepath%失败&& pause>nul && ECHO.重试... && goto ADBDD-1
::清理
call log %logger% I 开始删除%target%/%parname%.img
if "%target%"=="./sdcard" echo.su>tmp\cmd.txt& echo.rm %target%/%parname%.img>>tmp\cmd.txt
if "%target%"=="./tmp" echo.rm %target%/%parname%.img>tmp\cmd.txt
adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}删除%target%/%parname%.img失败.{%c_i%}{\n}&& call log %logger% E 删除%target%/%parname%.img失败
ENDLOCAL
goto :eof









:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)

