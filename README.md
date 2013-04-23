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
    - On windows use _linuxliveusb to create a USB Key, this is easiest
    - On linux, run dd if=TreasureBox-VERSION.iso of=/dev/your/usb/drive
  2. Boot your computer from the USB Key
  3. Tell TreasureBox which drive to use, this will *destroy* any data on the drive

        mkfs.ext4 -L tbox-storage /dev/drive  # often /dev/sda

  4. reboot and use another computer to access your TreasureBox


.. _linuxliveusb: http://www.linuxliveusb.com/en/download
