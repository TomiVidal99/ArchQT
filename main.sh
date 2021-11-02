#!/bin/bash

    username=$1
    username_password=$2
    root_password=$3
    hostname=$4
    desktop_environment=$5
    custom_locale=$6
    locale=$7
    custom_keymap=$8
    keymap=$9
    custom_region=$10
    region=$11
    timezone=$12
    nvim_config=$13
    format_disk=$14
    disk=$15


    echo -t "\n------------------------------------------------------------------------\n"
    echo -t "\n    █████╗ ██████╗  ██████╗██╗  ██╗ ██████╗ ████████╗ \n" 
    echo -t "\n   ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔═══██╗╚══██╔══╝ \n" 
    echo -t "\n   ███████║██████╔╝██║     ███████║██║   ██║   ██║    \n" 
    echo -t "\n   ██╔══██║██╔══██╗██║     ██╔══██║██║▄▄ ██║   ██║    \n" 
    echo -t "\n   ██║  ██║██║  ██║╚██████╗██║  ██║╚██████╔╝   ██║    \n" 
    echo -t "\n   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚══▀▀═╝    ╚═╝    \n" 
    echo -t "\n------------------------------------------------------------------------"

    echo -t "format disk on the main its: $format_disk\n"

    echo $(bash 0-preinstall.sh $region $format_disk $disk)
    echo $(arch-chroot /mnt /root/ArchQT/1-setup.sh $region $timezone $locale $keymap $username)
    echo $(arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchQT/2-user.sh)
    echo $(arch-chroot /mnt /root/ArchQT/3-post-setup.sh)
