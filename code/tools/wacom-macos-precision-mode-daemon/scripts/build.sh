#!/usr/bin/env bash

if command -v xcpretty >/dev/null; then
  set -o pipefail
  $@ | xcpretty --color | sed s/Copying.*/Copying.../g
else
  $@
fi
