#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${CURRENT_DIR}/formats.sh"

if [[ -z "${SC_MACHINE_PATH}" || -z "${SC_WEB_PATH}" ]];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi

function usage() {
  cat <<USAGE

  Usage: $0 [--dev]

  Options:
      --dev:          installs dependencies required to compile sc-machine and sc-web
USAGE
  exit 1
}

stage "Install dependencies"

args=()

while [ "$1" != "" ]; do
  case $1 in
  --dev)
    args+=("--dev")
    ;;
  -h | --help)
    usage # show help
    ;;
  *)
    usage
    exit 1
    ;;
  esac
  shift # remove the current value for `$1` and use the next
done

"${SC_MACHINE_PATH}/scripts/install_deps_ubuntu.sh" ${args}
"${SC_WEB_PATH}/scripts/install_deps_ubuntu.sh"

stage "Dependencies installed"
