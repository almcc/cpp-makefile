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

# Helpers
# ==============================
WD=$(shell pwd)

.PHONY: release clean

release: clean
	@mkdir -p release/

	@$(MAKE) -C source/ test docs NAME=$(NAME) MAJOR=$(MAJOR) MINOR=$(MINOR) FIX=$(FIX) LABEL=$(LABEL) BUILD=$(BUILD)
	cp -r source/rpt release/$(RELEASE)-rpt
	@cd release/; tar cvzf $(RELEASE)-rpt.tar.gz $(RELEASE)-rpt/*
	@rm -rf release/$(RELEASE)-rpt

	@$(MAKE) -C source/ dist NAME=$(NAME) MAJOR=$(MAJOR) MINOR=$(MINOR) FIX=$(FIX) LABEL=$(LABEL) BUILD=$(BUILD)
	@mkdir -p rpmbuild/SOURCES/
	@cp source/dst/* release/

	@cp source/dst/* rpmbuild/SOURCES/
	@$(MAKE) -C rpmbuild/ rpms NAME=$(NAME) MAJOR=$(MAJOR) MINOR=$(MINOR) FIX=$(FIX) LABEL=$(LABEL) BUILD=$(BUILD)
	@cp rpmbuild/RPMS/*/* release/
	@cp rpmbuild/SRPMS/* release/

clean:
	@$(MAKE) -C source/ clean
	@$(MAKE) -C rpmbuild/ clean
	@rm -rf release/