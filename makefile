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

ifeq ($(USER), vagrant)
SRC_DIR=/mnt/src/
else
SRC_DIR=
endif

ifdef TRAVIS_TAG
VERSION=-$(TRAVIS_TAG)
else
VERSION=-$(shell cd $(SRC_DIR) && git describe --tags --always --dirty)
endif

IMAGE_FILE?=$(SRC_DIR)treasurebox$(VERSION).iso

BINARY_ISO=binary.hybrid.iso
LB_CONFIG_FILES=$(addprefix config/, binary bootstrap chroot common source)
LB_CONFIG_EXTRAS+=$(wildcard config/package-lists/*)
LB_CONFIG_EXTRAS+=$(wildcard config/hooks/*)
LB_CONFIG_EXTRAS+=$(wildcard config/includes.chroot/*/*)


rebuild: $(LB_CONFIG_FILES) $(LB_CONFIG_EXTRAS)
	$(MAKE) clean
	$(MAKE) $(IMAGE_FILE)

build: $(IMAGE_FILE)

$(LB_CONFIG_FILES): auto/config
	lb config

$(BINARY_ISO): $(LB_CONFIG_FILES)
	time sudo lb build

ifdef SRC_DIR
$(SRC_DIR)$(BINARY_ISO): $(BINARY_ISO)
	sudo install --owner $(USER) $< $@
endif

$(IMAGE_FILE): $(SRC_DIR)$(BINARY_ISO)
	sudo install --owner $(USER) $< $@
	ls -lah $@

$(VM_DRIVE_FILE):
	truncate -s $(VM_DRIVE_SIZE) $@

.PHONY: run clean

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

usb: $(IMAGE_FILE)
	@if [ -z "$(DEV)" ]; then \
		echo "no DEV defined"; \
		diskutil list; \
		exit 1; \
	fi
	diskutil unmountDisk $(DEV)
#	sudo dd if=$(IMAGE_FILE) of=$(DEV) conv=fsync bs=1m
	sudo dd if=$(IMAGE_FILE) of=$(DEV) bs=1m
	diskutil unmountDisk $(DEV)

update:
	rsync -av config/includes.chroot/etc user@treasurebox.local:
	ssh user@treasurebox.local 'sudo cp -rv etc/* /etc && sudo reboot'

clean:
	sudo lb clean

help:
	@echo "rebuild			clean and build iso image"
	@echo "usb DEV=/dev/XXXX	write image to DEV"
