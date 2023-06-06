#!/bin/bash
set -e

if [[ -z ${SC_WEB_PATH+1} ]];
then
  source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"/set_vars.sh
fi

"${SC_WEB_PATH}/scripts/run_sc_web.sh" "$@"
