#!/bin/bash

red="\e[1;31m"  # Red B
blue="\e[1;34m" # Blue B
green="\e[0;32m"

bwhite="\e[47m" # white background

rst="\e[0m"     # Text reset

st=1

build_kb=1
build_sc_machine=1

while [ "$1" != "" ]; do
	case $1 in
		"no_build_kb" )
			build_kb=0
			;;
		"no_build_sc_machine" )
			build_sc_machine=0
			build_kb=0
			;;
	esac
	shift
done

stage()
{
	echo -en "$green[$st] "$blue"$1...$rst\n"
	let "st += 1"
}

clone_project()
{
	if [ ! -d "../$2" ]; then
		echo -en $green"Clone $2$rst\n"
		git clone $1 ../$2
		cd ../$2
		git checkout $3
		cd -
	else
		echo -en "You can update "$green"$2"$rst" manualy$rst\n"
	fi
}

stage "Clone projects"

clone_project https://github.com/ostis-ai/sc-machine.git sc-machine main
clone_project https://github.com/ostis-ai/sc-web.git sc-web main
clone_project https://github.com/ostis-ai/ims.ostis.kb.git ims.ostis.kb main

stage "Prepare projects"

prepare()
{
	echo -en $green$1$rst"\n"
}

prepare "sc-machine"

cd ../sc-machine
git submodule update --init --recursive


cd scripts
./install_deps_ubuntu.sh


cd ..
pip3 install setuptools wheel
pip3 install -r requirements.txt


cd scripts
if (( $build_sc_machine == 1 )); then
	./make_all.sh
fi
cd ..


prepare "sc-web"
sudo yes | sudo pip3 install --default-timeout=100 future


cd ../sc-web/scripts

./install_deps_ubuntu.sh
./install_nodejs_dependence.sh


cd -
cd ../sc-web
npm install
grunt build

if (( $build_kb == 1 )); then
	stage "Build knowledge base"
	cd ../scripts
	./build_kb.sh
fi
