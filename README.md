# Treasure Box

Treasure Box is a simple to use NAS that helps store, organize share and protect your data: photos, documents, videos, backups.


## Goals

  - appliance-like, just works, low maintaince
  - copy to USB and run, including upgrades
  - satisfy the common case, not every case


## Requirements

  - DHCP server on the network, usually your internet router
  - USB Key to install TreasureBox onto
  - A Computer with hard disk, any recent PC should be fine

## Install

  1. Create a USB key
    - On windows use [Live Live USB][linuxliveusb] to create a USB Key, this is easiest option
    - On linux, run dd if=TreasureBox-VERSION.iso of=/dev/your/usb/drive
  2. Boot your computer from the USB Key
  3. Tell TreasureBox which drive to use, this will *destroy* any data on the drive

        sudo mkfs.ext4 -L tbox-storage /dev/drive  # often /dev/sda
        sudo mount /shares
        sudo tbox-init-drive

  4. reboot and use another computer to access your TreasureBox

        sudo reboot

## Development

# Building an Image

TreasureBox uses live-build from the Debian Live Project to build images.
You can install live-build from the externals/live-build directory.

	cd external/live-build && sudo make install

You will also need some build tools::

	sudo apt-get install debootstrap syslinux

If you would like to work on TreasureBox please feel free to contact me, any
help would be appreciated.
If you want a new feature adding it might be a good idea to discuss it with
me before working on it.
To keep TreasureBox simple I'm going to be very careful about adding new
features.
I value your time and don't want to reject your hard work simply because it didn't fit well with the goals of the project.

To iterate more quickly than constantly building new images you can test changes by your device by enabling persistence.

    sudo tbox-develop
    sudo reboot

[linuxliveusb]: http://www.linuxliveusb.com/en/download "Linux Live USB"
