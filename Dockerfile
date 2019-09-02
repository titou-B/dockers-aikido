FROM debian:stretch

# Workaround to suppress "Warning: apt-key output should not be parsed (stdout is not a terminal)"
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

RUN apt-get update -qq

# To run dpkg without interactive dialogue
ENV DEBIAN_FRONTEND=noninteractive

#RUN apt-get install -y \
#    build-essential  \
#    cmake \
#    curl \
#    git \
#    lsb-release \
#    pkg-config \
#    python \
#    software-properties-common \
#    \
#    tzdata \
#    catkin \
#    gcc \
#    g++

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get update \
    && apt-get install -y \
    gcc \
    g++ \
    catkin \
    git \
    python2.7

RUN mkdir -p /home/developer/src \
    && cd /home/developer/src \
    && git clone https://github.com/titou-B/aikido.git \
    && mkdir shared

# dependencies aikido except dart
RUN apt-get install -y \
    libboost-filesystem-dev \
    libeigen3-dev \
    libyaml-cpp-dev \
    libtinyxml2-dev \
    python-dev \
    libompl-dev

#install dart
ADD ./dart /home/developer/dart
RUN echo "deb http://ftp.fr.debian.org/debian/ stretch-backports main" >> /etc/apt/sources.list && \
    apt update && \
    apt install -t stretch-backports -y libnlopt-cxx-dev && \
    cd /home/developer/dart && \
    apt install -y \
    ./libdart6-external-odelcpsolver_6.9.1-0~eoan_amd64.deb \
    ./libdart6-external-odelcpsolver-dev_6.9.1-0~eoan_amd64.deb \
    ./libdart6-external-ikfast-dev_6.9.1-0~eoan_amd64.deb \
    ./libdart6_6.9.1-0~eoan_amd64.deb \
    ./libdart6-dev_6.9.1-0~eoan_amd64.deb \
    ./libdart6-optimizer-nlopt_6.9.1-0~eoan_amd64.deb \
    ./libdart6-optimizer-nlopt-dev_6.9.1-0~eoan_amd64.deb \
    ./libdart6-utils_6.9.1-0~eoan_amd64.deb \
    ./libdart6-collision-bullet_6.9.1-0~eoan_amd64.deb \
    ./libdart6-collision-bullet-dev_6.9.1-0~eoan_amd64.deb \
    ./libdart6-utils-dev_6.9.1-0~eoan_amd64.deb \
    ./libdart6-utils-urdf_6.9.1-0~eoan_amd64.deb \
    ./libdart6-utils-urdf-dev_6.9.1-0~eoan_amd64.deb && \
    cd .. && \
    rm -r dart

# RUN cd /home/developer && \
#     catkin_make_isolated
RUN cd /home/developer/src/aikido && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j2 && \
    make install && \
    cd /usr/include && \
    ln -s eigen3/Eigen Eigen && \
    rm -r /home/developer/src/aikido

WORKDIR /home/developer
VOLUME /home/developer/src/shared

CMD /bin/bash


