#  vim: set syntax=dockerfile expandtab fdm=marker ts=2 sw=2 tw=80 et :

FROM ubuntu:focal

#
# Maximum number of threads to compile tools
#
ENV NUMBER_OF_JOBS=6

#
# Avoid interactive prompts
#
ENV DEBIAN_FRONTEND=noninteractive

#
# Update and install dependencies
#
RUN apt update
RUN apt install -y git build-essential gcc clang binutils cmake  \
  extra-cmake-modules libboost-filesystem-dev libboost-dev python3 \
  python3-distutils python-dev python3-dev libreadline-dev

#
# Create user
#
RUN useradd -u 1000 -m eda
RUN usermod -a -G $(groups) eda
USER eda
WORKDIR /home/eda/

#
# Clone and compile fiction
#
RUN git clone --recursive https://github.com/ruanformigoni/fiction.git fiction
RUN cd fiction \
  && mkdir build \
  && cd build \
  && cmake -DCMAKE_CXX_COMPILER=clang++ .. \
  && make -lboost_filesystem -lboost_system -j${NUMBER_OF_JOBS}

WORKDIR /home/eda/fiction

CMD ["bash"]
