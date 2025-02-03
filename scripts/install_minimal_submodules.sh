#!/usr/bin/env bash
set -eo pipefail

SCRIPTS_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
SUBMODULE_SCRIPTS_DIR="${SCRIPTS_DIR}/submodule-scripts"
source "${SCRIPTS_DIR}/formats.sh"

stage "Clone submodules"

"${SUBMODULE_SCRIPTS_DIR}/install_sc_machine.sh"
"${SUBMODULE_SCRIPTS_DIR}/install_scp_machine.sh"
"${SUBMODULE_SCRIPTS_DIR}/install_sc_component_manager.sh"

stage "Submodules cloned successfully"
