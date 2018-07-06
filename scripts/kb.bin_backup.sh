#!/bin/bash

export LD_LIBRARY_PATH=./sc-machine/bin

if [ ! -d "../kb.bin_backup" ]; then
	mkdir ../kb.bin_backup
	cd ../kb.bin_backup
	git init
	cd -
fi

cd ../
rm -rf kb.bin_backup/kb.bin
cp -a kb.bin kb.bin_backup/

cd ./kb.bin_backup
git add --all && git commit -m "$(date)"

cd -


