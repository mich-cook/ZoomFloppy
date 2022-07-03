#!/bin/bash

#
# install the c64 software to talk to drive through the ZoomFloppy
#

# install the ubuntu packages we'll need to build stuff
sudo apt-get -qq update && sudo apt-get install -qq git make gcc libusb-dev libncurses5-dev git

# stopping here for now. sudo works so we don't have to change the script and
# apt-get install is working. next step: run through the rest and see what breaks.
exit

# get the stuff
mkdir /tmp/git && cd /tmp/git
git clone https://github.com/cc65/cc65.git
# this was the original line pointing at sf.net, but it's on
# github too, so it's probably easier to clone from there.
# git clone git://git.code.sf.net/p/opencbm/code opencbm
git clone https://github.com/OpenCBM/OpenCBM.git opencbm

# build cc65
cd /tmp/git/cc65
git checkout 93b6efcb2f969c6de0fd1eca5b07dbce18046c0a
make && sudo PREFIX=/usr make install

# build opencbm
cd /tmp/git/opencbm
git checkout 0718991803fb603359b92c777d975eb06b8623b6
make -f LINUX/Makefile opencbm plugin-xum1541
sudo make -f LINUX/Makefile opencbm install-plugin-xum1541
sudo make -f LINUX/Makefile install install-xum1541

# put opencbm lib where it will be found
sudo ln -s /usr/local/lib/libopencbm.so.0 /usr/lib/libopencbm.so.0

# remove the code we cloned
sudo rm -rf /tmp/git
