#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
SUBMODULE_SCRIPTS_DIR="${CURRENT_DIR}/../ostis-scripts/submodule-scripts"

if [[ -z "${SC_MACHINE_REPO}" || -z "${SC_MACHINE_PATH}" || -z "${SC_MACHINE_BRANCH}" || -z "${SC_MACHINE_COMMIT}" ]];
then
  source "${CURRENT_DIR}/../set_vars.sh"
fi

"${SUBMODULE_SCRIPTS_DIR}/update_submodule.sh" --repo "${SC_MACHINE_REPO}" --path "${SC_MACHINE_PATH}" --branch "${SC_MACHINE_BRANCH}" --commit "${SC_MACHINE_COMMIT}"
