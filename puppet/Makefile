# Release Settings
# ==============================
MAJOR = 0
MINOR = 1
FIX = 0
LABEL = dev
BUILD = 1
VERSION = $(MAJOR).$(MINOR).$(FIX)
RELEASE = alpha-puppet-$(VERSION)-$(LABEL)$(BUILD)

# Helpers
# ==============================
WD=$(shell pwd)

# Directories
# ==============================
DST_DIR = dst/

.PHONY: clean dist

clean:
	@rm -rf $(DST_DIR)

dist: clean
	@echo "Making distribution"
	@mkdir -p $(DST_DIR)
	@mkdir -p $(RELEASE)/
	@cp -r alpha-setup/ $(RELEASE)/
	@cp -r alpha-devel/ $(RELEASE)/
	@cp -r Makefile $(RELEASE)/
	@tar cvzf $(DST_DIR)/$(RELEASE)-dist.tar.gz $(RELEASE)/*
	@rm -rf $(RELEASE)/

install:
	@echo "Installing to $(DESTDIR)"
	mkdir -p $(DESTDIR)/etc/puppet/modules/
	cp -r alpha-setup/ $(DESTDIR)/etc/puppet/modules/
	cp -r alpha-devel/ $(DESTDIR)/etc/puppet/modules/

uninstall:
	@echo "Uninstalling from $(DESTDIR)"
	rm -rf $(DESTDIR)/etc/puppet/modules/alpha-setup/
	rm -rf $(DESTDIR)/etc/puppet/modules/alpha-devel/
