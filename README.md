# Jenkins Deployment via Helm on Minikube

This project automates the deployment of a fully configured Jenkins instance on a local Minikube cluster using a bash script and Helm.

## Prerequisites

- Docker
- Minikube
- kubectl
- Helm

## Installation and Deployment

The entire deployment process is handled by a single script.

1.  **Clone the repository.**
2.  **Make the script executable:**
    ```bash
    chmod +x deploy-jenkins.sh
    ```
3.  **Run the deployment script:**
    ```bash
    ./deploy-jenkins.sh
    ```
The script will perform the following actions:
- Start a Minikube cluster with appropriate resources.
- Create a `jenkins-values.yaml` file to configure the deployment.
- Install Jenkins using the official Helm chart.
- Configure Jenkins via JCasC to create a "Hello World" job and set up security.

## Accessing Jenkins

Once the script completes successfully, it will provide an admin password.

1.  **Forward the port to the Jenkins service:**
    ```bash
    kubectl --namespace jenkins port-forward svc/jenkins 8080:8080
    ```
2.  **Access the UI:** Open your browser to `http://localhost:8080`.
3.  **Log in** with the username `admin` and the password provided by the script.

## Verification

```agsl
kubectl get all --all-namespaces
NAMESPACE     NAME                                   READY   STATUS    RESTARTS   AGE
jenkins       pod/jenkins-0                          2/2     Running   0          16m
kube-system   pod/coredns-674b8bbfcf-7m7lv           1/1     Running   0          102m
kube-system   pod/etcd-minikube                      1/1     Running   0          102m
kube-system   pod/kube-apiserver-minikube            1/1     Running   0          102m
kube-system   pod/kube-controller-manager-minikube   1/1     Running   0          102m
kube-system   pod/kube-proxy-5m6fh                   1/1     Running   0          102m
kube-system   pod/kube-scheduler-minikube            1/1     Running   0          102m
kube-system   pod/storage-provisioner                1/1     Running   0          102m

NAMESPACE     NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
default       service/kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP                  102m
jenkins       service/jenkins         ClusterIP   10.102.227.92   <none>        8080/TCP                 16m
jenkins       service/jenkins-agent   ClusterIP   10.100.33.246   <none>        50000/TCP                16m
kube-system   service/kube-dns        ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP,9153/TCP   102m

NAMESPACE     NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   daemonset.apps/kube-proxy   1         1         1       1            1           kubernetes.io/os=linux   102m

NAMESPACE     NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/coredns   1/1     1            1           102m

NAMESPACE     NAME                                 DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/coredns-674b8bbfcf   1         1         1       102m

NAMESPACE   NAME                       READY   AGE
jenkins     statefulset.apps/jenkins   1/1     16m
```