#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

cd $BUILD_DIR
if [ -d xtapp_$XTAPP_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/xtapp_$XTAPP_VERSION.orig.tar.gz ]; then
    check tar zxf $SOURCE_DIR/xtapp_$XTAPP_VERSION.orig.tar.gz
  else
    check wget $MALIVE_REPOSITORY/main/x/xtapp/xtapp_$XTAPP_VERSION.orig.tar.gz
    check tar zxf xtapp_$XTAPP_VERSION.orig.tar.gz
  fi
  cd xtapp_$XTAPP_VERSION
  if [ -f $SOURCE_DIR/xtapp_$XTAPP_VERSION-$XTAPP_PATCH_VERSION.debian.tar.gz ]; then
    tar zxf $SOURCE_DIR/xtapp_$XTAPP_VERSION-$XTAPP_PATCH_VERSION.debian.tar.gz
  else
    check wget $MALIVE_REPOSITORY/main/x/xtapp/xtapp_$XTAPP_VERSION-$XTAPP_PATCH_VERSION.debian.tar.gz
    check tar zxf xtapp_$XTAPP_VERSION-$XTAPP_PATCH_VERSION.debian.tar.gz
  fi
  PATCHES="makefile.patch debian.patch"
  for p in $PATCHES; do
    patch -p1 < debian/patches/$p
  done
  cp -fp src/Makefile-dist src/Makefile
  cp -rp src/config90.h-dist src/config90.h
  cp -rp src/config.h-dist src/config.h
fi

cd $BUILD_DIR/xtapp_$XTAPP_VERSION
if [ -d xtapp-util_$XTAPP_UTIL_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/xtapp-util_$XTAPP_UTIL_VERSION.orig.tar.gz ]; then
    check tar zxf $SOURCE_DIR/xtapp-util_$XTAPP_UTIL_VERSION.orig.tar.gz
  else
    check wget $MALIVE_REPOSITORY/main/x/xtapp-util/xtapp-util_$XTAPP_UTIL_VERSION.orig.tar.gz
    check tar zxf xtapp-util_$XTAPP_UTIL_VERSION.orig.tar.gz
  fi
  cd xtapp-util_$XTAPP_UTIL_VERSION
  if [ -f $SOURCE_DIR/xtapp-util_$XTAPP_UTIL_VERSION-$XTAPP_UTIL_PATCH_VERSION.debian.tar.gz ]; then
    tar zxf $SOURCE_DIR/xtapp-util_$XTAPP_UTIL_VERSION-$XTAPP_UTIL_PATCH_VERSION.debian.tar.gz
  else
    check wget $MALIVE_REPOSITORY/main/x/xtapp-util/xtapp-util_$XTAPP_UTIL_VERSION-$XTAPP_UTIL_PATCH_VERSION.debian.tar.gz
    check tar zxf xtapp-util_$XTAPP_UTIL_VERSION-$XTAPP_UTIL_PATCH_VERSION.debian.tar.gz
  fi
  PATCHES="makefile-1.patch xtapp-1.patch"
  for p in $PATCHES; do
    patch -p1 < debian/patches/$p
  done
fi

cd $BUILD_DIR/xtapp_150401
if [ -d xtapp-ps_$XTAPP_PS_VERSION ]; then :; else
  if [ -f $SOURCE_DIR/xtapp-ps_$XTAPP_PS_VERSION.orig.tar.gz ]; then
    check tar zxf $SOURCE_DIR/xtapp-ps_$XTAPP_PS_VERSION.orig.tar.gz
  else
    check wget $MALIVE_REPOSITORY/main/x/xtapp-ps/xtapp-ps_$XTAPP_PS_VERSION.orig.tar.gz
    check tar zxf xtapp-ps/xtapp-ps_$XTAPP_PS_VERSION.orig.tar.gz
  fi
fi
