#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
SUBMODULE_SCRIPTS_DIR="${CURRENT_DIR}/../ostis-scripts/submodule-scripts"

if [[ -z "${SCP_MACHINE_REPO}" || -z "${SCP_MACHINE_PATH}" || -z "${SCP_MACHINE_BRANCH}" || -z "${SCP_MACHINE_COMMIT}" ]];
then
  source "${CURRENT_DIR}/../set_vars.sh"
fi

"${SUBMODULE_SCRIPTS_DIR}/update_submodule.sh" --repo "${SCP_MACHINE_REPO}" --path "${SCP_MACHINE_PATH}" --branch "${SCP_MACHINE_BRANCH}" --commit "${SCP_MACHINE_COMMIT}"
