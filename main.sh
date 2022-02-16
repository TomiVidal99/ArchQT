#!/bin/bash

    args=("$@")
    username=${args[0]}
    username_password=${args[1]}
    root_password=${args[2]}
    hostname=${args[3]}
    desktop_environment=${args[4]}
    locale=${args[5]}
    custom_locale=${args[6]}
    keymap=${args[7]}
    custom_keymap=${args[8]}
    region=${args[9]}
    custom_region=${args[10]}
    timezone=${args[11]}
    nvim_config=${args[12]}
    gaming_packages=${args[13]}
    format_disk=${args[14]}
    disk=${args[15]}
    install_extra_packages=${args[16]}

    echo -t "\n------------------------------------------------------------------------\n"
    echo -t "\n    █████╗ ██████╗  ██████╗██╗  ██╗ ██████╗ ████████╗ \n" 
    echo -t "\n   ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔═══██╗╚══██╔══╝ \n" 
    echo -t "\n   ███████║██████╔╝██║     ███████║██║   ██║   ██║    \n" 
    echo -t "\n   ██╔══██║██╔══██╗██║     ██╔══██║██║▄▄ ██║   ██║    \n" 
    echo -t "\n   ██║  ██║██║  ██║╚██████╗██║  ██║╚██████╔╝   ██║    \n" 
    echo -t "\n   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚══▀▀═╝    ╚═╝    \n" 
    echo -t "\n------------------------------------------------------------------------"

    echo -t $(bash 0-preinstall.sh $region $format_disk $disk)
    echo -t $(arch-chroot /mnt /root/ArchQT/1-setup.sh $region $timezone $locale $keymap $username $gaming_packages $desktop_environment)
    if install_extra_packages; then
      echo -t $(arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchQT/2-user.sh)
      echo -t $(arch-chroot /mnt /root/ArchQT/3-post-setup.sh)
    fi

    # copy over the .bashrc config
    echo -t $(cp --force /root/ArchQT/.bashrc /home/$username)
    # copy over the .zsh config
    echo -t $(cp --force /root/ArchQT/.zshrc /home/$username)

    # install nvim config if the user wants
    case $nvim_config in
    y|Y|yes|Yes|YES)
      echo -t $(arch-chroot /mnt /home/$username/ArchQT/nvim-config.sh)
        ;;
    esac


    # set up the passwords for the root and the user
    echo -e "\n\n Enter the root password: "
    arch-chroot /mnt passwd root
    echo -e "\n\n Enter the user ($username) password: "
    arch-chroot /mnt passwd $username
