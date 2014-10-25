#!/bin/sh

set -e

VM_NAME=$1
VM_ISO_IMAGE=$2

VBoxManage createvm --name "$VM_NAME" --register
VBoxManage modifyvm "$VM_NAME" --memory 512 --acpi on --boot1 dvd
VBoxManage modifyvm "$VM_NAME" --nic1 bridged --bridgeadapter1 en0
VBoxManage modifyvm "$VM_NAME" --macaddress1 auto
VBoxManage modifyvm "$VM_NAME" --ostype Debian
VBoxManage storagectl "$VM_NAME" --name "IDE Controller" --add ide

VBoxManage storageattach "$VM_NAME" --storagectl "IDE Controller"  \
    --port 0 --device 0 --type hdd --medium ./$VM_NAME.vdi

VBoxManage storageattach "$VM_NAME" --storagectl "IDE Controller" \
    --port 1 --device 0 --type dvddrive --medium binary.hybrid.iso
