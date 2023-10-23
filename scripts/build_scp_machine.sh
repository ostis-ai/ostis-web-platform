#!/usr/bin/env bash
set -fexeo pipefail

if [ -z "${SCP_MACHINE_PATH}" ];
then
  source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"/../scp-machine/scripts/set_vars.sh
fi

cd "${SCP_MACHINE_PATH}" && ./scripts/build_scp_machine.sh "$@"
