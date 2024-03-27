#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
OSTIS_SCRIPTS_DIR="${CURRENT_DIR}/ostis-scripts"
source "${OSTIS_SCRIPTS_DIR}/message-scripts/messages.sh"

info "Install ostis-web-platform"

"${CURRENT_DIR}/install_minimal_submodules.sh"
"${CURRENT_DIR}/install_sc_machine_dependencies.sh" --dev
"${CURRENT_DIR}/build_sc_machine.sh"
"${CURRENT_DIR}/build_scp_machine.sh"
"${CURRENT_DIR}/build_sc_component_manager.sh"
"${CURRENT_DIR}/build_kb.sh"

info "ostis-web-platform is installed successfully"
