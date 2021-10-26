#!/bin/bash

    bash 0-preinstall.sh
    arch-chroot /mnt /root/Archmatic/1-setup.sh
    source /mnt/root/Archmatic/install.conf
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/Archmatic/2-user.sh
    arch-chroot /mnt /root/Archmatic/3-post-setup.sh
