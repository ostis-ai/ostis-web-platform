#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
OSTIS_SCRIPTS_DIR="${CURRENT_DIR}/ostis-scripts"
source "${OSTIS_SCRIPTS_DIR}/message-scripts/messages.sh"

info "Build ostis-web-platform"

"${CURRENT_DIR}/build_sc_machine.sh" "$@"
"${CURRENT_DIR}/build_scp_machine.sh" "$@"
"${CURRENT_DIR}/build_sc_component_manager.sh" "$@"
"${CURRENT_DIR}/build_sc_web.sh" "$@"

info "ostis-web-platform is built successfully"
