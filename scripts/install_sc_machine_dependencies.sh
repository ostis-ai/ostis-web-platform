#!/usr/bin/env bash
set -eo pipefail

SCRIPTS_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${SCRIPTS_DIR}/formats.sh"

if [ -z "${SC_MACHINE_PATH}" ];
then
  source "${SCRIPTS_DIR}/set_vars.sh"
fi

stage "Install sc-machine dependencies"

"${SC_MACHINE_PATH}/scripts/install_dependencies.sh" "$@"

stage "Dependencies of sc-machine installed successfully"
