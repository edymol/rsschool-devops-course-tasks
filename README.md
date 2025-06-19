# RS School - DevOps Course Task 1

This repository contains the infrastructure as code for deploying an S3 bucket for Terraform state and an IAM role for GitHub Actions automation.

## 🚀 Infrastructure

The infrastructure is managed by Terraform and is organized into modules and environments.

-   **`terraform/s3`**: A module to create an S3 bucket.
-   **`terraform/iam`**: A module to create an IAM role for GitHub Actions with OIDC federation.
-   **`environments/dev`**: The root configuration for the 'dev' environment.

## ⚙️ Initial Setup

To deploy this infrastructure for the first time, you need to have the AWS CLI and Terraform installed and configured.

1.  **Comment out the `backend.tf` content** in `environments/dev/backend.tf`. Terraform cannot reference a backend that does not exist yet.
2.  **Run `terraform init` and `terraform apply`** from the `environments/dev` directory to create the S3 bucket and the IAM role.
    ```bash
    cd environments/dev
    terraform init
    terraform apply
    ```
3.  **Uncomment the `backend.tf` content**.
4.  **Run `terraform init` again**. Terraform will prompt you to migrate your state to the newly created S3 backend. Type `yes`.

    ```bash
    terraform init -migrate-state
    ```

After these steps, the Terraform state will be securely stored in the S3 bucket, and all subsequent changes can be managed via the GitHub Actions workflow.

## 🤖 CI/CD Pipeline

This project uses GitHub Actions for continuous integration and deployment. The workflow is defined in `.github/workflows/terraform.yml`.

-   **Triggers**: The workflow runs on any `push` or `pull_request` to the `main` branch.
-   **Jobs**:
    -   `terraform-check`: Ensures the code is correctly formatted.
    -   `terraform-plan`: Creates a Terraform plan. This job runs on all PRs and pushes.
    -   `terraform-apply`: Applies the Terraform plan. This job only runs on a `push` to the `main` branch.

### Secure Authorization

The connection to AWS is secured using OIDC, which avoids the need for long-lived access keys. An IAM role (`GithubActionsRole`) is configured with a trust policy that only allows access from this specific GitHub repository.