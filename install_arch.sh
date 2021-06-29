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
# Select part.
checkInternetConnection

function inputVarPartition {
    echo "Input varriable sda/sdc/sdb:"

    read varPart

    sudo cfdisk /dev/$varPart
}

inputVarPartition

#loadkeys ru


