#!/bin/bash
# Installs Pulsway for Linux
#
thisHost=$(hostname)
read -p "What group will this machine be in?. . . . . :" -e -i Default groupName
read -p "What do we want to call this machine in the dashboard?. . . . . :" -e -i $thisHost machineName
mkdir -P /DATA/ops
sudo wget -N http://www.RMM.com/download/RMM_x64.rpm -P /DATA/ops/
sudo rpm -ivh /DATA/ops/RMM_x64.rpm
sed -i -e 's/linux-CHANGEMYNAME/$machineName/g' /DATA/ops/linux-config.xml
sed -i -e 's/CHANGEMYGROUPE/$groupName/g' /DATA/ops/linux-config.xml
sudo mv -v /DATA/ops/linux-config.xml /etc/RMM/config.xml
sudo chmod 755 /etc/RMM/config.xml
sudo update-rc.d RMM.redhat defaults
sudo /etc/init.d/RMM start