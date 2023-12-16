::这是一个主脚本示例,请按照此示例中的启动过程完成脚本的启动.

::常规准备,请勿改动
@ECHO OFF
chcp 936>nul
cd /d %~dp0
if exist bin (cd bin) else (ECHO.找不到bin & goto FATAL)

::加载框架基础配置和指定的主题,请勿改动
if exist conf\framwork.bat (call conf\framwork) else (ECHO.找不到conf\framwork.bat & goto FATAL)
if exist framwork.bat (call framwork theme %framwork_theme%) else (ECHO.找不到framwork.bat & goto FATAL)
COLOR %c_i%

::自定义窗口大小,可以按照需要改动
TITLE viQOO工具箱启动中...
mode con cols=71

::检查和获取管理员权限,如不需要可以去除
if not exist tool\Windows\gap.exe ECHO.找不到gap.exe & goto FATAL
if exist %windir%\System32\bff-test rd %windir%\System32\bff-test 1>nul || start gap.exe %0 && EXIT || EXIT
md %windir%\System32\bff-test 1>nul || start gap.exe %0 && EXIT || EXIT
rd %windir%\System32\bff-test 1>nul || start gap.exe %0 && EXIT || EXIT

::启动准备和检查,请勿改动
call framwork startpre

::加载自定义配置.如有自定义配置文件应在此时加载
call conf\user.bat

::完成启动.请在下面编写你的脚本
TITLE viQOO工具箱 V%prog_ver% 作者:酷安@某贼 [永久免费]
CLS
goto MENU



:MENU
call log viQOO工具箱.bat-menu I 进入主菜单
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.                        viQOO工具箱 - 主菜单
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHOC {%c_w%}        工具箱开源免费, 禁止商用, 禁止未经许可的二改, 打包, 加密{%c_i%}{\n}
ECHO.           viQOO新版本由BFF框架强力驱动: gitee.com/mouzei/bff
if not "%product%"=="" ECHO. & ECHO. [%model%]
ECHO.
ECHO. 0.给机油们的一封信
ECHO.
ECHO. 1.解锁BL锁   2.Root和取消Root   3.刷入第三方Recovery
ECHO.
ECHO. 4.刷入自定义分区
ECHO.
ECHO. A.选择型号   B.检查更新   C.更换主题   D.开关日志
ECHO.
call choice common [0][1][2][3][4][A][B][C]
if "%choice%"=="0" goto ALETTER
if "%choice%"=="1" goto UNLOCKBL
if "%choice%"=="2" goto ROOT
if "%choice%"=="3" goto REC
if "%choice%"=="4" goto CUSTOMFLASH
if "%choice%"=="A" goto SELDEV
if "%choice%"=="B" goto UPDATE
if "%choice%"=="C" goto THEME
if "%choice%"=="D" goto LOG




:CUSTOMFLASH
SETLOCAL
set logger=viQOO工具箱.bat-customflash
call log %logger% I 进入功能:刷入自定义分区
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.刷入自定义分区
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
:CUSTOMFLASH-1
ECHOC {%c_h%}请输入要刷入的分区名: {%c_i%}& set /p parname=
if "%parname%"=="" goto CUSTOMFLASH-1
call log %logger% I 输入分区名:%parname%
ECHOC {%c_h%}请选择要刷入的img文件...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [img]
ECHOC {%c_h%}请将设备进入Fastboot模式...{%c_i%}{\n}& call chkdev fastboot rechk 1
ECHO.正在将%sel__file_path%刷入%parname%...& call write fastboot %parname% %sel__file_path%
ECHOC {%c_s%}完成. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& pause>nul
call log %logger% I 完成功能:刷入自定义分区
ENDLOCAL
goto MENU


