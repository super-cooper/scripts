#!/bin/bash

cd ~/Downloads

rm -rf gdb 
mkdir gdb && cd gdb
sudo apt build-dep gdb
apt source gdb
cd $(ls | grep gdb-)
./configure --with-python=$(which python2.7)
dpkg-buildpackage -us -uc -nc -B
sudo dpkg -i ../*.deb
