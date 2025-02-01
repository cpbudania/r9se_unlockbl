::更改了以下脚本:
::framwork.bat

::这是一个主脚本示例,请按照此示例中的启动过程完成脚本的启动.

::常规准备,请勿改动
@ECHO OFF
chcp 936>nul
cd /d %~dp0
if exist bin (cd bin) else (ECHO.找不到bin & goto FATAL)

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
TITLE [未选择机型] 欧加真9008工具 版本:%prog_ver%
if "%product%"=="" goto SELDEV
if not exist conf\dev-%product%.bat goto SELDEV
if "%chkddr_fh%"=="y" (if "%ddrtype%"=="" goto SELDEV)
if "%chkddr_img%"=="y" (if "%ddrtype%"=="" goto SELDEV)
goto MENU



:MENU
TITLE [%model%] 欧加真9008工具 版本:%prog_ver% [免费工具 禁止倒卖]
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.主菜单
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.【方案来自 酷安@mi搞机爱好者】  脚本作者: 酷安@某贼
ECHO.进入9008方法: 关机状态按住音量加减连接电脑, 或进入官方Recovery连续点击版本号.
ECHO.强制重启方法: 长按电源键或长按电源键和音量加.
ECHO.9008发送引导卡住, 发送引导失败解决方法: 强制重启, 重新进入9008, 重试.
ECHO.9008不会上锁BL. 所有回读备份功能不涉及BL解锁状态和用户数据相关分区.
ECHO.
if "%method%"=="special-token" (if "%flash_pk%"=="" ECHOC {%c_e%}你尚未设置刷机密钥. 部分功能无法正常使用. 请先使用"输入刷机密钥"功能.{%c_i%}{\n})
ECHO.当前机型: %model%   若机型不正确请先选择更换机型, 否则后果自负.
if "%chkddr_fh%"=="y" ECHO.ddr类型: %ddrtype%
ECHO.
ECHO.
ECHO.0.测试发送引导
ECHO.1.刷入-完整包     (刷入9008包)
ECHO.2.刷入-全分区备份 (恢复字库)
ECHO.3.刷入-指定分区
ECHO.4.擦除-指定分区
ECHO.A.回读-完整包     (制作9008包)
ECHO.B.回读-全分区备份 (备份字库)
ECHO.C.回读-指定分区
ECHO.
ECHO.11.下载9008线刷包
ECHO.22.ADB投屏
ECHO.33.输入刷机密钥
if "%chkddr_fh%"=="y" (ECHO.44.选择\更换机型, 更改ddr类型) else (ECHO.44.选择\更换机型)
ECHO.55.检查更新 (密码:f65u)
ECHO.66.刷机驱动
ECHO.77.关于BFF
ECHO.88.加入群聊
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
if "%choice%"=="22" call scrcpy 欧加真9008工具-ADB投屏
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
ECHO.[%model%] 输入刷机密钥
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
if not "%method%"=="special-token" ECHOC {%c_i%}%model%无需此功能. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& pause>nul & goto MENU
ECHO.对于部分一加机型, 需要获取刷机密钥才能使用欧加真工具9008刷机. 理论上每个机器的密钥不同, 可以长期使用.
ECHO.
ECHO.
ECHO.1.手动输入
::ECHO.2.自动获取(尚未完成)
ECHO.A.如何手动抓取刷机密钥(新手必看)
ECHO.B.返回主菜单
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
ECHO.请在弹出的窗口中输入刷机密钥... & start /wait opredl_token.exe
if not exist tmp\token.bat ECHOC {%c_e%}程序没有成功启动或没有正确关闭. {%c_h%}按任意键重试...{%c_i%}{\n}& pause>nul & ECHO.重试... & goto INPUTTOKEN-INPUT
ECHO.写入刷机密钥...
call tmp\token.bat
if not "%demacia_token%"=="" (
        busybox.exe sed -i "s/\"/#/g" res\firehose\special\%product%\demacia.xml
        busybox.exe sed -i "s/ token=#[^#]*#/ token=#%demacia_token%#/g" res\firehose\special\%product%\demacia.xml
        busybox.exe sed -i "s/#/\"/g" res\firehose\special\%product%\demacia.xml
        call framwork conf dev-%product%.bat demacia_token %demacia_token%
    ) else (ECHO.未输入 demacia_token. 跳过...)
