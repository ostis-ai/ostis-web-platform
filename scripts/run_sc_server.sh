#!/bin/bash
export LD_LIBRARY_PATH=../sc-machine/bin
python3 ../sc-machine/scripts/run_sc_server.py -c ../web-platform-config.ini
