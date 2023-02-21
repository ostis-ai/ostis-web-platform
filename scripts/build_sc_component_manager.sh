#!/usr/bin/env bash
set -eo pipefail

if [ -z "${SC_COMPONENT_MANAGER_PATH}" ];
then
  source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"/../sc-component-manager/scripts/set_vars.sh
fi

# Need to define this variables to execute build_sc_component_manager.sh
export ROOT_CMAKE_PATH="${SC_COMPONENT_MANAGER_PATH}"
export BUILD_PATH="${SC_COMPONENT_MANAGER_PATH}/build"
"${SC_COMPONENT_MANAGER_PATH}/scripts/build_sc_component_manager.sh" "$@"
