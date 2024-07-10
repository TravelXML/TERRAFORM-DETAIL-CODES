#!/bin/bash
sudo apt-get update
sudo apt-get install nginx -y
echo "Hey SAPAN" >/var/www/html/index.nginx-debian.html