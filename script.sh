#!/bin/bash
#1. Connect to the EC2 instance using SSH.
#2. Install Docker and Docker Compose on the EC2 instance if they are not already installed.
#3. Stop and remove any existing containers that are running on the EC2 instance.
#4. Pull the latest Docker image from Docker Hub.
#5. Start the new containers based on the Docker image.
#6. Check the health of the application by running a curl command to the health endpoint.
#      If the application is healthy, exit the script.
#BONUS: If the application is not healthy, send a notification via Slack or email. (curl) 

# Install Docker and Docker Compose on the EC2 instance if they are not already installed.
if ! command -v docker &> /dev/null
then
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo systemctl start docker
    sudo systemctl enable docker
fi

if ! command -v docker-compose &> /dev/null
then
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Stop and remove any existing containers that are running
sudo docker stop $(docker ps -a -q)
sudo docker rm $(docker ps -a -q)

# Pull the latest Docker image from Docker Hub
sudo docker-compose pull

# Start the new containers based on the Docker image
sudo docker-compose up -d

# Check the health of the application by running a curl command to the health endpoint
HEALTH_CHECK=$(curl -sSfi -m 2 ${public_ip}:8000/todo --head -o /dev/null; echo $?)

# Exit the script if the application is healthy
if [[ "$HEALTH_CHECK" -eq 0 ]]; then
    exit 0
else
    echo "Application is not healthy."
    exit 1
fi