::����һ�����ű�ʾ��,�밴�մ�ʾ���е�����������ɽű�������.

::����׼��,����Ķ�
@ECHO OFF
chcp 936>nul
cd /d %~dp0
if exist bin (cd bin) else (ECHO.�Ҳ���bin & goto FATAL)

::��������,������Զ���������ļ�Ҳ���Լ�������
if exist conf\fixed.bat (call conf\fixed) else (ECHO.�Ҳ���conf\fixed.bat & goto FATAL)
if exist conf\user.bat call conf\user

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
call framwork startpre
::call framwork startpre skiptoolchk

::�������.���������д��Ľű�
TITLE [��ȫ���] OPPOFindX6Proˢ�������� �汾:%prog_ver% ����:�ᰲ@ĳ��
CLS
goto MENU



:MENU
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.���˵�
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.���������� �ᰲ@mi��������ߡ�  �ű�����: �ᰲ@ĳ��
ECHO.��������ȫ���, ��ֹ����. ˢ����Ը, �����Ը�, �����򲻻����������豸, Ҳ��Ϊ�κο��ܷ��������⸺��.
ECHO.
ECHO.����״̬ǿ�ƹػ�����: ������Դ����������.
ECHO.����9008: �ػ�״̬��ס�����Ӽ����ӵ���.
ECHO.
ECHO.
ECHO.0.ˢ��ָ�� (����ˢ���ؿ�)
ECHO.1.����BL
ECHO.2.ˢ��TWRP
ECHO.3.��ȡRoot
ECHO.4.ŷ���湤����-9008��ש�ض���ع��� (����:f65u)
ECHO.5.����BL (������)
ECHO.
ECHO.A.������ (����:8o8k)
ECHO.B.ˢ����Դ����
ECHO.C.ˢ������
ECHO.D.����QQȺ��
ECHO.E.�����ƺ�Ⱥ��
ECHO.F.����BFF
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
ECHO.��ȡRoot
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.Root�ǰ�׿ϵͳ�����Ȩ��. ��ȡRoot���ӵ���˲鿴, �޸��ֻ�ϵͳ��Ȩ��.
ECHO.�˹�����Ҫ��TWRP��ʹ��. ���Ƚ���TWRP.
ECHO.
ECHO.
ECHO.1.ˢ��Magisk26.4 (�ٷ����)
ECHO.
ECHO.2.ˢ��MagiskDelta26.1 (�������)
ECHO.
ECHO.A.ˢ���Զ���Magisk (֧��zip��apk)
ECHO.
ECHO.B.�������˵�
ECHO.
call choice common [1][2][A][B]
if "%choice%"=="1" set target=..\Magisk26.4.apk
if "%choice%"=="2" set target=..\MagiskDelta26.1.apk
if "%choice%"=="A" ECHO.��ѡ��Magisk��ˢ����apk... & call sel file s %framwork_workspace%\.. [zip][apk]
if "%choice%"=="A" set target=%sel__file_path%
if "%choice%"=="B" goto MENU
ECHO.�����TWRP... & call chkdev recovery rechk 3
ECHO.����λ... & call slot recovery chk
ECHO.����init_boot_%slot__cur%...
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
call read recovery init_boot_%slot__cur% bak\init_boot\init_boot.img noprompt
copy /Y bak\init_boot\init_boot.img bak\init_boot\init_boot_%var%.img 1>nul
ECHO.init_boot_%slot__cur%�Ѿ����ݵ�bak\init_boot\init_boot_%var%.img
start framwork logviewer start %logfile%
ECHO.ˢ��%target%... & call write twrpinst %target%
ECHO.
ECHO.���. �ű��޷��ж��Ƿ�ɹ�, �������־�򿪻������ж�. ����޷�����, ����ʹ���Զ����ݵ�init_boot�ָ�. �����������... & pause>nul & goto MENU


