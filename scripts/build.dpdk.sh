#!/bin/bash

REPO=`mktemp -d`
BUILD=`mktemp -d`
trap "rm -fr $BUILD $REPO" EXIT

git clone http://dpdk.org/git/dpdk $REPO && \
cd $REPO && \
git checkout $1 && \
pip3 install meson && \
meson $BUILD && \
cd $BUILD && \
meson configure -Dexamples= && \
meson configure -Dtests=false && \
ninja && \
(DESTDIR="$2" ninja install)
