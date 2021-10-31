#!/usr/bin/env bash
#-------------------------------------------------------------------------
#    █████╗ ██████╗  ██████╗██╗  ██╗ ██████╗ ████████╗
#   ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔═══██╗╚══██╔══╝
#   ███████║██████╔╝██║     ███████║██║   ██║   ██║   
#   ██╔══██║██╔══██╗██║     ██╔══██║██║▄▄ ██║   ██║   
#   ██║  ██║██║  ██║╚██████╗██║  ██║╚██████╔╝   ██║   
#   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚══▀▀═╝    ╚═╝   
#-------------------------------------------------------------------------

# setting up variables from arguments
iso=$1
formatdisk=$2
disk=$3

echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download          "
echo "-------------------------------------------------"

# ask if it should use the most efficient mirror based on the current iso or set custom country
timedatectl set-ntp true
pacman -S --noconfirm pacman-contrib terminus-font
setfont ter-v22b
sed -i 's/^#Para/Para/' /etc/pacman.conf
pacman -S --noconfirm reflector rsync
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
reflector -c $iso -f 5 -l 10 --sort rate --save /etc/pacman.d/mirrorlist
mkdir /mnt

echo -e "\nInstalling prereqs...\n$HR"
pacman -S --noconfirm gptfdisk btrfs-progs

echo "-------------------------------------------------"
echo "-------select your disk to format----------------"
echo "-------------------------------------------------"

case $formatdisk in
y|Y|yes|Yes|YES)
echo "--------------------------------------"
echo -e "\nFormatting disk...\n$HR"
echo "--------------------------------------"

  # i need to check if the system has UEFI enabled, if it does install with GPT partition table type, else just use MBR
  if test -f "/sys/firmware/efi/efivars"; then

    # INSTALL WITH GPT
    echo "The system has UEFI enabled, will install with GPT"

    # disk prep
    sgdisk -Z ${DISK} # zap all on disk
    #dd if=/dev/zero of=${DISK} bs=1M count=200 conv=fdatasync status=progress
    sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment

    # create partitions
    sgdisk -n 1:0:+1000M ${DISK} # partition 1 (UEFI SYS), default start block, 512MB
    sgdisk -n 2:0:0     ${DISK} # partition 2 (Root), default start, remaining

    # set partition types
    sgdisk -t 1:ef00 ${DISK}
    sgdisk -t 2:8300 ${DISK}

    # label partitions
    sgdisk -c 1:"UEFISYS" ${DISK}
    sgdisk -c 2:"ROOT" ${DISK}

    # make filesystems
    echo -e "\nCreating Filesystems...\n$HR"
    if [[ ${DISK} =~ "nvme" ]]; then
    mkfs.vfat -F32 -n "UEFISYS" "${DISK}p1"
    mkfs.btrfs -L "ROOT" "${DISK}p2" -f
    mount -t btrfs "${DISK}p2" /mnt
    else
    mkfs.vfat -F32 -n "UEFISYS" "${DISK}1"
    mkfs.btrfs -L "ROOT" "${DISK}2" -f
    mount -t btrfs "${DISK}2" /mnt
    fi
    ls /mnt | xargs btrfs subvolume delete
    btrfs subvolume create /mnt/@
    umount /mnt

  else 
    # INSTALL WITH MBR
    echo "The system has UEFI disabled, will install with MBR"

    # disk prep
    sfdisk --delete $DISK # delete all partitions


    # make filesystems
    echo -e "\nCreating Filesystems...\n$HR"

    # only create a single partition with a MBR partition table
    fdisk $DISK << EOF
o
n
p
1




Y
a
w
EOF

    # just in case format the partition to linux
    mkfs.ext4 "${DISK}1"

    # mount the partition to /mnt
    mount "${DISK}1" /mnt

  fi

  ;;
esac

# mount target
mount -t btrfs -o subvol=@ -L ROOT /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount -t vfat -L UEFISYS /mnt/boot/

echo "--------------------------------------"
echo "-- Arch Install on Main Drive       --"
echo "--------------------------------------"
pacstrap /mnt base base-devel linux linux-firmware vim nano sudo archlinux-keyring wget libnewt --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab
echo "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf
echo "--------------------------------------"
echo "-- Bootloader Systemd Installation  --"
echo "--------------------------------------"
bootctl install --esp-path=/mnt/boot
[ ! -d "/mnt/boot/loader/entries" ] && mkdir -p /mnt/boot/loader/entries
cat <<EOF > /mnt/boot/loader/entries/arch.conf
title Arch Linux  
linux /vmlinuz-linux  
initrd  /initramfs-linux.img  
options root=LABEL=ROOT rw rootflags=subvol=@
EOF
cp -R ~/ArchQT /mnt/root/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
echo "--------------------------------------"
echo "--   SYSTEM READY FOR 0-setup       --"
echo "--------------------------------------"
