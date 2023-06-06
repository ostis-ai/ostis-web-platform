#!/bin/bash
set -eo pipefail

RED='\033[0;31m'
NC='\033[0m' # No Color
echo -e "${RED}[WARNING] This script was deprecated in ostis-web-platform 0.8.0.
Please, use scripts/install_platform.sh instead. It will be removed in in ostis-web-platform 0.9.0.${NC}"

if [[ -z ${PLATFORM_PATH+1} ]];
then
  CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
  source "${CURRENT_DIR}/set_vars.sh"
  source "${CURRENT_DIR}/formats.sh"
fi

build_kb=1
build_sc_machine=1
build_sc_web=1

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

clone_project()
{
	if [ ! -d "${PLATFORM_PATH}/$2" ]; then
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

if (( $build_sc_machine == 1 ));
then
  prepare "SC-machine"

  cd "${SC_MACHINE_PATH}"
  git submodule update --init --recursive
  "${SC_MACHINE_PATH}/scripts/install_deps_ubuntu.sh" --dev

  "${SC_MACHINE_PATH}/scripts/make_all.sh"
fi


if (( $build_sc_web == 1 )); then
  prepare "SC-web"

  "${SC_WEB_PATH}/scripts/install_deps_ubuntu.sh"

  "${SC_WEB_PATH}/scripts/build_sc_web.sh"
fi

if (( $build_kb == 1 )); then
	stage "Build knowledge base"
	"${APP_ROOT_PATH}/scripts/build_kb.sh"
fi

cd "${WORKING_PATH}"
