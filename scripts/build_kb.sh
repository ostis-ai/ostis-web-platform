#!/bin/bash
set -e

if [[ -z ${BINARY_PATH+1} ]];
then
  source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"/set_vars.sh
fi

"${BINARY_PATH}/sc-builder" -f --clear -c "${CONFIG_PATH}" -i "${APP_ROOT_PATH}/repo$1.path" -o "${APP_ROOT_PATH}"/kb.bin
