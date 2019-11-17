ARG BASE
ARG DIST

# take distro and roll out pre-built binaries
FROM ${BASE}:${DIST}
ARG LD_PATH
ARG DPDK_TAR
ADD ${DPDK_TAR} /

# update ld.so.cache
RUN /bin/bash -c 'echo $LD_PATH > /etc/ld.so.conf.d/dpdk.conf && ldconfig'
