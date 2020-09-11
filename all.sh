#!/bin/sh
set -eu
script="$(readlink -f "$0")"
scriptpath="$(dirname "$script")"

"$scriptpath/packages.sh"
"$scriptpath/services.sh"
