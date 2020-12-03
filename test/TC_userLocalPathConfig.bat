
@if {%_Echo%}=={1} ( @echo on ) else ( @echo off )
set "tc_localGitRepo=D:\sourceCode\jabberGit129"
set "tc_localGitRepo_fetch=D:\sourceCode\jabberGit128"
set "tc_onePdbFilePath=D:\sourceCode\jabberGit129\components\accessories-manager\plugins_external\windows\CiscoJabberStandalone.pdb"
echo test case path :
echo tc_localGitRepo        = %tc_localGitRepo%
echo tc_localGitRepo_fetch  = %tc_localGitRepo_fetch%
echo tc_onePdbFilePath      = %tc_onePdbFilePath%
echo.

:: ******************************** verify path ********************************************************
if not exist "%tc_onePdbFilePath%" (
echo pdb file is not geneated. below path is copied to your clipboard.
echo path : %tc_onePdbFilePath%
echo %tc_onePdbFilePath% | clip
pause
)
