#!/bin/bash
set -e

DOCKER_USER="alexluthor135"
APP_NAME="alappas"

# Ensure Docker is running
sudo systemctl start docker

# # Build and tag v1 locally
sed -i 's/Welcome to Nginx v2!/Welcome to Nginx!/' index.html
docker build -t $DOCKER_USER/$APP_NAME:v1 .

# Push v1 to DockerHub
echo "Pushing v1..."
docker push $DOCKER_USER/$APP_NAME:v1

# Modify index.html for v2
echo "Updating application for v2..."
sed -i 's/Welcome to Nginx!/Welcome to Nginx v2!/' index.html

# # Build and tag v2 locally
docker build -t $DOCKER_USER/$APP_NAME:v2 .

# Push v2 to DockerHub
echo "Pushing v2..."
docker push $DOCKER_USER/$APP_NAME:v2

echo "Both versions v1 and v2 have been pushed to DockerHub."
