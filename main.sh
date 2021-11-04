#!/bin/bash

    args=("$@")
    username=${args[0]}
    username_password=${args[1]}
    root_password=${args[2]}
    hostname=${args[3]}
    desktop_environment=${args[4]}
    custom_locale=${args[5]}
    locale=${args[6]}
    custom_keymap=${args[7]}
    keymap=${args[8]}
    custom_region=${args[9]}
    region=${args[10]}
    timezone=${args[11]}
    nvim_config=${args[12]}
    format_disk=${args[13]}
    disk=${args[14]}

    echo -t "\n------------------------------------------------------------------------\n"
    echo -t "\n    █████╗ ██████╗  ██████╗██╗  ██╗ ██████╗ ████████╗ \n" 
    echo -t "\n   ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔═══██╗╚══██╔══╝ \n" 
    echo -t "\n   ███████║██████╔╝██║     ███████║██║   ██║   ██║    \n" 
    echo -t "\n   ██╔══██║██╔══██╗██║     ██╔══██║██║▄▄ ██║   ██║    \n" 
    echo -t "\n   ██║  ██║██║  ██║╚██████╗██║  ██║╚██████╔╝   ██║    \n" 
    echo -t "\n   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚══▀▀═╝    ╚═╝    \n" 
    echo -t "\n------------------------------------------------------------------------"

    echo -t $(bash 0-preinstall.sh $region $format_disk $disk)
    echo -t $(arch-chroot /mnt /root/ArchQT/1-setup.sh $region $timezone $locale $keymap $username)
    echo -t $(arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchQT/2-user.sh)
    echo -t $(arch-chroot /mnt /root/ArchQT/3-post-setup.sh)

    # copy over the .bashrc config
    echo -t $(cp --force /root/ArchQT/.bashrc /home/$username)

    # install nvim config if the user wants
    case $nvim_config in
    y|Y|yes|Yes|YES)
      echo -t $(arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchQT/nvim-config.sh)
        ;;
    esac

    # set up the passwords for the root and the user
    arch-chroot /mnt passwd root
    arch-chroot /mnt passwd $username
