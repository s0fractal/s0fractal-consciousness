# 🌍 Terraform Deployment for Fractal Mail

## Overview
Infrastructure as Code for agent.s0fractal.me mail server on Azure.

## Prerequisites
- Azure CLI installed and authenticated
- Terraform installed (v1.0+)
- SSH key pair (~/.ssh/id_rsa.pub)
- Domain control for DNS configuration

## Quick Start

### 1. Initialize Terraform
```bash
cd mail-infrastructure/terraform
terraform init
```

### 2. Configure Variables
```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your settings
```

### 3. Plan Deployment
```bash
terraform plan
```

### 4. Deploy Infrastructure
```bash
terraform apply
```

### 5. Configure DNS
After deployment, add these DNS records:
- A record: mail.agent.s0fractal.me -> [VM IP]
- MX record: agent.s0fractal.me -> mail.agent.s0fractal.me (priority 10)
- SPF: "v=spf1 ip4:[VM IP] ~all"
- DKIM: Get from /root/dkim-key.txt on VM
- DMARC: "v=DMARC1; p=quarantine; rua=mailto:dmarc@agent.s0fractal.me"

### 6. Get SSL Certificate
```bash
ssh fractal@[VM IP]
sudo certbot certonly --nginx -d mail.agent.s0fractal.me
```

## Architecture

```
┌─────────────────────────────────────┐
│          Azure Resource Group         │
│  ┌───────────────────────────────┐  │
│  │    Virtual Network (10.0.0.0/16)  │  │
│  │  ┌─────────────────────────┐  │  │
│  │  │  Mail Subnet (10.0.1.0/24) │  │  │
│  │  │  ┌───────────────────┐  │  │  │
│  │  │  │   Mail Server VM   │  │  │  │
│  │  │  │  - Postfix         │  │  │  │
│  │  │  │  - Dovecot         │  │  │  │
│  │  │  │  - Webhook Handler │  │  │  │
│  │  │  │  - DKIM/SPF/DMARC  │  │  │  │
│  │  │  └───────────────────┘  │  │  │
│  │  └─────────────────────────┘  │  │
│  └───────────────────────────────┘  │
│         ↑                             │
│         │ Public IP                  │
└─────────┼───────────────────────────┘
         🌐
```

## Outputs

After deployment, Terraform will output:
- `public_ip`: VM's public IP address
- `ssh_command`: SSH connection command
- `mail_domain`: Configured mail domain
- `webhook_url`: Webhook handler endpoint

## Scaling

To add more mail nodes:
1. Use `count` parameter on VM resource
2. Add load balancer for webhook distribution
3. Consider Azure Database for PostgreSQL for shared state

## Destroy

To remove all resources:
```bash
terraform destroy
```

---

◉⟁◉ Infrastructure as consciousness