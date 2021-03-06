#!/bin/bash

REPO=`mktemp -d`
BUILD=`mktemp -d`
FILELIST=`mktemp`
LD_CONF=/etc/ld.so.conf.d/dpdk.conf

trap "rm -fr $BUILD $REPO $FILELIST" EXIT

# args
TARBALL=build/dpdk.tar.gz

# take first ninja available
NINJA=$(type -p ninja-build ninja)

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
#
# let's collect what we take to next stage
# register directories with libraries to $LD_CONF
#
python3 ./meson-installed.py $BUILD/meson-info/intro-installed.json | \
(while read file; do
	case $file in
		*.so*|*.a) dirname $file ;;
	esac
done) | sort | uniq > $LD_CONF || exit 1

# store $LD_CONF to $FILELIST
echo "$LD_CONF" >> $FILELIST

# enlist all files into $FILELIST
# *.so* is a special case because we need all symlinks too
# also move  *.pc to /usr/local/share/pkgconfig
python3 ./meson-installed.py $BUILD/meson-info/intro-installed.json | \
(while read file; do
	case $file in
		*.so*)
			ls $(echo $file|awk 'BEGIN{OFS=FS="."}{while($NF!="so")NF--; print}')*
			;;
		*.pc)
			mkdir -p /usr/local/share/pkgconfig
			mv $file /usr/local/share/pkgconfig
			ls /usr/local/share/pkgconfig/$(basename $file)
			;;
		*)
			echo $file
			;;
	esac
done) | sort | uniq >> $FILELIST || exit 1
popd

#
# save all files into TARBALL
#
case $TARBALL in
	*.gz) TAR_OPTS="cfz" ;;
	*.bz2) TAR_OPTS="cfj" ;;
	*) TAR_OPTS="cf" ;;
esac
tar $TAR_OPTS $TARBALL -P -T $FILELIST || exit 1

# change owner to DOCKER_UID
chown $DOCKER_UID $TARBALL || exit 1

cat > build/Dockerfile <<EOF
FROM ${BASE}:${DIST}
LABEL org.opencontainers.image.authors="yerden.zhumabekov@gmail.com"
LABEL org.opencontainers.image.created="$(date --rfc-3339='seconds')"
ADD $TARBALL /
EOF
