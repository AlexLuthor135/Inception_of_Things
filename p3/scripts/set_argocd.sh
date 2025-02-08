#!/bin/bash
set -e


if ! k3d cluster list | grep -q my-cluster; then
    echo "K3d cluster is not running. Creating it now..."
    sudo k3d cluster create my-cluster --servers 1 --agents 1 --port 8080:80@loadbalancer
fi

echo "Waiting for Kubernetes API to be ready..."
until kubectl cluster-info &> /dev/null; do
    sleep 2
done

# Install Argo CD
echo "Installing Argo CD..."
kubectl create namespace argocd
kubectl apply -n argocd -f ../confs/install.yaml
kubectl get pods -n argocd
echo "Argo CD installed successfully."
