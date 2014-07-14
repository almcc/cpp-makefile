# Release Settings
# ==============================
MAJOR = x
MINOR = x
FIX = x
LABEL = dev
BUILD = x
VERSION = $(MAJOR).$(MINOR).$(FIX)
RELEASE = alpha-$(VERSION)-$(LABEL)$(BUILD)

# Directories
# ==============================

SRC_DIR = src/
TST_DIR = tst/
OBJ_DIR = obj/
BIN_DIR = bin/
LIB_DIR = lib/
DST_DIR = dst/
RPT_DIR = rpt/
SYS_DIR = sys/
UTL_DIR = utils/

VPATH = $(SRC_DIR) $(TST_DIR)

# Compiler Settings
# ==============================

CC = /opt/rh/devtoolset-2/root/usr/bin/g++
CC_INCLUDES = -I$(SRC_DIR)common/ \
              -I$(TST_DIR)common/ \
              -I/usr/local/include/python2.7/

CC_OPTIONS = -g -O3 -fPIC -std=c++11 --coverage
CC_WARNINGS = -Wpedantic -Wall -Wextra -Weffc++ -Wold-style-cast -Woverloaded-virtual -Wshadow
CC_FLAGS = $(CC_OPTIONS) $(CC_WARNINGS)
LK_FLAGS = --coverage

# Tools
# ==============================
GCOV = /opt/rh/devtoolset-2/root/usr/bin/gcov
LIZARD = /usr/local/bin/lizard
DOXYGEN = /usr/local/bin/doxygen

# (Required) Libraries
# ==============================

LIB_INC = -L/usr/lib -L/usr/lib64
SHARED_LIBS =
STATIC_LIBS =

# Swig
# ==============================

SWIG_INT = src/swig/alpha.swig
SWIG_SRC = src/swig/alpha_wrap.cxx
SWIG_PYT = src/swig/alpha.py
SWIG_OBJ = obj/swig/alpha_wrap.o

# All sources and objects
# ==============================

HEADERS = $(shell for file in `find $(SRC_DIR) -name *.h`; do echo $$file; done)
SRCS = $(shell for file in `find $(SRC_DIR) -name *.cpp`; do echo $$file; done)
OBJS = $(patsubst $(SRC_DIR)%,$(OBJ_DIR)%,$(SRCS:.cpp=.o))

# Objects per directory
# ==============================

COMMON_SRCS = $(shell for file in `find $(SRC_DIR)common -name *.cpp`; do echo $$file; done)
COMMON_OBJS = $(patsubst $(SRC_DIR)common%,$(OBJ_DIR)common%,$(COMMON_SRCS:.cpp=.o))

# Bin specific Objects
# ==============================

APP_OBJS = $(COMMON_OBJS) $(OBJ_DIR)mains/alpha-main.o

# Tests
# ==============================

TST_RUNNER_DIR = $(TST_DIR)runners/
TST_RUNNER_SRC = $(TST_RUNNER_DIR)runner.cpp
TST_RUNNER_OBJ = $(OBJ_DIR)runners/runner.o
TST_RUNNER_BIN = $(BIN_DIR)runner
TST_OBJS = $(COMMON_OBJS) $(TST_RUNNER_OBJ)
TST_SRCS = $(shell for file in `find $(TST_DIR)common -name *.h`; do echo $$file; done)
TST_XML_OUT = cxxtest.xml

# CppCheck
# ==============================
CHECK_SRCS = $(shell for file in `find $(SRC_DIR)common -name *.cpp`; do echo $$file; done)
CHECK_HDRS = $(shell for file in `find $(SRC_DIR)common -name *.h`; do echo $$file; done)

# Static Analysis Settings
# ==============================

MAX_LINE_LENGHT = 100

# Targets
# ==============================

.PHONY : all bins libs fresh clean-cpp clean index test docs build cxxtest valgrind cppcheck cpplint lizard install uninstall dist

all: bins libs

bins: $(BIN_DIR)alpha

libs: $(LIB_DIR)_alpha.so

fresh: clean all

clean-cpp:
	@echo "Cleaning CPP atrifacts."
	@rm -rf $(OBJ_DIR)
	@rm -rf $(BIN_DIR)
	@rm -rf $(DST_DIR)
	@rm -rf $(LIB_DIR)
	@rm -f $(SRC_DIR)/common/Release.h
	@rm -rf $(TST_RUNNER_DIR)

clean: clean-cpp
	@echo "Cleaning everything else."
	@find . -name '*.DS_Store' -type f -delete
	@rm -rf $(RPT_DIR)
	@rm -f $(TST_XML_OUT)
	@rm -f $(SWIG_SRC)

