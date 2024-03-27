#!/usr/bin/env bash
set -eo pipefail

SUBMODULE_SCRIPTS_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
OSTIS_SCRIPTS_DIR="${SUBMODULE_SCRIPTS_DIR}/../ostis-scripts"

if [[ -z "${SC_WEB_REPO}" || -z "${SC_WEB_PATH}" || -z "${SC_WEB_BRANCH}" || -z "${SC_WEB_COMMIT}" ]];
then
  source "${SUBMODULE_SCRIPTS_DIR}/../set_vars.sh"
fi

"${OSTIS_SCRIPTS_DIR}/update_submodule.sh" --repo "${SC_WEB_REPO}" --path "${SC_WEB_PATH}" --branch "${SC_WEB_BRANCH}" --commit "${SC_WEB_COMMIT}"
