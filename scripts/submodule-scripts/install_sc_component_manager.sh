#!/usr/bin/env bash
set -eo pipefail

SUBMODULE_SCRIPTS_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
UTILS_DIR="${SUBMODULE_SCRIPTS_DIR}/utils"

if [[ -z "${SC_COMPONENT_MANAGER_REPO}" || -z "${SC_COMPONENT_MANAGER_PATH}" || -z "${SC_COMPONENT_MANAGER_BRANCH}" || -z "${SC_COMPONENT_MANAGER_COMMIT}" ]];
then
  source "${SUBMODULE_SCRIPTS_DIR}/../set_vars.sh"
fi

"${UTILS_DIR}/install_submodule.sh" --repo "${SC_COMPONENT_MANAGER_REPO}" --path "${SC_COMPONENT_MANAGER_PATH}" --branch "${SC_COMPONENT_MANAGER_BRANCH}" --commit "${SC_COMPONENT_MANAGER_COMMIT}"
