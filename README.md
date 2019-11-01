# dpdk-build

[![](https://images.microbadger.com/badges/version/nedrey/dpdk-build:bionic-v19.08.svg)](https://hub.docker.com/r/nedrey/dpdk-build)

DPDK docker-based binary build.

Libraries are installed to destination path specified in `DPDK_PATH`
build argument (by default, `/dpdk`). This path is then propagated to
derived images as `DPDK_ROOT` environment variable.

To use in some build environment, you should copy the `DPDK_ROOT` to
your root directory. Or, you may use `Dockerfile.runtime` to build a
runtime image.

You may also wish to add library path to `/etc/ld.so.conf.d`.
