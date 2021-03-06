# Please update this skeleton 
# Don't forget to write commentaries in English instead of French for you would be asked to in a work environment!
# Based on Ubuntu "" x.y => Your version of Ubuntu or else!
FROM ubuntu:latest as ynov-ctng-ubuntu

# LABEL about the custom image 
# Your Ynov Bordeaux Campus student email address
LABEL maintainer="moise.moussetafa@ynov.com"
# First version, nothing to change!
LABEL version="0.1"
# Add a relevant description of the image here! (Recommended)
LABEL description="docker image (container) with cross toolchain (crosstool-ng)"

# Make the creation of docker images easier so that CTNG_UID/CTNG_GID have
# a default value if it's not explicitly specified when building. This
# will allow publishing of images on various package repositories (e.g.
# docker hub, gitlab containers). dmgr.sh can still be used to set the
# UID/GID to that of the current user when building a custom container.
ARG CTNG_UID=1000
ARG CTNG_GID=1000
# File to configure for your raspberry pi version
ARG CONFIG_FILE=./arm-ynov-linux-gnuabihf


RUN apt-get -y update && apt-get -y upgrade 


# Necessary packages
RUN TZ="Europe/Paris" apt-get install -y tzdata
RUN apt-get install git -y
RUN apt-get install gcc-arm-linux-gnueabi -y


# Install necessary packages to run crosstool-ng
# You don't remember the previous lectures on the crosstool-ng?
# Use google : install crosstool-ng <Your distribution>??
RUN apt-get install -y \
	autoconf \
	automake \
	binutils \
	bison \
	build-essential \
	curl \
    chrpath \
	flex \
	gawk \
    g++ \
	gperf \
	libncurses5-dev \
	libtool \
    libtool-bin \
    libexpat1-dev \
    libsdl1.2-dev \
    python3-dev \
	subversion \
	texinfo \
	tmux \
	unzip \
	wget \
    help2man \
    apt-utils \
    rsync


# Install Dumb-init
# https://github.com/Yelp/dumb-init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64
RUN chmod +x /usr/local/bin/dumb-init
RUN echo 'export PATH=/opt/ctng/bin:$PATH' >> /etc/profile
ENTRYPOINT [ "/usr/local/bin/dumb-init", "--" ]


# Crosstool-ng must be executed from a user that isn't the superuser (root)
# You must create a user and add it to the sudoer group
# Help : https://phoenixnap.com/kb/how-to-create-sudo-user-on-ubuntu
RUN apt-get -y install sudo
RUN adduser --disabled-password --gecos '' user
RUN adduser user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# Login with user 
USER user
WORKDIR /home/user
# Download and install the latest version of crosstool-ng
# https://github.com/crosstool-ng/crosstool-ng.git
RUN git clone -b master --single-branch --depth 1 \
    https://github.com/crosstool-ng/crosstool-ng.git ct-ng
WORKDIR /home/user/ct-ng
RUN ./bootstrap
RUN ./configure --enable-local
RUN make
RUN sudo make install
ENV PATH=/home/user/.local/bin:$PATH
COPY ${CONFIG_FILE} .config
# Build ct-ng
RUN ./ct-ng oldconfig
RUN ./ct-ng build

ENV TOOLCHAIN_PATH=/home/dev/x-tools/${CONFIG_FILE}
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH

CMD ["bash"]
