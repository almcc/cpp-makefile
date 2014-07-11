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
.PHONY: robot clean

robot: clean
	pybot -M Release:$(RELEASE) -r $(RELEASE)-robot-report.html -l $(RELEASE)-robot-log.html tests/

clean:
	@rm -f output.xml
	@rm -f *log.html
	@rm -f *report.html