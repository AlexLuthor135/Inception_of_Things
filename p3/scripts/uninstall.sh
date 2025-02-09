#!/bin/bash
set -e

# kubectl delete namespace argocd
# kubectl delete namespace dev

# kubectl get nodes -o json | jq '.items[].spec.taints'
# kubectl taint nodes node1 node.kubernetes.io/disk-pressure-
# docker rm -f $(docker ps -aq)

# Delete the Argo CD application
# argocd app delete my-app --yes

# Delete the dev namespace
kubectl delete namespace dev
kubectl delete namespace argocd
docker rm -f $(docker ps -aq)

docker image prune -a -f
docker volume prune -f
docker network prune -f
docker system prune -a -f

echo "Project turned off successfully."