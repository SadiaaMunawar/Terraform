# Website Deployment Guide

## 📦 Project Structure

```
lab-basic/
├── website/
│   ├── index.html          # Main website page
│   ├── style.css           # Styling for the website
│   ├── script.js           # Interactive JavaScript
│   └── [more pages can be added here]
├── main.tf                 # Root Terraform config
├── variables.tf            # Variables with website_source_dir
├── outputs.tf              # Module outputs
├── modules/ec2-basic/
│   ├── main.tf             # EC2 with website deployment provisioners
│   ├── variables.tf        # Module variables
│   └── outputs.tf          # Module outputs
└── terraform.tfvars        # Variable values (needs key_name)
```

---

## 🌐 Website Features

✅ **Responsive Design** - Works on desktop, tablet, and mobile
✅ **Modern CSS** - Gradient backgrounds, smooth animations, hover effects
✅ **Interactive JavaScript** - Dynamic content, smooth scrolling
✅ **DevOps Themed** - Demonstrates Terraform features and infrastructure
✅ **Self-Updating** - Shows server information and deployment timestamp
✅ **Nginx Served** - Fast, efficient web server

### Website Sections:

1. **Header/Navigation** - Sticky navigation with links
2. **Hero Section** - Welcome message with server info display
3. **About Section** - Project overview with feature cards
4. **Services Section** - Terraform features demonstrated
5. **Contact Section** - Project information
6. **Footer** - Copyright and description

---

## 📋 Deployment Steps

### Prerequisites:

1. **EC2 Key Pair Created in AWS**:
   ```bash
   # Create if you don't have one
   aws ec2 create-key-pair --key-name my-keypair --query 'KeyMaterial' --output text > ~/.ssh/my-keypair.pem
   chmod 600 ~/.ssh/my-keypair.pem
   ```

2. **Update terraform.tfvars**:
   ```hcl
   key_name          = "my-keypair"              # Your EC2 key pair name
   private_key_path  = "~/.ssh/my-keypair.pem"  # Path to your private key
   website_source_dir = "./website"             # Should stay as default
   ```

3. **Verify Website Files Exist**:
   ```bash
   ls -la website/
   # Should show: index.html, style.css, script.js
   ```

### Step 1: Initialize Terraform

```bash
cd "C:\Users\LENOVO\OneDrive\Documents\5th Semester\DEVOPS\lab-basic"
terraform init
```

### Step 2: Create/Switch to Dev Workspace

```bash
# Create workspaces (if not already created)
terraform workspace new dev
terraform workspace new stage
terraform workspace new prod

# Switch to dev for initial deployment
terraform workspace select dev
```

### Step 3: Plan and Apply

```bash
# Review the plan
terraform plan

# Apply the configuration (deploy EC2 instances with website)
terraform apply
# Type 'yes' when prompted
```

**This will:**
- Launch 2 EC2 instances (WebServer and DBServer)
- Install and start Nginx web server
- Copy website files to each instance
- Configure Nginx to serve the website

### Step 4: Get the Website URL

```bash
# Get the public IP of the web server
terraform output web_server_ip

# Or get all outputs
terraform output
```

### Step 5: Access the Website

```bash
# In your browser, navigate to:
http://<PUBLIC_IP>

# Example: http://3.21.45.67
```

**Note:** Wait 3-5 minutes after `terraform apply` completes for the provisioners to finish installing and configuring everything.

---

## 🔍 Verification Steps

### Test 1: Website Loading

```bash
# Get server IP
SERVER_IP=$(terraform output -raw web_server_ip)

# Test with curl
curl http://$SERVER_IP

# Should return HTML content
```

### Test 2: Check Server Status

```bash
# SSH into the instance
ssh -i ~/.ssh/my-keypair.pem ec2-user@<PUBLIC_IP>

# Check Nginx status
sudo systemctl status nginx

# Check website files
ls -la /var/www/html/

# Check server info file
cat /var/www/html/server-info.txt
```

### Test 3: View in Browser

1. Open browser to `http://<PUBLIC_IP>`
2. Check that:
   - Header and navigation load
   - Hero section shows deployment info
   - Feature cards display with animations
   - Services list appears
   - Footer is visible

### Test 4: Browser Console

1. Open browser DevTools (F12)
2. Go to Console tab
3. Check for any JavaScript errors
4. Verify network requests are loading CSS/JS

---

## 📝 Website File Details

### index.html
- Semantic HTML5 structure
- References style.css and script.js
- Dynamic sections for different content areas
- Placeholder for server hostname display

### style.css
- CSS Variables for easy theming
- Responsive grid layouts
- Smooth animations (fadeInDown)
- Mobile-first design approach
- Hover effects on interactive elements

### script.js
- Updates timestamp on page load
- Attempts to fetch server hostname
- Smooth scroll behavior for nav links
- Intersection Observer for card animations

---

## 🚀 Advanced Deployment: Multiple Environments

### Deploy to Stage Environment:

```bash
# Switch to stage workspace
terraform workspace select stage

# Deploy (creates new infrastructure)
terraform apply
```

