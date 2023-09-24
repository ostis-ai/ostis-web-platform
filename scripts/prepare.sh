#!/usr/bin/env bash
set -eo pipefail

<<<<<<< HEAD
YELLOW='\033[01;33m'
NC='\033[0m' # No Color
echo -e "${YELLOW}[WARNING] This script was deprecated in ostis-web-platform 0.8.0.
Please, use scripts/install_platform.sh instead. It will be removed in in ostis-web-platform 0.9.0.${NC}"

CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${CURRENT_DIR}/formats.sh"

if [[ -z "${PLATFORM_PATH}" || -z "${SC_MACHINE_PATH}" || -z "${SC_WEB_PATH}" ]];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi
=======
st=1
>>>>>>> main

build_kb=1
build_sc_machine=1
build_sc_web=1
<<<<<<< HEAD
=======

set -eo pipefail
>>>>>>> main

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

<<<<<<< HEAD
clone_project()
{
  if [ ! -d "$2" ]; then
    printf "Clone submodule %s (%s) into %s\n" "$1" "$3" "$2"
    git clone "$1" --branch "$3" --single-branch "$2" --recursive
  else
    printf "You can update %s manually.\n" "$2"
  fi
=======
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
>>>>>>> main
}

stage "Clone projects"

<<<<<<< HEAD
clone_project "${SC_MACHINE_REPO}" "${SC_MACHINE_PATH}" "${SC_MACHINE_BRANCH}"
clone_project "${SC_WEB_REPO}" "${SC_WEB_PATH}" "${SC_WEB_BRANCH}"
=======
clone_project https://github.com/ostis-ai/sc-machine.git sc-machine 0.7.0-Rebirth
clone_project https://github.com/ostis-ai/sc-web.git sc-web 0.7.0-Rebirth
>>>>>>> main

git submodule update --init --recursive

stage "Prepare projects"

prepare()
{
<<<<<<< HEAD
  echo -en "$1\n"
}

if (( build_sc_machine == 1 ));
then
  prepare "SC-machine"

  cd "${SC_MACHINE_PATH}"
  git submodule update --init --recursive
  "${SC_MACHINE_PATH}/scripts/install_deps_ubuntu.sh" --dev

  "${SC_MACHINE_PATH}/scripts/make_all.sh"
fi


if (( build_sc_web == 1 )); then
  prepare "SC-web"
=======
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
>>>>>>> main

  "${SC_WEB_PATH}/scripts/install_deps_ubuntu.sh"

<<<<<<< HEAD
  "${SC_WEB_PATH}/scripts/build_sc_web.sh"
fi

if (( build_kb == 1 )); then
  stage "Build knowledge base"
  "${PLATFORM_PATH}/scripts/build_kb.sh"
=======
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
>>>>>>> main
fi
