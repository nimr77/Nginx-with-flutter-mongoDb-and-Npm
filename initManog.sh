./addMongoDbRepo.sh
yum repolist
yum -y install mongodb-org
systemctl start mongod
netstat -plntu
systemctl status mongod
systemctl enable mongod
