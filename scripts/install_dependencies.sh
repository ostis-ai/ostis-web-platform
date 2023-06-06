#!/bin/bash
set -eo pipefail

if [[ -z ${SC_MACHINE_PATH+1} ]];
then
  CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
  source "${CURRENT_DIR}/set_vars.sh"
  source "${CURRENT_DIR}/formats.sh"
fi

stage "Install dependencies"

"${SC_MACHINE_PATH}/scripts/install_deps_ubuntu.sh" --dev
"${SC_WEB_PATH}/scripts/install_deps_ubuntu.sh"

cd "${WORKING_PATH}"

stage "Dependencies installed"
