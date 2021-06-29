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

function mountPart {

    echo "mount all part in dir"

    mount /dev/$varPart"2" /mnt
    
    mkdir /mnt/home

    mount /dev/$varPart"3" /mnt/home
}

checkInternetConnection
inputVarPartition
formattingPartition