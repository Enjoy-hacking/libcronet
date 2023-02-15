#!/bin/bash
echo 'nobody ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
echo 'root ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

pacman -Syu --noconfirm
pacman -S base-devel namcap git --noconfirm

git clone https://aur.archlinux.org/yay.git
chmod -R nobody yay
pushd yay
sudo -u nobody makepkg -crsi
popd
rm -rf yay
