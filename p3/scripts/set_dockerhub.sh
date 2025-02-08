#!/bin/bash
set -e

DOCKER_USER="AlexLuthor135"
APP_NAME="alappas"

# Ensure Docker is running
sudo systemctl start docker

# Build and tag v1
echo "Building version v1..."
docker build -t $DOCKER_USER/$APP_NAME:v1 .

# Push v1
echo "Pushing v1..."
docker push $DOCKER_USER/$APP_NAME:v1

# Modify application (e.g., change response message)
echo "Updating application for v2..."
sed -i 's/"message": "v1"/"message": "v2"/' app.py

# Build and tag v2
echo "Building version v2..."
docker build -t $DOCKER_USER/$APP_NAME:v2 .

# Push v2
echo "Pushing v2..."
docker push $DOCKER_USER/$APP_NAME:v2

echo "Both versions v1 and v2 have been pushed to DockerHub."