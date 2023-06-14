#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${CURRENT_DIR}/formats.sh"

if [ -z "${SC_MACHINE_PATH}" ];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi

stage "Install dependencies"

"${SC_MACHINE_PATH}/scripts/install_deps_ubuntu.sh" --dev
"${SC_WEB_PATH}/scripts/install_deps_ubuntu.sh"

stage "Dependencies installed"
