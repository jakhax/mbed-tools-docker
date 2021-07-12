FROM python:3.10.0b3-buster

# Set up a tools dev directory
WORKDIR /home/dev

#update
RUN apt-get update 

#requirements
RUN apt-get install -y build-essential\
                    python3-dev\
                    git\
                    ninja-build\
                    mercurial


#download GCC_ARM 10-2020-q4-major x86_64 linux
RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2\
    && tar xvf gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 \
    && rm gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2

# Set up the compiler path
ENV PATH $PATH:/home/dev/gcc-arm-none-eabi-10-2020-q4-major/bin

# #install cmake from source
# RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.5/cmake-3.20.5.tar.gz\
#     && tar -zxvf cmake-3.20.5.tar.gz\
#     && cd cmake-3.20.5\
#     && ./bootstrap\
#     && make\
#     && make install

# install cmake from binary, faster
RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.5/cmake-3.20.5-linux-x86_64.sh\
    && chmod 755 cmake-3.20.5-linux-x86_64.sh\
    && ./cmake-3.20.5-linux-x86_64.sh --include-subdir --skip-license\
    && rm cmake-3.20.5-linux-x86_64.sh

ENV PATH $PATH:/home/dev/cmake-3.20.5-linux-x86_64/bin

#install mbed tools
RUN python3 -m pip install mbed-tools

# install mbed os requirements
RUN wget https://raw.githubusercontent.com/ARMmbed/mbed-os/master/requirements.txt
RUN python3 -m pip install -r ./requirements.txt

#workdir
WORKDIR /home/projects

#shared user
ARG USER_ID
ARG GROUP_ID
RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
USER user
