#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
SUBMODULE_SCRIPTS_DIR="${CURRENT_DIR}/../ostis-scripts/submodule-scripts"

if [[ -z "${SC_COMPONENT_MANAGER_REPO}" || -z "${SC_COMPONENT_MANAGER_PATH}" || -z "${SC_COMPONENT_MANAGER_BRANCH}" || -z "${SC_COMPONENT_MANAGER_COMMIT}" ]];
then
  source "${CURRENT_DIR}/../set_vars.sh"
fi

"${SUBMODULE_SCRIPTS_DIR}/install_submodule.sh" --repo "${SC_COMPONENT_MANAGER_REPO}" --path "${SC_COMPONENT_MANAGER_PATH}" --branch "${SC_COMPONENT_MANAGER_BRANCH}" --commit "${SC_COMPONENT_MANAGER_COMMIT}"