:REC
SETLOCAL
set logger=viQOO工具箱.bat-rec
call log %logger% I 进入功能:刷入第三方Recovery
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.刷入第三方Recovery
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHOC {%c_w%}注意: 选择错误的型号或安卓版本可能导致设备无法进入Recovery{%c_i%}{\n}
if not "%product%"=="" ECHO. & ECHO.[%model%]
ECHO.
ECHO.1.[在线资源]刷入第三方Recovery
ECHO.2.刷入自定义Recovery
ECHO.A.返回主菜单
call choice common [1][2][A]
if "%choice%"=="A" goto REC-DONE
if "%choice%"=="1" goto REC-1
if "%choice%"=="2" goto REC-
:REC-1
if "%product%"=="" ECHOC {%c_e%}请先选择型号再使用此功能. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& pause>nul & goto REC-DONE
ECHOC {%c_h%}输入安卓版本(如10,11,不是系统版本号), 按Enter继续: {%c_i%}& set /p androidver=
if "%androidver%"=="" goto REC-1
call log %logger% I 输入安卓版本:%androidver%
ECHO.下载Recovery... & call dl direct %dlsource%/rec/%product%/%androidver%.7z %framwork_workspace%\tmp\rec.7z once noprompt
if not "%dl__result%"=="y" ECHOC {%c_e%}下载失败{%c_i%}{\n}& goto REC-1
ECHO.解压Recovery... & 7z.exe x -aoa -otmp tmp\rec.7z 1>>%logfile% 2>&1 || ECHOC {%c_e%}解压失败{%c_i%}{\n}&& goto REC-1
ECHOC {%c_h%}请将设备进入Fastboot模式{%c_i%}{\n}& call chkdev fastboot rechk 1
ECHO.刷入Recovery... & call write fastboot recovery %framwork_workspace%\tmp\rec.img
ECHOC {%c_s%}完成. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& pause>nul & goto REC-DONE
:REC-DONE
call log %logger% I 完成功能:刷入第三方Recovery
ENDLOCAL
goto MENU


:ROOT
SETLOCAL
set logger=viQOO工具箱.bat-root
call log %logger% I 进入功能:Root和取消Root
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Root和取消Root
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHOC {%c_w%}注意: 选择错误的型号, boot或系统版本可能导致设备无法开机{%c_i%}{\n}
if not "%product%"=="" ECHO. & ECHO.[%model%]
ECHO.
ECHO.1.[在线资源]获取Root
ECHO.2.[在线资源]恢复官方boot,取消Root
ECHO.3.选择自定义boot
ECHO.A.返回主菜单
call choice common [1][2][3][A]
if "%choice%"=="A" goto ROOT-DONE
if "%choice%"=="3" goto ROOT-2
if "%choice%"=="1" set func=root& goto ROOT-1
if "%choice%"=="2" set func=unroot& goto ROOT-1
:ROOT-1
if "%product%"=="" ECHOC {%c_e%}请先选择型号再使用此功能. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& pause>nul & goto ROOT-DONE
ECHOC {%c_h%}输入系统版本号, 按Enter继续: {%c_i%}& set /p systemver=
if "%systemver%"=="" goto ROOT-1
call log %logger% I 输入版本号:%systemver%
ECHO.下载boot... & call dl direct %dlsource%/boot/%product%/%systemver%.7z %framwork_workspace%\tmp\boot.7z once noprompt
if not "%dl__result%"=="y" ECHOC {%c_e%}下载失败{%c_i%}{\n}& goto ROOT-1
ECHO.解压boot... & 7z.exe x -aoa -otmp tmp\boot.7z 1>>%logfile% 2>&1 || ECHOC {%c_e%}解压失败{%c_i%}{\n}&& goto ROOT-1
if "%func%"=="root" call imgkit magiskpatch %framwork_workspace%\tmp\boot.img %framwork_workspace%\tmp\boot.img 25200 noprompt
goto ROOT-3
:ROOT-2
ECHOC {%c_h%}请选择boot文件...{%c_i%}{\n}& call sel file s %framwork_workspace%\.. [img]
ECHO.是否用Magisk修补以获取Root?
ECHO.1.修补   2.不修补, 直接刷入
call choice common [1][2]
if "%choice%"=="2" echo.F|xcopy /Y %sel__file_path% tmp\boot.img 1>>%logfile% 2>&1 & goto ROOT-3
ECHO.1.使用内置的Magisk25200版本修补   2.自己选择MagiskAPK
call choice common [1][2]
if "%choice%"=="1" set var=25200
if "%choice%"=="2" set var=%sel__file_path%
call imgkit magiskpatch %var% %framwork_workspace%\tmp\boot.img 25200 noprompt
goto ROOT-3
:ROOT-3
ECHO.请选择启动方式
ECHO.1.直接刷入: 直接刷入boot分区并开机
ECHO.2.临时启动: 只启动不刷入,重启即恢复,可测试boot是否可用.临时启动失败说明设备不支持临时启动,启动成功但卡第一屏,进入Fastboot或开机过程中自动重启说明该boot不可用
call choice common [1][2]
if "%choice%"=="1" set var=flash
if "%choice%"=="2" set var=boot
ECHOC {%c_h%}请将设备开机开启USB调试或进入Fastboot模式{%c_i%}{\n}& call chkdev all rechk 2
if "%chkdev__all__mode%"=="system" call reboot %chkdev__all__mode% fastboot rechk 1& goto ROOT-4
if "%chkdev__all__mode%"=="fastboot" goto ROOT-4
ECHOC {%c_e%}模式错误, 请进入系统或Fastboot模式. {%c_h%}按任意键重试...{%c_i%}{\n}& pause>nul & ECHO.重试... & goto ROOT-3
:ROOT-4
if "%var%"=="flash" ECHO.刷入boot... & call write fastboot boot %framwork_workspace%\tmp\boot.img
if "%var%"=="boot" ECHO.临时启动boot... & call write fastbootboot %framwork_workspace%\tmp\boot.img
ECHOC {%c_s%}完成. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& pause>nul & goto ROOT-DONE
:ROOT-DONE
call log %logger% I 完成功能:Root和取消Root
ENDLOCAL
goto MENU


