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

## Use Cases

  - Media server for XBMC/Openelec
  - Store Apple Time Machine Backups
  - General Purpose File Server NFS/Samba

## Install

  1. Create a USB key
    - On windows use [Live Live USB][linuxliveusb] to create a USB Key, this is easiest option
    - On linux, run dd if=TreasureBox-VERSION.iso of=/dev/your/usb/drive
    - On MacOSX, use Unetbootin
  2. Boot your computer from the USB Key
  3. Tell TreasureBox which drive to use, this will *destroy* any data on the drive

        sudo mkfs.ext4 -L tbox-storage /dev/drive  # often /dev/sda
        sudo mount /shares
        sudo tbox-init-drive

  4. (Optional) enable use as a Time Machine Backup

        sudo tbox-init-timemachine

    Then configure Time Machine on your Mac using the login of 'user' and
    password 'live'

  5. reboot and use another computer to access your TreasureBox

        sudo reboot

## Development

# SSH

You can access your treasurebox via SSH, using the password "live".

    ssh user@treasurebox.local

# Experimenting

To iterate more quickly than constantly building new images you can test changes by your device by enabling persistence.

    sudo tbox-develop
    sudo reboot

After rebooting any changes you make will survive future reboots


# Building an Image

TreasureBox uses live-build from the Debian Live Project to build images.
You can install live-build from the externals/live-build directory.

	cd external/live-build && sudo make install

You will also need some build tools::

	sudo apt-get install debootstrap syslinux

If you would like to work on TreasureBox please feel free to contact me, any
help would be appreciated.

[linuxliveusb]: http://www.linuxliveusb.com/en/download "Linux Live USB"
