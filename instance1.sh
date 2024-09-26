#!/bin/bash

# Update package list
sudo apt-get update

# Install Nginx
sudo apt-get install -y nginx

# Create a simple HTML page
echo "<html>
  <head>
    <title>Welcome to My Webpage</title>
  </head>
  <body>
    <h1>Hello from Nginx!</h1>
    <p>This is a simple web page served from an EC2 instance using Nginx.</p>
  </body>
</html>" | sudo tee /var/www/html/index.html

# Start Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
