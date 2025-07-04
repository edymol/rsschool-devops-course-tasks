#!/bin/bash
set -e

# --- Prerequisite Checks ---
echo "Checking Docker status..."
if ! docker info &> /dev/null; then
    echo "Error: Docker is not running." && exit 1
fi
echo "Docker is running."

echo "Checking Minikube cluster status..."
if ! minikube status | grep -q "apiserver: Running"; then
    echo "Minikube cluster is not running. Starting..."
    minikube start --driver=docker --cpus=2 --memory=4096 || { echo "Error: Failed to start Minikube"; exit 1; }
fi
kubectl config use-context minikube || { echo "Error: Failed to set Minikube context"; exit 1; }
echo "Minikube cluster is running."

# --- Main Script ---

# 1. Clean up previous installations
echo "Cleaning up any existing application resources..."
kubectl delete deployment,service -l app=my-react-app --ignore-not-found=true

# 2. Create Kubernetes Manifest File
echo "Creating Kubernetes deployment manifest..."
cat << EOF > react-app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-react-app-deployment
  labels:
    app: my-react-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-react-app
  template:
    metadata:
      labels:
        app: my-react-app
    spec:
      containers:
      - name: my-react-app
        # <-- MODIFIED: Using your new image
        image: edydockers/rsschool:latest
        ports:
        - containerPort: 9999
---
apiVersion: v1
kind: Service
metadata:
  name: my-react-app-service
  labels:
    app: my-react-app
spec:
  type: ClusterIP
  selector:
    app: my-react-app
  ports:
  - port: 9999
    targetPort: 9999
EOF

# 3. Deploy the Application
echo "Deploying the application..."
kubectl apply -f react-app-deployment.yaml

# 4. Verify the installation
echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=Available deployment/my-react-app-deployment --timeout=5m

echo "Application deployed successfully!"

# 5. Access the Application
echo "--------------------------------------------------"
echo "To access your application, run this in a new terminal:"
# <-- MODIFIED: The port-forward command now maps to port 9999
echo "kubectl port-forward service/my-react-app-service 8080:9999"
echo "Then open http://localhost:8080 in your browser."