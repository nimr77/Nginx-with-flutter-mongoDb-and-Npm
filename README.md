# Nginx-with-flutter-mongoDb-and-Npm
 This projects aims to explain how to create a web demo interface by using ```Flutter``` and creating rest Api with ```NodeJS```, with a ```CentOS``` server, that runs with ```nginx```, and a database ```MongoDB```.
 ### Please note that all the packages installaization is been take care of by using ```./setup.sh```
 #### so lets explain how the setup will work!
 it will start by installing nginx:
 ```bash
 sudo yum install epel-release && echo " done installing epel" >> $R || echo "Error while installing epel">>$R
sudo yum install nginx && echo " done installing nginx" >> $R || echo "Error while installing nginx">> $R
echo "Installing done"
echo "Starting and enabling nginx"
sudo systemctl start nginx
sudo systemctl status nginx >> $R
sudo systemctl enable nginx
````
this will install nginx and configure it on the systemctl manager.
then we will configure the network, so our server will listen to the address of the machine not the localhost 

```bash
echo "Setting up the network"
ifconfig
read -p  "Please choose an interface for the static network:(enp0s8) " networkInterface
networkInterface=${networkInterface:-enp0s8}
read -p  "Please provide the Ipv4 address for the interface:(192.168.56.101) " netInfAdd
netInfAdd=${netInfAdd:-192.168.56.101}
read -p  "Please provide the Ipv4 mask for the interface:(255.255.255.0) " netInfAddMask
netInfAddMask=${netInfAddMask:-255.255.255.0}
```
