script_location=$(pwd)

cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo

#Install MongoDB

dnf install mongodb-org -y


#Start & Enable MongoDB Service

systemctl enable mongod
systemctl start mongod

#Usually MongoDB opens the port only to localhost(127.0.0.1), meaning this service can be accessed by the application that is hosted on this server only. However, we need to access this service to be accessed by another server, So we need to change the config accordingly.

#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf

#Restart the service to make the changes effected.

#systemctl restart mongod

