
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
cd /d "%~dp0"
call "%~dp0TC_userLocalPathConfig.bat"
set curCmd=call "%~dp0..\gitFetchRepo.cmd" "%tc_localGitRepo_fetch%" "%tc_onePdbFilePath%"
echo %curCmd%
%curCmd%


echo.
cd /d "%tc_localGitRepo_fetch%"