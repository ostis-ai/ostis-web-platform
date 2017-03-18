#!/bin/bash

task="*/$1 * * * * cd $PWD && ./kb.bin_backup.sh"
(crontab -l; echo "$task") | crontab -
