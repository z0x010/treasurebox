# Treasure Box

Treasure Box easy to install NAS that can store, organize, share and protect your photos, documents and videos.

## Goals

  - appliance-like, it just works, low maintaince and minimal tech skills required
  - up and running in 10min as simple as copy to USB and run, including upgrades
  - the common case is easy, the advanced is possible
  - preserve existing data on attached drives

## Requirements

  - A Computer, any recent PC should be fine
  - A USB Key to install TreasureBox onto
  - A network connection for your computer, with a DHCP server. Usually, this means your DSL/Cable/WiFi router.

## Use Cases

  - Apple Time Machine Backups
  - Central storage for your photos/videos
  - DNLA Media server for XBMC/Openelec/Chromecast/Smart TV
  - Manage and organize your photos/videos (TODO)
  - Your own personal Cloud (TODO)

## Install and Setup

  1. Create a USB key
    - On windows use [Live Live USB][linuxliveusb] to create a USB Key, this is easiest option
    - On linux, run dd if=treasurebox-VERSION.iso of=/dev/your/usb/drive
    - On MacOSX, use [UNetBootin][unetbootin] or diskutil and dd if you are comfortable on the command line.

  2. Boot your computer from the USB Key

  3. Tell TreasureBox which drive to use, this will *destroy* any data on the drive

        sudo tbox-format-drive /dev/sda

    See [http://  ] for instructions how to configure a drive without destroying existing data
     
  4. 
    1. (Optional) enable Time Machine Backup Service

        sudo tbox-init-timemachine

    2. Configure Time Machine on your Mac using the login of 'user' and
        password 'live'

  5. reboot your Treasure Box

        sudo reboot

  6. Access Treasure Box from other machines on your network

## SSH

You can access your treasurebox via SSH, using the password "live".

    ssh user@treasurebox.local

## Development
If you would like to improve TreasureBox please feel free to contact me,
help is appreciated.


### Experimenting

If you want to quickly test some changes or customizations you can enable developer mode,
which configures full persistence of the rootfs.

    sudo tbox-develop
    sudo reboot

After rebooting any changes you make will survive future reboots


### Building an ISO

TreasureBox uses live-build from the Debian Live Project to build images.

#### Linux (Debian/Ubuntu/Mint)
If you are running linux then you can build natively

  1. Install live-build from the externals/live-build directory.

    cd external/live-build && sudo make install

  2. Install build tools

    sudo apt-get install debootstrap syslinux

  3. make

If you run into errors you can try following the Mac OSX instructions below, which use Vagrant.

#### Mac OSX
If running OSX you can use [http:// ](Vagrant) to setup a Virtual Machine.

  1. Install Vagrant and VirtualBox
  2. Install ansible
  3. vagrant up
  4. vagrant ssh
  5. cd /mnt/src
  6. make



[linuxliveusb]: http://www.linuxliveusb.com/en/download "Linux Live USB"
[unetbootin]: http://unetbootin.sourceforge.net/ "UNetBootin"
