#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${CURRENT_DIR}/formats.sh"

if [ -z "${SC_MACHINE_PATH}" ];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi

args=()
install_component_manager_dependencies=false
for arg in "$@"; do
  if [ "$arg" != "-cm" ]; then
      args+=("$arg")
  else install_component_manager_dependencies=true
  fi
done

stage "Install sc-machine dependencies"

"${SC_MACHINE_PATH}/scripts/install_deps_ubuntu.sh" "${args[@]}"

if [ $install_component_manager_dependencies ]; 
then
  "${SC_MACHINE_PATH}/scripts/install_sc_component_manager_dependencies.sh" "${args[@]}"
fi

stage "Dependencies of sc-machine installed successfully"
