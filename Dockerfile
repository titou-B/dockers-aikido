FROM debian:stretch

# Workaround to suppress "Warning: apt-key output should not be parsed (stdout is not a terminal)"
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

RUN apt-get update -qq

# To run dpkg without interactive dialogue
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y \
    build-essential  \
    cmake \
    curl \
    git \
    lsb-release \
    pkg-config \
    python \
    software-properties-common \
    sudo \
    tzdata \
    catkin \
    gcc \
    g++

RUN git clone https://github.com/titou-B/aikido.git /aikido \
    cd aikidi \
    mkdir titou

VOLUME /aikido/titou

CMD /bin/bash


