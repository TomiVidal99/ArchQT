# ArchTitus Installer Script

<!--TODO: add custom pic-->
<!--<img src="https://i.imgur.com/YiNMnan.png" />-->

This README contains the steps I do to install and configure a fully-functional Arch Linux installation containing a desktop environment, all the support packages (network, bluetooth, audio, printers, etc.), along with all my preferred applications and utilities. The shell scripts in this repo allow the entire process to be automated.)

---

## Create Arch ISO or Use Image

Download ArchISO from <https://archlinux.org/download/> and put on a USB drive with Ventoy or Etcher

This script it's based on the script made by [@ChrisTitusTech](https://github.com/ChrisTitusTech); if you don't want to build using this script, he did create an image @ <https://www.christitus.com/arch-titus>

## Boot Arch ISO

From initial Prompt type the following commands:

```
pacman -Sy git
git clone https://github.com/TomiVidal99/ArchQT
cd ArchQT
./setup.sh
```

### System Description

This is completely automated arch install of the KDE desktop environment on arch using all the packages I use on a daily basis.

## Troubleshooting

**[Arch Linux Installation Guide](https://github.com/rickellis/Arch-Linux-Install-Guide)**

### No Wifi

```bash
sudo wifi-menu
```

## Credits

- Based on the script from <https://github.com/ChrisTitusTech>
- Original packages script was a post install cleanup script called ArchMatic located here: <https://github.com/rickellis/ArchMatic>
- Thank you to all the folks that helped during the creation from YouTube Chat! Here are all those Livestreams showing the creation: <https://www.youtube.com/watch?v=IkMCtkDIhe8&list=PLc7fktTRMBowNaBTsDHlL6X3P3ViX3tYg>
