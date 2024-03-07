#!/usr/bin/env bash
set -eo pipefail

if [ -z "${SC_COMPONENT_MANAGER_PATH}" ];
then
  source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)/set_vars.sh"
fi

"${SC_COMPONENT_MANAGER_PATH}/scripts/build_sc_component_manager.sh" "$@"
