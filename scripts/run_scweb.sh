#!/usr/bin/env bash
set -eo pipefail

YELLOW='\033[01;33m'
NC='\033[0m' # No Color
echo -e "${YELLOW}[WARNING] This script was deprecated in ostis-web-platform 0.8.0.
Please, use scripts/run_sc_web.sh instead. It will be removed in ostis-web-platform 0.9.0.${NC}"

if [ -z "${SC_WEB_PATH}" ];
then
  source "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"/set_vars.sh
fi

"${SC_WEB_PATH}/scripts/run_sc_web.sh" "$@"
