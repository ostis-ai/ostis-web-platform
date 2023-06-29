#!/usr/bin/env bash
set -eo pipefail

CURRENT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
source "${CURRENT_DIR}/formats.sh"

if [[ -z "${PLATFORM_PATH}" || -z "${SC_MACHINE_REPO}" || -z "${SC_WEB_REPO}" \
  || -z "${SC_MACHINE_NAME}" || -z "${SC_WEB_NAME}" || -z "${SC_MACHINE_BRANCH}" || -z "${SC_WEB_BRANCH}" ]];
then
  source "${CURRENT_DIR}/set_vars.sh"
fi


usage() {
  cat <<USAGE
Usage: $0 [update]

This script is used to download sources of ostis-web-platform and submodules
and install them. The exact behavior is configured via run arguments.

Options:
  update: Remove ostis-web-platform and submodules sources and download
          them from scratch.
USAGE
  exit 1
}

clone_project()
{
  if [[ ! -d "${PLATFORM_PATH}/$2" || ${update} == 1 ]]; then
    if (( ${update} == 1 ));
    then
      printf "Remove submodule %s (%s) %s \n" "$1" "$3" "$2"
      rm -rf "${PLATFORM_PATH}/$2"
      git pull
    fi

    printf "Clone submodule %s (%s) into %s\n" "$1" "$3" "$2"
    git clone "$1" --branch "$3" --single-branch "$2" --recursive
  else
    printf "You can update %s manually. Use this script with \"update\" parameter.\n" "$2"
  fi
}

update=0

while [ "$1" != "" ]; do
  case $1 in
    "update" )
      update=1
      ;;
    "--help" )
      usage
      ;;
    "help" )
      usage
      ;;
    "-h" )
      usage
      ;;
    * )
      usage
      ;;
      esac
      shift
done

stage "Clone submodules"

cd "${PLATFORM_PATH}"

clone_project "${SC_MACHINE_REPO}" "${SC_MACHINE_PATH}" "${SC_MACHINE_BRANCH}"
clone_project "${SC_WEB_REPO}" "${SC_WEB_PATH}" "${SC_WEB_BRANCH}"
git submodule update --init --recursive

stage "Submodules cloned successfully"
