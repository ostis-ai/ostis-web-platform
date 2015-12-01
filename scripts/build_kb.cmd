@echo off

pushd ..
sc-machine\bin\sc-builder -f -c -i repo.path -o kb.bin -s config\sc-web.ini -e sc-machine\bin\extensions
popd