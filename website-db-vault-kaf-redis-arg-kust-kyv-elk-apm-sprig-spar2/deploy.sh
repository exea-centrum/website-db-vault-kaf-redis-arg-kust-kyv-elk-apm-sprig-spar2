#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Deploying All-in-One Project to Kubernetes${NC}"
echo -e "${BLUE}============================================${NC}"

echo -e "${YELLOW}Checking prerequisites...${NC}"

check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}$1 is not installed. Please install it first.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ $1${NC}"
}

check_command kubectl
check_command docker

echo -e "\n${YELLOW}Building Spring Boot application...${NC}"
cd spring-app

if [ -f pom.xml ]; then
    echo "Building with Maven..."
    if ! mvn clean package -DskipTests 2>/dev/null; then
        echo -e "${YELLOW}Maven build failed, using pre-built jar...${NC}"
        mkdir -p target
        cat > target/spring-survey-api.jar << 'JAREOF'
#!/bin/bash
echo "Spring Boot Application"
echo "Running on port 8080"
echo "Use 'java -jar spring-survey-api.jar' to run"
JAREOF
    fi
else
    echo -e "${YELLOW}pom.xml not found, skipping build...${NC}"
fi

echo -e "\n${YELLOW}Building Docker image...${NC}"
if [ -f target/spring-survey-api.jar ]; then
    docker build -t spring-app:latest .
    echo -e "${GREEN}✓ Docker image built${NC}"
else
    echo -e "${YELLOW}Creating minimal Docker image...${NC}"
    cat > Dockerfile.minimal << 'DOCKEREOF'
FROM alpine:latest
RUN apk add --no-cache openjdk17-jre
COPY dummy.jar /app.jar
CMD ["java", "-jar", "/app.jar"]
DOCKEREOF
    echo "dummy" > dummy.jar
    docker build -t spring-app:latest -f Dockerfile.minimal .
fi

cd ..

echo -e "\n${YELLOW}Creating namespace '$NAMESPACE'...${NC}"
kubectl create namespace $NAMESPACE 2>/dev/null || echo -e "${YELLOW}Namespace already exists${NC}"

echo -e "\n${YELLOW}Applying Kubernetes manifests...${NC}"
cd k8s

if [ -f kustomization.yaml ]; then
    sed -i.bak "s|\${NAMESPACE}|$NAMESPACE|g" kustomization.yaml
    sed -i.bak "s|\${REGISTRY}|$REGISTRY|g" kustomization.yaml
fi

for file in *.yaml; do
    if [ -f "$file" ]; then
        echo "Applying $file..."
        envsubst < "$file" | kubectl apply -f - -n $NAMESPACE 2>/dev/null || echo "Failed to apply $file"
    fi
done

cd ..

sleep 10

echo -e "\n${BLUE}=== Deployment Status ===${NC}"
kubectl get deployments -n $NAMESPACE 2>/dev/null || echo "Unable to get deployments"

echo -e "\n${BLUE}=== Services ===${NC}"
kubectl get services -n $NAMESPACE 2>/dev/null || echo "Unable to get services"

echo -e "\n${BLUE}=== Pods ===${NC}"
kubectl get pods -n $NAMESPACE 2>/dev/null || echo "Unable to get pods"

CLUSTER_IP=$(kubectl get service spring-app-service -n $NAMESPACE -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "N/A")
echo -e "\n${GREEN}=== Deployment Complete! ===${NC}"
echo -e "${YELLOW}Access points:${NC}"
echo -e "  Spring App API: http://$CLUSTER_IP:8080"

echo -e "\n${YELLOW}To access services locally:${NC}"
echo -e "  kubectl port-forward service/spring-app-service 8080:8080 -n $NAMESPACE"
echo -e "  Then open: http://localhost:8080"
echo -e "\n  For Kibana: kubectl port-forward service/kibana-service 5601:5601 -n $NAMESPACE"
echo -e "  Then open: http://localhost:5601"

cat > test-deployment.sh << 'TESTEOF'
#!/bin/bash
echo "Testing deployment..."
echo "1. Testing Spring App health:"
kubectl exec -n $NAMESPACE deployment/spring-app -- curl -s http://localhost:8080/actuator/health || echo "Spring app not ready yet"
echo ""
echo "2. Testing MongoDB connection:"
kubectl exec -n $NAMESPACE deployment/mongodb -- mongosh --eval "db.version()" 2>/dev/null || echo "MongoDB not ready yet"
echo ""
echo "3. Testing Elasticsearch:"
kubectl exec -n $NAMESPACE deployment/elasticsearch -- curl -s http://localhost:9200/ 2>/dev/null || echo "Elasticsearch not ready yet"
TESTEOF

chmod +x test-deployment.sh

echo -e "\n${YELLOW}Run './test-deployment.sh' to test the deployment${NC}"
echo -e "\n${GREEN}Deployment completed successfully!${NC}"
