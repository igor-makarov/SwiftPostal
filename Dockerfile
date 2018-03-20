FROM swift
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
    curl libsnappy-dev autoconf automake libtool pkg-config \
    git

WORKDIR /
RUN git clone https://github.com/openvenues/libpostal
WORKDIR /libpostal

RUN ./bootstrap.sh && \
    mkdir -p /opt/libpostal_data && \
    ./configure --datadir=/opt/libpostal_data && \
    make -j4 && \
    make install && \
    ldconfig