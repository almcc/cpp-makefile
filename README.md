CPP Makefile
============

This is a simple make file project bootstrap for a fictitious CPP utility called 'alpha'.

Source
------

Source files go in `src/common` with the main file found in `src/mains`. The coresponding CxxTest Test Suite can be found in `tst/`. If a class is in a namespace, put it in a sub-directory of the same name. By default there is a 'alpha' namespace for all your code.

Make Targets
------------

- `make all` Builds all the binaries.
- `make fresh` Equivalient to 'make clean all'.
- `make clean-cpp` Removes all compiles cpp artifacts.
- `make clean` Removes all none source files.
- `make test` Runs cxxtest lcov and cppcheck.
- `make cxxtest` Makes the cxxtest executable, runs it and produces XML & HTML output..
- `make lcov` Runs a line coverage report, (after running the tests again) and generates an HTML report.
- `make cppcheck` Runs cppcheck over code, outputs a text file and cats to screen.
- `make install` Installs files, base directory defined by DESTDIR variable.
- `make uninstall` Un-installs all files, base directory defined by DESTDIR variable.
- `make dist` Makes a tar.gz file for distribution.

Scripts
-------

- `python build.py` Use to set new version/release label and build a distribution.
- `install-deps.sh` Use installing the dependencies to get you started.

Environment
-----------

There is a very simple Vagrant config file using an Ubuntu box provided by puppet labs, install like so:

`vagrant box add --name Ubuntu-13.10-x86_64 http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-1310-x64-virtualbox-puppet.box`
