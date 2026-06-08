PLIST := com.nguyenvukhang.heliumd.plist
DAEMON_DIR := /Library/LaunchAgents
ARCH := arm64

build:
	bash scripts/build.sh xcodebuild -project heliumd.xcodeproj \
		-scheme heliumd \
		-configuration Release \
		-archivePath build \
		-destination platform=macOS,arch=$(ARCH) \
		archive

install-bin: build
	sudo cp build.xcarchive/Products/usr/local/bin/heliumd /usr/local/bin/heliumd

load: install-bin unload
	sudo cp $(PLIST) $(DAEMON_DIR)/$(PLIST)
	launchctl load -w $(DAEMON_DIR)/$(PLIST)

unload:
	launchctl unload $(DAEMON_DIR)/$(PLIST)

.PHONY: build
