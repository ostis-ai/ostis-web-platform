#!/usr/bin/env bash
set -eo pipefail

SCRIPTS_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${SCRIPTS_DIR}/formats.sh"

stage "Install ostis-web-platform"

"${SCRIPTS_DIR}/install_submodules.sh"
"${SCRIPTS_DIR}/install_dependencies.sh" --dev
"${SCRIPTS_DIR}/build_sc_machine.sh"
"${SCRIPTS_DIR}/build_sc_web.sh"
"${SCRIPTS_DIR}/build_kb.sh"

stage "OSTIS-web-platform installed successfully"
