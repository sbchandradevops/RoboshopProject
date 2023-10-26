# 03-Catalogue

# Catalogue is a microservice that is responsible for serving the list of items that displays in roboshop application.

# HINT
# Developer has chosen NodeJs, Check with developer which version of NodeJS is needed. Developer has set a context that
# it can work with NodeJS >18

script_location=$(pwd)

# Setup NodeJS repos. Vendor is providing a script to setup the repos.
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

# Install NodeJS
dnf install nodejs -y

# Configure the application.

# INFO
# Our application developed by the developer of our org and it is not having any RPM software just like other softwares.
# So we need to configure every step manually
# Note : The applications should run as nonroot user.

# Add application User
useradd roboshop

# INFO
# User roboshop is a function / daemon user to run the application. Apart from that we dont use this user to login to
# server.
# Also, username roboshop has been picked because it more suits to our project name.
# INFO
# We keep application in one standard location. This is a usual practice that runs in the organization.

# Lets setup an app directory.
mkdir -p /app

# Download the application code to created app directory.
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
# Delete the existing if any
rm -rf /app/*

cd /app
unzip /tmp/catalogue.zip

# Every application is developed by development team will have some common softwares that they use as libraries.
# This application also have the same way of defined dependencies in the application configuration.

# Lets download the dependencies.
cd /app
npm install

# We need to setup a new service in systemd so systemctl can manage this service
# INFO
# Setup SystemD Catalogue Service
# Create a file named catalogue.service in Files
cp ${script_location}/Files/catalogue.service /etc/systemd/system/catalogue.service

# NOTE
# Ensure you replace <MONGODB-SERVER-IPADDRESS> with IP address
# Load the service.
systemctl daemon-reload

# INFO
# This above command is because we added a new service, We are telling systemd to reload so it will detect new service.
# Start the service.

systemctl enable catalogue
systemctl start catalogue

# For the application to work fully functional we need to load schema to the Database.
# INFO
# Schemas are usually part of application code and developer will provide them as part of development.
# We need to load the schema. To load schema we need to install mongodb client.
# To have it installed we can setup MongoDB repo and install mongodb-client
# /etc/yum.repos.d/mongo.repo

dnf install mongodb-org-shell -y

# Load Schema
# mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js
# NOTE
# You need to update catalogue server ip address in frontend configuration.
# Configuration file is /etc/nginx/default.d/roboshop.conf

mongo --host localgost-IPADDRESS </app/schema/catalogue.js














