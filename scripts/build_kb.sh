#!/bin/bash

./copy_ims_kb.sh

export LD_LIBRARY_PATH=../sc-machine/bin
if [ ! -d "../kb.bin" ]; then
    mkdir ../kb.bin
fi

cd ..
sc-machine/bin/sc-builder -f -c -i repo.path -o kb.bin -s config/sc-web.ini -e sc-machine/bin/extensions


