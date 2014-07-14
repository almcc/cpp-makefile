#!/bin/bash

sudo yum install -y wget

# epel
wget https://anorien.csc.warwick.ac.uk/mirrors/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo yum install -y --nogpgcheck epel-release-6-8.noarch.rpm
rm epel-release-6-8.noarch.rpm

# rpmforge
wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
sudo yum install -y --nogpgcheck rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
rm rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm

sudo yum clean all

# packages
sudo yum groupinstall -y development
sudo yum install -y cppcheck libxslt tree python-pygments nodejs npm python-pip graphviz valgrind java-1.6.0-openjdk zlib-dev openssl-devel sqlite-devel bzip2-devel texlive-latex plantuml

# lcov
wget http://downloads.sourceforge.net/ltp/lcov-1.11-1.noarch.rpm
sudo yum install -y lcov-1.11-1.noarch.rpm
rm -f lcov-1.11-1.noarch.rpm

# jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins

# gcc4.8
sudo wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo
sudo yum install -y devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++

# cxxtest
wget http://downloads.sourceforge.net/project/cxxtest/cxxtest/4.4/cxxtest-4.4.tar.gz
tar -xvf cxxtest-4.4.tar.gz
pushd cxxtest-4.4
sudo cp -r cxxtest/ /usr/local/include/
sudo cp -r bin/cxxtestgen /usr/local/bin/
pushd python
sudo python setup.py install
popd
popd
rm -rf cxxtest-4.4
rm -f cxxtest-4.4.tar.gz

# python 2.7
wget http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz
tar -xvf Python-2.7.6.tar.xz
pushd Python-2.7.6
./configure --prefix=/usr/local
make
sudo make altinstall
popd
rm -rf Python-2.7.6*

# setup tools
wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz
tar -xvf setuptools-1.4.2.tar.gz
pushd setuptools-1.4.2
sudo python2.7 setup.py install
popd
rm -rf setuptools-1.4.2
rm -f setuptools-1.4.2.tar.gz

# pip for 2.7
wget https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py
sudo /usr/local/bin/python2.7 get-pip.py
rm get-pip.py

# doxygen
wget http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.7.src.tar.gz
tar -xvf doxygen-1.8.7.src.tar.gz
pushd doxygen-1.8.7
./configure
make
sudo make install
popd
rm -rf doxygen-1.8.7*

# lizard
sudo /usr/local/bin/pip2.7 install lizard

# jade
sudo npm install jade --global

# sphinx
pushd /tmp # Can't run this in a directory with a child directroy named sphinx
sudo /usr/local/bin/easy_install-2.7 -U Sphinx
sudo /usr/local/bin/pip2.7 install sphinx_rtd_theme
sudo /usr/local/bin/pip2.7 install sphinxcontrib-plantuml
sudo /usr/local/bin/pip2.7 install breathe
popd

# robot framework
sudo /usr/local/bin/pip2.7 install robotframework

# starting services
sudo service jenkins start
sudo chkconfig jenkins on