if not "%demacia_pk%"=="" (
        busybox.exe sed -i "s/\"/#/g" res\firehose\special\%product%\demacia.xml
        busybox.exe sed -i "s/ pk=#[^#]*#/ pk=#%demacia_pk%#/g" res\firehose\special\%product%\demacia.xml
        busybox.exe sed -i "s/#/\"/g" res\firehose\special\%product%\demacia.xml
        call framwork conf dev-%product%.bat demacia_pk %demacia_pk%
    ) else (ECHO.未输入 demacia_pk. 跳过...)
if not "%setprojmodel_token%"=="" (
        busybox.exe sed -i "s/\"/#/g" res\firehose\special\%product%\setprojmodel.xml
        busybox.exe sed -i "s/ token=#[^#]*#/ token=#%setprojmodel_token%#/g" res\firehose\special\%product%\setprojmodel.xml
        busybox.exe sed -i "s/#/\"/g" res\firehose\special\%product%\setprojmodel.xml
        call framwork conf dev-%product%.bat setprojmodel_token %setprojmodel_token%
    ) else (ECHO.未输入 setprojmodel_token. 跳过...)
if not "%setprojmodel_pk%"=="" (
        busybox.exe sed -i "s/\"/#/g" res\firehose\special\%product%\setprojmodel.xml
        busybox.exe sed -i "s/ pk=#[^#]*#/ pk=#%setprojmodel_pk%#/g" res\firehose\special\%product%\setprojmodel.xml
        busybox.exe sed -i "s/#/\"/g" res\firehose\special\%product%\setprojmodel.xml
        call framwork conf dev-%product%.bat setprojmodel_pk %setprojmodel_pk%
    ) else (ECHO.未输入 setprojmodel_pk. 跳过...)
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
    ) else (ECHO.未输入 flash_token. 跳过...)
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
    ) else (ECHO.未输入 flash_pk. 跳过...)
ECHO.完成. 按任意键返回主菜单... & pause>nul & goto MENU


:WRITE-FULLBAK
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] 刷入-全分区备份
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.警告: 由于涉及基带等特殊分区, 全分区备份只有制作该备份的原机器可以使用, 不得混用或分发传播, 不得使用他人的备份, 否则后果自负.
ECHO.
ECHO.
ECHO.请选择备份所在文件夹 (文件夹内不得有同名分区文件否则会失败)... & call sel folder s %framwork_workspace%\..
set imgpath=%sel__folder_path%
if not exist %imgpath%\rawprogram0.xml ECHO.没有rawprogram0.xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist %imgpath%\rawprogram1.xml ECHO.没有rawprogram1.xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist %imgpath%\rawprogram2.xml ECHO.没有rawprogram2.xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist %imgpath%\rawprogram3.xml ECHO.没有rawprogram3.xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist %imgpath%\rawprogram4.xml ECHO.没有rawprogram4.xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist %imgpath%\rawprogram5.xml ECHO.没有rawprogram5.xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist %imgpath%\patch0.xml ECHO.没有patch0.xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist %imgpath%\patch1.xml ECHO.没有patch1.xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist %imgpath%\patch2.xml ECHO.没有patch2.xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist %imgpath%\patch3.xml ECHO.没有patch3.xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist %imgpath%\patch4.xml ECHO.没有patch4.xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist %imgpath%\patch5.xml ECHO.没有patch5.xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
ECHO.请进入9008... & call chkdev edl rechk 1
start framwork logviewer start %logfile%
call opredl sendfh %chkdev__edl__port%
ECHO.开始恢复...
call write edl %chkdev__edl__port% UFS %imgpath% rawprogram0.xml/rawprogram1.xml/rawprogram2.xml/rawprogram3.xml/rawprogram4.xml/rawprogram5.xml/patch0.xml/patch1.xml/patch2.xml/patch3.xml/patch4.xml/patch5.xml
call write edl %chkdev__edl__port% UFS %imgpath% %framwork_workspace%\res\setbootablestoragedrive.xml
ECHO.
ECHO.1.返回主菜单   2.重启设备
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto MENU


