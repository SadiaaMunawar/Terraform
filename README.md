# DevOps Lab - Terraform + AWS Infrastructure

A comprehensive Infrastructure as Code (IaC) project demonstrating Terraform best practices with AWS services.

## 🎯 Project Overview

This project showcases a complete DevOps setup using Terraform to provision and manage AWS infrastructure, including:

- **EC2 Instances** - Running Amazon Linux 2 with Nginx
- **Dynamic Websites** - Deployed using provisioners
- **Remote State Management** - S3 backend with DynamoDB locking
- **Multi-Environment Setup** - Dev, Stage, and Prod workspaces
- **Reusable Modules** - EC2 module for infrastructure consistency
- **Infrastructure as Code** - Fully version-controlled infrastructure

---

## 📋 Requirements

### Prerequisites:

- **Terraform** >= 1.0 (Installation guide: https://www.terraform.io/downloads)
- **AWS CLI** (Installation guide: https://aws.amazon.com/cli/)
- **AWS Account** with appropriate permissions
- **EC2 Key Pair** created in your AWS account
- **SSH Client** (comes with most systems, PuTTY for Windows)

### Setup AWS Credentials:

```bash
# Configure AWS credentials
aws configure

# You'll need:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region (us-east-1)
# - Default output format (json)
```

---

## 🚀 Quick Start

### 1. Clone/Setup Repository

```bash
cd "C:\Users\LENOVO\OneDrive\Documents\5th Semester\DEVOPS\lab-basic"
```

### 2. Configure Variables

Edit `terraform.tfvars`:

```hcl
key_name          = "your-ec2-keypair-name"
private_key_path  = "~/.ssh/your-keypair.pem"
website_source_dir = "./website"
aws_region        = "us-east-1"
```

### 3. Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Create and select dev workspace
terraform workspace new dev
terraform workspace select dev

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

### 4. Access Your Website

```bash
# Get the web server IP
terraform output web_server_ip

# Open in browser: http://<IP_ADDRESS>
```

---

## 📂 Directory Structure

```
lab-basic/
├── main.tf                          # Root configuration
├── variables.tf                     # Root variables
├── outputs.tf                       # Root outputs
├── backend-setup.tf                 # S3 + DynamoDB setup
├── terraform.tfvars                 # Variable values (ADD YOUR VALUES)
├── .gitignore                       # Git ignore file
├── README.md                        # This file
├── IMPLEMENTATION_SUMMARY.md        # Detailed task summary
├── WEBSITE_DEPLOYMENT_GUIDE.md      # Website deployment guide
├── TASKS_7-10_GUIDE.md             # Advanced tasks guide
│
├── website/                         # Website files
│   ├── index.html                   # Main HTML
│   ├── style.css                    # Styling
│   └── script.js                    # JavaScript
│
├── modules/
│   └── ec2-basic/                   # EC2 module
│       ├── main.tf                  # EC2 resource definition
│       ├── variables.tf             # Module variables
│       └── outputs.tf               # Module outputs
│
└── terraform.tfstate*               # State files (local, will migrate to S3)
```

---

## 🔧 Key Features

### ✅ Terraform Features Demonstrated:

1. **Infrastructure as Code** - All infrastructure defined in code
2. **Modules** - Reusable EC2 module instantiated twice
3. **Variables & Outputs** - Configurable and exportable values
4. **Data Sources** - Dynamic AMI lookup
5. **Provisioners** - Remote-exec and file provisioners
6. **Lifecycle Rules** - Resource protection
7. **Remote Backend** - S3 + DynamoDB for state management
8. **Workspaces** - Environment separation (dev/stage/prod)

### ✅ Infrastructure Components:

- **2 EC2 Instances** - WebServer and DBServer
- **Nginx Web Server** - Automatically installed and configured
- **Website** - Custom HTML/CSS/JS deployed to instances
- **S3 Backend** - For storing Terraform state
- **DynamoDB Table** - For state locking
- **Security Groups** - Configured for HTTP/SSH access

---

## 📖 Usage Guides

### Website Deployment

See [WEBSITE_DEPLOYMENT_GUIDE.md](WEBSITE_DEPLOYMENT_GUIDE.md) for:
- Website features and structure
- Detailed deployment steps
- Verification procedures
- Troubleshooting guide
- Production considerations

### Advanced Tasks (7-10)

See [TASKS_7-10_GUIDE.md](TASKS_7-10_GUIDE.md) for:
- Remote backend setup
- Workspace management
- Provisioner troubleshooting
- Lifecycle rules testing

### Implementation Details

See [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) for:
- Complete task checklist
- Code implementation details
- File structure overview
- Current status of all tasks

---

## 🌐 Common Commands

### Terraform Management

```bash
# Validate configuration
terraform validate

# Initialize (required first)
terraform init

# Plan changes
terraform plan
terraform plan -out=tfplan

# Apply changes
terraform apply
terraform apply tfplan

# Destroy resources
terraform destroy
```

### Workspace Management

```bash
# List workspaces
terraform workspace list

# Create workspace
terraform workspace new staging

# Switch workspace
terraform workspace select staging

# Delete workspace
terraform workspace delete staging
```

### State Management

```bash
# List resources
terraform state list

# Show resource details
terraform state show module.web_server.aws_instance.this

# Pull remote state
terraform state pull > state.json

# Refresh state
terraform refresh
```

### Outputs

```bash
# Show all outputs
terraform output

# Show specific output
terraform output web_server_ip

# Show as JSON
terraform output -json
```

---

## 🔐 Security Considerations

### Before Production Deployment:

1. **SSH Keys**
   - Keep private keys secure (add to .gitignore)
   - Use proper file permissions (chmod 600)
   - Rotate keys regularly

2. **AWS Credentials**
   - Use IAM roles when possible
   - Never commit credentials to Git
   - Use separate AWS accounts for environments

3. **Network Security**
   - Restrict SSH access (not 0.0.0.0/0)
   - Use VPC and subnets
   - Implement security groups properly

4. **State Files**
   - Use remote state in production
   - Enable encryption for S3 backend
   - Use DynamoDB for state locking
   - Restrict S3 bucket access

5. **HTTPS/TLS**
   - Use AWS Certificate Manager
   - Redirect HTTP to HTTPS
   - Update Nginx configuration

---

## 💰 Cost Optimization

### Free Tier Eligible:
- **EC2 t3.micro** - Free tier eligible for first 12 months
- **S3** - Free tier includes some storage
- **DynamoDB** - Free tier included

### Estimated Monthly Cost (On-Demand):
- 2x t3.micro EC2 instances: ~$15-20
- S3 storage (state files): ~$1
- DynamoDB (minimal): ~$1
- **Total: ~$20-25/month**

### Cost Reduction:
- Use spot instances for non-production
- Delete unused workspaces
- Monitor AWS usage in console

---

## 🐛 Troubleshooting

### Issue: "Error acquiring the state lock"

**Solution:**
```bash
terraform force-unlock <LOCK_ID>
```

### Issue: "permission denied" for provisioner

**Solution:**
1. Verify SSH key permissions: `chmod 600 ~/.ssh/key.pem`
2. Check key pair name matches Terraform config
3. Verify security group allows port 22

### Issue: Provisioner timeout

**Solution:**
1. Increase timeout in provisioner (default 5m)
2. Check instance has internet access
3. Verify security group allows outbound traffic

### Issue: "Invalid or expired token"

**Solution:**
```bash
aws configure  # Re-enter AWS credentials
```

---

## 📚 Learning Resources

### Terraform Documentation
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Terraform Language](https://www.terraform.io/language)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices)

### AWS Documentation
- [EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [S3 Documentation](https://docs.aws.amazon.com/s3/)
- [DynamoDB Documentation](https://docs.aws.amazon.com/dynamodb/)

### DevOps Resources
- [DevOps Best Practices](https://aws.amazon.com/devops/)
- [Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code)
- [AWS Architecture Center](https://aws.amazon.com/architecture/)

---

## 🤝 Contributing

To add improvements:

1. Create a feature branch
2. Make changes to Terraform code
3. Run `terraform fmt` to format
4. Run `terraform validate` to check
5. Update documentation
6. Create pull request with description

---

## 📝 Next Steps

### Phase 1: Setup & Testing (Current) ✅
- [x] Terraform installation
- [x] Basic infrastructure setup
- [x] Website deployment
- [ ] Website testing

### Phase 2: Advanced Features (In Progress)
- [ ] Remote backend configuration
- [ ] Workspace creation and testing
- [ ] GitHub repository creation
- [ ] GitHub Actions CI/CD setup

### Phase 3: Production Ready
- [ ] SSL/TLS certificate setup
- [ ] Auto-scaling configuration
- [ ] Load balancer setup
- [ ] Monitoring and logging

### Phase 4: GitOps
- [ ] Push to GitHub
- [ ] Automated deployments
- [ ] Infrastructure drift detection
- [ ] Cost monitoring

---

## 📞 Support & Feedback

For issues or questions:

1. Check the troubleshooting guides
2. Review Terraform documentation
3. Check AWS documentation
4. Review error messages in logs

---

## 📄 License

This project is part of the 5th Semester DevOps Lab curriculum.

---

## 📊 Project Status

| Task | Status | Details |
|------|--------|---------|
| Task 1-3 | ✅ Completed | Terraform setup and basic S3 bucket |
| Task 4-6 | ✅ Completed | EC2 instances with data sources |
| Task 7-10 | ✅ Code Ready | Remote backend, workspaces, provisioners |
| Website | ✅ Created | HTML/CSS/JS ready to deploy |
| GitHub | 🔄 Next | Ready to push to repository |

---

**Version**: 1.0
**Last Updated**: December 12, 2025
**Environment**: Development

For website deployment instructions, see [WEBSITE_DEPLOYMENT_GUIDE.md](WEBSITE_DEPLOYMENT_GUIDE.md)
T r i g g e r   t e s t  
 