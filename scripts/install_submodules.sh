#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${CURRENT_DIR}/formats.sh"

if [[ -z "${PLATFORM_PATH}" || -z "${SC_MACHINE_PATH}" || -z "${SC_WEB_PATH}" || -z "${SC_COMPONENT_MANAGER_PATH}" \
  || -z "${SC_MACHINE_REPO}" || -z "${SC_WEB_REPO}" || -z "${SC_COMPONENT_MANAGER_REPO}" \
  || -z "${SC_MACHINE_BRANCH}" || -z "${SC_WEB_BRANCH}" || -z "${SC_COMPONENT_MANAGER_BRANCH}" \
  || -z "${SC_MACHINE_COMMIT}" || -z "${SC_WEB_COMMIT}" || -z "${SC_COMPONENT_MANAGER_COMMIT}" ]];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi


usage() {
  cat <<USAGE
Usage: $0 [--update]

This script is used to download sources of ostis-web-platform and submodules
and install them. The exact behavior is configured via run arguments.

Options:
  --update: Remove ostis-web-platform submodules sources and download them from scratch.
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

stage "Clone submodules"

cd "${PLATFORM_PATH}" && git submodule update --init --recursive

"${PLATFORM_PATH}/scripts/install_sc_machine_submodule.sh" "$@"
"${PLATFORM_PATH}/scripts/install_sc_component_manager_submodule.sh" "$@"
"${PLATFORM_PATH}/scripts/install_sc_web_submodule.sh" "$@"
"${PLATFORM_PATH}/scripts/install_ims_kb_submodule.sh" "$@"

stage "Submodules cloned successfully"
