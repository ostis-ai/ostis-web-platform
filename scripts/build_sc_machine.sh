#!/usr/bin/env bash
set -eo pipefail

if [ -z "${SC_MACHINE_PATH}" ];
then
  source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"/set_vars.sh
fi

export ROOT_CMAKE_PATH="${SC_MACHINE_PATH}"
export BUILD_PATH="${SC_MACHINE_PATH}/build"
"${SC_MACHINE_PATH}/scripts/build_sc_machine.sh" "$@"
