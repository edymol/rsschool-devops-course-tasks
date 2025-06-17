# Terraform VPC and Kubernetes Cluster Deployment

This document outlines the Terraform configuration for deploying a VPC with public and private subnets, a k3s Kubernetes cluster, and associated resources in AWS. It includes setup, access, workload deployment, verification steps, and a GitHub Actions pipeline for automation.

## Infrastructure Overview
The Terraform code configures:
- **VPC**: A Virtual Private Cloud in the `eu-west-1` region.
- **2 Public Subnets**: In different Availability Zones (AZs) for high availability.
- **2 Private Subnets**: In different AZs for secure resources.
- **Internet Gateway**: Enables internet access for public subnets.
- **Routing Configuration**:
    - Instances in all subnets can communicate with each other.
    - Instances in public subnets can reach external addresses and be reached from outside the VPC.
- **NAT Gateway**: Provides internet access for private subnets in a cost-effective manner.
- **Bastion Host**: An EC2 instance in a public subnet for secure SSH access to private subnet resources.
- **Security Groups and Network ACLs**: Restrict and control traffic to and from resources.
- **k3s Cluster**: A lightweight Kubernetes cluster deployed in private subnets.

## Prerequisites
- Terraform installed locally.
- AWS CLI configured with appropriate credentials.
- SSH key pair (`task2-bastion-key.pem`) for accessing the bastion host.
- GitHub repository with AWS credentials configured as secrets for the GitHub Actions pipeline.
- Internet access for k3s installation via `user_data`.

## Terraform Code Implementation
### Directory Structure
```
infrastructure/terraform/
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── others ...
├── .github/
│   ├── workflows/
│   │   ├── main.yml
```

### VPC Configuration (50 points)
The `modules/vpc/main.tf` file configures:
- **VPC**: Created with a CIDR block (e.g., `10.0.0.0/16`).
- **2 Public Subnets**: In different AZs (e.g., `eu-west-1a`, `eu-west-1b`) with CIDR blocks (e.g., `10.0.1.0/24`, `10.0.2.0/24`).
- **2 Private Subnets**: In different AZs with CIDR blocks (e.g., `10.0.3.0/24`, `10.0.4.0/24`).
- **Internet Gateway**: Attached to the VPC for internet access.
- **Routing Configuration**:
    - **Public Route Table**: Routes traffic from public subnets to the Internet Gateway (`0.0.0.0/0`).
    - **Private Route Table**: Routes traffic from private subnets to the NAT Gateway.
    - **Subnet Communication**: Default VPC routing allows instances in all subnets to communicate within the VPC.



