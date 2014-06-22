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

CC_FLAGS = -g -Wall -Weffc++
LK_FLAGS =
lcov: CC_FLAGS = -g -Wall -Weffc++ --coverage
lcov: LK_FLAGS = --coverage

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

.PHONY : all fresh clean-cpp clean test cxxtest lcov cppcheck vera cpplint install uninstall dist

all: $(BIN_DIR)$(NAME)

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
	@rm -rf $(RPT_DIR)
	@rm -f $(TST_XML_OUT)

test: lcov cxxtest cppcheck vera cpplint

# Unit testing (CxxTest)
# ==============================

cxxtest: $(TST_RUNNER_BIN)
	@mkdir -p $(RPT_DIR)/cxxtest-html/
	@$(TST_RUNNER_BIN)
	@mv $(TST_XML_OUT) $(RPT_DIR)
	@xsltproc utils/xunit-to-html.xslt $(RPT_DIR)$(TST_XML_OUT) > $(RPT_DIR)/cxxtest-html/index.html
	@cp utils/jquery.min.js $(RPT_DIR)/cxxtest-html/

lcov: clean-cpp $(TST_RUNNER_BIN)
	@$(TST_RUNNER_BIN)
	@mkdir -p $(RPT_DIR)
	@lcov --base-directory . --directory . --capture --output-file $(RPT_DIR)coverage.info
	@lcov --remove $(RPT_DIR)coverage.info  "/usr*" -o $(RPT_DIR)coverage.info
	@lcov --remove $(RPT_DIR)coverage.info  "tst/*" -o $(RPT_DIR)coverage.info
	@genhtml $(RPT_DIR)coverage.info --output-directory $(RPT_DIR)coverage-html

# Static analysis
# ==============================

cppcheck: $(SRC_DIR)/common/Release.h
	@mkdir -p $(RPT_DIR)
	@rm -rf $(RPT_DIR)cppcheck-html
	@cppcheck --quiet --enable=all --xml --suppress=missingIncludeSystem $(CC_INCLUDES) $(SRCS) $(HEADERS) 2> $(RPT_DIR)cppcheck.xml
	@utils/cppcheck-htmlreport --file=$(RPT_DIR)cppcheck.xml --report-dir=$(RPT_DIR)cppcheck-html --source-dir=.

vera: $(SRC_DIR)/common/Release.h
	@mkdir -p $(RPT_DIR)
	@rm -f $(RPT_DIR)vera.txt
	@vera++ -rule F001 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Source files should not use the '\r' (CR) character
	@vera++ -rule F002 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # File names should be well-formed
	@vera++ -rule L001 -param strict-trailing-space=0 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # No trailing whitespace
	@vera++ -rule L002 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Don't use tab characters
	@vera++ -rule L003 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # No leading and no trailing empty lines
	@vera++ -rule L004 -param max-line-length=$(MAX_LINE_LENGHT) $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Line cannot be too long
	@vera++ -rule L005 -param max-consecutive-empty-lines=2 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # There should not be too many consecutive empty lines
	@vera++ -rule L006 -param max-file-length=1000 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Source file should not be too long
	@vera++ -rule T001 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # One-line comments should not have forced continuation
	@vera++ -rule T002 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Reserved names should not be used for preprocessor macros
	@vera++ -rule T003 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Some keywords should be followed by a single space
	@vera++ -rule T004 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Some keywords should be immediately followed by a colon
	@vera++ -rule T005 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Keywords break and continue should be immediately followed by a semicolon
	@vera++ -rule T006 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Keywords return and throw should be immediately followed by a semicolon or a single space
	@vera++ -rule T007 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Semicolons should not be isolated by spaces or comments from the rest of the code
	@vera++ -rule T008 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Keywords catch, for, if, switch and while should be followed by a single space
	@vera++ -rule T009 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Comma should not be preceded by whitespace, but should be followed by one
	@vera++ -rule T010 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Identifiers should not be composed of 'l' and 'O' characters only
	@vera++ -rule T011 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Curly brackets from the same pair should be either in the same line or in the same column
	@vera++ -rule T012 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Negation operator should not be used in its short form
	@vera++ -rule T017 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Unnamed namespaces are not allowed in header files
	@vera++ -rule T018 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Using namespace is not allowed in header files
	@vera++ -rule T019 $(SRCS) $(HEADERS) $(TST_SRCS) 2>> $(RPT_DIR)vera.txt # Control structures should have complete curly-braced block of code
	@cat $(RPT_DIR)vera.txt
	
cpplint:
	@mkdir -p $(RPT_DIR)
	@rm -f $(RPT_DIR)cpplint.txt
	@-utils/cpplint.py --extensions=h,cpp \
	                  --linelength=$(MAX_LINE_LENGHT) \
	                  --filter=-legal,-whitespace/braces \
	                  $(SRCS) $(HEADERS) $(TST_SRCS) 2> $(RPT_DIR)cpplint.txt

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
	@echo '#ifndef SRC_COMMON_RELEASE_H_' > $(SRC_DIR)/common/Release.h
	@echo '#define SRC_COMMON_RELEASE_H_' >> $(SRC_DIR)/common/Release.h
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
	@echo '#endif  // SRC_COMMON_RELEASE_H_' >> $(SRC_DIR)/common/Release.h

# Linking
# ==============================

$(BIN_DIR)$(NAME): $(APP_OBJS)
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

$(OBJ_DIR)mains/$(NAME)-main.o: $(SRC_DIR)mains/$(NAME)-main.cpp $(SRC_DIR)/common/Release.h
	@echo "Compling $< into $@"
	@mkdir -p $(dir $@)
	@$(CC) $(CC_FLAGS) $(CC_INCLUDES) -c $< -o $@

# Compiling Runners
# ==============================

$(TST_RUNNER_OBJ): $(TST_RUNNER_SRC)
	@echo "Compling $< into $@"
	@mkdir -p $(dir $@)
	@$(CC) -g --coverage $(CC_INCLUDES) -c $< -o $@

# Compiling Standard Classes
# ==============================
# Compiling section, using VPATH = $(SRC_DIR) to allow different obj and src dirs.

$(OBJ_DIR)%.o: %.cpp %.h $(SRC_DIR)/common/Release.h
	@echo "Compling $< into $@"
	@mkdir -p $(dir $@)
	@$(CC) $(CC_FLAGS) $(CC_INCLUDES) -c $< -o $@

