#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
OSTIS_SCRIPTS_DIR="${CURRENT_DIR}/ostis-scripts"
source "${OSTIS_SCRIPTS_DIR}/message-scripts/messages.sh"

SUBMODULE_SCRIPTS_DIR="${CURRENT_DIR}/submodule-scripts"

info "Install ostis-web-platform"

"${SUBMODULE_SCRIPTS_DIR}/install_sc_machine.sh"
"${SCRIPTS_DIR}/install_sc_machine_dependencies.sh" --dev
"${SUBMODULE_SCRIPTS_DIR}/install_scp_machine.sh"
"${SUBMODULE_SCRIPTS_DIR}/install_sc_component_manager.sh"
"${SCRIPTS_DIR}/build_sc_machine.sh"
"${SCRIPTS_DIR}/build_scp_machine.sh"
"${SCRIPTS_DIR}/build_sc_component_manager.sh"
"${SCRIPTS_DIR}/build_kb.sh"

info "ostis-web-platform is installed successfully"
