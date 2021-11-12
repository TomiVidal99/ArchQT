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
timezone=$2
locale=$3
keymap=$4
username=$5
desktop_environment=$6
gaming_packages=$5

echo "--------------------------------------"
echo "--          Network Setup           --"
echo "--------------------------------------"
pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable --now NetworkManager
echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download          "
echo "-------------------------------------------------"
pacman -S --noconfirm pacman-contrib curl
pacman -S --noconfirm reflector rsync
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have " $nc" cores."
echo "-------------------------------------------------"
echo "Changing the makeflags for "$nc" cores."
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$nc"/g' /etc/makepkg.conf
echo "Changing the compression settings for "$nc" cores."
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g' /etc/makepkg.conf

echo "-------------------------------------------------"
echo "       Setup Language to US and set locale       "
echo "-------------------------------------------------"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone $timezone 
timedatectl --no-ask-password set-ntp 1

# this command wont work for some reason???
#localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_COLLATE="" LC_TIME="en_US.UTF-8"
# i replaced the command above with these lines
echo "LANG=$locale.UTF-8" >> /etc/vconsole.conf
echo "FONT=$locale:en_US:es" >> /etc/vconsole.conf
echo "FONT_MAP=$locale:en_US:es" >> /etc/vconsole.conf

# TODO: check if all of this its actually necessary
#echo "FONT_MAP=$locale:en_US:es" >> /etc/vconsole.conf
#echo "LANGUAGE=$locale:en_US:es" >> /etc/vconsole.conf
#echo "KEYMAP=$keymap" >> /etc/vconsole.conf
#echo "LC_TIME=$locale.UTF-8" >> /etc/vconsole.conf
#echo "LC_COLLATE=C" >> /etc/vconsole.conf

# Set keymaps
localectl --no-ask-password set-keymap $keymap

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

#Add parallel downloading
sed -i 's/^#Para/Para/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

echo -e "\nInstalling Base System\n"

PKGS=(
'alsa-plugins' # audio plugins
'alsa-utils' # audio utils
'ark' # compression
'audiocd-kio' 
'autoconf' # build
'automake' # build
'base'
'bash-completion'
'bind'
'binutils'
'bison'
'bluedevil'
'bluez'
'bluez-libs'
'breeze'
'breeze-gtk'
'bridge-utils'
'btrfs-progs'
'celluloid' # video players
'cmatrix'
'cronie'
'cups'
'dhcpcd'
'dialog'
'discover'
'dmidecode'
'dnsmasq'
'dolphin'
'dosfstools'
'drkonqi'
'edk2-ovmf'
'efibootmgr' # EFI boot
'egl-wayland'
'exfat-utils'
'flex'
'fuse2'
'fuse3'
'fuseiso'
'gcc'
'gimp' # Photo editing
'git'
'gparted' # partition management
'gptfdisk'
'groff'
'grub'
'grub-customizer'
'gst-libav'
'gst-plugins-good'
'gst-plugins-ugly'
'haveged'
'htop'
'iptables-nft'
'jdk-openjdk' # Java 17
'kactivitymanagerd'
'kate'
'kvantum-qt5'
'kcalc'
'kcharselect'
'kcron'
'kde-cli-tools'
'kde-gtk-config'
'kdecoration'
'kdenetwork-filesharing'
'kdeplasma-addons'
'kdesdk-thumbnailers'
'kdialog'
'keychain'
'kfind'
'kgamma5'
'kgpg'
'khotkeys'
'kinfocenter'
'kitty'
'kmenuedit'
'kmix'
'konsole'
'kscreen'
'kscreenlocker'
'ksshaskpass'
'ksystemlog'
'ksystemstats'
'kwallet-pam'
'kwalletmanager'
'kwayland-integration'
'kwayland-server'
'kwin'
'kwrite'
'kwrited'
'layer-shell-qt'
'libguestfs'
'libkscreen'
'libksysguard'
'libnewt'
'libtool'
'linux'
'linux-firmware'
'linux-headers'
'lsof'
'lutris'
'lzop'
'm4'
'make'
'milou'
'nano'
'neofetch'
'networkmanager'
'ntfs-3g'
'okular'
'openbsd-netcat'
'openssh'
'os-prober'
'oxygen'
'p7zip'
'pacman-contrib'
'patch'
'picom'
'pkgconf'
'polkit-kde-agent'
'powerdevil'
'powerline-fonts'
'print-manager'
'pulseaudio'
'pulseaudio-alsa'
'pulseaudio-bluetooth'
'python-pip'
'qemu'
'rsync'
'sddm'
'sddm-kcm'
'snapper'
'spectacle'
'sudo'
'swtpm'
'synergy'
'systemsettings'
'terminus-font'
'texinfo'
'traceroute'
'ufw'
'unrar'
'unzip'
'usbutils'
'vde2'
'neovim' # replaced neovim for vim
'virt-manager'
'virt-viewer'
'wget'
'which'
'wine-gecko'
'wine-mono'
'winetricks'
'xdg-desktop-portal-kde'
'xdg-user-dirs'
'xorg'
'xorg-server'
'xorg-xinit'
'zeroconf-ioslave'
'zip'
'zsh'
'zsh-syntax-highlighting'
'zsh-autosuggestions'
'nodejs' # web dev and dependencies for neovim
'npm'
'yarn'
'python'
'thunderbird'
'ruby'
'redshift'
'octave'
'libreoffice'
)

