#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings \
  lib/loader.dart \
  lib/mdc_js.dart

pub run test -p vm,firefox