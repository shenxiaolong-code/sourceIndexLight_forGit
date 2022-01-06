

# SourceIndexLight_forGit  
windbg source index for git repo -- it is faster than the sourceIndex_forGit.  
The current windbg source index suite doesn't support git repo. here one solution is given by DOS script.

# source index Usage  
- Syntax:  
  gitIndex.cmd \<sourceCodeDir\> \<pdbFilePath\>
- example
  gitIndex.cmd "d:\myProject\newFeature" "d:\myProject\newFeature\output\bin\myApp.pdb"  
  gitIndex.cmd will make source index for this pdb file "d:\myProject\newFeature\output\bin\myApp.pdb" and update this pdb file.  
you can refer to the example in path : test/TC_gitIndex.bat  

### Prompt
-  for one solution with many projects/binary modules, one time is enough to call gitIndex.cmd.  
   In general, you can call gitIndex.cmd for your PDB file of the .exe module.
- you can configure the Post-Build Event in your visual studio project to simplify this procedure.  
  teps in solution explorer : .exe project > right click > properties > Configuration Properties > ild Events > Post-Build Event :  
  Command Line : gitIndex.cmd "$(SolutionDir)" \<ProjectPdbFilePath\>

# you need to do:
1. config windbg tool path  
if your windbg tool "pdbstr.exe" is added to %path%, you needn't do anything, else you need to update the file "userLocalPathConfig.bat"  
below is my windbg x86 path setting:  
where pdbstr.exe 2>nul || @set "path=C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\srcsrv;%path%"  
where windbg.exe 2>nul || @set "path=C:\Program Files (x86)\Windows Kits\10\Debuggers\x86;%path%"  

2. prepare one local git repo  
it is used to update the git repo to a specified commit id.   

    example:   
    assume your git repo path is "D:\sourceCode\myProjectGitRepo"   
    your git url is https://..../myRepo.git   
    you need to set environment varialbe :  
    set "gitRepo_myRepo=D:\sourceCode\myProjectGitRepo"  
    see *:getRepoFromEvnVar* in **gitFetchRepo.cmd** for detail.  
    *this variable is used in "gitFetchRepo.cmd" , certain you can edit "gitFetchRepo.cmd" directly without puting it into system environments*.  

# use symbol with source index 
1. debugg application  
   after you config your symbol path, the debugger will download the symbol file(.pdb) automatically.  
   and source server (srcsrv) will fetch the correct version source file according to the source index information in the .pdb file.  
   after the source file is downloaded , debuger will open it automaticaly and locate the current source code line.  

2. **optional** download source file manual   
  after your debugger has downloaded the pdbfile myApp.pdb file -- assume its path is "c:\symbols\cache\myApp.pdb"  
   - if you defined environment variable gitRepo_myRepo, you can run :  
     gitFetchRepo.cmd "" "c:\symbols\cache\myApp.pdb"  
     the gitFetchRepo.cmd will update the local repo folder indicated by environment variable    gitRepo_myRepo.
   - if you doesn't define environment variable gitRepo_myRepo  
     if your local git repo is "D:\sourceCode\myProjectGitRepo", you can run :  
     gitFetchRepo.cmd "D:\sourceCode\myProjectGitRepo" "c:\symbols\cache\myApp.pdb"  
     the gitFetchRepo.cmd will update the local repo folder "D:\sourceCode\myProjectGitRepo".
