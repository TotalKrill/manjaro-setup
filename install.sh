
packages="\
    neovim \
    python2-neovim \
    python-neovim \
    git \
    firefox \
    thunderbird \
    arm-none-eabi-gcc \
    arm-none-eabi-gdb \
    arm-none-eabi-newlib \
    clang \
    minicom \
    ack \
    network-manager-applet \
    virt-manager \
    cmake \
    qemu \
    owncloud-client \
    kdegraphics-okular \
    openocd \
    pavucontrol \
    pulseaudio \
    pulseaudio-bluetooth \
    pulseaudio-alsa \
    "

yaourtpkgs="\
    telegram-desktop-bin \
    otf-inconsolata-powerline-git \
    xcwd-git \
    spotify \
    kicad-git \
    youtube-viewer-git \
    neovim-symlinks \
    "

services="""
sshd.socket
libvirtd
virtlogd.socket
"""

removeables="\
    palemoon-bin \
    modemmanager \
    vim \
    vi \
    "
# Install some needed package
echo Removing some software
sudo pacman -Rsc $removeables --noconfirm

echo Fixing mirrors!
sudo pacman-mirrors -g
echo Upgrading
sudo pacman -Syu --force --noconfirm

echo Installing: $packages
sudo pacman -S --force --noconfirm $packages

echo Installing from yaourt
for package in $yaourtpkgs ; do
    yaourt -S --force --noconfirm $package
    echo $package
done

# enable some stuff
echo enabling: $services
sudo systemctl enable $services
sudo systemctl start $services

# fix udev rules

user=$(whoami)
# set some groups for manjaro and arch
sudo usermod -aG wheel $user
sudo usermod -aG uucp $user
sudo usermod -aG kvm $user

# Fix ltu printer system
sudo sh -c 'echo "ServerName IPP.LTU.SE" > /etc/cups/client.conf'

# Fix config files
git clone https://github.com/TotalKrill/.dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh

# Fix vim settings
git clone --recurse-submodules https://github.com/TotalKrill/.nvim.git ~/.config/nvim
nvim -c PlugInstall

# Copying udec rules
echo copying udev rules
sudo cp ./udev_rules/* /etc/udev/rules.d/
sudo udevadm control --reload
