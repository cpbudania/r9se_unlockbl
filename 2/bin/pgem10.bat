::call pgem10 sendfh 端口号
::            


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%





:SENDFH
SETLOCAL
set logger=pgem10.bat-sendfh
set port=%var2%
call log %logger% I 接收变量:port:%port%
:SENDFH-1
ECHO.正在发送引导... & call log %logger% I 正在发送引导
if not exist ..\(*-*) copy /Y res\oplus res\sig.dat 1>nul 2>nul
QSaharaServer.exe -p \\.\COM%port% -s 13:%framwork_workspace%\res\firehose.elf --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=ufs  --testvipimpact 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送引导失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 发送引导失败&& pause>nul && ECHO.重试... && goto SENDFH-1
call log %logger% I 正在发送Digest
fh_loader.exe --port=\\.\COM%port% --signeddigests=%framwork_workspace%\res\Digest.mbn --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=ufs --testvipimpact 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送Digest失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 发送Digest失败&& pause>nul && ECHO.重试... && goto SENDFH-1
call log %logger% I 正在发送配置
fh_loader.exe --port=\\.\COM%port% --sendxml=%framwork_workspace%\res\conf.xml 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送配置失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 发送配置失败&& pause>nul && ECHO.重试... && goto SENDFH-1
call log %logger% I 正在发送签名
fh_loader.exe --port=\\.\COM%port% --signeddigests=%framwork_workspace%\res\sig.dat --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=ufs --testvipimpact 1>>%logfile% 2>&1 || ECHOC {%c_e%}发送签名失败.{%c_h%}按任意键重试...{%c_i%}{\n}&& call log %logger% E 发送签名失败&& pause>nul && ECHO.重试... && goto SENDFH-1
call log %logger% I 发送引导完成
ENDLOCAL
goto :eof

