IMAGE_FILE=binary.hybrid.iso

VM_DRIVE_FILE?=/tmp/tbox.disk
VM_DRIVE_FILE_SIZE=1G

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
	truncate -s $(DRIVE_FILE_SIZE) $@

.PHONY: run clean

run: $(IMAGE_FILE) $(VM_DRIVE_FILE)
	kvm -cdrom binary.hybrid.iso -hda $(VM_DRIVE_FILE) -net nic,model=virtio -net user,hostfwd=tcp::2222-:22

clean:
	sudo lb clean
