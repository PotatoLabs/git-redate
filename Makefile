# Makefile for git-redate

# Package name
PACKAGE_NAME := git-redate

# Package version
PACKAGE_VERSION := 1.0.2

# Author
AUTHOR := Potato Labs

# Build directory
BUILD_DIR := build

# Source directory
SOURCE_DIR := .

# Install directory
INSTALL_DIR := /usr/local/bin

# Build artifacts
DEB_PACKAGE := $(PACKAGE_NAME)_$(PACKAGE_VERSION)_all.deb
RPM_PACKAGE := $(PACKAGE_NAME)-$(PACKAGE_VERSION).noarch.rpm

.PHONY: all clean package install uninstall

all: package

package:
	# Detect system type
	@if [ -x $$(command -v dpkg) ]; then \
		echo "Building DEB package..."; \
		mkdir -p $(BUILD_DIR)/deb/DEBIAN; \
		echo "Package: $(PACKAGE_NAME)" > $(BUILD_DIR)/deb/DEBIAN/control; \
		echo "Version: $(PACKAGE_VERSION)" >> $(BUILD_DIR)/deb/DEBIAN/control; \
		echo "Architecture: all" >> $(BUILD_DIR)/deb/DEBIAN/control; \
		echo "Maintainer: $(AUTHOR)" >> $(BUILD_DIR)/deb/DEBIAN/control; \
		echo "Depends: bash, git" >> $(BUILD_DIR)/deb/DEBIAN/control; \
		echo "Description: Change the dates of several git commits with a single command." >> $(BUILD_DIR)/deb/DEBIAN/control; \
		mkdir -p $(BUILD_DIR)/deb/usr/bin; \
		cp $(SOURCE_DIR)/$(PACKAGE_NAME) $(BUILD_DIR)/deb/usr/bin; \
		chmod +x $(BUILD_DIR)/deb/usr/bin/$(PACKAGE_NAME); \
		dpkg-deb --build $(BUILD_DIR)/deb $(BUILD_DIR)/$(DEB_PACKAGE); \
	elif [ -x $$(command -v rpm) ]; then \
		echo "Building RPM package..."; \
		mkdir -p $(BUILD_DIR)/rpm/usr/bin; \
		cp $(SOURCE_DIR)/$(PACKAGE_NAME) $(BUILD_DIR)/rpm/usr/bin; \
		chmod +x $(BUILD_DIR)/rpm/usr/bin/$(PACKAGE_NAME); \
		fpm -s dir -t rpm \
			-n $(PACKAGE_NAME) \
			-v $(PACKAGE_VERSION) \
			--iteration 1 \
			--maintainer "$(AUTHOR)" \
			--depends bash \
			--depends git \
			--description "Change the dates of several git commits with a single command." \
			-C $(BUILD_DIR)/rpm \
			usr; \
	else \
		echo "Unsupported system type!"; \
		exit 1; \
	fi

install:
	# Install the script
	cp $(SOURCE_DIR)/$(PACKAGE_NAME) $(INSTALL_DIR)/$(PACKAGE_NAME)
	chmod +x $(INSTALL_DIR)/$(PACKAGE_NAME)

uninstall:
	# Uninstall the script
	rm -f $(INSTALL_DIR)/$(PACKAGE_NAME)

clean:
	# Clean build artifacts
	rm -rf $(BUILD_DIR)
