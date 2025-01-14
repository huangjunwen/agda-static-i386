FROM i386/debian:11.11

RUN apt-get update && \
    apt-get install -y cabal-install pkg-config patch zlib1g-dev libncurses5-dev upx && \
    cabal update 

WORKDIR /root

COPY patches /root/patches

ARG AGDA_VER=2.6.4.3
ARG PREFIX=/usr/local

RUN cabal get Agda-$AGDA_VER && \
    cd Agda-$AGDA_VER && \
    patch -p1 < /root/patches/Agda-$AGDA_VER.patch && \
    cabal install --enable-split-objs -O2  --install-method=copy && \
    upx /root/.cabal/bin/agda && \
    upx /root/.cabal/bin/agda-mode



FROM i386/alpine:3.21

ARG AGDA_VER=2.6.4.3

COPY --from=0 /root/Agda-$AGDA_VER/src/data/. /usr/local/share/agda/
COPY --from=0 /root/.cabal/bin/. /usr/local/bin/

ENV Agda_datadir=/usr/local/share/agda
