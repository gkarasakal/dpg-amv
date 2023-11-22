# DPG - AMV Assignment

To manage infrastructure on AWS by Terraform

# Terraform
Terraform `v1.6.4` is required, otherwise commands are not going to be executed due to the version mismatch.

## Install Terraform
### macOS
tfswitch can be installed with homebrew and in case you have installed `terraform` with brew before, remove it and let `tfswitch` manage the versions.
```
# Update formulaes first
brew update

# Install tfswitch
brew install warrensbox/tap/tfswitch

# Install and enable version
tfswitch 1.6.4

# Double check enabled version
terraform --version
```

## Deployment

### Documentation for AWS Login to access relevant AWS account
* https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html

### How to run Terraform

* **environment_name:** acceptance | production

```
# Initialize Terraform with backend config
terraform -chdir=./main/infrastructure init"

# Create/Select workspace
terraform workspace new <environment_name>
terraform workspace select <environment_name>

# Plan deployment
terraform -chdir=./main/infrastructure plan

# Execute and apply plan
terraform -chdir=./main/infrastructure apply
```
### Documentation for Terraform Stages
* https://www.terraform.io/cloud-docs/run/states
