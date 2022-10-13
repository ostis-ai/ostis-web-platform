#!/bin/bash

st=1

build_kb=1
build_sc_machine=1
build_sc_web=1

set -eo pipefail

while [ "$1" != "" ]; do
	case $1 in
		"no_build_kb" )
			build_kb=0
			;;
		"no_build_sc_machine" )
			build_sc_machine=0
			build_kb=0
			;;
		"no_build_sc_web" )
			build_sc_web=0
	esac
	shift
done

stage()
{
	echo -en "[$1]\n"
	let "st += 1"
}

clone_project()
{
	if [ ! -d "../$2" ]; then
		printf "Clone %s\n" "$1"
		git clone "$1" ../"$2"
		cd ../"$2"
		git checkout "$3"
		cd -
	else
		echo -e "You can update $2 manualy\n"
	fi
}

stage "Clone projects"

clone_project https://github.com/ostis-ai/sc-machine.git sc-machine main
clone_project https://github.com/ostis-ai/sc-web.git sc-web main

git submodule update --init --recursive

stage "Prepare projects"

prepare()
{
	echo -en "$1\n"
}

if (( $build_sc_machine == 1 )); then
prepare "sc-machine"

cd ../sc-machine
git submodule update --init --recursive
cd scripts
./install_deps_ubuntu.sh --dev


cd ..
pip3 install setuptools wheel
pip3 install -r requirements.txt


cd scripts
	./make_all.sh
cd ..
fi


if (( $build_sc_web == 1 )); then
prepare "sc-web"
pip3 install --default-timeout=100 future


cd ../sc-web/scripts

./install_deps_ubuntu.sh --dev

cd -
cd ../sc-web
pip3 install -r requirements.txt

npm install
npm run build
fi

if (( $build_kb == 1 )); then
	stage "Build knowledge base"
	cd ../scripts
	./build_kb.sh
fi
