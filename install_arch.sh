#!/bin/bash

#wget -q --spider http://google.com

#if [ $? -eq 0 ]; then
#	echo "ping ok..."
#else
#	echo "ping not ok..."
#fi

function checkInternetConnection {

    echo "check internet connection"

    if ping -c 2 8.8.8.8 >/dev/null; then

    echo "ping is ok"

    else

    echo "ping not ok"

    fi
}

loadkeys ru

#
## Select part.
#
function inputVarPartition {
    echo "Input varriable sda/sdc/sdb:"

    read varPart

    sudo cfdisk /dev/$varPart
}


function formattingPartition {
    echo format /efi part
    mkfs.fat -F32 /dev/$varPart"1"

    echo format /root part
    mkfs.ext4 /dev/$varPart"2"

    echo format /home part
    mkfs.ext4 /dev/$varPart"3"

}

function mountPartAndInstallBaseLinux {

    echo "mount all part in dir"

    mount /dev/$varPart"2" /mnt
    
    mkdir /mnt/home

    mount /dev/$varPart"3" /mnt/home

    pacstrap -i /mnt base linux linux-firmware sudo vim networkmanager

    genfstab -U -p /mnt >> /mnt/etc/fstab
}

function chrootSystem {

    arch-chroot /mnt /bin/bash
    
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

checkInternetConnection
inputVarPartition
formattingPartition
mountPartAndInstallBaseLinux
chrootSystem
grubInstall