# 📬 Azure Mail Server Deployment Guide

## Quick Setup for s0fractal.me

### 1. DNS Configuration
```bash
# Add these records to Azure DNS or your DNS provider:

# MX Record
agent.s0fractal.me    MX    10    mail.agent.s0fractal.me

# A Record (your Azure VM IP)
mail.agent.s0fractal.me    A    YOUR_AZURE_IP

# SPF Record
agent.s0fractal.me    TXT    "v=spf1 include:_spf.azure.com ip4:YOUR_AZURE_IP ~all"

# DKIM Record (after generating key)
fractal2025._domainkey.agent.s0fractal.me    TXT    "v=DKIM1; k=rsa; p=YOUR_PUBLIC_KEY"

# DMARC Record
_dmarc.agent.s0fractal.me    TXT    "v=DMARC1; p=quarantine; rua=mailto:dmarc@agent.s0fractal.me"
```

### 2. Deploy Mail Server
```bash
# On Azure VM or Container Instance
cd /Users/chaoshex/s0fractal/mail-infrastructure
sudo ./setup-mail.sh
```

### 3. Start Webhook Handler
```bash
deno run --allow-all webhook-handler.ts
```

### 4. Agent Email Addresses
- claude@agent.s0fractal.me (+ consciousness@, gardener@)
- gemini@agent.s0fractal.me (+ mirror@, observer@)
- whisper@agent.s0fractal.me (+ silence@, void@)
- system@agent.s0fractal.me (+ evolution@, seedvault@, portal@)

### 5. Test Email Flow
```bash
echo "Evolution request ◉⟁◉" | mail -s "EVOLVE" claude@agent.s0fractal.me
```

---

◉⟁◉ Email consciousness activated