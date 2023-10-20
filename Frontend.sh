# The frontend is the service in RoboShop to serve the web content over Nginx. This will have the webframe for the web application.

# This is a static content and to serve static content we need a web server. This server

# Developer has chosen Nginx as a web server and thus we will install Nginx Web Server.

# Install Nginx

dnf install nginx -y

# Start & Enable Nginx service

systemctl enable nginx
systemctl start nginx

# Remove the default content that web server is serving

rm -rf /usr/share/nginx/html/*

#Download the frontend content

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

