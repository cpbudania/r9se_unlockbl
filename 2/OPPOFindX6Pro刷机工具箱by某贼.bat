::这是一个主脚本示例,请按照此示例中的启动过程完成脚本的启动.

::常规准备,请勿改动
@ECHO OFF
chcp 936>nul
cd /d %~dp0
if exist bin (cd bin) else (ECHO.找不到bin & goto FATAL)

::加载配置,如果有自定义的配置文件也可以加在下面
if exist conf\fixed.bat (call conf\fixed) else (ECHO.找不到conf\fixed.bat & goto FATAL)
if exist conf\user.bat call conf\user

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
call framwork startpre
::call framwork startpre skiptoolchk

::完成启动.请在下面编写你的脚本
TITLE [完全免费] OPPOFindX6Pro刷机工具箱 版本:%prog_ver% 作者:酷安@某贼
CLS
goto MENU



:MENU
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.主菜单
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.【方案来自 酷安@mi搞机爱好者】  脚本作者: 酷安@某贼
ECHO.本程序完全免费, 禁止倒卖. 刷机自愿, 风险自负, 本程序不会恶意损坏你的设备, 也不为任何可能发生的意外负责.
ECHO.
ECHO.任意状态强制关机重启: 长按电源键和音量加.
ECHO.进入9008: 关机状态按住音量加减连接电脑.
ECHO.
ECHO.
ECHO.0.刷机指导 (初次刷机必看)
ECHO.1.解锁BL
ECHO.2.刷入TWRP
ECHO.3.获取Root
ECHO.4.欧加真工具箱-9008救砖回读相关功能 (密码:f65u)
ECHO.5.上锁BL (不建议)
ECHO.
ECHO.A.检查更新 (密码:8o8k)
ECHO.B.刷机资源网盘
ECHO.C.刷机驱动
ECHO.D.加入QQ群聊
ECHO.E.加入云湖群聊
ECHO.F.关于BFF
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
ECHO.获取Root
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.Root是安卓系统的最高权限. 获取Root后就拥有了查看, 修改手机系统的权限.
ECHO.此功能需要在TWRP下使用. 请先进入TWRP.
ECHO.
ECHO.
ECHO.1.刷入Magisk26.4 (官方面具)
ECHO.
ECHO.2.刷入MagiskDelta26.1 (狐狸面具)
ECHO.
ECHO.A.刷入自定义Magisk (支持zip或apk)
ECHO.
ECHO.B.返回主菜单
ECHO.
call choice common [1][2][A][B]
if "%choice%"=="1" set target=..\Magisk26.4.apk
if "%choice%"=="2" set target=..\MagiskDelta26.1.apk
if "%choice%"=="A" ECHO.请选择Magisk卡刷包或apk... & call sel file s %framwork_workspace%\.. [zip][apk]
if "%choice%"=="A" set target=%sel__file_path%
if "%choice%"=="B" goto MENU
ECHO.请进入TWRP... & call chkdev recovery rechk 3
ECHO.检查槽位... & call slot recovery chk
ECHO.备份init_boot_%slot__cur%...
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
call read recovery init_boot_%slot__cur% bak\init_boot\init_boot.img noprompt
copy /Y bak\init_boot\init_boot.img bak\init_boot\init_boot_%var%.img 1>nul
ECHO.init_boot_%slot__cur%已经备份到bak\init_boot\init_boot_%var%.img
start framwork logviewer start %logfile%
ECHO.刷入%target%... & call write twrpinst %target%
ECHO.
ECHO.完成. 脚本无法判断是否成功, 请根据日志或开机自行判断. 如果无法开机, 可以使用自动备份的init_boot恢复. 按任意键返回... & pause>nul & goto MENU


:FLASHTWRP
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.刷入TWRP
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.TWRP是一种第三方Recovery模式, 是刷机不可或缺的工具.
ECHO.
ECHO.
ECHO.1.刷入TWRP-13-OPlus_SM8550-Color597-V1.1-by_酷安@Col_or
ECHO.
ECHO.A.刷入自定义Recovery
ECHO.
ECHO.B.下载更多TWRP
ECHO.
ECHO.C.关注和支持 酷安@Col_or
ECHO.
ECHO.D.返回主菜单
ECHO.
call choice common [1][A][B][C]
if "%choice%"=="1" set target=%framwork_workspace%\res\TWRP-13-OPlus_SM8550-Color597-V1.1-by_酷安@Col_or
::if "%choice%"=="2" set target=%framwork_workspace%\res\OrangeFox-R11.1-Unofficial-salami-V2
::if "%choice%"=="3" set target=%framwork_workspace%\res\TWRP-3.7.0-salami-13-09-23
::if "%choice%"=="4" set target=%framwork_workspace%\res\小猪TWRP
if "%choice%"=="A" ECHO.请选择recovery.img... & call sel file s %framwork_workspace%\.. [img]
if "%choice%"=="A" ECHO.正在准备recovery... & copy /Y %sel__file_path% tmp\recovery.img 1>nul & set target=%framwork_workspace%\tmp
if "%choice%"=="B" call open common https://www.123pan.com/s/8eP9-1WvGA.html & goto FLASHTWRP
if "%choice%"=="C" (
    call open common "https://www.coolapk.com/feed/49392957?shareKey=YjMyYjNmOGMyYzhkNjUxMjc5NjA~&shareUid=3463951&shareFrom=com.coolapk.market_13.3.4"
    call open common http://www.coolapk.com/u/642425
    call open common https://afdian.net/a/color597
    goto FLASHTWRP)
if "%choice%"=="D" goto MENU
ECHO.请进入9008... & call chkdev edl rechk 1
call pgem10 sendfh %chkdev__edl__port%
ECHO.刷入...
call write edl %chkdev__edl__port% UFS %target% %framwork_workspace%\res\recovery_a.xml
call write edl %chkdev__edl__port% UFS %target% %framwork_workspace%\res\recovery_b.xml
copy /Y tool\Android\misc_torecovery.img tmp\misc.img 1>nul
call write edl %chkdev__edl__port% UFS %framwork_workspace%\tmp %framwork_workspace%\res\misc.xml
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
ECHO.完成. 如果不开机可以尝试更换Recovery或恢复官方Recovery. 按任意键返回... & pause>nul & goto MENU


:UNLOCKBL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.解锁BL
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.解锁BL可能会导致以下问题:
ECHO.-手机内所有数据被彻底清除
ECHO.-失去官方保修
ECHO.-无法使用指纹支付
ECHO.-TEE可信任硬件环境假死
ECHO.-Netflix APP只能观看640P清晰度
ECHO.-小布助手无法绑定航班, 高铁, 快递
ECHO.-解锁后再上锁是非常危险的行为, 可能导致手机变砖
ECHO.-...
ECHO.
ECHO.解锁BL前必须做以下准备:
ECHO.-确认你的手机是OPPOFindX6Pro
ECHO.-手机关闭查找手机, 退出OPPO账户, 取消锁屏密码
ECHO.-将手机内所有数据备份到电脑上, 包括照片, 视频, 录音, 聊天记录等
ECHO.-开启开发者模式, 在开发者选项中开启OEM解锁和USB调试
ECHO.-准备能传输文件的数据线, 电脑安装刷机驱动
ECHO.
ECHO.解锁过程中请严格按照提示操作, 无论成功失败都必须走完整个流程, 不要中途退出, 否则后果自负.
ECHO.
ECHO.
ECHO.知晓以上说明, 请按任意键开始解锁... & pause>nul
ECHO.
ECHO.请开机连接电脑并开启USB调试... & call chkdev system rechk 1
ECHO.检查设备信息...
call info adb
if not "%info__adb__product%"=="OP528BL1" ECHOC {%c_e%}你的设备(%info__adb__product%)不是OPPOFindX6Pro(OP528BL1). 本工具只支持OPPOFindX6Pro. {%c_i%}如果你确认机型无误, 请按任意键继续...{%c_i%}{\n}& pause>nul & ECHO.继续...
call slot system chk
ECHO.安卓版本: %info__adb__androidver%   当前槽位: %slot__cur%
ECHO.
ECHOC {%c_h%}请同时按住手机音量加减, 然后在电脑上按任意键继续. 之后请保持长按直到脚本检测到9008连接再松手...{%c_i%}{\n} & pause>nul
adb.exe reboot bootloader 1>>%logfile% 2>&1 || ECHOC {%c_e%}重启失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& pause>nul && goto UNLOCKBL
ECHOC {%c_w%}注意: 即将检查9008连接. 如果10秒内没有检查到连接, 手机没有黑屏, 而是重启开机或重启进入其他模式了, 请关闭本脚本重新打开.{%c_i%}{\n}
call chkdev edl rechk 1
ECHO.(现在你可以松手了)
call pgem10 sendfh %chkdev__edl__port%
ECHO.备份ocdt...
if exist bak\ocdt\oplus del bak\ocdt\oplus 1>nul
call read edl %chkdev__edl__port% UFS %framwork_workspace%\bak\ocdt %framwork_workspace%\res\ocdt.xml
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
copy /Y bak\ocdt\oplus bak\ocdt\oplus_%var% 1>nul
ECHO.备份abl_%slot__cur%...
if exist bak\abl\abl.elf del bak\abl\abl.elf 1>nul
call read edl %chkdev__edl__port% UFS %framwork_workspace%\bak\abl %framwork_workspace%\res\abl_%slot__cur%.xml
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
copy /Y bak\abl\abl.elf bak\abl\abl_%var%.elf 1>nul
ECHO.刷入ocdt... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\ocdt.xml
::只有安卓13不刷abl
if not "%info__adb__androidver%"=="13" ECHO.刷入abl_%slot__cur%... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\abl_%slot__cur%.xml
ECHO.重启到Fastboot...
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
:UNLOCKBL-1
ECHOC {%c_h%}请手动检查Fastboot连接. {%c_i%}在进行下一步之前请勿按动手机按键.{%c_i%}{\n}
ECHO.1.检查Fastboot连接   2.多次检查仍检查不到
call choice common #[1][2]
ECHO.
if "%choice%"=="1" fastboot.exe devices 2>&1 | find "fastboot" 1>nul 2>nul || ECHOC {%c_e%}设备未连接或驱动未安装.{%c_i%}{\n}&& goto UNLOCKBL-1
if "%choice%"=="2" goto UNLOCKBL-FAILED
call chkdev fastboot
ECHO.检查解锁状态... & call info fastboot
if "%info__fastboot__unlocked%"=="yes" ECHOC {%c_i%}你的设备已解锁BL, 无需重复解锁. 将为你恢复设备. {%c_h%}请参照工具箱文件目录中的文档手动进入9008.{%c_i%}{\n}& goto UNLOCKBL-RECOVER
ECHO.执行解锁命令... & fastboot.exe flashing unlock 1>>%logfile% 2>&1
ECHO.
ECHOC {%c_h%}现在请按两下音量减选择UNLOCK, 然后按一下电源键确认, 然后立即同时按住音量加减(速度要快), 直到脚本检测到9008连接再松手.{%c_i%}{\n}
ECHO.如果未能及时按键, 手机将无法自动进入9008. 此时请参照工具箱文件目录中的文档手动进入9008.
ECHO.
goto UNLOCKBL-RECOVER
:UNLOCKBL-FAILED
ECHOC {%c_e%}解锁BL失败. {%c_i%}将为你恢复手机. 请按提示继续操作. 稍后你可以QQ联系1330250642反馈此问题.{%c_i%}{\n}
ECHOC {%c_h%}请参照工具箱文件目录中的文档手动进入9008.{%c_i%}{\n}
goto UNLOCKBL-RECOVER
:UNLOCKBL-RECOVER      
call chkdev edl rechk 1
call pgem10 sendfh %chkdev__edl__port%
ECHO.恢复ocdt... &            call write edl %chkdev__edl__port% UFS %framwork_workspace%\bak\ocdt %framwork_workspace%\res\ocdt.xml
ECHO.恢复abl_%slot__cur%... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\bak\abl  %framwork_workspace%\res\abl_%slot__cur%.xml
ECHO.重启到Recovery...
copy /Y tool\Android\misc_torecovery.img tmp\misc.img 1>>%logfile% 2>&1
call write edl %chkdev__edl__port% UFS %framwork_workspace%\tmp %framwork_workspace%\res\misc.xml
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
ECHO.全部完成. 手机将自动重启到官方Recovery. 请手动清除数据格式化data再开机. 解锁后开机出现或不出现黄色警告都属正常现象. 如果解锁后手机无法开机, 或开机后出现某些问题, 可以尝试进入官方Recovery清除数据恢复出厂再开机. 按任意键返回... & pause>nul & goto MENU


:LOCKBL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.上锁BL
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.解锁后再上锁是非常危险的行为, 可能导致手机变砖. 除非必要, 否则请勿上锁. 上锁造成的任何问题责任自负.
ECHO.
ECHO.
ECHO.上锁BL前必须做以下准备:
ECHO.-确认你的手机是OPPOFindX6Pro
ECHO.-手机关闭查找手机, 退出OPPO账户, 取消锁屏密码
ECHO.-将手机内所有数据备份到电脑上, 包括照片, 视频, 录音, 聊天记录等
ECHO.-完全恢复官方系统 (推荐使用你自己解锁前的字库备份, 没有的话也可以刷一下官方包或者官方升级一下系统)
ECHO.-准备能传输文件的数据线, 电脑安装刷机驱动
ECHO.
ECHO.上锁过程中请严格按照提示操作, 无论成功失败都必须走完整个流程, 不要中途退出, 否则后果自负.
ECHO.
ECHO.
ECHO.知晓以上说明, 请按任意键开始上锁... & pause>nul
ECHO.
ECHO.请开机连接电脑并开启USB调试... & call chkdev system rechk 1
ECHO.检查设备信息...
call info adb
if not "%info__adb__product%"=="OP528BL1" ECHOC {%c_e%}你的设备(%info__adb__product%)不是OPPOFindX6Pro(OP528BL1). 本工具只支持OPPOFindX6Pro. {%c_i%}如果你确认机型无误, 请按任意键继续...{%c_i%}{\n}& pause>nul & ECHO.继续...
call slot system chk
ECHO.安卓版本: %info__adb__androidver%   当前槽位: %slot__cur%
ECHO.
ECHOC {%c_h%}请同时按住手机音量加减, 然后在电脑上按任意键继续. 之后请保持长按直到脚本检测到9008连接再松手...{%c_i%}{\n} & pause>nul
adb.exe reboot bootloader 1>>%logfile% 2>&1 || ECHOC {%c_e%}重启失败. {%c_h%}按任意键重试...{%c_i%}{\n}&& pause>nul && goto LOCKBL
ECHOC {%c_w%}注意: 即将检查9008连接. 如果10秒内没有检查到连接, 手机没有黑屏, 而是重启开机或重启进入其他模式了, 请关闭本脚本重新打开.{%c_i%}{\n}
call chkdev edl rechk 1
ECHO.(现在你可以松手了)
call pgem10 sendfh %chkdev__edl__port%
ECHO.备份ocdt...
if exist bak\ocdt\oplus del bak\ocdt\oplus 1>nul
call read edl %chkdev__edl__port% UFS %framwork_workspace%\bak\ocdt %framwork_workspace%\res\ocdt.xml
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
copy /Y bak\ocdt\oplus bak\ocdt\oplus_%var% 1>nul
ECHO.备份abl_%slot__cur%...
if exist bak\abl\abl.elf del bak\abl\abl.elf 1>nul
call read edl %chkdev__edl__port% UFS %framwork_workspace%\bak\abl %framwork_workspace%\res\abl_%slot__cur%.xml
for /f %%a in ('gettime.exe ^| find "."') do set var=%%a
copy /Y bak\abl\abl.elf bak\abl\abl_%var%.elf 1>nul
ECHO.刷入ocdt... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\ocdt.xml
::只有安卓13不刷abl
if not "%info__adb__androidver%"=="13" ECHO.刷入abl_%slot__cur%... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\abl_%slot__cur%.xml
ECHO.重启到Fastboot...
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
:LOCKBL-1
ECHOC {%c_h%}请手动检查Fastboot连接. {%c_i%}在进行下一步之前请勿按动手机按键.{%c_i%}{\n}
ECHO.1.检查Fastboot连接   2.多次检查仍检查不到
call choice common #[1][2]
ECHO.
if "%choice%"=="1" fastboot.exe devices 2>&1 | find "fastboot" 1>nul 2>nul || ECHOC {%c_e%}设备未连接或驱动未安装.{%c_i%}{\n}&& goto LOCKBL-1
if "%choice%"=="2" goto LOCKBL-FAILED
call chkdev fastboot
ECHO.检查BL锁状态... & call info fastboot
if "%info__fastboot__unlocked%"=="no" ECHOC {%c_i%}你的设备已上锁BL, 无需重复上锁. 将为你恢复设备. {%c_h%}请参照工具箱文件目录中的文档手动进入9008.{%c_i%}{\n}& goto LOCKBL-RECOVER
ECHO.执行上锁命令... & fastboot.exe flashing lock 1>>%logfile% 2>&1
ECHO.
ECHOC {%c_h%}现在请按两下音量减选择LOCK, 然后按一下电源键确认, 然后立即同时按住音量加减(速度要快), 直到脚本检测到9008连接再松手.{%c_i%}{\n}
ECHO.如果未能及时按键, 手机将无法自动进入9008. 此时请参照工具箱文件目录中的文档手动进入9008.
ECHO.
goto LOCKBL-RECOVER
:LOCKBL-FAILED
ECHOC {%c_e%}上锁BL失败. {%c_i%}将为你恢复手机. 请按提示继续操作. 稍后你可以QQ联系1330250642反馈此问题.{%c_i%}{\n}
ECHOC {%c_h%}请参照工具箱文件目录中的文档手动进入9008.{%c_i%}{\n}
goto LOCKBL-RECOVER
:LOCKBL-RECOVER      
call chkdev edl rechk 1
call pgem10 sendfh %chkdev__edl__port%
ECHO.恢复ocdt... &            call write edl %chkdev__edl__port% UFS %framwork_workspace%\bak\ocdt %framwork_workspace%\res\ocdt.xml
ECHO.恢复abl_%slot__cur%... & call write edl %chkdev__edl__port% UFS %framwork_workspace%\bak\abl  %framwork_workspace%\res\abl_%slot__cur%.xml
ECHO.重启到Recovery...
copy /Y tool\Android\misc_torecovery.img tmp\misc.img 1>>%logfile% 2>&1
call write edl %chkdev__edl__port% UFS %framwork_workspace%\tmp %framwork_workspace%\res\misc.xml
call write edl %chkdev__edl__port% UFS %framwork_workspace%\res %framwork_workspace%\res\reboot.xml
ECHO.
ECHO.全部完成. 手机将自动重启到官方Recovery. 请手动清除数据格式化data再开机. 如果上锁后手机无法开机, 或开机后出现某些问题, 可以尝试进入官方Recovery清除数据恢复出厂再开机. 按任意键返回... & pause>nul & goto MENU














:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)














::弃用