:READ-FULLBAK
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] 回读-全分区备份
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.警告: 由于涉及基带等特殊分区, 全分区备份只有制作该备份的原机器可以使用, 不得混用或分发传播, 不得使用他人的备份, 否则后果自负.
ECHO.
ECHO.
if not exist res\rom\%product%\rawprogram0.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram1.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram2.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram3.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram4.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram5.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
ECHO.请选择保存文件夹 (文件夹内不得有同名分区文件否则会失败)... & call sel folder s %framwork_workspace%\..
set imgpath=%sel__folder_path%
ECHO.将备份以下分区...
::合并
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
::将空分区名加一个空格
busybox.exe sed -i "s/ filename=## / filename=# # /g" tmp\par.xml
::去除不要的分区
type tmp\par.xml | find /v " label=#last_parti# " | find /v " label=#BackupGPT# " | find /v " label=#PrimaryGPT# " | find /v " label=#userdata# " 1>tmp\par2.xml
::添加行号
type tmp\par2.xml | find /N "{" 1>tmp\par.xml
::替换文件名
set num=1
:READ-FULLBAK-1
find "[%num%]" "tmp\par.xml" 1>nul 2>nul || ECHO. && goto READ-FULLBAK-2
for /f "tokens=8 delims=#" %%a in ('type tmp\par.xml ^| find "[%num%]"') do ECHOC {%c_we%}%%a {%c_i%}& busybox.exe sed -i "%num%s/ filename=#[^#]*# / filename=#%%a.bin# /" tmp\par.xml
set /a num+=1
goto READ-FULLBAK-1
:READ-FULLBAK-2
::去掉行号
busybox.exe sed -i "s/\[[^#]*\]//g" tmp\par.xml
ECHO.准备文件...
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
ECHO.请进入9008... & call chkdev edl rechk 1
start framwork logviewer start %logfile%
call opredl sendfh %chkdev__edl__port%
ECHO.开始备份...
call read edl %chkdev__edl__port% UFS %imgpath% %framwork_workspace%\tmp\par.xml
ECHO.
ECHO.1.返回主菜单   2.重启设备
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto MENU


