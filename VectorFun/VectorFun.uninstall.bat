@echo off
setlocal


set M9=C:\Program Files\Manifold\v9.0\shared\Addins


if exist "%M9%\VectorFun\" GOTO PROMPT
GOTO NOTHINGTOUNINSTALL

:PROMPT
SET /P AREYOUSURE=Are you sure you want to delete VectorFun ([Y]/N)?
IF /I "%AREYOUSURE%" NEQ "N" GOTO DOUNINST
GOTO DONOTWANT


:DOUNINST
cd..
del "%M9%\VectorFun\VectorFun.dll"
if exist "%M9%\VectorFun\VectorFun.dll" GOTO NOLUCK
echo VectorFun.dll deleted. 
rmdir /S /Q "%M9%\VectorFun\"
if exist "%M9%\VectorFun\" GOTO NOLUCK
goto END

:NOLUCK
echo Error: Cannot delete VectorFun.dll. Perhaps you have Manifold running.
echo %M9%\VectorFun\
GOTO END


:DONOTWANT
echo Uninstall skipped.
GOTO END

:NOTHINGTOUNINSTALL
echo Nothing to uninstall
echo VectorFun directory does not exist
GOTO END

:END
endlocal
pause
