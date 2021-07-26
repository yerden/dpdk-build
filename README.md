# dpdk-build

[![](https://images.microbadger.com/badges/version/nedrey/dpdk-build:bionic-v19.08.svg)](https://hub.docker.com/r/nedrey/dpdk-build)

DPDK docker-based binary build.


Manual build
------------

You can manually build an image, e.g.:
```
export DOCKER_TAG=centos7-v21.05
export IMAGE_NAME=dpdk-kd:$DOCKER_TAG
export MESON_OPTS="-D disable_drivers=net/mlx4"
export DPDK_URL=http://dpdk.org/git/dpdk

./hook/pre_build
./hook/build
```

Base image and DPDK revision are derived from `DOCKER_TAG`.