:ERASE-CUSTOM
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] 擦除 - 指定分区
ECHO.=--------------------------------------------------------------------=
ECHO.
if not exist res\rom\%product%\rawprogram0.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram1.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram2.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram3.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram4.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram5.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
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
ECHO.[序号] 分区名   (对应文件名) 分区大小 rawprogram lun
ECHO.
type tmp\par.txt
ECHO.[A]返回主菜单
ECHO.
call choice common
if "%choice%"=="A" goto MENU
find "[%choice%] " "tmp\par.txt" 1>nul 2>nul || goto ERASE-CUSTOM
for /f "tokens=2,5 delims=[] " %%a in ('type tmp\par.txt ^| find "[%choice%] "') do set parname=%%a& set rawprogram=rawprogram%%b.xml
ECHO.
ECHO.是否发送引导? 如果已发送过引导则无需再发送.
ECHO.1.发送(默认)   2.不发送
call choice common #[1][2]
if "%choice%"=="1" (set sendfh=y) else (set sendfh=n)
ECHO.
ECHO.生成xml...
copy /Y res\rom\%product%\%rawprogram% tmp\rawprogram.xml 1>nul
busybox.exe sed -i "s/\"/#/g" tmp\rawprogram.xml
busybox.exe sed -i "s/</{/g" tmp\rawprogram.xml
busybox.exe sed -i "s/>/}/g" tmp\rawprogram.xml
::开始生成该分区的xml
echo.{?xml version=#1.0# ?}>tmp\targetpar.xml
echo.{data}>>tmp\targetpar.xml
type tmp\rawprogram.xml | find " label=#%parname%# " 1>>tmp\targetpar.xml
echo.{/data}>>tmp\targetpar.xml
busybox.exe sed -i "s/{program /{erase /" tmp\targetpar.xml
::busybox.exe sed -i "s/ sparse=#true# / sparse=#false# /" tmp\targetpar.xml
busybox.exe sed -i "s/#/\"/g" tmp\targetpar.xml
busybox.exe sed -i "s/{/</g" tmp\targetpar.xml
busybox.exe sed -i "s/}/>/g" tmp\targetpar.xml
ECHO.请进入9008... & call chkdev edl
::start framwork logviewer start %logfile%
if "%sendfh%"=="y" call opredl sendfh %chkdev__edl__port%
ECHO.正在擦除 %parname% ... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\tmp targetpar.xml
ECHO.
ECHO.1.返回   2.重启设备
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto ERASE-CUSTOM


:WRITE-CUSTOM
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] 刷入 - 指定分区
ECHO.=--------------------------------------------------------------------=
ECHO.
if not exist res\rom\%product%\rawprogram0.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram1.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram2.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram3.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram4.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram5.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
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
ECHO.[序号] 分区名   (对应文件名) 分区大小 rawprogram lun
ECHO.
type tmp\par.txt
ECHO.[A]返回主菜单
ECHO.
call choice common
if "%choice%"=="A" goto MENU
find "[%choice%] " "tmp\par.txt" 1>nul 2>nul || goto WRITE-CUSTOM
for /f "tokens=2,5 delims=[] " %%a in ('type tmp\par.txt ^| find "[%choice%] "') do set parname=%%a& set rawprogram=rawprogram%%b.xml
::选文件
ECHO.
ECHO.请选择要刷入 %parname% 的文件... & call sel file s %framwork_workspace%\..
set imgpath=%sel__file_path%& set imgfolder=%sel__file_folder%& set imgname=%sel__file_fullname%
ECHO.
ECHO.是否发送引导? 如果已发送过引导则无需再发送.
ECHO.1.发送(默认)   2.不发送
call choice common #[1][2]
if "%choice%"=="1" (set sendfh=y) else (set sendfh=n)
ECHO.
ECHO.生成xml...
copy /Y res\rom\%product%\%rawprogram% tmp\rawprogram.xml 1>nul
busybox.exe sed -i "s/\"/#/g" tmp\rawprogram.xml
busybox.exe sed -i "s/</{/g" tmp\rawprogram.xml
busybox.exe sed -i "s/>/}/g" tmp\rawprogram.xml
::开始生成该分区的xml
echo.{?xml version=#1.0# ?}>tmp\targetpar.xml
echo.{data}>>tmp\targetpar.xml
type tmp\rawprogram.xml | find " label=#%parname%# " 1>>tmp\targetpar.xml
echo.{/data}>>tmp\targetpar.xml
busybox.exe sed -i "s/ filename=#[^#]*# / filename=#%imgname%# /" tmp\targetpar.xml
::busybox.exe sed -i "s/ sparse=#true# / sparse=#false# /" tmp\targetpar.xml
busybox.exe sed -i "s/#/\"/g" tmp\targetpar.xml
busybox.exe sed -i "s/{/</g" tmp\targetpar.xml
busybox.exe sed -i "s/}/>/g" tmp\targetpar.xml
ECHO.请进入9008... & call chkdev edl
::start framwork logviewer start %logfile%
if "%sendfh%"=="y" call opredl sendfh %chkdev__edl__port%
ECHO.正在将 %imgname% 刷入 %parname% ... & call write edl %chkdev__edl__port% UFS %imgfolder% %framwork_workspace%\tmp\targetpar.xml
ECHO.
ECHO.1.返回   2.重启设备
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto WRITE-CUSTOM


:READ-CUSTOM
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] 回读 - 指定分区
ECHO.=--------------------------------------------------------------------=
ECHO.
if not exist res\rom\%product%\rawprogram0.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram1.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram2.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram3.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram4.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
if not exist res\rom\%product%\rawprogram5.xml ECHO.没有%model%的xml. 请QQ联系1330250642. 按任意键返回... & pause>nul & goto MENU
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
ECHO.[序号] 分区名   (对应文件名) 分区大小 rawprogram lun
ECHO.
type tmp\par.txt
ECHO.[A]返回主菜单
ECHO.
call choice common
if "%choice%"=="A" goto MENU
find "[%choice%] " "tmp\par.txt" 1>nul 2>nul || goto READ-CUSTOM
for /f "tokens=2,3,5 delims=[] " %%a in ('type tmp\par.txt ^| find "[%choice%] "') do set parname=%%a& set imgname=%%b& set rawprogram=rawprogram%%c.xml
::选目录
ECHO.
set imgname=%imgname:~1,-1%
if "%imgname%"=="" set imgname=%parname%.img
ECHO.请选择 %imgname% 保存目录(不得有同名文件否则会失败)... & call sel folder s %framwork_workspace%\..
set imgfolder=%sel__folder_path%
ECHO.
ECHO.是否发送引导? 如果已发送过引导则无需再发送.
ECHO.1.发送(默认)   2.不发送
call choice common #[1][2]
if "%choice%"=="1" (set sendfh=y) else (set sendfh=n)
ECHO.
ECHO.生成xml...
copy /Y res\rom\%product%\%rawprogram% tmp\rawprogram.xml 1>nul
busybox.exe sed -i "s/\"/#/g" tmp\rawprogram.xml
busybox.exe sed -i "s/</{/g" tmp\rawprogram.xml
busybox.exe sed -i "s/>/}/g" tmp\rawprogram.xml
::开始生成该分区的xml
echo.{?xml version=#1.0# ?}>tmp\targetpar.xml
echo.{data}>>tmp\targetpar.xml
type tmp\rawprogram.xml | find " label=#%parname%# " 1>>tmp\targetpar.xml
echo.{/data}>>tmp\targetpar.xml
busybox.exe sed -i "s/ filename=#[^#]*# / filename=#%imgname%# /" tmp\targetpar.xml
busybox.exe sed -i "s/ sparse=#true# / sparse=#false# /" tmp\targetpar.xml
busybox.exe sed -i "s/#/\"/g" tmp\targetpar.xml
busybox.exe sed -i "s/{/</g" tmp\targetpar.xml
busybox.exe sed -i "s/}/>/g" tmp\targetpar.xml
ECHO.请进入9008... & call chkdev edl
::start framwork logviewer start %logfile%
if "%sendfh%"=="y" call opredl sendfh %chkdev__edl__port%
ECHO.正在回读 %parname% 到 %imgfolder%\%imgname% ... & call read edl %chkdev__edl__port% UFS %imgfolder% %framwork_workspace%\tmp\targetpar.xml
ECHO.
ECHO.1.返回   2.重启设备
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto READ-CUSTOM


:READ-ALL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] 回读 - 完整包
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.请选择分区文件保存文件夹 (文件夹内不得有同名分区文件否则会失败)... & call sel folder s %framwork_workspace%\..
set imgpath=%sel__folder_path%
if "%parlayout%"=="aonly" set targetxmlname=readback_all& goto READ-ALL-2
:READ-ALL-1
ECHO.
ECHO.1.回读a槽位   2.回读b槽位   3.查看应该回读哪个槽位
call choice common [1][2][3]
ECHO.
if "%choice%"=="3" start opredl getcurrentslot& goto READ-ALL-1
if "%choice%"=="1" set targetxmlname=readback_all_a& goto READ-ALL-2
if "%choice%"=="2" set targetxmlname=readback_all_b& goto READ-ALL-2
:READ-ALL-2
set rawprogram=%framwork_workspace%\res\rom\%product%\%targetxmlname%.xml
if not exist %rawprogram% ECHOC {%c_e%}找不到回读脚本. 请QQ联系1330250642报告此问题.{%c_i%}{\n}& goto FATAL
ECHO.请进入9008... & call chkdev edl rechk 1
start framwork logviewer start %logfile%
call opredl sendfh %chkdev__edl__port%
call read edl %chkdev__edl__port% UFS %imgpath% %rawprogram%
::区分ddr
if "%chkddr_img%"=="y" (if "%ddrtype%"=="auto" call opredl chkddr %chkdev__edl__port%)
if "%chkddr_img%"=="y" (if "%ddrtype%"=="auto" set read_all_ddrtype=%chkddr__type%)
if "%chkddr_img%"=="y" (if not "%ddrtype%"=="auto" set read_all_ddrtype=%ddrtype%)
if "%chkddr_img%"=="y" call read edl %chkdev__edl__port% UFS %imgpath% %framwork_workspace%\res\rom\%product%\%targetxmlname%_ddr%read_all_ddrtype%.xml
ECHO.补充文件...
copy /Y res\rom\%product%\rawprogram*.xml %imgpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}复制res\rom\%product%\rawprogram?.xml到%imgpath%失败{%c_i%}{\n}&& ECHO.继续...
if exist res\rom\%product%\patch*.xml copy /Y res\rom\%product%\patch?.xml %imgpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}复制res\rom\%product%\patch?.xml到%imgpath%失败{%c_i%}{\n}&& ECHO.继续...
if exist res\rom\%product%\gpt_*.bin copy /Y res\rom\%product%\gpt_*.bin %imgpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}复制res\rom\%product%\gpt_*.bin到%imgpath%失败{%c_i%}{\n}&& ECHO.继续...
ECHO.
ECHO.1.返回主菜单   2.重启设备
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto MENU


