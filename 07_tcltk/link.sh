#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

TCLTKVARS_SH=$PREFIX_TOOL/tcltk/tcltkvars-$TCL_VERSION-$TCLTK_PATCH_VERSION.sh
$SUDO_TOOL rm -f $PREFIX_TOOL/env.d/tcltkvars.sh
$SUDO_TOOL ln -s $TCLTKVARS_SH $PREFIX_TOOL/env.d/tcltkvars.sh
