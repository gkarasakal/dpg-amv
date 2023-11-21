#!/bin/bash

# OS Update
sudo yum update -y

# HTTPD Install and Enable
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Preparing html file
sudo touch /var/www/html/index.html
sudo chmod 777 /var/www/html/index.html
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html