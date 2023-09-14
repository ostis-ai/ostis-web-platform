#!/usr/bin/env bash
set -eo pipefail

packagelist_runtime=(
  subversion
)

packages=()
packages+=("${packagelist_runtime[@]}")

if ! command -v apt> /dev/null 2>&1;
then
  RED='\033[22;31m'
  echo -e "${RED}[ERROR] Apt command not found. Debian-based distros are the only officially supported.
Please install the following packages by yourself:
  ${packages[*]}"
  exit 1
fi

sudo apt-get install -y --no-install-recommends "${packages[@]}"
