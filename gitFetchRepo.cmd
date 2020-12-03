::source index for git repo -- xlshen@126.com
::Author    : Shen Xiaolong(xlshen2002@hotmail.com,xlshen@126.com)
::Copyright : free use,modify,spread, but MUST include this original two line information(Author and Copyright).
::usage     : call gitFetchRepo.cmd "%LocalGitRepoPath%" "%pdbFilePathWithIndex%"
::@set _Echo=1
::@set EchoCmd=%~nx0
::@set _Debug=1

@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo. & @echo [Enter %~nx0] commandLine: %0 %*
where "%~nx0" 1>nul 2>nul || set "path=%~dp0;%path%"

call :CheckInput %*
call :config
echo read srcsrvGit ...
call :pdb.read "%~fs2"
if not defined lastCommitID call :ErrMsg "Fails to read srcsrvGit".
echo.
echo srcsrvGit info:
echo.
call :dumpSrcsrvGit
call :updateRepo "%~1"
goto :End

:updateRepo
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
set "localRepoFolder=%~1"
if not exist "%localRepoFolder%" call :getRepoFromEvnVar
if not exist "%localRepoFolder%" call :ErrMsg "local git repo '%localRepoFolder%' doesn't exist"
set "_tmpFolderBackup=%cd%"
cd /d "%localRepoFolder%"
call :updateRepo.impl
cd /d "%_tmpFolderBackup%"
goto :eof

:updateRepo.impl
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
@for /F "usebackq tokens=*" %%1 in ( ` git rev-parse --abbrev-ref HEAD ` )    do set curBranchName=%%1
if not {"%branchName%"}=={"%curBranchName%"} (
echo current branch is '%curBranchName%' , switch to branch '%branchName%'
git checkout -f %branchName%
)
git fetch --all
git pull -X theirs
echo up to commit ID : %lastCommitID%
git reset --hard %lastCommitID%
echo.
goto :eof

:getRepoFromEvnVar
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
set "dummy=%originRepoUrl:/=" & set "repoVar=%"
set "repoVar=%repoVar:~0,-4%"
if not defined gitRepo_%repoVar% call :ErrMsg "Environment gitRepo_%repoVar% is not defined , it indictes the local repo folder for %originRepoUrl%."
call set "localRepoFolder=%%gitRepo_%repoVar%%%"
goto :eof

:pdb.read
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
set "_tmpSrcsrvGitFolder=%temp%\windbg"
if not exist "%_tmpSrcsrvGitFolder%\" md "%_tmpSrcsrvGitFolder%\"
set "_tmpSrcsrvGitFile=%_tmpSrcsrvGitFolder%\srcsrvGit_%~n1.txt"
if exist "%_tmpSrcsrvGitFile%" del /f/q "%_tmpSrcsrvGitFile%"
pdbstr.exe -r -p:"%~fs1" -s:srcsrvGit > "%_tmpSrcsrvGitFile%"
for /f "usebackq tokens=*" %%i in ( ` type "%_tmpSrcsrvGitFile%" ` ) do call set "%%~i"
goto :eof

:dumpSrcsrvGit
@for %%a in ( 1 "%~nx0" "%0" %EchoCmdList% ) do @if {"%%~a"}=={"%EchoCmd%"} @echo [%~nx0] commandLine: %0 %*
echo time=%time%
echo originRepoUrl=%originRepoUrl%
echo branchName=%branchName%
echo lastCommitID=%lastCommitID%
echo gitRoot=%gitRoot%
echo bNeedSave=%bNeedSave%
echo.
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
echo call gitFetchRepo.cmd "D:\sourceCode\jabberGit140\products\jabber-win\src\jabber-client\jabber-build\Win32\bin\Release\CiscoJabber.pdb"
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