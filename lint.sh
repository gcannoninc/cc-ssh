#!/bin/bash

clear

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1091
source "$DIR/test/common.sh"

switch_php latest

cp -f cc-ssh cc-ssh-load.php

phpcs && rm cc-ssh-load.php && exit 0

echo "==========================================="
echo "THERE HAS BEEN AN ISSUE - RESOLVE AND RERUN"
echo "==========================================="
exit 1
