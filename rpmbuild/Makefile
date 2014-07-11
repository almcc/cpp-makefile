# Release Settings
# ==============================
MAJOR = x
MINOR = x
FIX = x
LABEL = dev
BUILD = x
VERSION = $(MAJOR).$(MINOR).$(FIX)
RELEASE = alpha-$(VERSION)-$(LABEL)$(BUILD)

# Helpers
# ==============================
WD=$(shell pwd)

# Targets
# ==============================
.PHONY: rpms clean

rpms:
	@rpmbuild --define '_topdir $(WD)' --clean -ba SPECS/alpha.spec  --define 'version $(VERSION)' \
	                                                                 --define 'release_label $(LABEL)$(BUILD)'
	@rpmbuild --define '_topdir $(WD)' --clean -bb SPECS/alpha-puppet.spec  --define 'version $(VERSION)' \
	                                                                        --define 'release_label $(LABEL)$(BUILD)'
	@rpmbuild --define '_topdir $(WD)' --clean -bb SPECS/alpha-sphinx.spec  --define 'version $(VERSION)' \
	                                                                        --define 'release_label $(LABEL)$(BUILD)'

clean:
	@rm -rf BUILD
	@rm -rf BUILDROOT
	@rm -rf RPMS
	@rm -rf SOURCES
	@rm -rf SRPMS
