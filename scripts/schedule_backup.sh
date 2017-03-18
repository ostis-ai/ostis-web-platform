#!/bin/bash

task="*/$1 * * * * $PWD/kb.bin_backup.sh"
(crontab -l; echo "$task") | crontab -
