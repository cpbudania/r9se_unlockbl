::call opredl confdevpre
::            sendfh      �˿ں�
::            chkddr      �˿ں�  ��������·��(��ѡ, �����򲻷���)

::start opredl getcurrentslot


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
goto %var1%






:GETCURRENTSLOT
::����һ�����ű�ʾ��,�밴�մ�ʾ���е�����������ɽű�������.
::����׼��,����Ķ�
chcp 936>nul
::��������,������Զ���������ļ�Ҳ���Լ�������
if exist conf\fixed.bat (call conf\fixed) else (ECHO.�Ҳ���conf\fixed.bat & goto FATAL)
if exist conf\user.bat call conf\user
if not "%product%"=="" (if exist conf\dev-%product%.bat call conf\dev-%product%.bat)
::��������,����Ķ�
if "%framwork_theme%"=="" set framwork_theme=default
call framwork theme %framwork_theme%
COLOR %c_i%
::�Զ��崰�ڴ�С,���԰�����Ҫ�Ķ�
TITLE ����������...
mode con cols=71
::���ͻ�ȡ����ԱȨ��,�粻��Ҫ����ȥ��
if not exist tool\Windows\gap.exe ECHO.�Ҳ���gap.exe & goto FATAL
if exist %windir%\System32\bff-test rd %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
md %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
rd %windir%\System32\bff-test 1>nul || start tool\Windows\gap.exe %0 && EXIT || EXIT
::����׼���ͼ��,����Ķ�
::call framwork startpre
call framwork startpre skiptoolchk
::�������.���������д��Ľű�
TITLE [�鿴��ǰ��λ] ŷ����9008���� �汾:%prog_ver% [��ѹ��� ��ֹ����]
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.�鿴��ǰ��λ
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHOC {%c_h%}�뽫�豸��������ϵͳ������USB����...{%c_i%}{\n}& call chkdev system rechk 3
call slot system chk
ECHO.
ECHO.��ǰ�豸���� %slot__cur% ��λ. ��Ӧ��ѡ��ض� %slot__cur% ��λ.
ECHO.
ECHO.���. �����������... & pause>nul & goto WRITE-CUSTOM


:SENDFH
SETLOCAL
set logger=opredl.bat-sendfh
set port=%var2%
call log %logger% I ���ձ���:port:%port%
if "%method:~0,7%"=="common-" set workfolder=%framwork_workspace%\res\firehose\common& goto SENDFH-COMMON
if "%method%"=="8gen2" set workfolder=%framwork_workspace%\res\firehose\8gen2& goto SENDFH-8GEN2
if "%method%"=="special" set workfolder=%framwork_workspace%\res\firehose\special& goto SENDFH-SPECIAL
if "%method%"=="special-token" set workfolder=%framwork_workspace%\res\firehose\special\%product%& goto SENDFH-SPECIAL-TOKEN
goto FATAL
:SENDFH-SPECIAL-TOKEN
call log %logger% I �豸ר������-��token
if "%chkddr_fh%"=="n" set fh=%workfolder%\firehose.elf
if "%chkddr_fh%"=="y" (if "%ddrtype%"=="auto" call opredl chkddr %port% %workfolder%\firehose_lite.elf)
if "%chkddr_fh%"=="y" (if "%ddrtype%"=="auto" set fh=%workfolder%\firehose_ddr%chkddr__type%.elf)
if "%chkddr_fh%"=="y" (if not "%ddrtype%"=="auto" set fh=%workfolder%\firehose_ddr%ddrtype%.elf)
ECHO.���ڷ�������... & call log %logger% I ���ڷ�������:%fh%
QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto SENDFH-SPECIAL-TOKEN
if exist %workfolder%\configure.xml (
    ECHO.���ڷ���configure.xml... & call log %logger% I ���ڷ���configure.xml
    fh_loader.exe --port=\\.\COM%port% --memoryname=UFS --search_path=%workfolder% --sendxml=configure.xml --noprompt 1>>%logfile% 2>&1 || call log %logger% E ����configure.xmlʧ��)
if exist %workfolder%\demacia.xml (
    ECHO.���ڷ���demacia.xml... & call log %logger% I ���ڷ���demacia.xml
    fh_loader.exe --port=\\.\COM%port% --memoryname=UFS --search_path=%workfolder% --sendxml=demacia.xml --noprompt 1>>%logfile% 2>&1 || call log %logger% E ����demacia.xmlʧ��)
if exist %workfolder%\setprojmodel.xml (
    ECHO.���ڷ���setprojmodel.xml... & call log %logger% I ���ڷ���setprojmodel.xml
    fh_loader.exe --port=\\.\COM%port% --memoryname=UFS --search_path=%workfolder% --sendxml=setprojmodel.xml --noprompt 1>>%logfile% 2>&1 || call log %logger% E ����setprojmodel.xmlʧ��)
