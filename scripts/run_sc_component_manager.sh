#!/bin/bash

APP_ROOT_PATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd)

$APP_ROOT_PATH/sc-machine/bin/sc-component-manager -c $APP_ROOT_PATH/ostis-web-platform.ini $1
