#!/usr/bin/env bash
set -eo pipefail

UTILS_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)

"${UTILS_DIR}/remove_submodule.sh" "$@" 

case $? in
  0) 
    "${UTILS_DIR}/install_submodule.sh" "$@"
    ;;
  1) 
    "${UTILS_DIR}/install_submodule.sh" "$@"
    ;;
  2)
    exit 1
    ;;
esac

exit 0

