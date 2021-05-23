FROM alpine

LABEL maintainer="Patrice Ferlet <metal3d@gmail.com>"

ARG VERSION=6.12.1
    
RUN set -xe;\
    echo "@community http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories; \
    apk update; \
    apk add util-linux build-base cmake libuv-static libuv-dev openssl-dev hwloc-dev@community; \
    wget https://github.com/xmrig/xmrig/archive/v${VERSION}.tar.gz; \
    tar xf v${VERSION}.tar.gz; \
    mkdir -p xmrig-${VERSION}/build; \
    cd xmrig-${VERSION}/build; \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DUV_LIBRARY=/usr/lib/libuv.a;\
    make -j $(nproc); \
    cp xmrig /usr/local/bin/xmrig;\
    rm -rf xmrig* *.tar.gz; \
    apk del build-base; \
    apk del openssl-dev;\ 
    apk del hwloc-dev; \
    apk del cmake; \
    apk add hwloc@community;

ENV POOL_USER="82pMESeTPnQT4cioTeyJywgQ1yykRVweffpjTxJtNyx7KFQjFeDaExVeM7pUVeYATCXfGrk3TLBVhdVmRWrsnSrYLz9crTF" \
    POOL_PASS="" \
    POOL_URL="pool.supportxmr.com:443" \
    DONATE_LEVEL=0 \
    PRIORITY=0 \
    THREADS=10

ADD entrypoint.sh /entrypoint.sh
WORKDIR /tmp
EXPOSE 3000
CMD ["/entrypoint.sh"]
