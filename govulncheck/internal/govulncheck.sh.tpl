#!/usr/bin/env bash

set -euo pipefail

TOOL_PATH="%tool_path%"
PATH=$PATH:$PWD/%go_root%/bin

if [[ "%warn%" == "True" ]] ; then
  # Set the module cache to PWD, so we can download the vulnerability cache
  GOMODCACHE=$PWD GOROOT=$PWD/%go_root% $TOOL_PATH --db=file://$PWD/external/vulndb --mode=binary %srcs% || exit 0
else
  GOMODCACHE=$PWD GOROOT=$PWD/%go_root% $TOOL_PATH --db=file://$PWD/external/vulndb --mode=binary %srcs%
fi
