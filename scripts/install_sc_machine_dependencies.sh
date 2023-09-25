#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${CURRENT_DIR}/formats.sh"

if [ -z "${SC_MACHINE_PATH}" ];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi

install_component_manager_dependencies=false
while [ "$1" != "" ]; do
	case $1 in
    "-cm"|"--component-manager" )
      install_component_manager_dependencies=true
      ;;
	esac
	shift 1
done

stage "Install sc-machine dependencies"

"${SC_MACHINE_PATH}/scripts/install_deps_ubuntu.sh" "$@"

if [ $install_component_manager_dependencies ]; 
then
  "${SC_MACHINE_PATH}/scripts/install_sc_component_manager_dependencies.sh" "$@"
fi

stage "Dependencies of sc-machine installed successfully"
