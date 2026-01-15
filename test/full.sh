#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1091
source "$DIR/common.sh"

cc_ssh_bin_type_to_test_with="$1"
php_version_to_test_with="$2"

if [ -z "$cc_ssh_bin_type_to_test_with" ]; then
    cc_ssh_bin_type_to_test_with="development"
fi

case "$cc_ssh_bin_type_to_test_with" in
    packaged|pkg|p)
        cc_ssh_bin_to_test_with=$(realpath "$DIR/../dist/cc-ssh")
        cc_ssh_bin_type_to_test_with="Packaged/Dist ($cc_ssh_bin_to_test_with)"
        ;;
    installed|inst|i)
        cc_ssh_bin_to_test_with="command cc-ssh"
        cc_ssh_bin_type_to_test_with="Installed ($cc_ssh_bin_to_test_with)"
        ;;
    *)
        cc_ssh_bin_to_test_with=$(realpath "$DIR/../cc-ssh")
        cc_ssh_bin_type_to_test_with="Development ($cc_ssh_bin_to_test_with)"
        ;;
esac

clear
echodiv
if [ -n "$php_version_to_test_with" ]; then
    echo "Running full test suite with PHP $php_version_to_test_with"
else
    echo "Running full test suite with all configured PHP versions"
fi

function full_test {
    _php_version="$1"
    pced "Running full test suite with PHP $_php_version"
    switch_php "$_php_version"
    echo "Testing with CC-SSH bin: $cc_ssh_bin_type_to_test_with"

    pced "Testing version output"
    $cc_ssh_bin_to_test_with version

    pced "Testing help output"
    $cc_ssh_bin_to_test_with help

    pced "Testing help output for add"
    $cc_ssh_bin_to_test_with help add

    pced "Testing search"
    $cc_ssh_bin_to_test_with search cmp
}

if [ -n "$php_version_to_test_with" ]; then
    full_test "$php_version_to_test_with"
else
    full_test "8.3"
    full_test "8.2"
    full_test "8.1"
    full_test "8.0"
fi

# Reset to latest PHP version
switch_php latest
