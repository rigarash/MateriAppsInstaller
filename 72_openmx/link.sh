#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

OPENMXVARS_SH=$PREFIX_APPS/openmx/openmxvars-$OPENMX_VERSION-$OPENMX_PATCH_VERSION.sh
$SUDO_APPS rm -f $PREFIX_APPS/openmx/openmxvars.sh
$SUDO_APPS ln -s $OPENMXVARS_SH $PREFIX_APPS/openmx/openmxvars.sh
