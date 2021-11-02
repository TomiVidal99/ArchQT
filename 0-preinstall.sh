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

echo -e "\n-------------------------------------------------\n"
echo -e "\nSetting up mirrors for optimal download          \n"
echo -e "\n-------------------------------------------------\n"

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

echo -e "\n\nthe format disk its $(formatdisk)\n\n"
case $formatdisk in
y|Y|yes|Yes|YES)
echo -e "\n--------------------------------------"
echo -e "\nFormatting disk...\n$HR"
echo -e "\n--------------------------------------"

  # i need to check if the system has UEFI enabled, if it does install with GPT partition table type, else just use MBR
  if test -f "/sys/firmware/efi/efivars"; then

    # INSTALL WITH GPT
    echo -e "\nThe system has UEFI enabled, will install with GPT"

    # disk prep
    sgdisk -Z ${disk} # zap all on disk
    #dd if=/dev/zero of=${disk} bs=1M count=200 conv=fdatasync status=progress
    sgdisk -a 2048 -o ${disk} # new gpt disk 2048 alignment

    # create partitions
    sgdisk -n 1:0:+1000M ${disk} # partition 1 (UEFI SYS), default start block, 512MB
    sgdisk -n 2:0:0     ${disk} # partition 2 (Root), default start, remaining

    # set partition types
    sgdisk -t 1:ef00 ${disk}
    sgdisk -t 2:8300 ${disk}

    # label partitions
    sgdisk -c 1:"UEFISYS" ${disk}
    sgdisk -c 2:"ROOT" ${disk}

    # make filesystems
    echo -e "\nCreating Filesystems...\n$HR"
    if [[ ${disk} =~ "nvme" ]]; then
    mkfs.vfat -F32 -n "UEFISYS" "${disk}p1"
    mkfs.btrfs -L "ROOT" "${disk}p2" -f
    mount -t btrfs "${disk}p2" /mnt
    else
    mkfs.vfat -F32 -n "UEFISYS" "${disk}1"
    mkfs.btrfs -L "ROOT" "${disk}2" -f
    mount -t btrfs "${disk}2" /mnt
    fi
    ls /mnt | xargs btrfs subvolume delete
    btrfs subvolume create /mnt/@
    umount /mnt

  else 
    # INSTALL WITH MBR
    echo -e "\nThe system has UEFI disabled, will install with MBR"

    # disk prep
    sfdisk --delete $disk # delete all partitions


    # make filesystems
    echo -e "\nCreating Filesystems...\n$HR"

    # only create a single partition with a MBR partition table
    fdisk $disk << EOF
o
n
p
1




Y
a
w
EOF

    # just in case format the partition to linux
    mkfs.ext4 "${disk}1"

    # mount the partition to /mnt
    mount "${disk}1" /mnt

  fi

  ;;
esac

# mount target
mount -t btrfs -o subvol=@ -L ROOT /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount -t vfat -L UEFISYS /mnt/boot/

echo -e "\n--------------------------------------"
echo -e "\n-- Arch Install on Main Drive       --"
echo -e "\n--------------------------------------"
pacstrap /mnt base base-devel linux linux-firmware vim nano sudo archlinux-keyring wget libnewt --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab
echo "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf
echo "--------------------------------------"
echo "-- Bootloader Systemd Installation  --"
echo "--------------------------------------"


# check if it should install bootloader for BIOS or UEFI
if test -f "/sys/firmware/efi/efivars"; then

  bootctl install --esp-path=/mnt/boot
  [ ! -d "/mnt/boot/loader/entries" ] && mkdir -p /mnt/boot/loader/entries
cat <<EOF > /mnt/boot/loader/entries/arch.conf
title Arch Linux  
linux /vmlinuz-linux  
initrd  /initramfs-linux.img  
options root=LABEL=ROOT rw rootflags=subvol=@
EOF

else

  pacman -S --noconfirm grub
  grub-install --target=i386-pc $disk # installs the grub
  grub-mkconfig -o /boot/grub/grub.cfg # setups the grub config

  # TODO: should pull the grub config from titus script to have dual boot if the user wants with the custom boot pictures

fi

cp -R ~/ArchQT /mnt/root/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
echo -e "\n--------------------------------------"
echo -e "\n--   SYSTEM READY FOR 0-setup       --"
echo -e "\n--------------------------------------"
