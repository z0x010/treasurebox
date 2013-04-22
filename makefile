
IMAGE_FILE=binary.hybrid.iso

DRIVE_FILE?=/tmp/tbox.disk
DRIVE_FILE_SIZE=1G

LB_CONFIG_FILES=$(addprefix config/, binary bootstrap chroot common source)

build: $(IMAGE_FILE)

$(LB_CONFIG_FILES): auto/config
	lb config

$(IMAGE_FILE): $(LB_CONFIG_FILES)
	mkdir -p /tmp/chroot
	ln -s /tmp/chroot chroot
	sudo lb build
	ls -lah $@

$(DRIVE_FILE):
	truncate -s $(DRIVE_FILE_SIZE) $@

.PHONY: run clean

run: $(IMAGE_FILE) $(DRIVE_FILE)
	kvm -cdrom binary.hybrid.iso -hda $(DRIVE_FILE)

clean:
	sudo lb clean
