#!/bin/bash
#-------------------------------------------------------------------------
#  ▄▄▄       ██▀███   ▄████▄   ██░ ██  ███▄ ▄███▓ ▄▄▄     ▄▄▄█████▓ ██▓ ▄████▄  
# ▒████▄    ▓██ ▒ ██▒▒██▀ ▀█  ▓██░ ██▒▓██▒▀█▀ ██▒▒████▄   ▓  ██▒ ▓▒▓██▒▒██▀ ▀█  
# ▒██  ▀█▄  ▓██ ░▄█ ▒▒▓█    ▄ ▒██▀▀██░▓██    ▓██░▒██  ▀█▄ ▒ ▓██░ ▒░▒██▒▒▓█    ▄ 
# ░██▄▄▄▄██ ▒██▀▀█▄  ▒▓▓▄ ▄██▒░▓█ ░██ ▒██    ▒██ ░██▄▄▄▄██░ ▓██▓ ░ ░██░▒▓▓▄ ▄██▒
#  ▓█   ▓██▒░██▓ ▒██▒▒ ▓███▀ ░░▓█▒░██▓▒██▒   ░██▒ ▓█   ▓██▒ ▒██▒ ░ ░██░▒ ▓███▀ ░
#  ▒▒   ▓▒█░░ ▒▓ ░▒▓░░ ░▒ ▒  ░ ▒ ░░▒░▒░ ▒░   ░  ░ ▒▒   ▓▒█░ ▒ ░░   ░▓  ░ ░▒ ▒  ░
#   ▒   ▒▒ ░  ░▒ ░ ▒░  ░  ▒    ▒ ░▒░ ░░  ░      ░  ▒   ▒▒ ░   ░     ▒ ░  ░  ▒   
#   ░   ▒     ░░   ░ ░         ░  ░░ ░░      ░     ░   ▒    ░       ▒ ░░        
#       ░  ░   ░     ░ ░       ░  ░  ░       ░         ░  ░         ░  ░ ░      
#                    ░                                                 ░
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
# disk

echo "Set up all the variables before installing so the installation won't stop until has finished..."

read -p "username: " username
read -p "username password: " username_password
read -p "root password: " root_password 
read -p "hostname: " hostname
read -p "desktop environment: ['KDE', 'KDE/i3', 'custom'] " desktop_environment

read -p "custom locale or default to en_US: [Y/N] " custom_locale
locale='es_US'
case $custom_locale in
  y|Y|yes|Yes|YES)
    read -p "Set custom locale: (i.e 'es_AR'): " locale
    ;;
esac

read -p "custom keymap? (default to en_US layout): [Y/N] " custom_keymap
keymap=''
case $custom_locale in
  y|Y|yes|Yes|YES)
    read -p "Set custom keymap [i.e: 'la-latin1'] " keymap 
    ;;
esac

read -p "custom region? (default from image source): [Y/N] " custom_region
region=''
case $custom_locale in
  y|Y|yes|Yes|YES)
    read -p "Set custom region: (i.e 'br'): " region
    ;;
  *)
    iso=$(curl -4 ifconfig.co/country-iso)
    ;;
esac

lsblk # list the disks and partitions with the size
read -p "Set a disk to install: [i.e: '/dev/sda', NOT the partition] " disk

# should pass all the parameters to the installation files as arguments
