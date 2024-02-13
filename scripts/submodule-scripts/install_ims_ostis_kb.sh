#!/usr/bin/env bash
set -eo pipefail

SUBMODULE_SCRIPTS_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
UTILS_DIR="${SUBMODULE_SCRIPTS_DIR}/utils"

if [[ -z "${IMS_KB_REPO}" || -z "${IMS_KB_PATH}" || -z "${IMS_KB_BRANCH}" || -z "${IMS_KB_COMMIT}" ]];
then
  source "${SUBMODULE_SCRIPTS_DIR}/../set_vars.sh"
fi

"${UTILS_DIR}/install_submodule.sh" --repo "${IMS_KB_REPO}" --path "${IMS_KB_PATH}" --branch "${IMS_KB_BRANCH}" --commit "${IMS_KB_COMMIT}"