:TESTFH
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] 测试发送引导
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.请进入9008... & call chkdev edl rechk 1
start framwork logviewer start %logfile%
call opredl sendfh %chkdev__edl__port%
ECHO.
ECHO.1.返回主菜单   2.重启设备
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto MENU


:WRITE-ALL
set rawprogram_folder=
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.[%model%] 刷入 - 完整包
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.请选择刷机包分区镜像所在文件夹... & call sel folder s %framwork_workspace%\..
set imgpath=%sel__folder_path%
set rawprogram0=无& set rawprogram1=无& set rawprogram2=无& set rawprogram3=无& set rawprogram4=无& set rawprogram5=无
if exist %imgpath%\rawprogram0.xml set rawprogram0=rawprogram0.xml
if exist %imgpath%\rawprogram1.xml set rawprogram1=rawprogram1.xml
if exist %imgpath%\rawprogram2.xml set rawprogram2=rawprogram2.xml
if exist %imgpath%\rawprogram3.xml set rawprogram3=rawprogram3.xml
if exist %imgpath%\rawprogram4.xml set rawprogram4=rawprogram4.xml
if exist %imgpath%\rawprogram5.xml set rawprogram5=rawprogram5.xml
set patch0=无& set patch1=无& set patch2=无& set patch3=无& set patch4=无& set patch5=无
if exist %imgpath%\patch0.xml set patch0=patch0.xml
if exist %imgpath%\patch1.xml set patch1=patch1.xml
if exist %imgpath%\patch2.xml set patch2=patch2.xml
if exist %imgpath%\patch3.xml set patch3=patch3.xml
if exist %imgpath%\patch4.xml set patch4=patch4.xml
if exist %imgpath%\patch5.xml set patch5=patch5.xml
ECHO.
ECHO.1.使用工具箱内置的rawprogram (默认)
ECHO.2.自动识别rawprogram
ECHO.  [%rawprogram0%]
ECHO.  [%rawprogram1%]
ECHO.  [%rawprogram2%]
ECHO.  [%rawprogram3%]
ECHO.  [%rawprogram4%]
ECHO.  [%rawprogram5%]
ECHO.3.手动选择rawprogram
call choice common #[1][2][3]
if "%choice%"=="1" set rawprogram_folder=%framwork_workspace%\res\rom\%product%& set rawprogram=%framwork_workspace%\res\rom\%product%\rawprogram0.xml/%framwork_workspace%\res\rom\%product%\rawprogram1.xml/%framwork_workspace%\res\rom\%product%\rawprogram2.xml/%framwork_workspace%\res\rom\%product%\rawprogram3.xml/%framwork_workspace%\res\rom\%product%\rawprogram4.xml/%framwork_workspace%\res\rom\%product%\rawprogram5.xml
if "%choice%"=="2" set rawprogram_folder=%imgpath%& set rawprogram=%rawprogram0%/%rawprogram1%/%rawprogram2%/%rawprogram3%/%rawprogram4%/%rawprogram5%
if "%choice%"=="3" ECHO.请选择rawprogram (可多选)... & call sel file m %imgpath% [xml]
if "%choice%"=="3" set rawprogram=%sel__files%
goto WRITE-ALL-1
:WRITE-ALL-1
ECHO.
ECHO.1.使用工具箱内置的patch (默认)
ECHO.2.自动识别patch
ECHO.  [%patch0%]
ECHO.  [%patch1%]
ECHO.  [%patch2%]
ECHO.  [%patch3%]
ECHO.  [%patch4%]
ECHO.  [%patch5%]
ECHO.3.手动选择patch
ECHO.4.不使用patch
call choice common #[1][2][3][4]
if "%choice%"=="1" set patch=%framwork_workspace%\res\rom\%product%\patch0.xml/%framwork_workspace%\res\rom\%product%\patch1.xml/%framwork_workspace%\res\rom\%product%\patch2.xml/%framwork_workspace%\res\rom\%product%\patch3.xml/%framwork_workspace%\res\rom\%product%\patch4.xml/%framwork_workspace%\res\rom\%product%\patch5.xml
if "%choice%"=="2" set patch=%patch0%/%patch1%/%patch2%/%patch3%/%patch4%/%patch5%
if "%choice%"=="3" ECHO.请选择patch (可多选)... & call sel file m %imgpath% [xml]
if "%choice%"=="3" set patch=%sel__files%
if "%choice%"=="4" set patch=
goto WRITE-ALL-2
:WRITE-ALL-2
ECHO.
ECHO.请进入9008... & call chkdev edl rechk 1
start framwork logviewer start %logfile%
call opredl sendfh %chkdev__edl__port%
call write edl %chkdev__edl__port% UFS %imgpath% %rawprogram%/%patch%
::区分ddr
if not "%chkddr_img%"=="y" goto WRITE-ALL-3
if "%rawprogram_folder%"=="" goto WRITE-ALL-3
call opredl chkddr %chkdev__edl__port%
if not exist %rawprogram_folder%\rawprogram_ddr%chkddr__type%.xml ECHOC {%c_w%}警告: 找不到%rawprogram_folder%\rawprogram_ddr%chkddr__type%.xml. 跳过刷入相关分区...{%c_i%}{\n}& goto WRITE-ALL-3
call write edl %chkdev__edl__port% UFS %imgpath% %rawprogram_folder%\rawprogram_ddr%chkddr__type%.xml
:WRITE-ALL-3
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\setbootablestoragedrive.xml
ECHO.
ECHO.1.返回主菜单   2.重启设备
call choice common #[1][2]
if "%choice%"=="2" call write edl %chkdev__edl__port% UFS %framwork_workspace%\res reboot.xml
goto MENU


