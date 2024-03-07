#!/usr/bin/env bash
set -eo pipefail

SUBMODULE_SCRIPTS_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
UTILS_DIR="${SUBMODULE_SCRIPTS_DIR}/utils"

if [[ -z "${SCP_MACHINE_REPO}" || -z "${SCP_MACHINE_PATH}" || -z "${SCP_MACHINE_BRANCH}" || -z "${SCP_MACHINE_COMMIT}" ]];
then
  source "${SUBMODULE_SCRIPTS_DIR}/../set_vars.sh"
fi

"${UTILS_DIR}/update_submodule.sh" --repo "${SCP_MACHINE_REPO}" --path "${SCP_MACHINE_PATH}" --branch "${SCP_MACHINE_BRANCH}" --commit "${SCP_MACHINE_COMMIT}"
