@echo off
cd C:\Local\_github\mc.ATm.8.Common\
echo -- rm --
c:\usr\git\bin\git.exe rm -r --cashed .\
echo -- add --
c:\usr\git\bin\git.exe add --all .\
echo -- stage --
c:\usr\git\bin\git.exe stage
echo -- commit --
c:\usr\git\bin\git.exe commit -m "12th"
echo -- push --
c:\usr\git\bin\git.exe push 

