#!/bin/bash

export LD_LIBRARY_PATH=./sc-machine/bin
../sc-machine/bin/sctp-server ../config/sc-web.ini
