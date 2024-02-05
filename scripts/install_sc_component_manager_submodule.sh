#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${CURRENT_DIR}/formats.sh"
source "${CURRENT_DIR}/clone_update_submodule.sh"

if [[ -z "${PLATFORM_PATH}" || -z "${SC_MACHINE_REPO}" || -z "${SC_MACHINE_BRANCH}" ]];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi

cd "${PLATFORM_PATH}"

clone_update_submodule --repo "${SC_COMPONENT_MANAGER_REPO}" --path "${SC_COMPONENT_MANAGER_PATH}" --branch "${SC_COMPONENT_MANAGER_BRANCH}" --commit "${SC_COMPONENT_MANAGER_COMMIT}" "$@"
