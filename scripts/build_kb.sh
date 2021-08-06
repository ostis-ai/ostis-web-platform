#!/bin/bash

export LD_LIBRARY_PATH=./sc-machine/bin
if [ ! -d "../kb.bin" ]; then
    mkdir ../kb.bin
fi


python3 kb_scripts/prepare_kb.py

cd ..
sc-machine/bin/sc-builder -f -c -i prepared_kb/repo.path -o kb.bin -s config/sc-web.ini -e sc-machine/bin/extensions


