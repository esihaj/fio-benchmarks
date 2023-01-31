#!/bin/bash
set -xe

sudo apt update
sudo apt -y install gcc g++ make htop cmake curl zsh git nvme-cli libaio-dev sysstat tmux libnuma-dev iotop

mkdir results

#SPDK
git clone https://github.com/spdk/spdk.git

# FIO
git clone https://github.com/axboe/fio.git
cd fio
./configure
make
sudo make install

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"