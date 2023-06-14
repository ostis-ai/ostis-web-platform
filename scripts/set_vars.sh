#!/usr/bin/env bash
set -eo pipefail

APP_ROOT_PATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd)

export APP_ROOT_PATH="${APP_ROOT_PATH}"
export PLATFORM_PATH="${APP_ROOT_PATH}"
export SCRIPTS_PATH="${PLATFORM_PATH}/scripts"
export BINARY_PATH="${PLATFORM_PATH}/sc-machine/bin"
export CONFIG_PATH="${PLATFORM_PATH}/ostis-web-platform.ini"

export SC_MACHINE_REPO="https://github.com/ostis-ai/sc-machine.git"
export SC_MACHINE_BRANCH="main"
export SC_MACHINE_PATH="${PLATFORM_PATH}/sc-machine"

export SC_WEB_REPO="https://github.com/ostis-ai/sc-web.git"
export SC_WEB_BRANCH="main"
export SC_WEB_PATH="${PLATFORM_PATH}/sc-web"
