#!/bin/bash

REPO=`mktemp -d`
BUILD=`mktemp -d`
FILELIST=`mktemp`
LD_CONF=/etc/ld.so.conf.d/dpdk.conf

trap "rm -fr $BUILD $REPO $FILELIST" EXIT

# args
TARBALL=$1

# where to install
DESTDIR=/

# take first ninja available
NINJA=$(which ninja-build ninja|head -1)

# build
(git clone http://dpdk.org/git/dpdk $REPO && \
cd $REPO && \
git checkout $DPDK_VER && \
pip3 install meson && \
meson $BUILD && \
cd $BUILD && \
$NINJA && $NINJA install) || exit 1

# configuration options before ninja build
#meson configure -Dexamples= && \
#meson configure -Dtests=false && \

pushd $(dirname $0)
# collect libdir
python3 ./meson-installed.py $BUILD/meson-info/intro-installed.json | \
(while read file; do
	case $file in
		*.so*|*.a) dirname $file ;;
	esac
done) | sort | uniq > $LD_CONF || exit 1
echo "$LD_CONF" >> $FILELIST

python3 ./meson-installed.py $BUILD/meson-info/intro-installed.json | \
(while read file; do
	echo $file
done) | sort | uniq >> $FILELIST || exit 1
popd

# archive all files
tar cfz $TARBALL -P -T $FILELIST || exit 1
chown $DOCKER_UID $TARBALL || exit 1
