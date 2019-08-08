#!/bin/bash

cd ~/Downloads

rm -rf gdb 
mkdir gdb && cd gdb
sudo apt build-dep gdb
apt source gdb
cd $(ls | grep gdb-)
sed -Ei 's/(.*)--with-python=python3/\1--with-python=python2.7/g' debian/rules
dpkg-buildpackage -us -uc -nc -B
sudo dpkg -i ../*.deb
sudo apt install --fix-broken
