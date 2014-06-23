#!/bin/bash
sudo apt-get update
sudo apt-get install git unzip make g++ cppcheck xsltproc tree apt-file lcov python-pygments cxxtest vera++ nodejs nodejs-legacy npm python-pip flawfinder
sudo npm install jade --global
sudo pip install lizard
mkdir -p ~/stage
pushd ~/stage
wget http://archives.oclint.org/releases/0.7/oclint-0.7-x86_64-linux-ubuntu-12.04.tar.gz
tar -xvf oclint-0.7-x86_64-linux-ubuntu-12.04.tar.gz
pushd oclint-0.7-x86_64-linux-ubuntu-12.04
sudo mv bin/* /usr/local/bin/
sudo mv lib/* /usr/local/lib/
popd
rm -rf oclint-0.7-x86_64-linux-ubuntu-12.04
rm -f oclint-0.7-x86_64-linux-ubuntu-12.04.tar.gz
popd