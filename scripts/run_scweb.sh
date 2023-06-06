#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color
echo -e "${RED}[WARNING] This script was deprecated in ostis-web-platform 0.8.0.
Please, use scripts/run_sc_web.sh instead. It will be removed in ostis-web-platform 0.9.0.${NC}"

./run_sc_web.sh "$@"