index:
	@mkdir -p $(RPT_DIR)
	@cp -r $(UTL_DIR)web $(RPT_DIR)
	@jade --obj "{ 'name': 'alpha', \
				   'major': '$(MAJOR)', \
				   'minor': '$(MINOR)', \
				   'fix': '$(FIX)', \
				   'label': '$(LABEL)', \
				   'build': '$(BUILD)', \
				   'version': '$(VERSION)', \
				   'release': '$(RELEASE)' \
				}" $(UTL_DIR)index.jade -o rpt

test: clean cppcheck cpplint all cxxtest valgrind lizard index

docs: index
	@cp Doxyfile Doxyfile.filled
	@echo "PROJECT_NAME = $(shell echo alpha | tr a-z A-Z)" >> Doxyfile.filled
	@echo "PROJECT_NUMBER = $(RELEASE)" >> Doxyfile.filled
	@$(DOXYGEN) Doxyfile.filled
	@rm -f Doxyfile.filled

build: test docs dist

# Unit testing (CxxTest)
# ==============================

cxxtest: $(TST_RUNNER_BIN)
	@echo "Running cxxtest ..."
	@mkdir -p $(RPT_DIR)/cxxtest-html/
	@lcov --gcov-tool $(GCOV) --directory . --zerocounters
	@$(TST_RUNNER_BIN)
	@mv $(TST_XML_OUT) $(RPT_DIR)
	@xsltproc $(UTL_DIR)xunit-to-html.xslt $(RPT_DIR)$(TST_XML_OUT) > $(RPT_DIR)/cxxtest-html/index.html
	@cp $(UTL_DIR)web/js/jquery.min.js $(RPT_DIR)/cxxtest-html/
	@mkdir -p $(RPT_DIR)
	@lcov --gcov-tool $(GCOV) --base-directory . --directory . --capture --output-file $(RPT_DIR)coverage.info
	@lcov --gcov-tool $(GCOV) --remove $(RPT_DIR)coverage.info  "/usr*" -o $(RPT_DIR)coverage.info
	@lcov --gcov-tool $(GCOV) --remove $(RPT_DIR)coverage.info  "tst/*" -o $(RPT_DIR)coverage.info
	@genhtml $(RPT_DIR)coverage.info --output-directory $(RPT_DIR)coverage-html

valgrind: $(TST_RUNNER_BIN)
	@echo "Running valgrind ..."
	@rm -f $(RPT_DIR)valgrind-report.*
	@mkdir -p $(RPT_DIR)
	@valgrind --tool=memcheck --xml=yes --xml-file=$(RPT_DIR)valgrind-memcheck-report.xml $(TST_RUNNER_BIN)
	@valgrind --tool=helgrind --xml=yes --xml-file=$(RPT_DIR)valgrind-helgrind-report.xml $(TST_RUNNER_BIN)

# Static analysis
# ==============================

cppcheck: $(SRC_DIR)/common/Release.h
	@echo "Running cppcheck ..."
	@mkdir -p $(RPT_DIR)
	@rm -rf $(RPT_DIR)cppcheck-html
	@cppcheck --quiet --enable=all --xml --suppress=missingIncludeSystem $(CC_INCLUDES) $(SRCS) $(HEADERS) 2> $(RPT_DIR)cppcheck.xml
	@$(UTL_DIR)cppcheck-htmlreport --file=$(RPT_DIR)cppcheck.xml --report-dir=$(RPT_DIR)cppcheck-html --source-dir=.

cpplint: $(SRC_DIR)/common/Release.h
	@echo "Running cpplint ..."
	@rm -f $(RPT_DIR)cpplint.txt
	@rm -rf $(RPT_DIR)cpplint-html/
	@mkdir -p $(RPT_DIR)cpplint-html/
	@cp -r $(UTL_DIR)web $(RPT_DIR)
	@-$(UTL_DIR)cpplint.py --root=source \
	                       --extensions=h,cpp \
	                       --linelength=$(MAX_LINE_LENGHT) \
	                       --filter=-legal \
	                       $(SRCS) $(HEADERS) $(TST_SRCS) 2> $(RPT_DIR)cpplint.txt
	@$(UTL_DIR)cpplint-html.py $(RPT_DIR)cpplint.txt . > $(RPT_DIR)cpplint-html/index.html

lizard: $(SRC_DIR)/common/Release.h
	@echo "Running lizard ..."
	@rm -f $(RPT_DIR)lizard-report.*
	@mkdir -p $(RPT_DIR)
	@$(LIZARD) $(SRCS) $(TST_SRCS) > $(RPT_DIR)lizard-report.txt

# Installing & releasing
# ==============================

install: all
	@echo "Installing to $(DESTDIR)"
	mkdir -p $(DESTDIR)/usr/local/bin/
	cp -p $(BIN_DIR)alpha $(DESTDIR)/usr/local/bin/

uninstall:
	@echo "Uninstalling from $(DESTDIR)"
	rm -f $(DESTDIR)/usr/local/bin/$(BIN_DIR)alpha

