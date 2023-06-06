#!/bin/bash
set -eo pipefail

if [[ -z ${SC_MACHINE_PATH+1} ]];
then
  CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
  source "${CURRENT_DIR}/set_vars.sh"
  source "${CURRENT_DIR}/formats.sh"
fi

stage "Install ostis-web-platform"

"${SCRIPTS_PATH}/install_submodules.sh"
"${SCRIPTS_PATH}/install_dependencies.sh"
"${SCRIPTS_PATH}/build_sc_machine.sh"
"${SCRIPTS_PATH}/build_sc_web.sh"

cd "${WORKING_PATH}"

stage "OSTIS-web-platform installed"
