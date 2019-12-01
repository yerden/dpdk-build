#!/bin/bash

LOG=`mktemp`
trap "rm -f $LOG" EXIT

PACKAGES="\
	libz-dev \
	pkg-config \
	git \
	ninja-build \
	python3-pip \
	build-essential \
	libnuma-dev \
	libjansson-dev \
	libisal-dev \
	libfdt-dev \
	libmnl-dev \
	libibverbs-dev \
	libpcap-dev \
	cmake \
	linux-headers-generic \
"

(apt-get -y update && apt-get -y install $PACKAGES > $LOG)
if [ $? != 0 ]; then
        cat $LOG
        exit 1
fi
echo "Packages installed OK."

#
# container's uname reports host kernel,
# we have to trick uname's users.
#
mv /bin/uname /bin/uname.orig && \
cat > /bin/uname << EOF
#!/bin/bash
if [ "\$1" != "-r" ]; then /bin/uname.orig \$@
else ls -v /lib/modules/ |tail -1
fi
EOF
chmod +x /bin/uname || exit 1

echo "uname replaced OK."
