#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
SUBMODULE_SCRIPTS_DIR="${CURRENT_DIR}/../ostis-scripts/submodule-scripts"

if [[ -z "${IMS_KB_REPO}" || -z "${IMS_KB_PATH}" || -z "${IMS_KB_BRANCH}" || -z "${IMS_KB_COMMIT}" ]];
then
  source "${CURRENT_DIR}/../set_vars.sh"
fi

"${SUBMODULE_SCRIPTS_DIR}/install_submodule.sh" --repo "${IMS_KB_REPO}" --path "${IMS_KB_PATH}" --branch "${IMS_KB_BRANCH}" --commit "${IMS_KB_COMMIT}"
