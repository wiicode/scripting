#!/bin/bash
#run it like this ./linux_sudoers.sh name1 name2 name3
#or ./linux_sudoers.sh `cat linux_sudoers_list.txt`

while [[ -n $1 ]]; do
    echo "$1    ALL=(ALL:ALL) ALL" >> /etc/sudoers;
    shift # shift all parameters;
done
