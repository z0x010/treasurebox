# Build and test Treasurebox Images
#
#
# Under Vagrant we split build and src directories, to ansure we build wihtin the local fs
#  - trying to build on the network mounted src will fail due to unsupoorted operations
#
#

# You may want to override these settings using environment vars
VM_DRIVE_FILE?=/tmp/tbox.disk
VM_DRIVE_SIZE?=1G
VM_NAME?=tbtest
VM_MAC?="DE:AD:BE:EF:7B:04"


#
# You shouldn't need to change anything below here
#

# handle split src/build dir

VERSION_CMD:=git describe --tags --always --dirty

ifeq ($(USER), vagrant)
SRC_DIR=/mnt/src/
VERSION=$(shell cd $(SRC_DIR) && $(VERSION_CMD))
else
VERSION=$(shell $(VERSION_CMD))
endif
ifdef TRAVIS_TAG
VERSION=$(TRAVIS_TAG)
endif

VERSION_FILE=config/includes.chroot/etc/treasurebox_version
IMAGE_FILE?=$(SRC_DIR)treasurebox-$(VERSION).iso
BINARY_ISO=binary.hybrid.iso

LB_CONFIG_FILES=$(addprefix config/, binary bootstrap chroot common source)
LB_CONFIG_EXTRAS+=$(wildcard config/package-lists/*)
LB_CONFIG_EXTRAS+=$(wildcard config/hooks/*)
LB_CONFIG_EXTRAS+=$(wildcard config/includes.chroot/*/*)

.PHONY: run clean

rebuild: $(LB_CONFIG_FILES) $(LB_CONFIG_EXTRAS)
	$(MAKE) clean
	$(MAKE) $(IMAGE_FILE)

build: $(IMAGE_FILE)

$(LB_CONFIG_FILES): auto/config
	lb config

$(BINARY_ISO) $(VERSION_FILE): $(LB_CONFIG_FILES)
	echo $(VERSION) > $(VERSION_FILE)
	time sudo lb build

$(IMAGE_FILE): $(BINARY_ISO)
	sudo install --owner $(USER) $< $@
ifdef SRC_DIR
	cd $(SRC_DIR) && ln -sf $(notdir $@) $(BINARY_ISO)
endif
	ls -lah $@

$(VM_DRIVE_FILE):
	truncate -s $(VM_DRIVE_SIZE) $@


kvm: $(BINARY_ISO) $(VM_DRIVE_FILE)
	kvm -cdrom $(BINARY_ISO) -hda $(VM_DRIVE_FILE) -net nic,macaddr=$(VM_MAC) -net tap,script=/usr/bin/qemu-ifup

vbox: $(BINARY_ISO)
	VBoxManage startvm $(VM_NAME)

vbox-create:
	./vbox-create.sh $(VM_NAME)

vbox-destroy:
	-VBoxManage controlvm $(VM_NAME) poweroff
	VBoxManage unregistervm $(VM_NAME) --delete
	rm -f $(VM_NAME).vdi

usb: $(BINARY_ISO)
	@if [ -z "$(DEV)" ]; then \
		echo "no DEV defined; make dev DEV=/dev/????"; \
		diskutil list; \
		exit 1; \
	fi
	diskutil unmountDisk $(DEV)
#	sudo dd if=$(IMAGE_FILE) of=$(DEV) conv=fsync bs=1m
	sudo dd if=$< of=$(DEV) bs=1m
	diskutil eject $(DEV)

update:
	ansible-playbook -i ansible/host ansible/sync.yml

clean:
	sudo lb clean

help:
	@echo "rebuild			clean and build iso image"
	@echo "usb DEV=/dev/XXXX	write image to DEV"