:SELDEV
type conf\dev.csv | find /v "[product]" | find "[" | find /N "]" 1>tmp\dev.txt
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.选择\更换机型
ECHO.=--------------------------------------------------------------------=
ECHO.
for /f "tokens=1,3 delims=[]," %%a in (tmp\dev.txt) do ECHO.%%a.%%b
ECHO.
call choice common
if "%choice%"=="" goto SELDEV
find "[%choice%][" "tmp\dev.txt" 1>nul 2>nul || goto SELDEV
ECHO.切换机型中. 请勿关闭窗口...
for /f "tokens=2 delims=[]," %%a in ('type tmp\dev.txt ^| find "[%choice%]["') do set product=%%a
call opredl confdevpre
call framwork conf user.bat product %product%
call conf\dev-%product%.bat
if "%chkddr_fh%"=="y" goto SELDEV-1
if "%chkddr_img%"=="y" goto SELDEV-1
goto MENU
:SELDEV-1
ECHO.
ECHO.请选择设备的ddr类型 (错选会导致发送引导后无法发送命令).
ECHO.稍后你仍然可以从主菜单更改此设置.
ECHO.
ECHO.1.自动识别 (可能失败)
ECHO.2.ddr4 (类型1)
ECHO.3.ddr5 (类型2)
ECHO.
call choice common [1][2][3]
if "%choice%"=="1" set ddrtype=auto
if "%choice%"=="2" set ddrtype=1
if "%choice%"=="3" set ddrtype=2
call framwork conf dev-%product%.bat ddrtype %ddrtype%
goto MENU












:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)
