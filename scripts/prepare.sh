#!/usr/bin/env bash
set -eo pipefail

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
  if [ ! -d "$2" ]; then
    printf "Clone submodule %s (%s) into %s\n" "$1" "$3" "$2"
    git clone "$1" --branch "$3" --single-branch "$2" --recursive
  else
    printf "You can update %s manually.\n" "$2"
  fi
}

stage "Clone projects"

clone_project "${SC_MACHINE_REPO}" "${SC_MACHINE_PATH}" "${SC_MACHINE_BRANCH}"
clone_project "${SC_WEB_REPO}" "${SC_WEB_PATH}" "${SC_WEB_BRANCH}"

git submodule update --init --recursive

stage "Prepare projects"

prepare()
{
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

  "${SC_WEB_PATH}/scripts/install_deps_ubuntu.sh"

  "${SC_WEB_PATH}/scripts/build_sc_web.sh"
fi

if (( build_kb == 1 )); then
  stage "Build knowledge base"
  "${PLATFORM_PATH}/scripts/build_kb.sh"
fi
