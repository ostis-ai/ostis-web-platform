#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
SUBMODULE_SCRIPTS_DIR="${CURRENT_DIR}/../ostis-scripts/submodule-scripts"

if [[ -z "${SC_WEB_REPO}" || -z "${SC_WEB_PATH}" || -z "${SC_WEB_BRANCH}" || -z "${SC_WEB_COMMIT}" ]];
then
  source "${CURRENT_DIR}/../set_vars.sh"
fi

"${SUBMODULE_SCRIPTS_DIR}/install_submodule.sh" --repo "${SC_WEB_REPO}" --path "${SC_WEB_PATH}" --branch "${SC_WEB_BRANCH}" --commit "${SC_WEB_COMMIT}"
