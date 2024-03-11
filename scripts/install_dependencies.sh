#!/usr/bin/env bash
set -eo pipefail

SCRIPTS_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${SCRIPTS_DIR}/formats.sh"

if [[ -z "${SC_MACHINE_PATH}" || -z "${SC_WEB_PATH}" ]];
then
  source "${SCRIPTS_DIR}/set_vars.sh"
fi

function usage() {
  cat <<USAGE
Usage: $0 [--dev]

Options:
  --dev:          Installs dependencies required to compile sc-machine and sc-web
USAGE
  exit 1
}

stage "Install dependencies"

args=()
while [ "$1" != "" ];
do
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
  shift 1 # remove the current value for `$1` and use the next
done

"${SCRIPTS_DIR}/install_sc_machine_dependencies.sh" "${args[@]}"
"${SCRIPTS_DIR}/install_sc_web_dependencies.sh" "${args[@]}"

stage "Dependencies installed successfully"
