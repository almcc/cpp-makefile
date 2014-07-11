# Release Settings
# ==============================
MAJOR = 0
MINOR = 1
FIX = 0
LABEL = dev
BUILD = 1
VERSION = $(MAJOR).$(MINOR).$(FIX)
RELEASE = alpha-$(VERSION)-$(LABEL)$(BUILD)

# Helpers
# ==============================
WD=$(shell pwd)

.PHONY: release clean

release: clean
	@mkdir -p release/

	@$(MAKE) -C source/ test docs MAJOR=$(MAJOR) MINOR=$(MINOR) FIX=$(FIX) LABEL=$(LABEL) BUILD=$(BUILD)
	@cp -r source/rpt release/$(RELEASE)-rpt
	@cd release/; tar cvzf $(RELEASE)-rpt.tar.gz $(RELEASE)-rpt/*
	@rm -rf release/$(RELEASE)-rpt

	@$(MAKE) -C source/ dist MAJOR=$(MAJOR) MINOR=$(MINOR) FIX=$(FIX) LABEL=$(LABEL) BUILD=$(BUILD)
	@mkdir -p rpmbuild/SOURCES/
	@cp source/dst/* release/

	@$(MAKE) -C puppet/ dist MAJOR=$(MAJOR) MINOR=$(MINOR) FIX=$(FIX) LABEL=$(LABEL) BUILD=$(BUILD)
	@mkdir -p rpmbuild/SOURCES/
	@cp puppet/dst/* release/

	@$(MAKE) -C sphinx/ dist MAJOR=$(MAJOR) MINOR=$(MINOR) FIX=$(FIX) LABEL=$(LABEL) BUILD=$(BUILD)
	@mkdir -p rpmbuild/SOURCES/
	@cp sphinx/dst/* release/

	@cp source/dst/* rpmbuild/SOURCES/
	@cp puppet/dst/* rpmbuild/SOURCES/
	@cp sphinx/dst/* rpmbuild/SOURCES/
	@$(MAKE) -C rpmbuild/ rpms MAJOR=$(MAJOR) MINOR=$(MINOR) FIX=$(FIX) LABEL=$(LABEL) BUILD=$(BUILD)
	@cp rpmbuild/RPMS/*/* release/
	@cp rpmbuild/SRPMS/* release/

	@ls -hl release/

clean:
	@$(MAKE) -C source/ clean
	@$(MAKE) -C puppet/ clean
	@$(MAKE) -C rpmbuild/ clean
	@$(MAKE) -C sphinx/ clean
	@rm -rf release/