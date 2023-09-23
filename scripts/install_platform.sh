#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${CURRENT_DIR}/formats.sh"

if [[ -z "${SC_MACHINE_PATH}" || -z "${SC_WEB_PATH}" ]];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi

stage "Install ostis-web-platform"

"${PLATFORM_PATH}/scripts/install_submodules.sh"
"${PLATFORM_PATH}/scripts/install_dependencies.sh" --dev
"${PLATFORM_PATH}/scripts/build_sc_machine.sh"
"${PLATFORM_PATH}/scripts/build_scp_machine.sh"
"${PLATFORM_PATH}/scripts/build_sc_web.sh"
"${PLATFORM_PATH}/scripts/build_kb.sh"

stage "OSTIS-web-platform installed successfully"
