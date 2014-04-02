IMAGE_FILE=binary.hybrid.iso

VM_DRIVE_FILE?=/tmp/tbox.disk
VM_DRIVE_SIZE=1G
VM_MAC?="DE:AD:BE:EF:7B:04"

LB_CONFIG_FILES=$(addprefix config/, binary bootstrap chroot common source)
LB_CONFIG_EXTRAS+=$(wildcard config/package-lists/*)
LB_CONFIG_EXTRAS+=$(wildcard config/hooks/*)
LB_CONFIG_EXTRAS+=$(wildcard config/includes.chroot/*/*)

build: $(IMAGE_FILE)

$(LB_CONFIG_FILES): auto/config
	lb config

$(IMAGE_FILE): $(LB_CONFIG_FILES)
	time sudo lb build
	ls -lah $@

rebuild: $(LB_CONFIG_FILES) $(LB_CONFIG_EXTRAS)
	$(MAKE) clean
	$(MAKE) build

$(VM_DRIVE_FILE):
	truncate -s $(VM_DRIVE_SIZE) $@

.PHONY: run clean

run: $(IMAGE_FILE) $(VM_DRIVE_FILE)
	kvm -cdrom binary.hybrid.iso -hda $(VM_DRIVE_FILE) -net nic,macaddr=$(VM_MAC) -net tap,script=/usr/bin/qemu-ifup

usb: $(IMAGE_FILE)
	@if [ -z "$(DEV)" ]; then echo "no DEV defined"; exit 1; fi
	diskutil unmountDisk $(DEV)
#	sudo dd if=$(IMAGE_FILE) of=$(DEV) conv=fsync bs=1m
	sudo dd if=$(IMAGE_FILE) of=$(DEV) bs=1m
	diskutil unmountDisk $(DEV)

update:
	rsync -av config/includes.chroot/etc user@treasurebox.local:
	ssh user@treasurebox.local 'sudo cp -rv etc/* /etc && sudo reboot'

clean:
	sudo lb clean