GAMING_PACKAGES=(
'gamemode'
'steam'
)

KDE=(
'plasma-browser-integration'
'plasma-desktop'
'plasma-disks'
'plasma-firewall'
'plasma-integration'
'plasma-nm'
'plasma-pa'
'plasma-sdk'
'plasma-systemmonitor'
'plasma-thunderbolt'
'plasma-vault'
'plasma-workspace'
'plasma-workspace-wallpapers'
)

I3=(
  'i3-gaps'
  'feh'
  'j4-dmenu-desktop' 
  'morc_menu'
  'i3status'
  'wmctrl'
)

# necessary packages
for PKG in "${PKGS[@]}"; do
    echo -e "INSTALLING: ${PKG} \n\n"
    sudo pacman -S "$PKG" --noconfirm --needed
done


# gaming packages
case $gaming_packages in
y|Y|yes|Yes|YES)
    for GAMING_PACKAGE in "${GAMING_PACKAGES[@]}"; do
        echo -e "INSTALLING: ${GAMING_PACKAGE} \n\n"
        sudo pacman -S "$GAMING_PACKAGE" --noconfirm --needed
    done
    ;;
esac

# desktop environment packages
case $desktop_environment in
kde|KDE)
    for PACKAGE in "${KDE[@]}"; do
        echo -e "INSTALLING: ${PACKAGE} \n\n"
        sudo pacman -S "$PACKAGE" --noconfirm --needed
    done
    ;;
i3|I3)
    # install dependencies
    for PACKAGE in "${I3[@]}"; do
        echo -e "INSTALLING: ${PACKAGE} \n\n"
        sudo pacman -S "$PACKAGE" --noconfirm --needed
    done
    # set up configuration
    arch-chroot /mnt cp /home/$username/plasma-i3.desktop /usr/share/xsessions
    ;;
esac

#
# determine processor type and install microcode
# 
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
		echo -e "\nInstalling Intel microcode"
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		echo -e "\nInstalling AMD microcode"
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    pacman -S nvidia --noconfirm --needed
	nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    pacman -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

echo "username=$username" >> ${HOME}/ArchQT/install.conf

if [ $(whoami) = "root"  ];
then
    useradd -m -G wheel,libvirt -s /bin/bash $username 

    # TODO: should remove this maybe??? see how to set this at init.
		#passwd $username
	  cp -R /root/ArchQT /home/$username/
    chown -R $username: /home/$username/ArchQT

else
	echo "You are already a user proceed with aur installs"
fi

