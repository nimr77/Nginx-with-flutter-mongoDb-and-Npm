#!/bin/bash
#This will init the work to install the server and the hhtp server
#and all logs will be saved into Init.log
echo "This will init the server to start working, the Init.log will contain all the information about the process"
R="Init.log"
echo "Installing nginx"
sudo yum install epel-release && echo " done installing epel" >> $R || echo "Error while installing epel">>$R
sudo yum install nginx && echo " done installing nginx" >> $R || echo "Error while installing nginx">> $R
echo "Installing done"
echo "Starting and enabling nginx"
sudo systemctl start nginx
sudo systemctl status nginx >> $R
sudo systemctl enable nginx
echo "Done"
echo "Setting up the network"
ifconfig
read -p  "Please choose an interface for the static network:(enp0s8) " networkInterface
networkInterface=${networkInterface:-enp0s8}
read -p  "Please provide the Ipv4 address for the interface:(192.168.56.101) " netInfAdd
netInfAdd=${netInfAdd:-192.168.56.101}
read -p  "Please provide the Ipv4 mask for the interface:(255.255.255.0) " netInfAddMask
netInfAddMask=${netInfAddMask:-255.255.255.0}

./configureNetwork.sh $networkInterface $netInfAdd $netInfAddMask
echo "setting firewall"
./activePort80.sh
echo "installing MongoDB"
#this will install mongo Db 
./initManog.sh
#this will install node js
./InitNPM.sh
#this will setup the UI
./setupUI.sh
#this will configure the Http Server
./configNginx.sh $netInfAdd "/usr/share/nginx/html"

echo "To start the APi go to Launcher"
echo "The test Web Ui is http://$netInfAdd/databaseDriver/web/"
