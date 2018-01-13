#!/bin/bash

rm -R /tmp/kernel-build
mkdir -p /tmp/kernel-build
cp mvsas.patch /tmp/kernel-build
cd /tmp/kernel-build

apt-get -t stretch source linux-image-$(uname -r)
apt-get -y install linux-headers-$(uname -r)

cd $(find -type d -name 'linux-*')
quilt push -a
cp /boot/config-$(uname -r) .config
cp /usr/src/linux-headers-$(uname -r)/Module.symvers .
make modules_prepare

patch -p0 < ../mvsas.patch

make M=drivers/scsi/mvsas

cp drivers/scsi/mvsas/mvsas.ko /lib/modules/$(uname -r)/kernel/drivers/scsi/mvsas/mvsas.ko
modprobe mvsas