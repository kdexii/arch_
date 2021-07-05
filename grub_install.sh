#!/bin/bash

function chrootSystem {

    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

    echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen

    echo "LANG=en_US.UTF-8" > /etc/locale.conf

    ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

    hwclock --systohc --utc

    date

    echo "Input name ur system:"

    read nameArch

    echo "$nameArch" > /etc/hostname

    echo "127.0.0.1 localhost.localdomain $nameArch" >> /etc/hosts

    systemctl enable NetworkManager

}

function grubInstall {
    
    echo "Print new password for root:"
    passwd

    pacman -S grub efibootmgr
    mkdir /boot/efi
    mount /dev/sda1 /boot/efi
    lsblk
    grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi --removable
    grub-mkconfig -o /boot/grub/grub.cfg
    exit
    umount -R /mnt
    reboot
}

chrootSystem
grubInstall
