#!/bin/bash
pacman -Syu --noconfirm
pacman -S base-devel namcap git --noconfirm

echo 'nobody ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

git clone https://aur.archlinux.org/yay.git
chown -R nobody yay
pushd yay
sudo -u nobody makepkg -crsi
popd
rm -rf yay
