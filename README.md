CPP Makefile
============

This is a simple make file project bootstrap for a fictitious CPP utility called 'alpha'.

Source
------

Source files go in `src/common` with the main file found in `src/mains`. This coresponding CPPUnit test
can be found in `tst/`. If a class is in a namespace, put it in a sub-directory of that name. By default
there is a 'alpha' namespace for all your code. Run `make` for help.

Environment
-----------

There is a very simple Vagrant config file using the standard precise64 box. There is an `install-deps.sh`
script for installing the dependencies to get you started. This script should work on any debian bases OS.