#!/bin/bash
export LD_LIBRARY_PATH=../sc-machine/bin
../sc-machine/bin/sc-server -e ../sc-machine/bin/extensions -r ../kb.bin -i ../sc-machine/bin/config.ini
