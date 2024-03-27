#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
OSTIS_SCRIPTS_DIR="${CURRENT_DIR}/ostis-scripts"
source "${OSTIS_SCRIPTS_DIR}/message-scripts/messages.sh"

SUBMODULE_SCRIPTS_DIR="${CURRENT_DIR}/submodule-scripts"

if [[ -z "${PLATFORM_PATH}" ]];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi

usage() {
  cat <<USAGE
Usage: $0 [--update]

This script is used to download sources of ostis-web-platform and submodules
and install them. The exact behavior is configured via run arguments.

Options:
  --update: Removes ostis-web-platform submodules sources and download them from scratch.
USAGE
  exit 1
}

UPDATE=0

while [ "$1" != "" ];
do
  case $1 in
    "--help" | "-h" )
      usage
      ;;
    "--update" )
      UPDATE=1
      ;;
    * )
      usage
      ;;
  esac
  shift 1
done

if (( UPDATE == 1 ));
then
  warning "The option \"--update\" is deprecated. Use \"update_submodules.sh\" instead."

  "${SCRIPTS_DIR}/update_submodules.sh"
else
  info "Clone submodules"

  cd "${PLATFORM_PATH}" && git submodule update --init --recursive

  "${SUBMODULE_SCRIPTS_DIR}/install_sc_machine.sh"
  "${SUBMODULE_SCRIPTS_DIR}/install_scp_machine.sh"
  "${SUBMODULE_SCRIPTS_DIR}/install_sc_component_manager.sh"
  "${SUBMODULE_SCRIPTS_DIR}/install_sc_web.sh"
  "${SUBMODULE_SCRIPTS_DIR}/install_ims_ostis_kb.sh"

  info "Submodules is cloned successfully"
fi
