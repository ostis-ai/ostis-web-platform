#!/bin/bash
REPO_PATH_FILE="repo.path"
PREPARED_KB="prepared_kb"

ERRORS_FILE="${PWD}/prepare.log"
touch "$ERRORS_FILE"

export LD_LIBRARY_PATH=./sc-machine/bin
if [ ! -d "../kb.bin" ]; then
    mkdir ../kb.bin
fi

python3 kb_scripts/prepare_kb.py "${PWD%/[^/]*}" $PREPARED_KB $REPO_PATH_FILE "$ERRORS_FILE"


if [[ -f ${ERRORS_FILE} && ! ( -s ${ERRORS_FILE} )]];
then
  cd ..
  sc-machine/bin/sc-builder -f -c -i $PREPARED_KB/$REPO_PATH_FILE -o kb.bin -s config/sc-web.ini -e sc-machine/bin/extensions
  rm "$ERRORS_FILE"
fi

