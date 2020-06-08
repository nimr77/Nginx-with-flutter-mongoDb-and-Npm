#!/bin/bash

echo "Network config log will be saved into NetConf.log"
R="NetConf.log"

#The where need to change to make the network static 
whereToChange="/etc/sysconfig/network-scripts/ifcfg-$1"
echo "We will change $whereToChange"
#what need to be added to make this interface static 

whatToChange="
DEVICE=$1
BOOTPROTO=static 
IPADDR=$2 
NETMASK=$3 
NM_CONTROLLED=no 		
ONBOOT=yes"

echo $whatToChange > $whereToChange && echo " Done saving into $whereToChange" >> $R 

#Results
systemctl restart network
