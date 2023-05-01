#!/bin/bash
#1. Connect to the EC2 instance using SSH.
#2. Install Docker and Docker Compose on the EC2 instance if they are not already installed.
#3. Stop and remove any existing containers that are running on the EC2 instance.
#4. Pull the latest Docker image from Docker Hub.
#5. Start the new containers based on the Docker image.
#6. Check the health of the application by running a curl command to the health endpoint.
#      If the application is healthy, exit the script.
#BONUS: If the application is not healthy, send a notification via Slack or email. (curl) 

# Define the SSH key file and EC2 instance IP address
SSH_KEY="~/.ssh/oleg-key-pair.pem"
PUBLIC_IP="13.53.188.209"

# Connect to the EC2 instance using SSH
ssh -i $SSH_KEY ubuntu@$EC2_IP

# Install Docker and Docker Compose on the EC2 instance if they are not already installed.
if ! command -v docker &> /dev/null
then
    sudo apt-get -y update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    apt-cache policy docker-ce
    sudo apt install -y docker-ce
    sudo systemctl status docker
    sudo systemctl enable docker
    sudo apt install -y make
    sudo usermod -a -G docker ubuntu
fi

if ! command -v docker-compose &> /dev/null
then
    sudo apt install docker-compose
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
    curl -X POST -H 'Content-type: application/json' --data '{"text":"Application is not healthy!"}' https://hooks.slack.com/services/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
    exit 1
fi