SourceIndexLight_forGit
source index for git repo -- it is faster than the sourceIndex_forGit.
current windbg source index suite doesn't support git repo. here one solution is given by DOS script.

Usage :
Syntax:
gitIndex.cmd <sourceCodeDir> <pdbFilePath>
.e.g
gitIndex.cmd "d:\myProject\newFeature" "d:\myProject\newFeature\output\bin\myApp.pdb"
gitIndex.cmd will make source index for this pdb file "d:\myProject\newFeature\output\bin\myApp.pdb" and update this pdb file.
you can refer to example in path :test/TC_gitIndex.bat

Prompt
a.  for one solution with many projects/binaryModules, one time is enough to call gitIndex.cmd.
    In general , you can call gitIndex.cmd for your pdb file of .exe module.
b.  you can configure the Post-Build Event in your visual studio project to simply thos procedure.
    steps in solution explorer : .exe project > right click > properties > Configuration Properties > Build Events > Post-Build Event :
	Command Line : gitIndex.cmd "$(SolutionDir)" <ProjectPdbFilePath>

Note:
1. config windbg tool path
if your windbg tool "pdbstr.exe" is added to %path%, you needn't do anything , else you need to update the file "userLocalPathConfig.bat"
below is my windbg x86 path setting:
where pdbstr.exe 2>nul || @set "path=C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\srcsrv;%path%"
where windbg.exe 2>nul || @set "path=C:\Program Files (x86)\Windows Kits\10\Debuggers\x86;%path%"

2. you need to repare one local git repo
it is used to update the git repo to specified commit id. 
e.g. assume your git repo path is "D:\sourceCode\myProjectGitRepo" and your git url is https://..../myRepo.git , you need to set environment varialbe :
set "gitRepo_myRepo=D:\sourceCode\myProjectGitRepo"
see :getRepoFromEvnVar in gitFetchRepo.cmd for detail.
this variable is used in "gitFetchRepo.cmd" , certain you can edit "gitFetchRepo.cmd" directly without puting it into system environments.

3. after your debugger has downloaded the pdbfile myApp.pdb file -- assume its path is "c:\symbols\cache\myApp.pdb",
a. if you defined environment variable gitRepo_myRepo, you can run :
   gitFetchRepo.cmd "" "c:\symbols\cache\myApp.pdb"
   the gitFetchRepo.cmd will update the local repo folder indicated by environment variable gitRepo_myRepo.
b. if you doesn't define environment variable gitRepo_myRepo, and your local git repo is "D:\sourceCode\myProjectGitRepo", you can run :
   gitFetchRepo.cmd "D:\sourceCode\myProjectGitRepo" "c:\symbols\cache\myApp.pdb"
   the gitFetchRepo.cmd will update the local repo folder "D:\sourceCode\myProjectGitRepo".

   