:UNLOCKBL
SETLOCAL
set logger=viQOO工具箱.bat-unlockbl
call log %logger% I 进入功能:解锁BL锁
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.解锁BL锁
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.提示: 由于官方已经通过系统更新封堵后门, 解锁失败属于正常现象.
ECHO.
ECHO.确定要解锁BL锁么? 解锁刷机可能造成以下影响:
ECHO.手机数据被清空
ECHO.手机系统损坏无法开机
ECHO.基带丢失
ECHO.失去保修
ECHO.光学指纹失效(可以售后校准恢复)
ECHO.指纹支付不可用(好像可以通过模块修复)
ECHO....
call choice twochoice 自愿承担以上风险.请输入1按Enter继续.否则直接按Enter返回主菜单:
if not "%choice%"=="1" goto UNLOCKBL-DONE
ECHO.
ECHO.请关闭查找手机, 退出vivo账号, 开启开发者选项中的OEM解锁, 然后将设备进入以下任意一个模式:
ECHO.- 开机状态并开启USB调试
ECHO.- Fastboot模式
ECHO.
:UNLOCKBL-1
call chkdev all rechk 2
if "%chkdev__all__mode%"=="system" call reboot %chkdev__all__mode% fastboot rechk 1& goto UNLOCKBL-2
if "%chkdev__all__mode%"=="fastboot" call reboot %chkdev__all__mode% fastboot rechk 1& goto UNLOCKBL-2
ECHOC {%c_e%}模式错误, 请进入系统或Fastboot模式. {%c_h%}按任意键重试...{%c_i%}{\n}& pause>nul & ECHO.重试... & goto UNLOCKBL-1
:UNLOCKBL-2
ECHO.读取设备信息... & call log %logger% I 读取设备信息& call info fastboot
if "%info__fastboot__unlocked%"=="y" ECHOC {%c_s%}你的设备已经解锁. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& pause>nul & goto UNLOCKBL-DONE
ECHO.尝试刷入vendor... & call log %logger% I 尝试刷入vendor& fastboot.exe flash vendor %vendor.img% 1>>%logfile% 2>&1 && ECHO.刷入成功
set var=n
ECHO.尝试解锁BL... & call log %logger% I 尝试解锁BL& fastboot_vivo.exe vivo_bsp unlock_vivo 1>>%logfile% 2>&1 && set var=y
if "%var%"=="n" ECHOC {%c_e%}解锁失败. {%c_i%}系统没有或已封堵此后门. 查看%logfile%以获得详细信息. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}
if "%var%"=="y" ECHOC {%c_s%}解锁成功. {%c_i%}如果无法开机, 请手动进入Recovery清除数据恢复出厂. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}
pause>nul & goto UNLOCKBL-DONE
:UNLOCKBL-DONE
call log %logger% I 完成功能:解锁BL锁
ENDLOCAL
goto MENU


