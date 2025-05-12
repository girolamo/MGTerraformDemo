# MGTerraformDemo

## Introduction

This project demonstrates how to deploy a simple React website to Azure Front Door (CDN) using Terraform.
The React code is only a placeholder and serves demonstration purposes.

**Goal:** Deploy a React app to Azure using Terraform, keeping the Terraform state in the cloud.
**Note:** This project is part of a personal portfolio.

## Tech Stack

You need to have the following tools installed on your machine:

* Git
* Terraform
* Azure CLI
* Node.js

This project also uses:

* Bash
* Azure:

  * Resource Groups
  * Azure Front Door
  * Azure Storage Account (Blob Storage)
* React
* JavaScript, CSS, HTML

## Implementation

This project uses Bash scripts to run commands and automate steps.

### Step 1: Log in to Azure

Use Azure CLI to log in to your Azure account:

```bash
az login --tenant [TENANT_ID]
```

Then choose the appropriate subscription for deployment.

### Step 2: Set Up Remote Backend

Navigate to the following directory:

```bash
/MGTerraformDemo/AzureRemoteState/
```

Run the standard Terraform commands:

```bash
terraform init
terraform plan
terraform apply
```

Terraform will create remote storage for the state file and generate a local file called `backend.config`
that contains backend configuration. This file is required in the next step.

### Step 3: Deploy Infrastructure

Navigate to the infrastructure directory:

```bash
/MGTerraformDemo/Infrastructure/
```

Initialize Terraform with the backend config:

```bash
terraform init -backend-config="../AzureRemoteState/backend.config"
terraform plan
terraform apply
```

This will deploy all necessary Azure resources for the static web app.

### Step 4: Deploy the Web App

At this point, all Azure services required to host the static web app are ready.

Navigate to the website folder:

```bash
/MGTerraformDemo/Website/react-demo-website
```

Then run the deployment script:

```bash
./build_and_deploy_to_azure.sh.sh
```

After a successful deployment, you will get the URL to access the app.
