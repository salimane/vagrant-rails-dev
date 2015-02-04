#!/bin/sh

set -e
set -x

if [ -f /etc/disk_added_date ]
then
   echo "disk already added so exiting."
   exit 0
fi

[[ `pvs /dev/sdb` ]] || pvcreate /dev/sdb
vgextend VolGroup /dev/sdb
lvextend --size $1G /dev/VolGroup/lv_root
resize2fs /dev/VolGroup/lv_root
lvextend --size $2G /dev/VolGroup/lv_swap
swapoff -a
mkswap /dev/VolGroup/lv_swap
swapon -a


date > /etc/disk_added_date
