#!/usr/bin/env bash
set -eo pipefail

SCRIPTS_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
SUBMODULE_SCRIPTS_DIR="${SCRIPTS_DIR}/submodule-scripts"
source "${SCRIPTS_DIR}/formats.sh"

if [[ -z "${PLATFORM_PATH}" ]];
then
  source "${SCRIPTS_DIR}/set_vars.sh"
fi

usage() {
  cat <<USAGE
Usage: $0

This script is used to update sources of ostis-web-platform and submodules.
The exact behavior is configured via run arguments.

Options:
USAGE
  exit 1
}

while [ "$1" != "" ];
do
  case $1 in
    "--help" | "-h" )
      usage
      ;;
    * )
      usage
      ;;
  esac
  shift 1
done

stage "Update submodules"

cd "${PLATFORM_PATH}" && git submodule update --init --recursive

"${SUBMODULE_SCRIPTS_DIR}/update_sc_machine.sh"
"${SUBMODULE_SCRIPTS_DIR}/update_sc_component_manager.sh"
"${SUBMODULE_SCRIPTS_DIR}/update_sc_web.sh"
"${SUBMODULE_SCRIPTS_DIR}/update_ims_ostis_kb.sh"

stage "Submodules updated successfully"
