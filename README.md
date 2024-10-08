# rsschool-devops-course-tasks

## Setup identify provider and GithubActionsRole

1. Created a new identity provider for github.
2. Created a new role with required policy to access my github repo and attached the required permissions. The configuration can be found in iam_role.tf file.

### Setup github actions
1. Created a workflow for github that will be triggered any time we have a PR to main or push to the main branch.
2. Created repo secrets to store AWS KEY_ID and SECRET.

### Confirmed the workflow works.
The logfile of a workflow is also attached as part of the PR.
