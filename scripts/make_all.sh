#!/bin/bash
APP_ROOT_PATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd)
TESTS_ARGS=""

while getopts "ft" OPT; do
	case "$OPT" in
		f | full ) 
			rm -rf "${APP_ROOT_PATH}"/build
			rm -rf "${APP_ROOT_PATH}"/bin
			find "${APP_ROOT_PATH}" -type d -name generated -exec rm -rf {} +
			;;
		t | tests )
			TESTS_ARGS="-DSC_AUTO_TEST=ON -DSC_BUILD_TESTS=ON"
			;;
	esac
done

cmake -B "${APP_ROOT_PATH}"/build "${APP_ROOT_PATH}" $TESTS_ARGS

cmake --build "${APP_ROOT_PATH}"/build -j$(nproc)