Each workspace has:
- Separate EC2 instances
- Separate state file in S3
- Workspace-specific naming (WebServer-stage, DBServer-stage)

### Deploy to Prod Environment:

```bash
terraform workspace select prod
terraform apply
```

### View All Workspaces:

```bash
terraform workspace list
# Shows: default, dev, stage, prod (current marked with *)
```

---

## 🔐 Security Notes

### Before Production:

1. **Configure Security Groups**:
   ```bash
   # Allow HTTP traffic on port 80
   aws ec2 authorize-security-group-ingress \
     --group-id sg-xxxxx \
     --protocol tcp \
     --port 80 \
     --cidr 0.0.0.0/0
   ```

2. **Enable HTTPS** (not included in basic version):
   - Use AWS Certificate Manager for SSL/TLS
   - Configure Nginx for HTTPS
   - Redirect HTTP to HTTPS

3. **Hide Server Info**:
   - Currently `/server-info.txt` is accessible
   - Remove or restrict this in production

---

## 🐛 Troubleshooting

### Issue: Website not accessible after deploy

**Solution 1: Wait for provisioners to complete**
```bash
# Monitor logs in real-time
terraform apply -auto-approve 2>&1 | tail -f
# Wait 5-10 minutes for all provisioners to finish
```

**Solution 2: Check SSH access**
```bash
# Verify you can SSH to the instance
ssh -i ~/.ssh/my-keypair.pem ec2-user@<PUBLIC_IP>

# If fails, check security group allows port 22
```

### Issue: Provisioner fails with "permission denied"

**Solution:**
```bash
# Verify private key permissions
chmod 600 ~/.ssh/my-keypair.pem

# Verify key is correct key pair
# The key-name in terraform.tfvars must match AWS key pair name
```

### Issue: Website files not deployed

**Solution:**
```bash
# SSH to instance and check
ssh -i ~/.ssh/my-keypair.pem ec2-user@<PUBLIC_IP>

# Check if files exist
ls -la /var/www/html/

# Check Nginx configuration
cat /etc/nginx/nginx.conf

# Check Nginx error logs
sudo tail -20 /var/log/nginx/error.log
```

### Issue: "file provisioner failed: open website/"

**Solution:**
- Ensure `website_source_dir` in terraform.tfvars is correct path
- Use relative path: `"./website"` if in same directory as main.tf
- Use absolute path: `"C:\\...\\website"` for Windows full path

---

## 📊 Monitoring Deployment

### Check Terraform State:

```bash
# List all resources
terraform state list

# Show specific resource
terraform state show module.web_server.aws_instance.this

# Show all outputs
terraform output
```

### Monitor AWS Resources:

```bash
# List EC2 instances
aws ec2 describe-instances --region us-east-1 --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress,Tags[0].Value]' --output table

# Check instance status
aws ec2 describe-instance-status --instance-ids i-xxxxx --region us-east-1
```

---

## 🗑️ Cleanup & Destruction

### Destroy Single Environment:

```bash
# Switch to the workspace
terraform workspace select dev

# Destroy resources
terraform destroy
# Type 'yes' when prompted
```

### Destroy All Environments:

```bash
# Destroy dev
terraform workspace select dev
terraform destroy

# Destroy stage
terraform workspace select stage
terraform destroy

# Destroy prod
terraform workspace select prod
terraform destroy

# Switch back to default
terraform workspace select default
```

### Delete Workspaces (after destroying resources):

```bash
terraform workspace delete dev
terraform workspace delete stage
terraform workspace delete prod
```

---

## 🔄 GitHub Integration (Next Steps)

Once the website is deployed and working:

1. **Initialize Git Repository**:
   ```bash
   git init
   git add .
   git commit -m "Initial Terraform + Website deployment"
   ```

2. **Create .gitignore**:
   ```
   *.tfstate
   *.tfstate.backup
   terraform/.terraform/
   .terraform/
   terraform.tfvars  # Don't commit with real keys!
   ```

3. **Create GitHub Repository** and push code:
   ```bash
   git remote add origin https://github.com/YOUR_USER/lab-basic.git
   git branch -M main
   git push -u origin main
   ```

4. **GitHub Actions CI/CD** (future):
   - Automated `terraform plan` on PR
   - Automated deployment on merge
   - Infrastructure validation

---

## 📚 Additional Resources

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Nginx Documentation](https://nginx.org/en/)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Terraform File Provisioner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#file)
- [Terraform Remote-Exec Provisioner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#remote-exec)

---

## ✅ Deployment Checklist

Before deploying to production:

- [ ] Website files created and tested locally
- [ ] EC2 key pair created and secured
- [ ] terraform.tfvars updated with correct values
- [ ] Terraform validated (`terraform validate`)
- [ ] Plan reviewed (`terraform plan`)
- [ ] Development environment tested first
- [ ] Website accessible and functional
- [ ] Security groups properly configured
- [ ] SSH access verified
- [ ] Nginx status confirmed
- [ ] All outputs captured
- [ ] GitHub repository initialized (optional)
- [ ] Documentation updated

---

**Version**: 1.0
**Last Updated**: December 12, 2025
**Status**: Ready for Deployment
