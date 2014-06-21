# Release Settings
# ==============================
NAME = alpha
MAJOR = 0
MINOR = 1
FIX = 0
LABEL = dev
BUILD = 1
VERSION = $(MAJOR).$(MINOR).$(FIX)
RELEASE = $(NAME)-$(VERSION)-$(LABEL)$(BUILD)

# Directories
# ==============================

SRC_DIR = src/
TST_DIR = tst/
OBJ_DIR = obj/
BIN_DIR = bin/
LIB_DIR = lib/
DST_DIR = dst/
RPT_DIR = rpt/

VPATH = $(SRC_DIR) $(TST_DIR)

# Compiler Settings
# ==============================

CC = g++
CC_INCLUDES = -I$(SRC_DIR)common/ \
              -I$(TST_DIR)common/
CC_FLAGS = -g -Wall -fPIC
LK_FLAGS =

lcov-html: CC_FLAGS = -g -Wall -fPIC --coverage
lcov-html: LK_FLAGS = --coverage

# (Required) Libraries
# ==============================

LIB_INC = -L/usr/lib -L/usr/lib64
SHARED_LIBS =
STATIC_LIBS =

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

APP_OBJS = $(COMMON_OBJS) $(OBJ_DIR)mains/$(NAME)-main.o

# Tests
# ==============================

TEST_SRCS = $(shell for file in `find $(TST_DIR)common -name *.h`; do echo $$file; done)


# Targets
# ==============================

.PHONY : help all fresh clean-cpp clean cppunit cppcheck cppunit-xml cppcheck-xml lcov-html cppcheck-html install uninstall dist

help:
	@echo "Makefile targerts"
	@echo "-----------------"
	@echo "make all             Builds all the binaries."
	@echo "make fresh           Equivalient to 'make clean all'."
	@echo "make clean-cpp       Removes all compiles cpp artifacts."
	@echo "make clean           Removes all none source files."
	@echo "make cppunit         Makes and runs the cppunit executable, outputs a text file and cats to screen."
	@echo "make cppcheck        Runs cppcheck over code, outputs a text file and cats to screen."
	@echo "make cppunit-xml     Makes and runs the cppunit executable, outputs an xml file, also translates to xunit style xml."
	@echo "make cppcheck-xml    Runs cppcheck over code, outputs an xml file."
	@echo "make lcov-html       Runs a line coverage report and generates an HTML report."
	@echo "make cppcheck-html   Runs cppcheck over code and generates an HTML report."
	@echo "make install         Installs files, base directory defined by DESTDIR variable."
	@echo "make uninstall       Un-installs all files, base directory defined by DESTDIR variable."
	@echo "make dist            Makes a tar.gz file for distribution."
	@echo ""
	@echo "Scripts"
	@echo "-------"
	@echo "python build.py      Use to set new version/release label and build a distribution."

all: $(BIN_DIR)$(NAME)

fresh: clean all

clean-cpp:
	@echo "Cleaning CPP atrifacts."
	@rm -rf $(OBJ_DIR)
	@rm -rf $(BIN_DIR)
	@rm -rf $(DST_DIR)
	@rm -rf $(LIB_DIR)
	@rm -f $(SRC_DIR)/common/Release.h
	@rm -rf tst/runners/

clean: clean-cpp
	@echo "Cleaning everything else."
	@rm -rf $(RPT_DIR)

# Unit testing (CxxTest)
# ==============================

cxxtest: tst/runners/runner.cpp $(COMMON_OBJS)
	@mkdir -p bin/
	@$(CC) $(CC_FLAGS) $(CC_INCLUDES) $(COMMON_OBJS) -o bin/runner tst/runners/runner.cpp

tst/runners/runner.cpp: $(TEST_SRCS)
	@mkdir -p tst/runners/
	@cxxtestgen --error-printer -o tst/runners/runner.cpp $(TEST_SRCS)

lcov-html: clean-cpp cxxtest
	@./bin/runner
	@mkdir -p $(RPT_DIR)
	lcov --base-directory . --directory . --capture --output-file $(RPT_DIR)cppunit-coverage.info
	lcov --remove $(RPT_DIR)cppunit-coverage.info  "/usr*" -o $(RPT_DIR)cppunit-coverage.info
	lcov --remove $(RPT_DIR)cppunit-coverage.info  "tst/*" -o $(RPT_DIR)cppunit-coverage.info
	genhtml $(RPT_DIR)cppunit-coverage.info --output-directory $(RPT_DIR)cppunit-coverage-html