goto SENDFH-DONE
:SENDFH-SPECIAL
call log %logger% I �豸ר������
if "%chkddr_fh%"=="n" set fh=%workfolder%\%product%.elf
if "%chkddr_fh%"=="y" (if "%ddrtype%"=="auto" call opredl chkddr %port% %workfolder%\%product%_lite.elf)
if "%chkddr_fh%"=="y" (if "%ddrtype%"=="auto" set fh=%workfolder%\%product%_ddr%chkddr__type%.elf)
if "%chkddr_fh%"=="y" (if not "%ddrtype%"=="auto" set fh=%workfolder%\%product%_ddr%ddrtype%.elf)
ECHO.���ڷ�������... & call log %logger% I ���ڷ�������:%fh%
QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto SENDFH-SPECIAL
goto SENDFH-DONE
:SENDFH-COMMON
call log %logger% I ͨ�÷���
set fh=%workfolder%\%method:~7,999%.elf
ECHO.���ڷ�������... & call log %logger% I ���ڷ�������:%fh%
QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto SENDFH-COMMON
goto SENDFH-DONE
:SENDFH-8GEN2
call log %logger% I 8Gen2����
ECHO.���ڷ�������... & call log %logger% I ���ڷ�������
QSaharaServer.exe -p \\.\COM%port% -s 13:%workfolder%\firehose.elf --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=ufs --testvipimpact 1>>%logfile% 2>&1 || ECHOC {%c_e%}��������ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto SENDFH-8GEN2
ECHO.���ڷ���Digest... & call log %logger% I ���ڷ���Digest
fh_loader.exe --port=\\.\COM%port% --signeddigests=%workfolder%\Digest.mbn --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=ufs --testvipimpact 1>>%logfile% 2>&1 || ECHOC {%c_e%}����Digestʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����Digestʧ��&& pause>nul && ECHO.����... && goto SENDFH-8GEN2
ECHO.���ڷ�������... & call log %logger% I ���ڷ�������
fh_loader.exe --port=\\.\COM%port% --sendxml=%workfolder%\conf.xml 1>>%logfile% 2>&1 || ECHOC {%c_e%}��������ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto SENDFH-8GEN2
ECHO.���ڷ���ǩ��... & call log %logger% I ���ڷ���ǩ��
fh_loader.exe --port=\\.\COM%port% --signeddigests=%workfolder%\sig.dat --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=ufs --testvipimpact 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ǩ��ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����ǩ��ʧ��&& pause>nul && ECHO.����... && goto SENDFH-8GEN2
goto SENDFH-DONE
:SENDFH-DONE
call log %logger% I �������ɶ�д���
ENDLOCAL
goto :eof


:CHKDDR
SETLOCAL
set logger=opredl.bat-chkddr
set port=%var2%& set fh=%var3%
call log %logger% I ���ձ���:port:%port%.fh:%fh%
:CHKDDR-1
ECHO.��ʼ���ddr & call log %logger% I ��ʼ���ddr
if not "%fh%"=="" (
    ECHO.���ڷ�������... & call log %logger% I ���ڷ�������
    QSaharaServer.exe -p \\.\COM%port% -s 13:%fh% --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}��������ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto CHKDDR-1)
ECHO.���ڻ�ȡddr����... & call log %logger% I ���ڻ�ȡddr����
::fh_loader.exe --port=\\.\COM%port% --memoryname=UFS --search_path=%framwork_workspace%\res --sendxml=%framwork_workspace%\res\chkddr.xml --noprompt 1>tmp\output.txt 2>&1 || type tmp\output.txt>>%logfile% && ECHOC {%c_e%}��ȡddr����ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡddr����ʧ��&& pause>nul && ECHO.����... && goto CHKDDR-1
edlcommand.exe COM%port% res\chkddr.xml 1>tmp\output.txt 2>&1 || type tmp\output.txt>>%logfile% && ECHOC {%c_e%}��ȡddr����ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡddr����ʧ��&& pause>nul && ECHO.����... && goto CHKDDR-1
type tmp\output.txt>>%logfile%
for /f "tokens=5 delims== " %%i in ('find " ddr_type=" "tmp\output.txt"') do set var=%%i
if "%var%"=="" ECHOC {%c_e%}��ȡddr����ʧ��.{%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡddr����ʧ��& pause>nul & ECHO.����... & goto CHKDDR-1
set chkddrtype=%var:~1,1%
ECHO.ddr����:%chkddrtype% & call log %logger% I ddr����:%chkddrtype%
if not "%fh%"=="" (
    ECHO.����9008... & call log %logger% I ����9008
    ::edlcommand.exe COM%port% res\rebootedl.xml 1>>%logfile% 2>&1 || ECHOC {%c_e%}����9008ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����9008ʧ��&& pause>nul && ECHO.����... && goto CHKDDR-1
    fh_loader.exe --port=\\.\COM%port% --memoryname=UFS --search_path=%framwork_workspace%\res --sendxml=rebootedl.xml --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}����9008ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����9008ʧ��&& pause>nul && ECHO.����... && goto CHKDDR-1
    ::ECHO.����9008�����������... & pause
    call chkdev edl)
ENDLOCAL & set chkddr__type=%chkddrtype%
goto :eof


:CONFDEVPRE
SETLOCAL
set logger=opredl.bat-confdevpre
set num=2
if not exist ..\(*-*) copy /Y tool\Windows\ECHOC.exe tool\Windows\QSaharaServer.exe 1>nul 2>nul
:CONFDEVPRE-1
if %num% GTR 31 ECHOC {%c_e%}������Ŀ����, ���������ɷ�Χ. ��QQ��ϵ1330250642���������.{%c_i%}{\n}& goto FATAL
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
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)















::����


ECHO.��ѡ��ddr����.
ECHO.1.����1   2.����2
if not "%ddrtype%"=="1" (if not "%ddrtype%"=="2" call choice common [1][2])
if "%ddrtype%"=="1" call choice common #[1][2]
if "%ddrtype%"=="2" call choice common [1]#[2]
set ddrtype=%choice%
call framwork conf user.bat ddrtype %choice%








