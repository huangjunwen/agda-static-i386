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
    cabal install --enable-split-objs -O2  --install-method=copy


FROM i386/alpine:3.21

ARG AGDA_VER=2.6.4.3

COPY --from=0 /root/Agda-$AGDA_VER/* /Agda-$AGDA_VER
COPY --from=0 /root/.cabal/bin/* /usr/local/agda/bin
