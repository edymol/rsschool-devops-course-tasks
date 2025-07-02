# Jenkins Deployment with Helm and JCasC

This project contains a script and configuration to automatically deploy a Jenkins instance on a local Minikube cluster.

## Features

- Deploys Jenkins using the official Helm chart.
- Configures Jenkins using Jenkins Configuration as Code (JCasC).
- Automatically creates a "Hello World" freestyle job.
- Sets up matrix-based security for an admin user.

## How to Run

1.  Ensure you have Minikube, Docker, kubectl, and Helm installed.
2.  Start Minikube: `minikube start`
3.  Make the script executable: `chmod +x deploy-jenkins.sh`
4.  Run the script: `./deploy-jenkins.sh`

## Accessing Jenkins

After the script succeeds, run the following command in a new terminal:
`kubectl --namespace jenkins port-forward svc/jenkins 8080:8080`

Open your browser to `http://localhost:8080`. The admin password will be printed by the script upon successful deployment.