:ALETTER
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.viQOO工具箱
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.朋友:
ECHO.
ECHO.    你好. 如你所见, 这是viQOO工具箱的全新版本. 在停止维护将近一年的时间之后, 我又重新为它重构并发布了新版. 究其原因, 首先自然离不开各位机油的支持. 你们的爱是我们的发动机. 其次, 这也得益于我近期编写的BFF框架, 使用它能快速制作出优质的刷机工具箱. 最后, 我个人技术上的进步也是原因之一.
ECHO.    说来惭愧, 当时用viQOO尝试了很多新的写法和设计方式, 最后弄的很乱, 以至于无法再维护下去. 不过这不是最主要的, 更多的还是因为, vivo解锁看不到未来, 而我们无能为力. 解锁是官方的后门, 不是漏洞, 不是破解. 官方随时可以封堵, 而事实上他们也很快这样做了. 能解锁的设备只会越来越少, 这注定是一个没有希望的项目.
ECHO.    我不知道我做下去还有多少意义, 也许只是为了那万分之一的可能吧. 不过假如能帮助到这万分之一, 倒也不算没有意义. 但是一个人的精力是有限的, 我更应该在值得的项目上投入更多, 这是必然的.
ECHO.    就这样吧.
ECHO.
ECHO.                                                                  某贼
ECHO.                                                                2023.6
pause>nul
goto MENU


:SELDEV
SETLOCAL
set logger=viQOO工具箱.bat-seldev
call log %logger% I 进入功能:选择型号
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.选择型号
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.正在联网获取型号列表...
::call dl lzlink https://syxz.lanzoub.com/iKWrI0ynhjva %framwork_workspace%\tmp\dev.csv retry noprompt [1]
call dl direct %dlsource%/dev.csv %framwork_workspace%\tmp\dev.csv retry noprompt [1]
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.选择型号
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
type tmp\dev.csv
ECHO.[A],返回主菜单
ECHO.
:SELDEV-1
ECHOC {%c_h%}输入序号, 按Enter继续: {%c_i%}& set /p choice=
if "%choice%"=="" goto SELDEV-1
if "%choice%"=="A" goto SELDEV-DONE
if "%choice%"=="a" goto SELDEV-DONE
find "[%choice%]," "tmp\dev.csv" 1>nul 2>nul || goto SELDEV-1
for /f "tokens=2,3 delims=," %%a in ('find "[%choice%]," "tmp\dev.csv"') do (set product=%%a& set model=%%b)
call framwork conf user.bat product %product%
call framwork conf user.bat model %model%
call log %logger% I 选择型号:%product%.%model%
goto SELDEV-DONE
:SELDEV-DONE
ENDLOCAL & set product=%product%& set model=%model%
goto MENU


