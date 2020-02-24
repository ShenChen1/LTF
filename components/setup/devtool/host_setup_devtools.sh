#!/bin/bash

set -aeu
source _shellflags

ARCH=$("${TESTANALYZER}" "arch")
cd "${DEVTOOL_SRCDIR}/${ARCH}"

