#!/bin/bash
REPO_PATH_FILE="repo.path"
PREPARED_KB="prepared_kb"

export LD_LIBRARY_PATH=./sc-machine/bin
if [ ! -d "../kb.bin" ]; then
    mkdir ../kb.bin
fi

python3 kb_scripts/prepare_kb.py "${PWD%/[^/]*}" $PREPARED_KB $REPO_PATH_FILE

cd ..
sc-machine/bin/sc-builder -f -c -i $PREPARED_KB/$REPO_PATH_FILE -o kb.bin -s config/sc-web.ini -e sc-machine/bin/extensions


