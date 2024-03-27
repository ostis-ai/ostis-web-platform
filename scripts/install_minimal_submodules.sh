#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
OSTIS_SCRIPTS_DIR="${CURRENT_DIR}/ostis-scripts"
source "${OSTIS_SCRIPTS_DIR}/message-scripts/messages.sh"

SUBMODULE_SCRIPTS_DIR="${CURRENT_DIR}/submodule-scripts"

if [[ -z "${PLATFORM_PATH}" ]];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi

info "Clone submodules"

cd "${PLATFORM_PATH}" && git submodule update --init --recursive

"${SUBMODULE_SCRIPTS_DIR}/install_sc_machine.sh"
"${SUBMODULE_SCRIPTS_DIR}/install_scp_machine.sh"
"${SUBMODULE_SCRIPTS_DIR}/install_sc_component_manager.sh"

info "Submodules is cloned successfully"
