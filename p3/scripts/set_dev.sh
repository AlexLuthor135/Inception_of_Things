#!/bin/bash
set -e

export ARGOCD_SERVER=localhost:8081
argocd login $ARGOCD_SERVER --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode) --insecure
kubectl create namespace dev
argocd repo add https://github.com/AlexLuthor135/Inception_of_Things.git
argocd app create my-app \
  --repo https://github.com/AlexLuthor135/Inception_of_Things.git \
  --path k8s \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev
argocd app sync my-app
kubectl get pods -n dev
kubectl apply -f ../confs/alappas-deployment.yaml -n dev
echo "Application deployed successfully."