# Static analysis
# ==============================

cppcheck:
	@mkdir -p $(RPT_DIR)
	@cppcheck --quiet --enable=all --suppress=missingInclude -I$(SRC_DIR)common/ $(SRCS) $(HEADERS) 2> $(RPT_DIR)cppcheck-results.txt
	@cat $(RPT_DIR)cppcheck-results.txt

cppcheck-xml:
	@mkdir -p $(RPT_DIR)
	@cppcheck --quiet --enable=all --xml --suppress=missingInclude -I$(SRC_DIR)common/ $(SRCS) $(HEADERS) 2> $(RPT_DIR)cppcheck-results.xml

cppcheck-html: cppcheck-xml
	@mkdir -p $(RPT_DIR)
	utils/cppcheck-htmlreport --file=$(RPT_DIR)cppcheck-results.xml --report-dir=$(RPT_DIR)cppcheck-results-html --source-dir=.

# Installing & releasing
# ==============================

install: all
	@echo "Installing to $(DESTDIR)"
	mkdir -p $(DESTDIR)/usr/local/bin/
	cp -p $(BIN_DIR)$(NAME) $(DESTDIR)/usr/local/bin/

uninstall:
	@echo "Uninstalling from $(DESTDIR)"
	rm -rf $(DESTDIR)/opt/$(NAME)/$(NAME)
	rm -rf $(DESTDIR)/etc/$(NAME)
	rm -rf $(DESTDIR)/etc/init.d/$(NAME)

dist:
	@echo "Making distribution"
	@mkdir -p $(DST_DIR)
	@mkdir -p $(RELEASE)/
	@cp -r $(SRC_DIR)/ $(RELEASE)/
	@cp -r $(SYS_DIR)/ $(RELEASE)/
	@cp -r Makefile $(RELEASE)/
	@tar cvzf $(DST_DIR)/$(RELEASE)-dist.tar.gz $(RELEASE)/*
	@rm -rf $(RELEASE)/

# Making release header file
# ==============================
$(SRC_DIR)/common/Release.h:
	@echo '#ifndef Release_H' > $(SRC_DIR)/common/Release.h
	@echo '#define Release_H' >> $(SRC_DIR)/common/Release.h
	@echo '' >> $(SRC_DIR)/common/Release.h
	@echo '#include <string>' >> $(SRC_DIR)/common/Release.h
	@echo '' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string NAME = "$(NAME)";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string MAJOR = "$(MAJOR)";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string MINOR = "$(MINOR)";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string FIX = "$(FIX)";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string LABEL = "$(LABEL)";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string BUILD = "$(BUILD)";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string VERSION = "$(VERSION)";' >> $(SRC_DIR)/common/Release.h
	@echo 'const std::string RELEASE = "$(RELEASE)";' >> $(SRC_DIR)/common/Release.h
	@echo '' >> $(SRC_DIR)/common/Release.h
	@echo '#endif' >> $(SRC_DIR)/common/Release.h

# Linking
# ==============================

$(BIN_DIR)$(NAME): $(APP_OBJS)
	@echo "Linking APP_OBJS into $@"
	@mkdir -p $(dir $@)
	@$(CC) $(LK_FLAGS) $(APP_OBJS) $(LIB_INC) -Wl,-Bstatic $(STATIC_LIBS) -Wl,-Bdynamic $(SHARED_LIBS) -Wl,--as-needed -o $@

# Compiling Mains
# ==============================
# Compiling mains separately as there is no header file for main files.

$(OBJ_DIR)mains/$(NAME)-main.o: $(SRC_DIR)mains/$(NAME)-main.cpp $(SRC_DIR)/common/Release.h
	@echo "Compling $< into $@"
	@mkdir -p $(dir $@)
	@$(CC) $(CC_FLAGS) $(CC_INCLUDES) -c $< -o $@

# Compiling Standard Classes
# ==============================
# Compiling section, using VPATH = $(SRC_DIR) to allow different obj and src dirs.

$(OBJ_DIR)%.o: %.cpp %.h $(SRC_DIR)/common/Release.h
	@echo "Compling $< into $@"
	@mkdir -p $(dir $@)
	@$(CC) $(CC_FLAGS) $(CC_INCLUDES) -c $< -o $@
