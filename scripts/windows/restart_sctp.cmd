@echo off

call build_kb
pushd ..
..\sc-machine\bin\sctp-server ..\config\sc-web.ini
popd