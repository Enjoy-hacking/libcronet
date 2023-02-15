#!/bin/bash
pacman -Syu --noconfirm
pacman -S base-devel namcap git --noconfirm
pacman -Sc --noconfirm

echo 'nobody ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

git clone https://aur.archlinux.org/yay.git
pacman -S go --noconfirm
chown -R nobody yay
pushd yay
sudo -u nobody makepkg -cri
popd
pacman -Rsn go --noconfirm
pacman -Sc --noconfirm
rm -rf yay
