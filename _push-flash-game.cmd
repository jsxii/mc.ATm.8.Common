@echo off
cd \home\_github\mc.ATm.8.Common\
echo -- rm --
d:\usr\git\bin\git.exe rm -r --cached .\
echo -- add --
d:\usr\git\bin\git.exe add --all .\
echo -- stage --
d:\usr\git\bin\git.exe stage
echo -- commit --
d:\usr\git\bin\git.exe commit -m "flash\root"
echo -- push --
d:\usr\git\bin\git.exe push --set-upstream origin master

