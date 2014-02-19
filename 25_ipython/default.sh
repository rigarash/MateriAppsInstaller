#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix
set_build_dir

. $PREFIX_OPT/env.sh

# pexpect
cd $BUILD_DIR
rm -rf pexpect-$PEXPECT_VERSION
if [ -f $HOME/source/pexpect-$PEXPECT_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/pexpect-$PEXPECT_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/p/pexpect/pexpect-$PEXPECT_VERSION.tar.gz | tar zxf -
fi
cd pexpect-$PEXPECT_VERSION
check $PREFIX_OPT/bin/python2.7 setup.py build
$SUDO $PREFIX_OPT/bin/python2.7 setup.py install

# sphinx
cd $BUILD_DIR
rm -rf Sphinx-$SPHINX_VERSION
if [ -f $HOME/source/Sphinx-$SPHINX_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/Sphinx-$SPHINX_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/S/Sphinx/Sphinx-$SPHINX_VERSION.tar.gz | tar zxf -
fi
cd Sphinx-$SPHINX_VERSION
check $PREFIX_OPT/bin/python2.7 setup.py build
$SUDO $PREFIX_OPT/bin/python2.7 setup.py install

# pyzmq
cd $BUILD_DIR
rm -rf pyzmq-$PYZMQ_VERSION
if [ -f $HOME/source/pyzmq-$PYZMQ_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/pyzmq-$PYZMQ_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/p/pyzmq/pyzmq-$PYZMQ_VERSION.tar.gz | tar zxf -
fi
cd pyzmq-$PYZMQ_VERSION
check $PREFIX_OPT/bin/python2.7 setup.py build --zmq=bundled
$SUDO $PREFIX_OPT/bin/python2.7 setup.py install

# tornado
cd $BUILD_DIR
rm -rf tornado-$TORNADO_VERSION
if [ -f $HOME/source/tornado-$TORNADO_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/tornado-$TORNADO_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/t/tornado/tornado-$TORNADO_VERSION.tar.gz | tar zxf -
fi
cd tornado-$TORNADO_VERSION
check $PREFIX_OPT/bin/python2.7 setup.py build
$SUDO $PREFIX_OPT/bin/python2.7 setup.py install

# ipython
cd $BUILD_DIR
rm -rf ipython-$IPYTHON_VERSION
if [ -f $HOME/source/ipython-$IPYTHON_VERSION.tar.gz ]; then
  check tar zxf $HOME/source/ipython-$IPYTHON_VERSION.tar.gz
else
  check wget --no-check-certificate -O - https://pypi.python.org/packages/source/i/ipython/ipython-$IPYTHON_VERSION.tar.gz | tar zxf -
fi
cd ipython-$IPYTHON_VERSION
check $PREFIX_OPT/bin/python2.7 setup.py build
$SUDO $PREFIX_OPT/bin/python2.7 setup.py install