:LOG
SETLOCAL
set logger=viQOO工具箱.bat-log
call log %logger% I 进入功能LOG
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.开关日志
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
if "%framwork_log%"=="y" (ECHO.1.[当前]开启日志) else (ECHO.1.      开启日志)
if "%framwork_log%"=="n" (ECHO.2.[当前]关闭日志) else (ECHO.2.      关闭日志)
call choice common [1][2]
if "%choice%"=="1" call framwork conf framwork.bat framwork_log y
if "%choice%"=="2" call framwork conf framwork.bat framwork_log n
ECHO. & ECHOC {%c_s%}完成. {%c_i%}更改将在下次启动时生效. {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& ENDLOCAL & call log %logger% I 完成功能SLOT& pause>nul & goto MENU


:THEME
SETLOCAL
set logger=viQOO工具箱.bat-theme
call log %logger% I 进入功能THEME
:THEME-1
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.主题
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.默认
ECHO.2.经典
ECHO.3.乌班图
ECHO.4.抖音黑客
ECHO.5.流金
ECHO.6.DOS
ECHO.7.过年好
ECHO.A.返回主菜单
call choice common [1][2][3][4][5][6][7][A]
if "%choice%"=="1" set target=default
if "%choice%"=="2" set target=classic
if "%choice%"=="3" set target=ubuntu
if "%choice%"=="4" set target=douyinhacker
if "%choice%"=="5" set target=gold
if "%choice%"=="6" set target=dos
if "%choice%"=="7" set target=ChineseNewYear
if "%choice%"=="A" ENDLOCAL & call log %logger% I 完成功能THEME& goto MENU
::加载预览
call framwork theme %target%
echo.@ECHO OFF>tmp\theme.bat
echo.mode con cols=50 lines=15 >>tmp\theme.bat
echo.cd ..>>tmp\theme.bat
echo.set path=%framwork_workspace%;%framwork_workspace%\tool\Windows;%framwork_workspace%\tool\Android;%path% >>tmp\theme.bat
echo.COLOR %c_i% >>tmp\theme.bat
echo.TITLE 主题预览: %target% >>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_i%}普通信息{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_w%}警告信息{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_e%}错误信息{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_s%}成功信息{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.ECHOC {%c_h%}手动操作提示{%c_i%}{\n}>>tmp\theme.bat
echo.ECHO. >>tmp\theme.bat
echo.pause^>nul>>tmp\theme.bat
echo.EXIT>>tmp\theme.bat
call framwork theme
start tmp\theme.bat
::加载预览完成
ECHO.
ECHO.已加载预览. 是否使用该主题
ECHO.1.使用   2.不使用
call choice common [1][2]
if "%choice%"=="1" call framwork conf framwork.bat framwork_theme %target%& ECHOC {%c_i%}已更换主题, 重新打开脚本生效. {%c_h%}按任意键关闭脚本...{%c_i%}{\n}& call log %logger% I 更换主题为%target%& pause>nul & EXIT
if "%choice%"=="2" goto THEME-1


:UPDATE
SETLOCAL
set logger=viQOO工具箱.bat-update
call log %logger% I 进入功能UPDATE
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.检查更新
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.正在检查更新...
call dl direct https://syxz.lanzouj.com/b01ey8k6j %framwork_workspace%\tmp\update.txt retry noprompt viqoo_update
for /f "tokens=2 delims=[]" %%i in ('find "viqoo_update" "tmp\update.txt"') do set var=%%i
call dl lzlink %var% %framwork_workspace%\tmp\update.txt retry noprompt [program]
for /f "tokens=2,3,4 delims=," %%a in ('find "[program]" "tmp\update.txt"') do (set prog_ver_new=%%a& set update_log=%%b& set update_lzlink=%%c)
if "%prog_ver%"=="%prog_ver_new%" ECHOC {%c_i%}主程序已是最新版本(V%prog_ver_new%). {%c_h%}按任意键返回主菜单...{%c_i%}{\n}& pause>nul & ENDLOCAL & goto MENU
ECHO.
ECHO.%prog_ver% - %prog_ver_new%
ECHO.%update_log%
ECHO.
ECHOC {%c_h%}按任意键开始更新(会强制结束所有刷机进程)...{%c_i%}{\n}& pause>nul
ECHO.下载更新包... & call dl lzlink %update_lzlink% %framwork_workspace%\tmp\update.7z retry noprompt
ECHO.生成更新脚本...
echo.TITLE viQOO工具箱更新中 请勿关闭窗口...>tmp\update.bat
echo.taskkill /f /im adb.exe>>tmp\update.bat
echo.taskkill /f /im fastboot.exe>>tmp\update.bat
echo.7z.exe x -aoa -o.. tmp\update.7z>>tmp\update.bat
echo.exit>>tmp\update.bat
ECHO.启动更新脚本... & start tmp\update.bat & EXIT











:FATAL
ECHO. & if exist tool\Windows\ECHOC.exe (tool\Windows\ECHOC {%c_e%}抱歉, 脚本遇到问题, 无法继续运行. 请查看日志. {%c_h%}按任意键退出...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.抱歉, 脚本遇到问题, 无法继续运行. 按任意键退出...& pause>nul & EXIT)
