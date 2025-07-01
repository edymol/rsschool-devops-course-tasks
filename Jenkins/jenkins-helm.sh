#!/bin/bash

# Exit on any error
set -e

# --- Environment and Prerequisite Checks (No changes needed here) ---
# ... (The initial functions for checking docker, network, etc., are well-written)
check_docker() {
    echo "Checking Docker status..."
    if ! docker info &> /dev/null; then
        echo "Error: Docker is not running or accessible. Please start Docker and try again."
        exit 1
    fi
    DOCKER_MEMORY=$(docker info --format '{{.MemTotal}}')
    DOCKER_CPUS=$(docker info --format '{{.NCPU}}')
    if [ "$DOCKER_MEMORY" -lt 4294967296 ]; then
        echo "Warning: Docker has less than 4GB memory allocated. This may be insufficient for Jenkins."
    fi
    if [ "$DOCKER_CPUS" -lt 2 ]; then
        echo "Warning: Docker has less than 2 CPUs allocated."
    fi
    echo "Docker is running."
}

check_network() {
    echo "Checking network connectivity..."
    for url in "https://charts.bitnami.com/bitnami" "https://charts.jenkins.io"; do
        if ! curl -Is "$url" &> /dev/null; then
            echo "Error: Cannot reach $url. Check your internet connection or DNS settings."
            exit 1
        fi
    done
    echo "Network connectivity to chart repositories is OK."
}

check_and_start_minikube() {
    echo "Checking Minikube installation..."
    if ! command -v minikube &> /dev/null; then
        echo "Minikube is not installed. Please install it first."
        exit 1
    fi

    echo "Checking Minikube cluster status..."
    if ! minikube status | grep -q "apiserver: Running"; then
        echo "Minikube cluster is not running. Attempting to start..."
        minikube start --driver=docker --cpus=4 --memory=4096 || { echo "Error: Failed to start Minikube"; exit 1; }
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
echo "Cleaning up any existing resources..."
helm uninstall jenkins --namespace jenkins &> /dev/null || true
kubectl delete namespace jenkins &> /dev/null || true
echo "Waiting for namespace to terminate..."
sleep 15

# 3. Create Jenkins Helm values file with CORRECTIONS
echo "Creating Jenkins Helm values file..."
cat << EOF > jenkins-values.yaml
controller:
  installPlugins:
    - kubernetes:4264.v8a_8d225b_1223
    - workflow-aggregator:596.v8c21d06d92c7
    - git:5.2.2
    - configuration-as-code:1810.v9b_50d22e2597
    - job-dsl:1.87 # <-- FIX 1: Added the required job-dsl plugin

  JCasC:
    enabled: true
    configScripts:
      hello-world-job: |
        jobs:
          - script: >
              # <-- FIX 2: Corrected the job definition syntax
              freeStyleJob('hello-world') {
                description('A simple Hello World freestyle job')
                steps {
                  shell('echo "Hello world"')
                }
              }
      security-config: |
        securityRealm:
          local:
            allowsSignup: false
        authorizationStrategy:
          globalMatrix:
            permissions:
              - "Overall/Administer:admin"
              - "Overall/Read:authenticated"
              - "Job/Read:authenticated"
              - "Job/Build:authenticated"

  service:
    type: ClusterIP
    port: 8080

  persistence:
    enabled: true
    size: 4Gi
EOF

# 4. Install Jenkins using Helm
echo "Installing Jenkins..."
helm repo add jenkins https://charts.jenkins.io
helm repo update
kubectl create namespace jenkins
helm install jenkins jenkins/jenkins \
  --namespace jenkins \
  -f jenkins-values.yaml \
  --timeout 10m \
  --wait

# 5. Verify the installation
echo "Verifying Jenkins installation..."
POD_STATUS=$(kubectl get pods -n jenkins -l app.kubernetes.io/component=jenkins-controller -o jsonpath='{.items[0].status.phase}')
if [ "$POD_STATUS" != "Running" ]; then
    echo "Error: Jenkins pod is not in a 'Running' state. Current status: $POD_STATUS"
    echo "--- Pod Description ---"
    kubectl describe pod -n jenkins -l app.kubernetes.io/component=jenkins-controller
    echo "--- Pod Logs ---"
    kubectl logs -n jenkins -l app.kubernetes.io/component=jenkins-controller --all-containers
    exit 1
fi

echo "Jenkins pod is running successfully!"

# 6. Access Jenkins and get credentials
echo "Accessing Jenkins..."
ADMIN_PASSWORD=$(kubectl -n jenkins get secret jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 -d)
echo "--------------------------------------------------"
echo "Jenkins Admin User: admin"
echo "Jenkins Admin Password: $ADMIN_PASSWORD"
echo "--------------------------------------------------"
echo "To access Jenkins, run this in a new terminal:"
echo "kubectl --namespace jenkins port-forward svc/jenkins 8080:8080"
echo "Then open http://localhost:8080 in your browser."