::source index for git repo -- xlshen@126.com
::Author    : Shen Xiaolong(xlshen2002@hotmail.com,xlshen@126.com)
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).
::usage     : call gitIndex.cmd "%LocalGitRepoPath%" "%pdbFilePathWithoutIndex%"
::@set _Echo=1
::@set EchoCmd=%~nx0
::@set _Debug=1
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo. & @echo [Enter %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

call :CheckInput %*
call :config
set gitInfoFile=%temp%\windbg\%~n0_%~n2.txt
if exist "%gitInfoFile%" del /f/q "%gitInfoFile%"
call :genGitRepoInfo "%gitInfoFile%" %*
echo.
echo srcsrvGit info:
type "%gitInfoFile%"
echo.
echo write srcsrvGit ...
call :pdb.write "%~fs2" "%gitInfoFile%"
echo.
echo read srcsrvGit ...
call :pdb.read "%~fs2"
goto :End

:pdb.write
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
pdbstr.exe -w -p:"%~fs1" -i:"%~fs2" -s:srcsrvGit
goto :eof

:pdb.read
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
pdbstr.exe -r -p:"%~fs1" -s:srcsrvGit
goto :eof

:genGitRepoInfo
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
if not exist "%~dp1"  md "%~dp1"
for /F "usebackq tokens=*" %%i in ( ` git -C "%~2" config remote.upstream.url ` )  do set originRepoUrlAll=%%i
:: remove credential
set "originRepoUrl=https://%originRepoUrlAll:*@=%"
@for /f "usebackq tokens=*" %%1 in ( ` git -C "%~2" rev-parse --abbrev-ref --symbolic-full-name @{u} ` ) do call set "brNameRemote=%%1"
@call set "brNameRemote=%brNameRemote:*/=%"
@for /F "usebackq tokens=*" %%1 in ( ` git -C "%~2" rev-parse --short HEAD ` )   do set lastCommitID=%%1
for /f "usebackq tokens=*" %%i in ( ` git -C "%~2" status -uno --porcelain ^| find /c /v "^*" ` ) do set bNeedSave=%%i
(
echo time=%date% %time%
echo originRepoUrl=%originRepoUrl%
echo branchName=%brNameRemote%
echo lastCommitID=%lastCommitID%
echo gitRoot=%~2
echo bNeedSave=%bNeedSave%
) > "%~fs1"
goto :eof

:CheckInput
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
if {"%~2"}=={""} call :usage  & call :ErrMsg "parameter is not enough"
if not exist "%~fs2" call :ErrMsg "pdb file doesn't exist"
set "lowerExt=%~x2"
call :toLower lowerExt
if not {"%lowerExt%"}=={".pdb"} call :ErrMsg "2nd file MUST be a pdb file"
call :gitLocalRootPath "%~1" gitRoot
if not defined gitRoot call :ErrMsg "%~1 is NOT a git repo"
goto :eof

:ErrMsg
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
echo.
echo [Error] %~1
echo press any key to exit current script.
exit
goto :eof

:config
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
call "%~dp0userLocalPathConfig.bat"
where pdbstr.exe 1>nul 2>nul || call :ErrMsg "can't find windbg folder, please check file %~dp0userLocalPathConfig.bat"
goto :eof

:usage
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
echo.
echo call %~nx0 repoPath  pdbFilePath
echo for example :
echo call gitIndex.bat "D:\sourceCode\jabberGit140"  "D:\sourceCode\jabberGit140\products\jabber-win\src\jabber-client\jabber-build\Win32\bin\Release\CiscoJabber.pdb"
echo.
goto :eof

:toLower 
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
for %%a in ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i"
            "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r"
            "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z" "?=?"
            "?=?" "จน=จน") do (
    call set %~1=%%%~1:%%~a%%
)
goto :eof

:gitLocalRootPath
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
set %~2=
git -C "%~fs1" config --get remote.origin.url 1>nul 2>nul || goto :eof
for /f "usebackq tokens=*" %%i in ( ` git -C "%~fs1" rev-parse --show-toplevel ` ) do set _tmpLocalPath=%%i
if defined _tmpLocalPath set %~2=%_tmpLocalPath:/=\%
goto :eof


:End
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [Leave %~nx0] commandLine: %0 %* & @echo.