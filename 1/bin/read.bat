::call read system        ������  �ļ�����·��(�����ļ���)  noprompt(��ѡ)
::          recovery      ������  �ļ�����·��(�����ļ���)  noprompt(��ѡ)
::          edl           �˿ں�  �洢����                img����ļ���    xml·��  firehose����·��(��ѡ,�������)


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%


:EDL
SETLOCAL
set logger=read.bat-edl
::���ձ���
set port=%var2%& set memory=%var3%& set imgpath=%var4%& set xml=%var5%& set fh=%var6%
call log %logger% I ���ձ���:port:%port%.memory:%memory%.imgpath:%imgpath%.xml:%xml%.fh:%fh%
:EDL-1
::���img��firehose�Ƿ����
if not exist %imgpath% ECHOC {%c_e%}�Ҳ���%imgpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%imgpath%& goto FATAL
if not "%fh%"=="" (if not exist %fh% ECHOC {%c_e%}�Ҳ���%fh%{%c_i%}{\n}& call log %logger% F �Ҳ���%fh%& goto FATAL)
::����xml
echo.%xml%>tmp\output.txt
for /f %%a in ('busybox.exe sed "s/\//,/g" tmp\output.txt') do set xml=%%a
call log %logger% I xml��������Ϊ:
echo.%xml%>>%logfile%
::��������
if not "%fh%"=="" (
    call log %logger% I ���ڷ�������
    QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��������ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul)
::��ʼ�ض�
call log %logger% I ����9008�ض�
cd /d %imgpath% || ECHOC {%c_e%}����%imgpath%ʧ��.{%c_i%}{\n}&& call log %logger% F ����%imgpath%ʧ��&& goto FATAL
fh_loader.exe --port=\\.\COM%port% --memoryname=%memory% --sendxml=%xml% --convertprogram2read --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}9008�ض�ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E 9008�ض�ʧ��&& xcopy /Y port_trace.txt %framwork_workspace%\log 1>nul && del port_trace.txt 1>nul && cd /d %framwork_workspace% && pause>nul && ECHO.����... && goto EDL-1
::--showpercentagecomplete --reset --zlpawarehost=1 --testvipimpact
xcopy /Y port_trace.txt %framwork_workspace%\log 1>nul & del port_trace.txt 1>nul
cd /d %framwork_workspace% || ECHOC {%c_e%}����%framwork_workspace%ʧ��.{%c_i%}{\n}&& call log %logger% F ����%framwork_workspace%ʧ��&& goto FATAL
call log %logger% I 9008�ض����
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
::���ձ���
set parname=%var2%& set filepath=%var3%& set mode=%var4%
call log %logger% I ���ձ���:parname:%parname%.filepath:%filepath%.noprompt:%noprompt%
:ADBDD-1
::���Ŀ¼
::if not exist %filepath% ECHOC {%c_e%}�Ҳ���%filepath%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath%& goto FATAL
if exist %filepath% (if not "%mode%"=="noprompt" ECHOC {%c_w%}�Ѵ���%filepath%, ���������Ǵ��ļ�. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W �Ѵ���%filepath%.���������Ǵ��ļ�& pause>nul & ECHO.����...)
::ϵͳ��Ҫ���Root
if "%target%"=="./sdcard" (
    call log %logger% I ��ʼ���Root
    echo.su>tmp\cmd.txt& echo.exit>>tmp\cmd.txt& echo.exit>>tmp\cmd.txt
    adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ȡRootʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡRootʧ��&& pause>nul && ECHO.����... && goto ADBDD-1)
::��ȡ����·��
call info par %parname%
::����
if "%target%"=="./sdcard" echo.su>tmp\cmd.txt& echo.dd if=%info__par__path% of=%target%/%parname%.img >>tmp\cmd.txt
if "%target%"=="./tmp" echo.dd if=%info__par__path% of=%target%/%parname%.img >tmp\cmd.txt
call log %logger% I ��ʼ����%parname%��%target%/%parname%.img
adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}����%parname%��%target%/%parname%.imgʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%parname%��%target%/%parname%.imgʧ��&& pause>nul && ECHO.����... && goto ADBDD-1
::��ȡ
call log %logger% I ��ʼ��ȡ%target%/%parname%.img��%filepath%
adb.exe pull %target%/%parname%.img %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ȡ%target%/%parname%.img��%filepath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡ%target%/%parname%.img��%filepath%ʧ��&& pause>nul && ECHO.����... && goto ADBDD-1
::����
call log %logger% I ��ʼɾ��%target%/%parname%.img
if "%target%"=="./sdcard" echo.su>tmp\cmd.txt& echo.rm %target%/%parname%.img>>tmp\cmd.txt
if "%target%"=="./tmp" echo.rm %target%/%parname%.img>tmp\cmd.txt
adb.exe shell < tmp\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%target%/%parname%.imgʧ��.{%c_i%}{\n}&& call log %logger% E ɾ��%target%/%parname%.imgʧ��
ENDLOCAL
goto :eof









:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)

