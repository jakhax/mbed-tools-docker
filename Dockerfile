FROM python:3.8.4-buster

#update
RUN apt-get update 

#requirements
RUN apt-get install -y build-essential\
                    python3-dev\
                    git\
                    mercurial

#install mbed cli
RUN python3 -m pip install mbed-cli

# Set up a tools dev directory
WORKDIR /home/dev

#download GCC_ARM compiler 6-2017-q2-update) 6.3.1 20170620 (release) 
RUN wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2\
    && tar xvf gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
    && rm gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2

# Set up the compiler path
ENV PATH $PATH:/home/dev/gcc-arm-none-eabi-9-2020-q2-update/bin

# set GCC_ARM  as global toolchain
RUN mbed config --global toolchain gcc_arm

# install mbed os requirements
RUN wget https://raw.githubusercontent.com/ARMmbed/mbed-os/master/requirements.txt
RUN python3 -m pip install -r ./requirements.txt

# # installing missing python libs and toolchain
# RUN cd /tmp && mbed new tmp0 && cd tmp0 && mbed compile >/dev/null 2>&1; cd .. && rm -r /tmp/tmp0

#workdir
WORKDIR /home/projects

#shared user
ARG USER_ID
ARG GROUP_ID
RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
USER user