### Code Organization (10 points)
- **Variables**: Defined in `modules/vpc/variables.tf` and `environments/dev/variables.tf` for reusability and customization (e.g., region, CIDR blocks, instance types).
- **Resource Separation**: Resources are modularized:
  ![Screenshot 2025-06-16 at 8 37 21 PM](https://github.com/user-attachments/assets/1d198813-5c0b-4024-b21a-29ccf2f02599)
  ![Screenshot 2025-06-16 at 8 39 02 PM](https://github.com/user-attachments/assets/764245ad-7f73-4f19-af40-176f71d2e3d5)
  ![Screenshot 2025-06-16 at 8 58 02 PM](https://github.com/user-attachments/assets/d770f759-8664-4051-a1ba-50622b25b74e)
  ![Screenshot 2025-06-16 at 9 02 23 PM](https://github.com/user-attachments/assets/d7f8afca-075f-42b4-8cf7-76dd6cca667d)
  ![Screenshot 2025-06-16 at 8 37 21 PM](https://github.com/user-attachments/assets/b0b03e8f-962d-4fc1-9ad6-0a175a1e1479)
  ![Screenshot 2025-06-16 at 8 39 02 PM](https://github.com/user-attachments/assets/8476ee89-1bcd-4528-bd7b-3b1fe7b8d248)
  ![Screenshot 2025-06-16 at 8 58 02 PM](https://github.com/user-attachments/assets/536c6cfb-427d-4cdd-8478-050012eb5a9e)
  ![Screenshot 2025-06-16 at 9 02 23 PM](https://github.com/user-attachments/assets/4017aab4-0d81-40a0-a52b-9c74dfbdaaa6)
  ![Screenshot 2025-06-15 at 10 57 21 PM](https://github.com/user-attachments/assets/28da1f2b-98ad-42e4-a628-7971b4c9f917)
  ![Screenshot 2025-06-15 at 11 01 21 PM](https://github.com/user-attachments/assets/7ffafbd8-34dc-4e3f-92ed-6d71df5660e7)
  ![Screenshot 2025-06-15 at 11 01 28 PM](https://github.com/user-attachments/assets/0163d6a2-2c14-4e30-9dfa-310ef77e50a6)
  ![Screenshot 2025-06-15 at 11 02 52 PM](https://github.com/user-attachments/assets/f3aeb7ed-1738-4574-9929-52dca324e1d6)


- `modules/vpc/` handles VPC, subnets, gateways, and routing.
- `modules/ec2/` handles EC2 instances (bastion and k3s nodes).
- `environments/dev/` ties modules together for the dev environment.

### Additional Tasks (30 points)
#### Security Groups and Network ACLs (5 points)
- **Security Groups**:
    - Bastion: Allows inbound SSH (port 22) from specific IPs (e.g., `0.0.0.0/0` for testing, restrict in production).
    - k3s Nodes: Allows intra-cluster communication (ports 6443, 10250) and SSH from the bastion.
- **Network ACLs**:
    - Public Subnets: Allow HTTP/HTTPS (80, 443) and SSH (22) inbound/outbound.
    - Private Subnets: Allow necessary k3s ports and outbound internet access via NAT.

#### Bastion Host (5 points)
- An EC2 instance in a public subnet, configured in `modules/ec2/main.tf`.
- Used for SSH access to private subnet instances (k3s nodes).
- Secured with a security group allowing SSH only from authorized IPs.

#### NAT Gateway (10 points)
- A single NAT Gateway in one public subnet (e.g., `eu-west-1a`) for cost efficiency.
- Private subnets route outbound traffic (`0.0.0.0/0`) through the NAT Gateway.
- Ensures instances in private subnets can access external resources (e.g., for k3s installation).

#### Documentation (5 points)
- This README documents the infrastructure setup, usage, and verification steps.

#### Submission (5 points)
- A GitHub Actions pipeline is defined in `.github/workflows/terraform.yml` to automate Terraform tasks.

## GitHub Actions Pipeline
The pipeline automates Terraform deployment:
1. **Trigger**: On push to any branch or manual dispatch.
2. **Steps**:
    - Checks out the repository.
    - Runs `terraform fmt -check` for formatting validation.
    - Initializes Terraform with an S3 backend: `terraform init`.
    - Previews changes: `terraform plan`.
    - Applies changes on push to `main` or manual dispatch: `terraform apply`.
3. **Monitor**: Check the **Actions** tab in the GitHub repository for run status.

### Pipeline Configuration
```yaml
name: Terraform CI/CD
on:
  push:
    branches:
      - '*'
  workflow_dispatch:
jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.0
      - name: Terraform Format
        run: terraform fmt -check
      - name: Terraform Init
        run: terraform init -backend-config="bucket=${{ secrets.TF_STATE_BUCKET }}" -backend-config="key=terraform.tfstate" -backend-config="region=eu-west-1"
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      - name: Terraform Plan
        run: terraform plan
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main' || github.event_name == 'workflow_dispatch'
        run: terraform apply -auto-approve
```

## Manual Deployment (Optional)
1. Navigate to `environments/dev/`:
   ```bash
   cd environments/dev
   ```
2. Initialize Terraform with the S3 backend:
   ```bash
   terraform init -backend-config="kms_key_id=<Your KMS Key ID>"
   ```
3. Preview changes:
   ```bash
   terraform plan
   ```
4. Apply changes:
   ```bash
   terraform apply
   ```

## Accessing the k3s Cluster
### Option 1: Via Bastion Host
1. SSH into the bastion host:
   ```bash
   ssh -i task2-bastion-key.pem ec2-user@<Bastion Public IP>
   ```
2. Copy the kubeconfig file from a k3s node:
   ```bash
   scp -i task2-bastion-key.pem ec2-user@<K3s Node Private IP>:/etc/rancher/k3s/k3s.yaml ./kubeconfig
   ```
3. Update the `kubeconfig` file to use the bastion’s public IP and port `6443`.
4. Verify cluster access:
   ```bash
   kubectl --kubeconfig=kubeconfig get nodes
   kubectl --kubeconfig=kubeconfig get all --all-namespaces
   ```

### Option 2: Via Local Computer
1. Set up an SSH tunnel:
   ```bash
   ssh -i task2-bastion-key.pem -L 6443:localhost:6443 ec2-user@<Bastion Public IP>
   ```
2. Update the `kubeconfig` file to use `localhost:6443`.
3. Verify cluster access:
   ```bash
   kubectl --kubeconfig=kubeconfig get nodes
   ```

## Deploying a Workload
1. From the bastion host or local machine with the SSH tunnel, deploy a sample pod:
   ```bash
   kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml
   ```
2. Verify the deployment:
   ```bash
   kubectl --kubeconfig=kubeconfig get all --all-namespaces
   ```
   Expect to see an "nginx" pod in the `default` namespace.

## Verification (10 points)
- **Terraform Plan**: Execute `terraform plan` to confirm successful planning with no errors.
- **Resource Map**: [Insert screenshot of AWS Console -> VPC -> Your VPCs -> your_VPC_name -> Resource map here]
- **Cluster Verification**:
    - Run `kubectl get nodes` to confirm two nodes: `task2-k3s-node-1` and `task2-k3s-node-2`.
    - Run `kubectl get all --all-namespaces` to confirm the "nginx" pod is running.

## Screenshots
- **kubectl get nodes**: [Insert screenshot of `kubectl get nodes` output here]
- **kubectl get all --all-namespaces**: [Insert screenshot of `kubectl get all --all-namespaces` output here]
- **VPC Resource Map**: [Insert screenshot of VPC resource map from AWS Console here]

## Notes
- **AMI IDs**: Ensure AMI IDs in `modules/ec2/main.tf` are valid for `eu-west-1`. Adjust if deploying to another region.
- **Security**: Securely store `task2-bastion-key.pem` and restrict SSH access to the bastion host (update security group to allow specific IPs in production).
- **k3s Installation**: The k3s cluster is installed via `user_data` in EC2 instances. Ensure private subnets can access the internet via the NAT Gateway.
- **Cost Optimization**: A single NAT Gateway is used to reduce costs while providing internet access to private subnets.

## Next Steps
1. **Update README**: Save this content as `infrastructure/terraform/vpc/README.md` or `README.md` in the repository root.
2. **Deploy and Capture Screenshots**:
    - Run `terraform -chdir=environments/dev apply`.
    - Capture screenshots of:
        - `kubectl get nodes`
        - `kubectl get all --all-namespaces`
        - AWS Console VPC resource map
3. **Submit PR**:
    - Push changes to a branch named `task-3`.
    - Include the README, Terraform code, GitHub Actions workflow, and screenshots in the pull request.

For assistance with screenshots, Terraform code details, or creating the pull request, please let me know!
