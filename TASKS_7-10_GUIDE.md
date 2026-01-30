# Terraform Lab Tasks - Execution Guide

## Summary of Completed Tasks (✅ Tasks 1-6)

- **Task 1**: Terraform installed and validated ✅
- **Task 2**: Basic S3 bucket created with tags ✅
- **Task 3**: Variables and outputs implemented ✅
- **Task 4**: EC2 instance state inspection ready ✅
- **Task 5**: EC2 module created and called twice with different configs ✅
- **Task 6**: Data sources for AMI lookup implemented ✅

---

## Remaining Tasks (Tasks 7-10) - Execution Steps

### Task 7: Remote Backend Setup

**Purpose**: Store Terraform state remotely in S3 with DynamoDB locking.

**Steps**:

1. **Create backend infrastructure** (separate from main config):
   ```bash
   # First, create S3 and DynamoDB using backend-setup.tf
   terraform init
   terraform plan -out=backend.plan
   terraform apply backend.plan
   ```

2. **Note the outputs**:
   - S3 bucket name: `terraform-state-[ACCOUNT_ID]-us-east-1`
   - DynamoDB table name: `terraform-locks`

3. **Update main.tf backend block** (uncomment in main.tf):
   ```hcl
   backend "s3" {
     bucket         = "terraform-state-ACCOUNT_ID-us-east-1"
     key            = "lab-basic/dev/terraform.tfstate"
     region         = "us-east-1"
     dynamodb_table = "terraform-locks"
     encrypt        = true
   }
   ```

4. **Migrate state to remote**:
   ```bash
   terraform init -migrate-state
   # Type 'yes' to confirm migration
   ```

5. **Verify**:
   ```bash
   terraform state list
   # State should now be in S3
   ```

---

### Task 8: Workspaces for Environment Separation

**Purpose**: Manage separate infrastructure for dev, stage, and prod environments.

**Steps**:

1. **Create workspaces**:
   ```bash
   terraform workspace new dev
   terraform workspace new stage
   terraform workspace new prod
   ```

2. **List workspaces**:
   ```bash
   terraform workspace list
   ```

3. **Switch to dev workspace**:
   ```bash
   terraform workspace select dev
   ```

4. **Deploy resources**:
   ```bash
   terraform plan
   terraform apply
   ```

5. **Observe workspace-specific tagging**:
   - EC2 names now include workspace: `WebServer-dev`, `WebServer-stage`, `WebServer-prod`
   - Backend stores state separately: `lab-basic/dev/terraform.tfstate`, etc.

6. **Test another workspace**:
   ```bash
   terraform workspace select stage
   terraform apply  # Creates separate EC2 instances for stage
   ```

---

### Task 9: Provisioners for Remote Configuration

**Purpose**: Automatically install Nginx on EC2 instances after creation.

**Steps**:

1. **Prerequisites**:
   - Ensure you have an EC2 key pair created in AWS
   - Private key file at path specified in `terraform.tfvars` or variables
   - Update `terraform.tfvars`:
     ```hcl
     key_name          = "your-actual-key-pair-name"
     private_key_path  = "/path/to/your/private/key.pem"
     ```

2. **Deploy with provisioner**:
   ```bash
   terraform apply
   ```
   - The `remote-exec` provisioner will:
     - Update system packages
     - Install Nginx
     - Start and enable Nginx service

3. **Verify Nginx installation**:
   ```bash
   # Get the public IP from outputs
   WEB_SERVER_IP=$(terraform output -raw web_server_ip 2>/dev/null || echo "")
   
   # Test Nginx (wait 2-3 minutes for provisioner to complete)
   curl http://$WEB_SERVER_IP
   # Should return Nginx welcome page
   ```

4. **Check via SSH**:
   ```bash
   ssh -i /path/to/key.pem ec2-user@<PUBLIC_IP>
   sudo systemctl status nginx
   ```

---

### Task 10: Lifecycle Rules and Resource Protection

**Purpose**: Protect critical resources from accidental deletion.

**Steps**:

1. **Enable resource protection**:
   - In `modules/ec2-basic/main.tf`, find the lifecycle block:
   ```hcl
   lifecycle {
     prevent_destroy = false  # Change to TRUE
   }
   ```

2. **Test protection** (with prevent_destroy = true):
   ```bash
   terraform destroy
   # Should see error: "Resource has prevent_destroy set, but the plan requests delete"
   ```

3. **Verify it's working**:
   - Try destroying again
   - You should see the protection message confirming lifecycle rules work

4. **Disable protection for cleanup** (change back to false):
   ```hcl
   lifecycle {
     prevent_destroy = false  # Set to FALSE
   }
   ```

5. **Perform cleanup**:
   ```bash
   terraform destroy
   # Confirm the destruction
   ```

---

## Important Notes

### Key Names & Path Issues
- Replace `my-keypair` with your actual AWS key pair name
- Replace `~/.ssh/my-keypair.pem` with actual path to your private key
- Windows paths: Use `C:\\Users\\YourUser\\.ssh\\key.pem` or use forward slashes

### Provisioner Troubleshooting
- Provisioners only run on resource creation
- If instances don't allow SSH, check security groups allow port 22
- EC2 user for Amazon Linux 2 is `ec2-user`
- For Ubuntu AMI, user is `ubuntu`

### Backend Troubleshooting
- If migration fails, check S3 bucket exists and is accessible
- Ensure AWS credentials are configured
- DynamoDB table must exist before terraform init

### Workspace Management
- Switching workspaces: `terraform workspace select [workspace-name]`
- Delete workspace: `terraform workspace delete [workspace-name]`
- Backend stores separate state per workspace

---

## Quick Command Reference

```bash
# Validation
terraform validate
terraform fmt

# Planning & Applying
terraform plan -out=tfplan
terraform apply tfplan
terraform destroy

# State Management
terraform state list
terraform state show [resource]
terraform refresh

# Workspaces
terraform workspace list
terraform workspace new [name]
terraform workspace select [name]
terraform workspace delete [name]

# Backend
terraform init -migrate-state
terraform state pull  # View remote state locally

# Outputs
terraform output
terraform output [output_name]
```

---

## Cleanup Guide (When Finished)

```bash
# 1. Destroy all resources in all workspaces
terraform workspace select dev && terraform destroy
terraform workspace select stage && terraform destroy
terraform workspace select prod && terraform destroy

# 2. Delete workspaces (after destroying)
terraform workspace select default
terraform workspace delete dev
terraform workspace delete stage
terraform workspace delete prod

# 3. Destroy backend infrastructure
# Run separately with backend-setup.tf
terraform destroy
```
