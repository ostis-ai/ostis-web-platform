#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${CURRENT_DIR}/formats.sh"
source "${CURRENT_DIR}/clone_project.sh"

if [[ -z "${PLATFORM_PATH}" || -z "${SC_MACHINE_REPO}" || -z "${SC_MACHINE_BRANCH}" ]];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi

cd "${PLATFORM_PATH}"

clone_project "${SC_WEB_REPO}" "${SC_WEB_PATH}" "${SC_WEB_BRANCH}" "${SC_WEB_COMMIT}" "$1"
git submodule update --init --recursive
