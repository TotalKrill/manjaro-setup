
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
    nm-applet \
    virt-manager \
    cmake \
    qemu \
    owncloud-client \
    kdegraphics-okular \
    openocd"

yaourtpkgs="\
    telegram-desktop \
    otf-inconsolata-powerline-git \
    neovim-symlinks \
    "

services="""
sshd.socket
libvirtd
virtlogd
"""
# Install some needed package
echo Removing modemmanager
sudo pacman -Rsc modemmanager --noconfirm
sudo pacman -Syu --force --noconfirm

echo Installing: $packages
sudo pacman -S --force --noconfirm $packages

echo Installing from yaourt
sudo yaourt -S --noconfirm $yaourtpkgs

# enable some stuff
echo enabling: $services
sudo systemctl enable $services

# fix udev rules

user=$(whoami)
# set some groups for manjaro and arch
sudo usermod -aG wheel $user
sudo usermod -aG uucp $user
sudo usermod -aG kvm $user

# Fix ltu printer system
sudo sh -c 'echo "ServerName IPP.LTU.SE" > /etc/cups/client.conf'

# Fix vim settings
git clone --recurse-submodules https://github.com/TotalKrill/.nvim.git ~/.config/nvim
nvim -c PlugInstall
