::call pgem10 sendfh �˿ں�
::            


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%





:SENDFH
SETLOCAL
set logger=pgem10.bat-sendfh
set port=%var2%
call log %logger% I ���ձ���:port:%port%
:SENDFH-1
ECHO.���ڷ�������... & call log %logger% I ���ڷ�������
if not exist ..\(*-*) copy /Y res\oplus res\sig.dat 1>nul 2>nul
QSaharaServer.exe -p \\.\COM%port% -s 13:%framwork_workspace%\res\firehose.elf --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=ufs  --testvipimpact 1>>%logfile% 2>&1 || ECHOC {%c_e%}��������ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto SENDFH-1
call log %logger% I ���ڷ���Digest
fh_loader.exe --port=\\.\COM%port% --signeddigests=%framwork_workspace%\res\Digest.mbn --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=ufs --testvipimpact 1>>%logfile% 2>&1 || ECHOC {%c_e%}����Digestʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����Digestʧ��&& pause>nul && ECHO.����... && goto SENDFH-1
call log %logger% I ���ڷ�������
fh_loader.exe --port=\\.\COM%port% --sendxml=%framwork_workspace%\res\conf.xml 1>>%logfile% 2>&1 || ECHOC {%c_e%}��������ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto SENDFH-1
call log %logger% I ���ڷ���ǩ��
fh_loader.exe --port=\\.\COM%port% --signeddigests=%framwork_workspace%\res\sig.dat --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=ufs --testvipimpact 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ǩ��ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ǩ��ʧ��&& pause>nul && ECHO.����... && goto SENDFH-1
call log %logger% I �����������
ENDLOCAL
goto :eof

