#!/bin/bash

# Exit on any error
set -e

# --- Environment and Prerequisite Checks ---
check_docker() {
    echo "Checking Docker status..."
    if ! docker info &> /dev/null; then
        echo "Error: Docker is not running or accessible. Please start Docker and try again."
        exit 1
    fi
    echo "Docker is running."
}

check_network() {
    echo "Checking network connectivity..."
    if ! curl -Is "https://charts.jenkins.io" &> /dev/null; then
        echo "Error: Cannot reach https://charts.jenkins.io. Check your internet connection."
        exit 1
    fi
    echo "Network connectivity is OK."
}

check_and_start_minikube() {
    echo "Checking Minikube installation..."
    if ! command -v minikube &> /dev/null; then
        echo "Minikube is not installed. Please install it first."
        exit 1
    fi

    echo "Checking Minikube cluster status..."
    if ! minikube status | grep -q "apiserver: Running"; then
        echo "Minikube cluster is not running. Attempting to start with recommended resources..."
        minikube start --driver=docker --cpus=4 --memory=6144 --disk-size=20g || { echo "Error: Failed to start Minikube"; exit 1; }
        echo "Waiting for cluster to be ready..."
        sleep 30
    fi
    kubectl config use-context minikube || { echo "Error: Failed to set Minikube context"; exit 1; }
    echo "Minikube cluster is running and reachable."
}

# --- Main Script ---

# 1. Prerequisite Checks
check_docker
check_network
check_and_start_minikube

# 2. Clean up previous installations
echo "Cleaning up any existing Jenkins resources..."
helm uninstall jenkins --namespace jenkins &> /dev/null || true
if kubectl get namespace jenkins &> /dev/null; then
    echo "Waiting for previous jenkins namespace to terminate..."
    kubectl delete namespace jenkins --wait=true &> /dev/null || true
fi

# 3. Create the final Jenkins Helm values file
echo "Creating final jenkins-values.yaml file..."
cat << EOF > jenkins-values.yaml
controller:
  persistence:
    securityContext:
      fsGroup: 1000
    storageClass: "standard" # Explicitly use Minikube's default
    size: 5Gi

  # Simplified plugin list for stability, with matrix-auth added
  installPlugins:
    - kubernetes
    - git
    - job-dsl
    - configuration-as-code
    - matrix-auth # <-- FIX: Added the missing security plugin

  # Correct JCasC configuration
  JCasC:
    configScripts:
      main-config: |
        jobs:
          - script: >
              freeStyleJob('hello-world-freestyle') {
                description('A simple freestyle job created by JCasC')
                steps {
                  shell('echo "Hello world"')
                }
              }
        jenkins:
          securityRealm:
            local:
              allowsSignup: false
              users:
                - id: "admin"
                  password: "password123"
          authorizationStrategy:
            globalMatrix:
              permissions:
                - "Overall/Administer:admin"
                - "Overall/Read:authenticated"
EOF

# 4. Install Jenkins using Helm
echo "Installing Jenkins..."
helm repo add jenkins https://charts.jenkins.io
helm repo update
kubectl create namespace jenkins

# Let Helm handle the PVC creation and wait for the deployment to be ready
helm install jenkins jenkins/jenkins \
  --namespace jenkins \
  -f jenkins-values.yaml \
  --timeout 15m \
  --wait # <-- This tells Helm to wait for everything, including the PVC

# 5. Verify the installation
echo "Verifying Jenkins installation..."
POD_STATUS=$(kubectl get pods -n jenkins -l app.kubernetes.io/component=jenkins-controller -o jsonpath='{.items[0].status.phase}')
if [ "$POD_STATUS" != "Running" ]; then
    echo "Error: Jenkins pod is not in a 'Running' state. Current status: $POD_STATUS"
    exit 1
fi

echo "Jenkins pod is running successfully!"

# 6. Access Jenkins and get credentials
echo "Accessing Jenkins..."
# Note: The password in JCasC is 'password123', but Helm also creates a secret.
# For consistency, we use the JCasC password. If that fails, get the secret.
echo "--------------------------------------------------"
echo "Jenkins Admin User: admin"
echo "Jenkins Admin Password: password123 (from JCasC)"
echo "--------------------------------------------------"
echo "To access Jenkins, run this in a new terminal:"
echo "kubectl --namespace jenkins port-forward svc/jenkins 8080:8080"
echo "Then open http://localhost:8080 in your browser."