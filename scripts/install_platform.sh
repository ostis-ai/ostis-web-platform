#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
OSTIS_SCRIPTS_DIR="${CURRENT_DIR}/ostis-scripts"
source "${OSTIS_SCRIPTS_DIR}/message-scripts/messages.sh"

info "Install ostis-web-platform"

"${SCRIPTS_DIR}/install_submodules.sh"
"${SCRIPTS_DIR}/install_dependencies.sh" --dev
"${SCRIPTS_DIR}/build_sc_machine.sh"
"${SCRIPTS_DIR}/build_scp_machine.sh"
"${SCRIPTS_DIR}/build_sc_component_manager.sh"
"${SCRIPTS_DIR}/build_sc_web.sh"
"${SCRIPTS_DIR}/build_kb.sh"

info "ostis-web-platform is installed successfully"
