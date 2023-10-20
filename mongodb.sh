script_location=$(pwd)

cp ${script_location}/files/mongo.repo /etc/yum.repos.d/mongo.repo

#Install MongoDB

dnf install mongodb-org -y

#Start & Enable MongoDB Service

systemctl enable mongod
systemctl start mongod

