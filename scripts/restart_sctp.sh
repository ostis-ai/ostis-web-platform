export LD_LIBRARY_PATH=../sc-machine/bin
./build_kb.sh
../sc-machine/bin/sctp-server ../config/sc-web.ini
