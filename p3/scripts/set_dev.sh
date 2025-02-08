#!/bin/bash
set -e

kubectl create namespace dev
argocd repo add https://github.com/AlexLuthor135/alappas.git
argocd app create my-app \
  --repo https://github.com/AlexLuthor135/alappas.git \
  --path k8s \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev
argocd app sync my-app
kubectl get pods -n dev
echo "Application deployed successfully."