dist: clean
	@echo "Making distribution"
	@mkdir -p $(DST_DIR)
	@mkdir -p $(SYS_DIR)
	@mkdir -p $(RELEASE)/
	@cp -r $(SRC_DIR)/ $(RELEASE)/
	@cp -r $(SYS_DIR)/ $(RELEASE)/
	@cp -r Makefile $(RELEASE)/
	@tar cvzf $(DST_DIR)/$(RELEASE)-dist.tar.gz $(RELEASE)/*
	@rm -rf $(RELEASE)/

# Making release header file
# ==============================
$(SRC_DIR)/common/Release.h: Makefile
	@echo '#ifndef SRC_COMMON_RELEASE_H_' > $(SRC_DIR)/common/Release.h
	@echo '#define SRC_COMMON_RELEASE_H_' >> $(SRC_DIR)/common/Release.h
	@echo '' >> $(SRC_DIR)/common/Release.h
	@echo '#include <string>' >> $(SRC_DIR)/common/Release.h
	@echo '' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string NAME = "alpha";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string MAJOR = "$(MAJOR)";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string MINOR = "$(MINOR)";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string FIX = "$(FIX)";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string LABEL = "$(LABEL)";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string BUILD = "$(BUILD)";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string VERSION = "$(VERSION)";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string RELEASE = "$(RELEASE)";' >> $(SRC_DIR)/common/Release.h
	@echo '' >> $(SRC_DIR)/common/Release.h
	@echo '#endif  // SRC_COMMON_RELEASE_H_' >> $(SRC_DIR)/common/Release.h

# Linking
# ==============================

$(BIN_DIR)alpha: $(APP_OBJS)
	@echo "Linking APP_OBJS into $@"
	@mkdir -p $(dir $@)
	@$(CC) $(LK_FLAGS) $(APP_OBJS) $(LIB_INC) -Wl,-Bstatic $(STATIC_LIBS) -Wl,-Bdynamic $(SHARED_LIBS) -Wl,--as-needed -o $@

$(TST_RUNNER_BIN): $(TST_OBJS)
	@mkdir -p $(BIN_DIR)
	@$(CC) $(LK_FLAGS) $(TST_OBJS) $(LIB_INC) -Wl,-Bstatic $(STATIC_LIBS) -Wl,-Bdynamic $(SHARED_LIBS) -Wl,--as-needed -o $@

# Tests
# ==============================

$(TST_RUNNER_SRC): $(TST_SRCS)
	@mkdir -p $(TST_RUNNER_DIR)
	@cxxtestgen --xunit-printer --xunit-file=$(TST_XML_OUT) -o $(TST_RUNNER_SRC) $(TST_SRCS)

# Compiling Mains
# ==============================
# Compiling mains separately as there is no header file for main files.

$(OBJ_DIR)mains/alpha-main.o: $(SRC_DIR)mains/alpha-main.cpp $(SRC_DIR)/common/Release.h
	@echo "Compling $< into $@"
	@mkdir -p $(dir $@)
	@$(CC) $(CC_FLAGS) $(CC_INCLUDES) -c $< -o $@

# Compiling Runners
# ==============================

$(TST_RUNNER_OBJ): $(TST_RUNNER_SRC)
	@echo "Compling $< into $@"
	@mkdir -p $(dir $@)
	@$(CC) -g --coverage $(CC_INCLUDES) -c $< -o $@

# Compiling Swig
# ==============================
# Generating and then compling the swig wrapper for python

$(SWIG_OBJ): $(SWIG_SRC)
	@echo "Compling $< into $@"
	@mkdir -p $(dir $@)
	@$(CC) $(CC_OPTIONS) $(CC_INCLUDES) -c $< -o $@

$(SWIG_SRC): $(SWIG_INT)
	@mkdir -p $(LIB_DIR)
	@echo "Compling $< into $@"
	@mkdir -p $(dir $@)
	@swig -c++ -python $<
	@mv $(SWIG_PYT) $(LIB_DIR)

# Shared Libraries
# ==============================

$(LIB_DIR)_alpha.so: $(SWIG_OBJ) $(COMMON_OBJS)
	@mkdir -p $(LIB_DIR)
	@$(CC) $(CC_FLAGS) -shared $(COMMON_OBJS) $(SWIG_OBJ) -o $(LIB_DIR)_alpha.so

# Compiling Standard Classes
# ==============================
# Compiling section, using VPATH = $(SRC_DIR) to allow different obj and src dirs.

$(OBJ_DIR)%.o: %.cpp %.h $(SRC_DIR)/common/Release.h
	@echo "Compling $< into $@"
	@mkdir -p $(dir $@)
	@$(CC) $(CC_FLAGS) $(CC_INCLUDES) -c $< -o $@
