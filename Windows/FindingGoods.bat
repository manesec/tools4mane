@echo off
setlocal enabledelayedexpansion

rem ======================  config  ======================
set keyWords=password username db secret
rem set keyWords=password pass user username db db_user db_pass database mysql sqlite admin root key secret apikey api_key
set outputDir=foutput

rem ======================  dont touch  ======================

rmdir /s /q "%outputDir%" >nul 2>nul & verify >nul

mkdir "%outputDir%"
mkdir "%outputDir%\raw"
mkdir "%outputDir%\analysis"
mkdir "%outputDir%\fileext"
mkdir "%outputDir%\tmp"

rem ======================  search common extension  ======================
echo.        ((               search goods script                ))
echo.        ((            using fd.exe and rg.exe               ))
echo.                    [===] Power by manesec [===]
echo.                 https://github.com/manesec/tools4mane
echo.=====================================================================
echo [*] Searching common extension files ...

set searchExt=txt pcap pcapng md 

rem zip files
set searchExt=%searchExt% zip zipx tar gz z cab bz2 7z rar lzh img iso xz vhd vmdk

rem documents
set searchExt=%searchExt% odt rtf doc dot wbk docx docm dotx dotm pdf wll wwl xls xlt xlm xlsx xlsm xltx xltm xlsb xla xlam xll xlw xll_ xla_ xla5 xla8 ppt pot pps ppa pptx pptm potx potm ppam ppsx ppsm sldx sldm ppam accda accdb accde accdr accdt accdu one ecf pub csv 

rem webserver files
set searchExt=%searchExt% asp aspx php php3 php4 php5 php7 php8 pht phar phpt pgif phtml phtm jsp cgi py html js css pl jar war swf

rem databases files
set searchExt=%searchExt% db db3 sql mdb sqlite 

rem config files
set searchExt=%searchExt% conf ini config xml json yml yaml inf

rem shell script
set searchExt=%searchExt% sh bat ps1 rb 

rem hidden files
set searchExt=%searchExt% htaccess htpasswd properties env 

rem cert files
set searchExt=%searchExt% pem crt key kdb kdbx ccache

rem backup files
set searchExt=%searchExt% bak old swp swp backup hive dit

rem project files
set searchExt=%searchExt% sln cs csproj vb vbproj java class

rem debug files
set searchExt=%searchExt% idb pdb dmp

rem some log files
set searchExt=%searchExt% log

rem put it all together
set allExt=
for %%i in (%searchExt%) do (
    set allExt=!allExt! -e %%i
)

fd.exe -a --type f -HIi -E "site-packages" -E "distutils" -E "**/Python*/Lib/**" -E "**/lib/python*/**" -E "**/Python/**/Lib/**" -E "**/AppData/Local/Programs/Python/**" -E "/Windows/" -E "/ProgramData/VMware" %allExt% . C:\ > "%outputDir%\raw\all_extension_file.txt"

rem ======================  search begin with dot file  ======================
echo [*] Searching begin with dot file ...
fd.exe -a -t f -HI --exclude "/Windows/" "^\." C:\ > "%outputDir%\raw\dot.txt"

rg.exe -v ".git" "%outputDir%\raw\dot.txt" > "%outputDir%\analysis\dot.txt"
rem ======================  search hidden folder  ======================

echo [*] Searching Recycle.Bin files ...
fd.exe -a --type f -HIip "\$Recycle.Bin" C:\ > "%outputDir%\analysis\recycle_bin.txt"

rem ======================  analysis file extension  ======================
echo [*] Analysising file extension ...
for %%i in (%searchExt%) do (
	rg.exe "\.%%i$" "%outputDir%\raw\all_extension_file.txt" > "%outputDir%\fileext\%%i.txt"
)

rem ======================  search common software - git  ======================
echo [*] Searching .git/head
fd.exe -a -HI -p "\.git\\head$" C:\ > "%outputDir%\analysis\git_repo.txt"

rem ======================  grep with the text  ======================

call :clearzerokb
echo [*] Grep with the keywords ...


set searchExt=asp aspx php php3 php4 php5 php7 php8 pht phar phpt pgif phtml phtm jsp cgi py pl md sql mdb conf ini config txt xml json yml yaml sh bat ps1 rb log js inf
set allExt=
for %%i in (%searchExt%) do (
    set allExt=!allExt! -e %%i
)

rem get all txt file
for %%k in (%keyWords%) do (
	echo.    - Searching keyWords of %%k ...
	fd.exe -a -HI -p %allExt% -E "site-packages" -E "distutils" -E "**/Python*/Lib/**" -E "**/lib/python*/**" -E "**/Python/**/Lib/**" -E "**/AppData/Local/Programs/Python/**" -E "/Windows/" -E "/ProgramData/VMware" . C:\ -x rg.exe -m 1 -F -il "%%k"  >> "%outputDir%\analysis\keyword_%%k.txt"
)

call :clearzerokb

rem ======================  grep with filename  ======================
echo [*] Grep Filename ...
rg.exe "history" "%outputDir%\raw\all_extension_file.txt" > "%outputDir%\analysis\history.txt"





rem ======================  All all file into foutput.7z  ======================
call :clearzerokb
call :sortfilecontent
rmdir /s /q "%outputDir%\tmp" >nul 2>nul & verify >nul


echo [*] Zipping file into %outputDir%.7z ...
del %outputDir%.7z
7z.exe a %outputDir%.7z ".\%outputDir%\*" -r

exit /b

rem ===============================
rem process should be exit in here.
rem ===============================

rem ======================  Function definition   ======================

:: Removing 0KB files
:clearzerokb

echo [*] Removing 0 KB files ...
fd.exe -a -S 0KB . "%outputDir%" > "%outputDir%\tmp\0kb_file.txt"

set "command_file=%outputDir%\tmp\0kb_file.txt"
for /f "usebackq delims=" %%a in ("%command_file%") do (
    del "%%a"
)

exit /b

:: Sort txt file content
:sortfilecontent
echo [*] Sorting file content ...
fd.exe -a -t f -e txt . "%outputDir%" > "%outputDir%\tmp\sort_tmp.txt"

set "command_file=%outputDir%\tmp\sort_tmp.txt"
for /f "usebackq delims=" %%a in ("%command_file%") do (
    sort < "%%a" > "%%a.tmp"
	del /Y "%%a" >nul
	move /Y "%%a.tmp" "%%a" >nul
)

exit /b