@echo off
echo -- rm --
c:\usr\git\bin\git.exe rm -r --cached .\
echo -- add --
c:\usr\git\bin\git.exe add --all .\
echo -- stage --
c:\usr\git\bin\git.exe stage
echo -- commit --
c:\usr\git\bin\git.exe commit -m "0300wsbss00182\ivm"
echo -- push --
c:\usr\git\bin\git.exe push --set-upstream origin master