:FLASHTWRP
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.ˢ��TWRP
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.TWRP��һ�ֵ�����Recoveryģʽ, ��ˢ�����ɻ�ȱ�Ĺ���.
ECHO.
ECHO.
ECHO.1.ˢ��TWRP-13-OPlus_SM8550-Color597-V1.1-by_�ᰲ@Col_or
ECHO.
ECHO.A.ˢ���Զ���Recovery
ECHO.
ECHO.B.���ظ���TWRP
ECHO.
ECHO.C.��ע��֧�� �ᰲ@Col_or
ECHO.
ECHO.D.�������˵�
ECHO.
call choice common [1][A][B][C]
if "%choice%"=="1" set target=%framwork_workspace%\res\TWRP-13-OPlus_SM8550-Color597-V1.1-by_�ᰲ@Col_or
::if "%choice%"=="2" set target=%framwork_workspace%\res\OrangeFox-R11.1-Unofficial-salami-V2
::if "%choice%"=="3" set target=%framwork_workspace%\res\TWRP-3.7.0-salami-13-09-23
::if "%choice%"=="4" set target=%framwork_workspace%\res\С��TWRP
if "%choice%"=="A" ECHO.��ѡ��recovery.img... & call sel file s %framwork_workspace%\.. [img]
if "%choice%"=="A" ECHO.����׼��recovery... & copy /Y %sel__file_path% tmp\recovery.img 1>nul & set target=%framwork_workspace%\tmp
if "%choice%"=="B" call open common https://www.123pan.com/s/8eP9-1WvGA.html & goto FLASHTWRP
if "%choice%"=="C" (
    call open common "https://www.coolapk.com/feed/49392957?shareKey=YjMyYjNmOGMyYzhkNjUxMjc5NjA~&shareUid=3463951&shareFrom=com.coolapk.market_13.3.4"
    call open common http://www.coolapk.com/u/642425
    call open common https://afdian.net/a/color597
    goto FLASHTWRP)
if "%choice%"=="D" goto MENU
ECHO.�����9008... & call chkdev edl rechk 1
call pgem10 sendfh %chkdev__edl__port%
ECHO.ˢ��...
call write edl %chkdev__edl__port% UFS %target% %framwork_workspace%\res\recovery_a.xml
call write edl %chkdev__edl__port% UFS %target% %framwork_workspace%\res\recovery_b.xml
copy /Y tool\Android\misc_torecovery.img tmp\misc.img 1>nul
call write edl %chkdev__edl__port% UFS %framwork_workspace%\tmp %framwork_workspace%\res\misc.xml
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
ECHO.���. ������������Գ��Ը���Recovery��ָ��ٷ�Recovery. �����������... & pause>nul & goto MENU


