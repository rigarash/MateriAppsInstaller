#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

$SUDO_TOOL /bin/true
LOG=$BUILD_DIR/hdf5-$HDF5_VERSION-$HDF5_MA_REVISION.log
PREFIX=$PREFIX_TOOL/hdf5/hdf5-$HDF5_VERSION-$HDF5_MA_REVISION
PREFIX_FRONTEND="$PREFIX/Linux-x86_64"
PREFIX_BACKEND="$PREFIX/Linux-s64fx"
export LANG C

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG

# for frontend

cd $BUILD_DIR/hdf5-$HDF5_VERSION
echo "[make]" | tee -a $LOG
check ./configure --prefix=$PREFIX --enable-threadsafe --with-pthread=yes | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG
check make distclean | tee -a $LOG

# for backend

cd $BUILD_DIR/hdf5-$HDF5_VERSION
echo "[make]" | tee -a $LOG
check cp $SCRIPT_DIR/fx10-config.cache config.cache
check env CC="fccpx -O2 -Xg" ./configure --cache-file=config.cache --prefix=$PREFIX_BACKEND --target=sparc-linux --host=x86 | tee -a $LOG
cd src
check make -j4 H5make_libsettings H5detect | tee -a $LOG
check pjsub --interact $SCRIPT_DIR/fx10-script.sh | tee -a $LOG
touch H5lib_settings.c H5Tinit.c
cd ..
check make -j4 | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_TOOL make install | tee -a $LOG
check make distclean | tee -a $LOG

echo "[make and make install]" | tee -a $LOG
check cp $SCRIPT_DIR/fx10-config.cache config.cache
check env CC="fccpx -O2 -Xg -KPIC" ./configure --cache-file=config.cache --prefix=$PREFIX_BACKEND --target=sparc-linux --host=x86 | tee -a $LOG
cd src
check make -j4 H5make_libsettings H5detect | tee -a $LOG
check pjsub --interact $SCRIPT_DIR/fx10-script.sh | tee -a $LOG
touch H5lib_settings.c H5Tinit.c
check make -j4 | tee -a $LOG
check fccpx -Xg -KPIC -shared -o libhdf5.so H5.o H5checksum.o H5dbg.o H5lib_settings.o H5system.o H5timer.o H5trace.o H5[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z]*.o
$SUDO_TOOL cp -fp libhdf5.so $PREFIX_BACKEND/lib
cd ../hl/src
check make -j4 | tee -a $LOG
check fccpx -Xg -KPIC -shared -o libhdf5_hl.so H5*.o
$SUDO_TOOL cp -fp libhdf5_hl.so $PREFIX_BACKEND/lib

cat << EOF > $BUILD_DIR/hdf5vars.sh
# hdf5 $(basename $0 .sh) $HDF5_VERSION $HDF5_MA_REVISION $(date +%Y%m%d-%H%M%S)
OS=\$(uname -s)
ARCH=\$(uname -m)
export HDF5_ROOT=$PREFIX
export HDF5_VERSION=$HDF5_VERSION
export HDF5_MA_REVISION=$HDF5_MA_REVISION
export PATH=\$HDF5_ROOT/\$OS-\$ARCH/bin:\$PATH
export LD_LIBRARY_PATH=\$HDF5_ROOT/\$OS-\$ARCH/lib:\$LD_LIBRARY_PATH
EOF
HDF5VARS_SH=$PREFIX_TOOL/hdf5/hdf5vars-$HDF5_VERSION-$HDF5_MA_REVISION.sh
$SUDO_TOOL rm -f $HDF5VARS_SH
$SUDO_TOOL cp -f $BUILD_DIR/hdf5vars.sh $HDF5VARS_SH
rm -f $BUILD_DIR/hdf5vars.sh
$SUDO_TOOL cp -f $LOG $PREFIX_TOOL/hdf5/
