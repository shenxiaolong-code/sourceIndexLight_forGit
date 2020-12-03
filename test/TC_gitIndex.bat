
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
cd /d "%~dp0"
call "%~dp0TC_userLocalPathConfig.bat"
set curCmd=call "%~dp0..\gitIndex.bat" "%tc_localGitRepo%"  "%tc_onePdbFilePath%"
echo %curCmd%
%curCmd%