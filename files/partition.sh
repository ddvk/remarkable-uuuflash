#!/bin/sh

# License: CC-BY-SA
# Copyright 'user2070305' --  http://superuser.com/a/984637

DEVICE="$1"

# to create the partitions programatically (rather than manually)
# we're going to simulate the manual input to fdisk
# The sed script strips off all the comments so that we can
# document what we're doing in-line with the actual commands
# Note that a blank line (commented as "defualt" will send a empty
# line terminated with a newline to take the fdisk default.
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk "${DEVICE}"
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk
  +20M # 20 MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
  +250M # 250 MB root parttion
  n # new partition
  p # primary partition
  3 # partion number 3
    # default, start immediately after preceding partition
  +250M # 250 MB root parttion
  n # new partition
  e # extended partition
  4 # partion number 4
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  n # new partition
    # default, start immediately after preceding partition
  +20M # 20MB /etc
  n # new partition
    # default, start immediately after preceding partition
  +20M # 20MB /var
  n # new partition
    # default, start immediately after preceding partition
    # default, extend partition to end of disk, /home
  a # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/mmcblk1p1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF
