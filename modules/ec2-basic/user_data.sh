#!/bin/bash
set -e

# Update system
yum update -y

# Install Nginx
yum install -y nginx

# Create website directory
mkdir -p /var/www/html

# Create index.html with basic content
cat > /var/www/html/index.html << 'WEBSITE_EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DevOps Lab - Terraform Deployment</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --accent-color: #e74c3c;
            --light-bg: #ecf0f1;
            --text-color: #2c3e50;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-color);
            line-height: 1.6;
            background-color: #fff;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        header {
            background-color: var(--primary-color);
            color: white;
            padding: 2rem 0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        header h1 {
            font-size: 2rem;
            color: var(--secondary-color);
        }

        .hero {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 6rem 0;
            text-align: center;
        }

        .hero h2 {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .hero p {
            font-size: 1.3rem;
            margin-bottom: 2rem;
        }

        .info-box {
            background: rgba(255, 255, 255, 0.15);
            padding: 2rem;
            border-radius: 8px;
            max-width: 600px;
            margin: 2rem auto;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .info-box p {
            margin: 0.8rem 0;
            font-size: 1.1rem;
        }

        .info-box strong {
            color: #ffd700;
        }

        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin: 4rem 0;
        }

        .feature-card {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
        }

        .feature-card h3 {
            color: var(--secondary-color);
            margin-bottom: 1rem;
        }

        section {
            padding: 4rem 0;
        }

        section h2 {
            text-align: center;
            font-size: 2.5rem;
            margin-bottom: 2rem;
            color: var(--primary-color);
        }

        footer {
            background-color: var(--primary-color);
            color: white;
            text-align: center;
            padding: 2rem 0;
            margin-top: 4rem;
        }

        .status {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 1rem;
            border-radius: 4px;
            margin: 2rem 0;
            text-align: center;
        }

        .status strong {
            color: #0c5620;
        }
    </style>
</head>
<body>
    <header>
        <div class="container">
            <h1>🚀 DevOps Lab - Terraform Deployment</h1>
        </div>
    </header>

    <main>
        <section class="hero">
            <div class="container">
                <h2>Welcome to Your AWS Deployment!</h2>
                <p>Infrastructure as Code with Terraform</p>
                <div class="info-box">
                    <p><strong>Server Name:</strong> <span id="servername">WebServer-dev</span></p>
                    <p><strong>Instance Type:</strong> t3.micro</p>
                    <p><strong>Region:</strong> us-east-1</p>
                    <p><strong>Web Server:</strong> Nginx</p>
                </div>
                <div class="status">
                    <strong>✅ Website is LIVE and Successfully Deployed!</strong>
                </div>
            </div>
        </section>

        <section id="about" class="about">
            <div class="container">
                <h2>About This Deployment</h2>
                <p>This website is running on an AWS EC2 instance (t3.micro) provisioned using Terraform Infrastructure as Code.</p>
                
                <div class="features">
                    <div class="feature-card">
                        <h3>🚀 Automated Infrastructure</h3>
                        <p>Complete infrastructure provisioned with Terraform - no manual setup required!</p>
                    </div>
                    <div class="feature-card">
                        <h3>☁️ Cloud Hosted</h3>
                        <p>Running on Amazon AWS with automatic scaling capabilities and high availability</p>
                    </div>
                    <div class="feature-card">
                        <h3>🔧 DevOps Ready</h3>
                        <p>Production-ready setup with state management, workspaces, and provisioners</p>
                    </div>
                </div>
            </div>
        </section>

        <section id="features">
            <div class="container">
                <h2>Terraform Features in Use</h2>
                <ul style="list-style: none; margin: 2rem 0;">
                    <li style="padding: 1rem; background: linear-gradient(135deg, #3498db, #3498db); color: white; margin: 0.5rem 0; border-radius: 4px;">✅ Infrastructure as Code</li>
                    <li style="padding: 1rem; background: linear-gradient(135deg, #3498db, #3498db); color: white; margin: 0.5rem 0; border-radius: 4px;">✅ EC2 Instance Provisioning</li>
                    <li style="padding: 1rem; background: linear-gradient(135deg, #3498db, #3498db); color: white; margin: 0.5rem 0; border-radius: 4px;">✅ Auto-installation of Nginx</li>
                    <li style="padding: 1rem; background: linear-gradient(135deg, #3498db, #3498db); color: white; margin: 0.5rem 0; border-radius: 4px;">✅ Dynamic Resource Management</li>
                    <li style="padding: 1rem; background: linear-gradient(135deg, #3498db, #3498db); color: white; margin: 0.5rem 0; border-radius: 4px;">✅ Remote State Storage (S3 + DynamoDB)</li>
                    <li style="padding: 1rem; background: linear-gradient(135deg, #3498db, #3498db); color: white; margin: 0.5rem 0; border-radius: 4px;">✅ Environment Workspaces (dev/stage/prod)</li>
                </ul>
            </div>
        </section>

        <section id="contact" style="background-color: #ecf0f1;">
            <div class="container">
                <h2>Deployment Information</h2>
                <div class="info-box" style="background: white; color: #2c3e50;">
                    <p><strong>Course:</strong> 5th Semester DevOps Lab</p>
                    <p><strong>Technology Stack:</strong> Terraform, AWS EC2, Nginx, Amazon Linux 2</p>
                    <p><strong>Deployment Date:</strong> December 12, 2025</p>
                    <p><strong>Infrastructure Status:</strong> ✅ Active and Running</p>
                </div>
            </div>
        </section>
    </main>

    <footer>
        <div class="container">
            <p>&copy; 2025 DevOps Lab Project. Infrastructure Managed with Terraform.</p>
            <p>Building reliable, scalable infrastructure through code.</p>
        </div>
    </footer>
</body>
</html>
WEBSITE_EOF

# Set proper permissions
chown -R nginx:nginx /var/www/html
chmod -R 755 /var/www/html

# Start and enable Nginx
systemctl start nginx
systemctl enable nginx

# Log successful completion
echo "Nginx installation and website deployment completed successfully" > /var/log/user-data.log
echo "Timestamp: $(date)" >> /var/log/user-data.log
