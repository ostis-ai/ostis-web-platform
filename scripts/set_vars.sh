#!/usr/bin/env bash
set -eo pipefail

ROOT_PATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd)

export APP_ROOT_PATH="${APP_ROOT_PATH:-${ROOT_PATH}}"
export PLATFORM_PATH="${PLATFORM_PATH:-${APP_ROOT_PATH}}"
export PROBLEM_SOLVER_PATH="${PROBLEM_SOLVER_PATH:-${PLATFORM_PATH}/sc-machine}"
export CONFIG_PATH="${CONFIG_PATH:-${PLATFORM_PATH}/ostis-web-platform.ini}"
export REPO_PATH="${REPO_PATH:-${PLATFORM_PATH}/repo.path}"

export SC_MACHINE_REPO="${SC_MACHINE_REPO:-https://github.com/ostis-ai/sc-machine.git}"
export SC_MACHINE_BRANCH="${SC_MACHINE_BRANCH:-release/0.8.0}"
export SC_MACHINE_PATH="${SC_MACHINE_PATH:-${PLATFORM_PATH}/sc-machine}"

export SC_WEB_REPO="${SC_WEB_REPO:-https://github.com/ostis-ai/sc-web.git}"
export SC_WEB_BRANCH="${SC_WEB_BRANCH:-release/0.8.0}"
export SC_WEB_PATH="${SC_WEB_PATH:-${PLATFORM_PATH}/sc-web}"
