#!/usr/bin/env bash
set -eo pipefail

SUBMODULE_SCRIPTS_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
UTILS_DIR="${SUBMODULE_SCRIPTS_DIR}/utils"

if [[ -z "${SC_MACHINE_REPO}" || -z "${SC_MACHINE_PATH}" || -z "${SC_MACHINE_BRANCH}" || -z "${SC_MACHINE_COMMIT}" ]];
then
  source "${SUBMODULE_SCRIPTS_DIR}/../set_vars.sh"
fi

"${UTILS_DIR}/install_submodule.sh" --repo "${SC_MACHINE_REPO}" --path "${SC_MACHINE_PATH}" --branch "${SC_MACHINE_BRANCH}" --commit "${SC_MACHINE_COMMIT}"