:UNLOCKBL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.����BL
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.����BL���ܻᵼ����������:
ECHO.-�ֻ����������ݱ��������
ECHO.-ʧȥ�ٷ�����
ECHO.-�޷�ʹ��ָ��֧��
ECHO.-TEE������Ӳ����������
ECHO.-Netflix APPֻ�ܹۿ�640P������
ECHO.-С�������޷��󶨺���, ����, ���
ECHO.-�������������Ƿǳ�Σ�յ���Ϊ, ���ܵ����ֻ���ש
ECHO.-...
ECHO.
ECHO.����BLǰ����������׼��:
ECHO.-ȷ������ֻ���OPPOFindX6Pro
ECHO.-�ֻ��رղ����ֻ�, �˳�OPPO�˻�, ȡ����������
ECHO.-���ֻ����������ݱ��ݵ�������, ������Ƭ, ��Ƶ, ¼��, �����¼��
ECHO.-����������ģʽ, �ڿ�����ѡ���п���OEM������USB����
ECHO.-׼���ܴ����ļ���������, ���԰�װˢ������
ECHO.
ECHO.�������������ϸ�����ʾ����, ���۳ɹ�ʧ�ܶ�����������������, ��Ҫ��;�˳�, �������Ը�.
ECHO.
ECHO.
ECHO.֪������˵��, �밴�������ʼ����... & pause>nul
ECHO.
ECHO.�뿪�����ӵ��Բ�����USB����... & call chkdev system rechk 1
ECHO.����豸��Ϣ...
call info adb
if not "%info__adb__product%"=="OP528BL1" ECHOC {%c_e%}����豸(%info__adb__product%)����OPPOFindX6Pro(OP528BL1). ������ֻ֧��OPPOFindX6Pro. {%c_i%}�����ȷ�ϻ�������, �밴���������...{%c_i%}{\n}& pause>nul & ECHO.����...
call slot system chk
ECHO.��׿�汾: %info__adb__androidver%   ��ǰ��λ: %slot__cur%
ECHO.
ECHOC {%c_h%}��ͬʱ��ס�ֻ������Ӽ�, Ȼ���ڵ����ϰ����������. ֮���뱣�ֳ���ֱ���ű���⵽9008����������...{%c_i%}{\n} & pause>nul
adb.exe reboot bootloader 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && goto UNLOCKBL
ECHOC {%c_w%}ע��: �������9008����. ���10����û�м�鵽����, �ֻ�û�к���, ��������������������������ģʽ��, ��رձ��ű����´�.{%c_i%}{\n}
call chkdev edl rechk 1
ECHO.(���������������)
call pgem10 sendfh %chkdev__edl__port%
ECHO.����ocdt...
if exist bak\ocdt\oplus del bak\ocdt\oplus 1>nul
call read edl %chkdev__edl__port% UFS %framwork_workspace%\bak\ocdt %framwork_workspace%\res\ocdt.xml
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
copy /Y bak\ocdt\oplus bak\ocdt\oplus_%var% 1>nul
ECHO.����abl_%slot__cur%...
if exist bak\abl\abl.elf del bak\abl\abl.elf 1>nul
call read edl %chkdev__edl__port% UFS %framwork_workspace%\bak\abl %framwork_workspace%\res\abl_%slot__cur%.xml
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
copy /Y bak\abl\abl.elf bak\abl\abl_%var%.elf 1>nul
ECHO.ˢ��ocdt... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\ocdt.xml
::ֻ�а�׿13��ˢabl
if not "%info__adb__androidver%"=="13" ECHO.ˢ��abl_%slot__cur%... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\abl_%slot__cur%.xml
ECHO.������Fastboot...
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
:UNLOCKBL-1
ECHOC {%c_h%}���ֶ����Fastboot����. {%c_i%}�ڽ�����һ��֮ǰ���𰴶��ֻ�����.{%c_i%}{\n}
ECHO.1.���Fastboot����   2.��μ���Լ�鲻��
call choice common #[1][2]
ECHO.
if "%choice%"=="1" fastboot.exe devices 2>&1 | find "fastboot" 1>nul 2>nul || ECHOC {%c_e%}�豸δ���ӻ�����δ��װ.{%c_i%}{\n}&& goto UNLOCKBL-1
if "%choice%"=="2" goto UNLOCKBL-FAILED
call chkdev fastboot
ECHO.������״̬... & call info fastboot
if "%info__fastboot__unlocked%"=="yes" ECHOC {%c_i%}����豸�ѽ���BL, �����ظ�����. ��Ϊ��ָ��豸. {%c_h%}����չ������ļ�Ŀ¼�е��ĵ��ֶ�����9008.{%c_i%}{\n}& goto UNLOCKBL-RECOVER
ECHO.ִ�н�������... & fastboot.exe flashing unlock 1>>%logfile% 2>&1
ECHO.
ECHOC {%c_h%}�����밴����������ѡ��UNLOCK, Ȼ��һ�µ�Դ��ȷ��, Ȼ������ͬʱ��ס�����Ӽ�(�ٶ�Ҫ��), ֱ���ű���⵽9008����������.{%c_i%}{\n}
ECHO.���δ�ܼ�ʱ����, �ֻ����޷��Զ�����9008. ��ʱ����չ������ļ�Ŀ¼�е��ĵ��ֶ�����9008.
ECHO.
goto UNLOCKBL-RECOVER
:UNLOCKBL-FAILED
ECHOC {%c_e%}����BLʧ��. {%c_i%}��Ϊ��ָ��ֻ�. �밴��ʾ��������. �Ժ������QQ��ϵ1330250642����������.{%c_i%}{\n}
ECHOC {%c_h%}����չ������ļ�Ŀ¼�е��ĵ��ֶ�����9008.{%c_i%}{\n}
goto UNLOCKBL-RECOVER
:UNLOCKBL-RECOVER      
call chkdev edl rechk 1
call pgem10 sendfh %chkdev__edl__port%
ECHO.�ָ�ocdt... &            call write edl %chkdev__edl__port% UFS %framwork_workspace%\bak\ocdt %framwork_workspace%\res\ocdt.xml
ECHO.�ָ�abl_%slot__cur%... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\bak\abl  %framwork_workspace%\res\abl_%slot__cur%.xml
ECHO.������Recovery...
copy /Y tool\Android\misc_torecovery.img tmp\misc.img 1>>%logfile% 2>&1
call write edl %chkdev__edl__port% UFS %framwork_workspace%\tmp %framwork_workspace%\res\misc.xml
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
ECHO.ȫ�����. �ֻ����Զ��������ٷ�Recovery. ���ֶ�������ݸ�ʽ��data�ٿ���. �����󿪻����ֻ򲻳��ֻ�ɫ���涼����������. ����������ֻ��޷�����, �򿪻������ĳЩ����, ���Գ��Խ���ٷ�Recovery������ݻָ������ٿ���. �����������... & pause>nul & goto MENU


