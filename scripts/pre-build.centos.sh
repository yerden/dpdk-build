#!/bin/bash

PACKAGES="\
	gcc \
	glibc-devel \
	kernel-headers \
	kernel-devel \
	numactl-devel \
	libibverbs-devel \
	jansson-devel \
	zlib-devel \
	python3-pip \
	libpcap-devel \
	libmnl-devel \
	libmnl-static \
	ninja-build \
	git \
	make \
	pkgconfig \
	cmake \
"

(yum -y install epel-release && yum -y install $PACKAGES) || exit 1

#
# container's uname reports host kernel,
# we have to trick uname's users.
#
mv /bin/uname /bin/uname.orig
cat > /bin/uname << EOF
#!/bin/bash
if [ "\$1" != "-r" ]; then /bin/uname.orig \$@
else ls -v /usr/src/kernels |tail -1
fi
EOF
chmod +x /bin/uname

mkdir -p /lib/modules/$(uname -r)
ln -sf /usr/src/kernels/$(uname -r) /lib/modules/$(uname -r)/build
