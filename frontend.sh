# 01-Frontend
# The frontend is the service in RoboShop to serve the web content over Nginx. This will have the webframe for the web application.
# This is a static content and to serve static content we need a web server. This server
# Developer has chosen Nginx as a web server and thus we will install Nginx Web Server.
### Install Nginx

script_location=$(pwd)

LOG=/tmp/roboshop.log

echo -e "\e[35m Install nginx\e[0m"

dnf install nginx -y &>>$LOG

if [ $? -eq 0 ]; then
  echo SUCCESS
  else
  echo FAILURE

# Remove the default content that web server is serving.
echo -e "\e[35m Remove nginx old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>$LOG

if [ $? -eq 0 ]; then
  echo SUCCESS
  else
  echo FAILURE

# Download the frontend content
echo -e "\e[35m Download the frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$LOG

if [ $? -eq 0 ]; then
  echo SUCCESS
  else
  echo FAILURE


cd /usr/share/nginx/html

# Extract the frontend content.
echo -e "\e[35m Extracting frontend content\e[0m"
unzip /tmp/frontend.zip &>>$LOG

if [ $? -eq 0 ]; then
  echo SUCCESS
  else
  echo FAILURE

# Create Nginx Reverse Proxy Configuration.

echo -e "\e[35m Copy Roboshop nginx config file\e[0m"
cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOG

if [ $? -eq 0 ]; then
  echo SUCCESS
  else
  echo FAILURE

# Restart Nginx Service to load the changes of the configuration.

echo -e "\e[35m enable nginx\e[0m"
systemctl enable nginx &>>$LOG

if [ $? -eq 0 ]; then
  echo SUCCESS
  else
  echo FAILURE

echo -e "\e[35m Start nginx\e[0m"
systemctl start nginx &>>$LOG

if [ $? -eq 0 ]; then
  echo SUCCESS
  else
  echo FAILURE




