#!/bin/bash
set -e

if ! k3d cluster list | grep -q my-cluster; then
    echo "K3d cluster is not running. Creating it now..."
    k3d cluster create my-cluster --servers 1 --agents 1 --port 8080:80@loadbalancer
fi

echo "Waiting for Kubernetes API to be ready..."
until kubectl cluster-info &> /dev/null; do
    sleep 2
done

# Install Argo CD
echo "Installing Argo CD..."
kubectl create namespace argocd
kubectl apply -n argocd -f ../confs/install.yaml

# Wait for all Argo CD pods to be running
echo "Waiting for all Argo CD pods to be running..."
while [[ $(kubectl get pods -n argocd -o jsonpath='{.items[*].status.containerStatuses[*].ready}' | tr ' ' '\n' | grep -c "true") -ne $(kubectl get pods -n argocd --no-headers | wc -l) ]]; do
    sleep 2
done

kubectl get pods -n argocd
echo "Argo CD installed successfully."

# Port-forward Argo CD server
echo "Port-forwarding Argo CD server..."
kubectl port-forward svc/argocd-server -n argocd 8081:443 &
echo "Argo CD server is available at https://localhost:8081"

# Set Argo CD server address
export ARGOCD_SERVER=localhost:8081
echo "Argo CD server address set to $ARGOCD_SERVER"

# Wait for port-forwarding to be ready
sleep 5