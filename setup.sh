#!/bin/bash
#-------------------------------------------------------------------------
#    █████╗ ██████╗  ██████╗██╗  ██╗ ██████╗ ████████╗
#   ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔═══██╗╚══██╔══╝
#   ███████║██████╔╝██║     ███████║██║   ██║   ██║   
#   ██╔══██║██╔══██╗██║     ██╔══██║██║▄▄ ██║   ██║   
#   ██║  ██║██║  ██║╚██████╗██║  ██║╚██████╔╝   ██║   
#   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚══▀▀═╝    ╚═╝   
#-------------------------------------------------------------------------

# this file will set up all the parameters for the whole installation so theres no prompts in the middle of the istallation.

# list of variables:
# username
# password
# root password
# hostname
# desktop environment
# custom locale
# custom keymap
# custom region
# timezone
# nvim config?
# format disk?
# disk

#echo "Set up all the variables before installing so the installation won't stop until has finished..."

#read -p "username: " username
#read -p "username password: " username_password
#read -p "root password: " root_password 
#read -p "hostname: " hostname
#read -p "desktop environment: ['KDE', 'KDE/i3', 'custom'] " desktop_environment

#read -p "custom locale? (default is en_US) [Y/N] " custom_locale
#locale='es_US'
#case $custom_locale in
  #y|Y|yes|Yes|YES)
    #read -p "Set custom locale: (i.e 'es_AR'): " locale
    #;;
#esac

#read -p "custom keymap? (default to en_US layout): [Y/N] " custom_keymap
#keymap=''
#case $custom_keymap in
  #y|Y|yes|Yes|YES)
    #read -p "Set custom keymap [i.e: 'la-latin1'] " keymap 
    #;;
#esac

#read -p "custom region? (default from image source): [Y/N] " custom_region
#region=''
#case $custom_region in
  #y|Y|yes|Yes|YES)
    #read -p "Set custom region: (i.e 'br'): " region
    #;;
  #*)
    #iso=$(curl -4 ifconfig.co/country-iso)
    #;;
#esac

#read -p "timezone: [i.e: America/Buenos_Aires] " timezone

#read -p "Install neovim config? [Y/N] " nvim_config

#lsblk # list the disks and partitions with the size
#read -p "Set a disk to install: [i.e: '/dev/sda', NOT the partition] " disk

#read -p "This will erase all data in your disk, are you sure you want to continue? [Y/N] " format_disk

# should pass all the parameters to the installation files as arguments
#sh ./main.sh $username $username_password $root_password $hostname $desktop_environment $custom_locale $locale $custom_keymap $keymap $custom_region $region $timezone $nvim_config $format_disk $disk
sh ./main.sh tomii 1234 1234 tomii-arch KDE br y la-latin1 y br y Argentina/Buenos_Aires n y /dev/sda
