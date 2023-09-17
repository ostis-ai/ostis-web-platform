#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${CURRENT_DIR}/formats.sh"

if [ -z "${SC_WEB_PATH}" ];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi

stage "Install sc-web dependencies"

"${SC_WEB_PATH}/scripts/install_dependencies.sh" "$@"

stage "Dependencies of sc-web installed successfully"
