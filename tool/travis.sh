#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings \
  lib/loader.dart

pub run test -p vm,firefox