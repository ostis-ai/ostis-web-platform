#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${CURRENT_DIR}/formats.sh"

if [[ -z "${SCRIPTS_PATH}" || -z "${SC_MACHINE_PATH}" || -z "${SC_WEB_PATH}" ]];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi

stage "Install ostis-web-platform"

"${SCRIPTS_PATH}/install_submodules.sh"
"${SCRIPTS_PATH}/install_dependencies.sh" --dev
"${SC_MACHINE_PATH}/build_sc_machine.sh"
"${SC_WEB_PATH}/build_sc_web.sh"

stage "OSTIS-web-platform successfully installed"
