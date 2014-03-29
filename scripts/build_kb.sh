export LD_LIBRARY_PATH=../sc-machine/bin
mkdir repo.bin
../sc-machine/bin/sc-builder -f -c -e ../sc-machine/bin/extensions -s ../config/sc-web.ini -i ../kb.sources -o ../repo.bin

