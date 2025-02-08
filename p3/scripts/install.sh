#!/bin/bash

# Update and upgrade
sudo apt update && sudo apt upgrade -y

# Install Docker
if ! command -v docker &> /dev/null
then
    echo "Installing Docker..."
    sudo apt install -y docker.io
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
fi

# Install K3d
if ! command -v k3d &> /dev/null; then
    echo "Installing K3d..."
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

# Install kubectl
if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl..."
    sudo snap install kubectl --classic
fi

# Install Argo CD CLI
if ! command -v argocd &> /dev/null; then
    echo "Installing Argo CD CLI..."
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64
fi

echo "All dependencies installed successfully."

# Install Argo CD
echo "Installing Argo CD..."
bash ./set_argocd.sh
echo "Argo CD installed successfully."

# Set up development environment
echo "Setting up development environment..."
bash ./set_dev.sh
echo "Development environment set up successfully."

# Set up DockerHub
echo "Setting up DockerHub..."
bash ./set_dockerhub.sh
echo "DockerHub set up successfully."