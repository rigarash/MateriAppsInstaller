#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/fftw-$FFTW_VERSION-$FFTW_MA_REVISION.log
PREFIX=$PREFIX_TOOL/fftw/fftw-$FFTW_VERSION-$FFTW_MA_REVISION

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

cd $BUILD_DIR/fftw-$FFTW_VERSION
echo "[make]" | tee -a $LOG
check ./configure CC=$(which icc) F77=$(which ifort) --prefix=$PREFIX -enable-shared --enable-threads --enable-avx | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG
check make clean | tee -a $LOG
echo "[make float version]" | tee -a $LOG
check ./configure CC=$(which icc) F77=$(which ifort) --prefix=$PREFIX -enable-shared --enable-threads --enable-avx --enable-float | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG

cat << EOF > $BUILD_DIR/fftwvars.sh
# fftw $(basename $0 .sh) $FFTW_VERSION $FFTW_MA_REVISION $(date +%Y%m%d-%H%M%S)
export FFTW_ROOT=$PREFIX
export FFTW_VERSION=$FFTW_VERSION
export FFTW_MA_REVISION=$FFTW_MA_REVISION
export PATH=\$FFTW_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$FFTW_ROOT/lib:\$LD_LIBRARY_PATH
EOF
FFTWVARS_SH=$PREFIX_TOOL/fftw/fftwvars-$FFTW_VERSION-$FFTW_MA_REVISION.sh
$SUDO_TOOL rm -f $FFTWVARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/fftwvars.sh $FFTWVARS_SH
rm -f $BUILD_DIR/fftwvars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/fftw/
