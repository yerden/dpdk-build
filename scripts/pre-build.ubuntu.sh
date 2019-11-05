#!/bin/bash

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

(apt-get -y update && apt-get -y install $PACKAGES) || exit 1

#
# container's uname reports host kernel,
# we have to trick uname's users.
#
mv /bin/uname /bin/uname.orig
cat > /bin/uname << EOF
#!/bin/bash
if [ "\$1" != "-r" ]; then /bin/uname.orig \$@
else ls -v /lib/modules/ |tail -1
fi
EOF
chmod +x /bin/uname

