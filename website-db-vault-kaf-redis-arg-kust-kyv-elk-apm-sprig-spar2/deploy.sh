#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Deploying $PROJECT ===${NC}"

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}kubectl is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if kustomize is installed
if ! command -v kustomize &> /dev/null; then
    echo -e "${YELLOW}kustomize is not installed. Installing...${NC}"
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
    sudo mv kustomize /usr/local/bin/
fi

# Set namespace
echo -e "${YELLOW}Setting up namespace: $NAMESPACE${NC}"
kubectl create namespace $NAMESPACE 2>/dev/null || true

# Apply Kustomize
echo -e "${YELLOW}Applying Kustomize manifests...${NC}"
cd k8s

# Create temporary files with environment substitution
for file in *.yaml; do
    if [ -f "$file" ]; then
        envsubst < "$file" > "${file}.tmp"
        mv "${file}.tmp" "$file"
    fi
done

# Build and apply kustomization
kustomize build . | kubectl apply -f -
cd ..

# Wait for deployments
echo -e "${YELLOW}Waiting for deployments to be ready...${NC}"
sleep 20

# Check deployment status
echo -e "\n${BLUE}=== Deployment Status ===${NC}"
kubectl get deployments -n $NAMESPACE

echo -e "\n${BLUE}=== Services ===${NC}"
kubectl get services -n $NAMESPACE

echo -e "\n${BLUE}=== Pods ===${NC}"
kubectl get pods -n $NAMESPACE

echo -e "\n${GREEN}=== Deployment Complete! ===${NC}"
echo -e "Access points:"
echo -e "  - Spring App API: http://spring-app-service.$NAMESPACE.svc.cluster.local:8080"
echo -e "  - MongoDB: mongodb-service.$NAMESPACE.svc.cluster.local:27017"
echo -e "  - Kibana: http://kibana-service.$NAMESPACE.svc.cluster.local:5601"
echo -e "  - Spark Master: http://spark-master-service.$NAMESPACE.svc.cluster.local:8080"

echo -e "\n${YELLOW}To monitor the deployment:${NC}"
echo -e "  kubectl get all -n $NAMESPACE"
echo -e "  kubectl logs deployment/spring-app -n $NAMESPACE"
echo -e "  kubectl port-forward service/spring-app-service 8080:8080 -n $NAMESPACE"
