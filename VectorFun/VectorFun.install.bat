@echo off
setlocal

set M9=C:\Program Files\Manifold\v9.0\shared\Addins

if exist "%M9%\VectorFun\" GOTO ALREADYINSTALLED
GOTO DOINST


:DOINST
echo ------- Creating directory VectorFun 
echo ------- under %M9%\ 
mkdir "%M9%\VectorFun"
if exist "%M9%\VectorFun\" GOTO COPYFILES 
GOTO CANNOTCREATEDIR

:COPYFILES
echo ------- Copying add-in files
copy VectorFun.dll           "%M9%\VectorFun\"
copy VectorFun.dll.addin     "%M9%\VectorFun\"
copy VectorFun.uninstall.bat "%M9%\VectorFun\"
copy VectorFun.readme.txt    "%M9%\VectorFun\"
copy VectorFunTest.sql       "%M9%\VectorFun\"
copy VectorFunBase.sql       "%M9%\VectorFun\"
copy VectorFunComplex.sql    "%M9%\VectorFun\"
copy VectorFunConstants.sql  "%M9%\VectorFun\"
copy VectorFunGeom.sql       "%M9%\VectorFun\"

goto END

:CANNOTCREATEDIR
echo Error: Cannot create Addin directory.
echo You must have write permission for %M9%
goto END

:ALREADYINSTALLED
echo Error: Cannot install
echo VectorFun directory already exists
echo Try running %M9%\VectorFun\VectorFun.uninstall.bat first
GOTO END

:END
endlocal
pause