:LOCKBL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.����BL
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.�������������Ƿǳ�Σ�յ���Ϊ, ���ܵ����ֻ���ש. ���Ǳ�Ҫ, ������������. ������ɵ��κ����������Ը�.
ECHO.
ECHO.
ECHO.����BLǰ����������׼��:
ECHO.-ȷ������ֻ���OPPOFindX6Pro
ECHO.-�ֻ��رղ����ֻ�, �˳�OPPO�˻�, ȡ����������
ECHO.-���ֻ����������ݱ��ݵ�������, ������Ƭ, ��Ƶ, ¼��, �����¼��
ECHO.-��ȫ�ָ��ٷ�ϵͳ (�Ƽ�ʹ�����Լ�����ǰ���ֿⱸ��, û�еĻ�Ҳ����ˢһ�¹ٷ������߹ٷ�����һ��ϵͳ)
ECHO.-׼���ܴ����ļ���������, ���԰�װˢ������
ECHO.
ECHO.�������������ϸ�����ʾ����, ���۳ɹ�ʧ�ܶ�����������������, ��Ҫ��;�˳�, �������Ը�.
ECHO.
ECHO.
ECHO.֪������˵��, �밴�������ʼ����... & pause>nul
ECHO.
ECHO.�뿪�����ӵ��Բ�����USB����... & call chkdev system rechk 1
ECHO.����豸��Ϣ...
call info adb
if not "%info__adb__product%"=="OP528BL1" ECHOC {%c_e%}����豸(%info__adb__product%)����OPPOFindX6Pro(OP528BL1). ������ֻ֧��OPPOFindX6Pro. {%c_i%}�����ȷ�ϻ�������, �밴���������...{%c_i%}{\n}& pause>nul & ECHO.����...
call slot system chk
ECHO.��׿�汾: %info__adb__androidver%   ��ǰ��λ: %slot__cur%
ECHO.
ECHOC {%c_h%}��ͬʱ��ס�ֻ������Ӽ�, Ȼ���ڵ����ϰ����������. ֮���뱣�ֳ���ֱ���ű���⵽9008����������...{%c_i%}{\n} & pause>nul
adb.exe reboot bootloader 1>>%logfile% 2>&1 || ECHOC {%c_e%}����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && goto LOCKBL
ECHOC {%c_w%}ע��: �������9008����. ���10����û�м�鵽����, �ֻ�û�к���, ��������������������������ģʽ��, ��رձ��ű����´�.{%c_i%}{\n}
call chkdev edl rechk 1
ECHO.(���������������)
call pgem10 sendfh %chkdev__edl__port%
ECHO.����ocdt...
if exist bak\ocdt\oplus del bak\ocdt\oplus 1>nul
call read edl %chkdev__edl__port% UFS %framwork_workspace%\bak\ocdt %framwork_workspace%\res\ocdt.xml
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
copy /Y bak\ocdt\oplus bak\ocdt\oplus_%var% 1>nul
ECHO.����abl_%slot__cur%...
if exist bak\abl\abl.elf del bak\abl\abl.elf 1>nul
call read edl %chkdev__edl__port% UFS %framwork_workspace%\bak\abl %framwork_workspace%\res\abl_%slot__cur%.xml
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
copy /Y bak\abl\abl.elf bak\abl\abl_%var%.elf 1>nul
ECHO.ˢ��ocdt... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\ocdt.xml
::ֻ�а�׿13��ˢabl
if not "%info__adb__androidver%"=="13" ECHO.ˢ��abl_%slot__cur%... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\abl_%slot__cur%.xml
ECHO.������Fastboot...
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
:LOCKBL-1
ECHOC {%c_h%}���ֶ����Fastboot����. {%c_i%}�ڽ�����һ��֮ǰ���𰴶��ֻ�����.{%c_i%}{\n}
ECHO.1.���Fastboot����   2.��μ���Լ�鲻��
call choice common #[1][2]
ECHO.
if "%choice%"=="1" fastboot.exe devices 2>&1 | find "fastboot" 1>nul 2>nul || ECHOC {%c_e%}�豸δ���ӻ�����δ��װ.{%c_i%}{\n}&& goto LOCKBL-1
if "%choice%"=="2" goto LOCKBL-FAILED
call chkdev fastboot
ECHO.���BL��״̬... & call info fastboot
if "%info__fastboot__unlocked%"=="no" ECHOC {%c_i%}����豸������BL, �����ظ�����. ��Ϊ��ָ��豸. {%c_h%}����չ������ļ�Ŀ¼�е��ĵ��ֶ�����9008.{%c_i%}{\n}& goto LOCKBL-RECOVER
ECHO.ִ����������... & fastboot.exe flashing lock 1>>%logfile% 2>&1
ECHO.
ECHOC {%c_h%}�����밴����������ѡ��LOCK, Ȼ��һ�µ�Դ��ȷ��, Ȼ������ͬʱ��ס�����Ӽ�(�ٶ�Ҫ��), ֱ���ű���⵽9008����������.{%c_i%}{\n}
ECHO.���δ�ܼ�ʱ����, �ֻ����޷��Զ�����9008. ��ʱ����չ������ļ�Ŀ¼�е��ĵ��ֶ�����9008.
ECHO.
goto LOCKBL-RECOVER
:LOCKBL-FAILED
ECHOC {%c_e%}����BLʧ��. {%c_i%}��Ϊ��ָ��ֻ�. �밴��ʾ��������. �Ժ������QQ��ϵ1330250642����������.{%c_i%}{\n}
ECHOC {%c_h%}����չ������ļ�Ŀ¼�е��ĵ��ֶ�����9008.{%c_i%}{\n}
goto LOCKBL-RECOVER
:LOCKBL-RECOVER      
call chkdev edl rechk 1
call pgem10 sendfh %chkdev__edl__port%
ECHO.�ָ�ocdt... &            call write edl %chkdev__edl__port% UFS %framwork_workspace%\bak\ocdt %framwork_workspace%\res\ocdt.xml
ECHO.�ָ�abl_%slot__cur%... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\bak\abl  %framwork_workspace%\res\abl_%slot__cur%.xml
ECHO.������Recovery...
copy /Y tool\Android\misc_torecovery.img tmp\misc.img 1>>%logfile% 2>&1
call write edl %chkdev__edl__port% UFS %framwork_workspace%\tmp %framwork_workspace%\res\misc.xml
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
ECHO.ȫ�����. �ֻ����Զ��������ٷ�Recovery. ���ֶ�������ݸ�ʽ��data�ٿ���. ����������ֻ��޷�����, �򿪻������ĳЩ����, ���Գ��Խ���ٷ�Recovery������ݻָ������ٿ���. �����������... & pause>nul & goto MENU














:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)














::����


