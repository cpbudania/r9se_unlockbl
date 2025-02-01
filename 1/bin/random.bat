::call random 随机数位数 指定字符池(可选,默认所有小写字母和数字)

::abcdefghijklmnopqrstuvwxyz0123456789 (默认)
::ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
::abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
::abcdef0123456789 (Magisk修补)


@ECHO OFF
set var1=%1& set var2=%2& set var3=%3& set var4=%4& set var5=%5& set var6=%6& set var7=%7& set var8=%8& set var9=%9
::goto %var1%


SETLOCAL EnableDelayedExpansion
set length=%var1%& set str=%var2%
call log %logger% I 接收变量:length:%length%.str:%str%
if "%str%"=="" set str=abcdefghijklmnopqrstuvwxyz0123456789
for /f %%a in ('busybox.exe expr length "%str%"') do set str_length=%%a
for /l %%a in (1,1,%length%) do call :random-generate "%%a"
call log %logger% I 从%str%中生成%length%位随机数:%random_str%
ENDLOCAL & set random__str=%random_str%
goto :eof
:random-generate
if "%~1"=="" goto :eof
set /a var=%random%%%%str_length%
set random_str=%random_str%!str:~%var%,1!
goto :eof




:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)

