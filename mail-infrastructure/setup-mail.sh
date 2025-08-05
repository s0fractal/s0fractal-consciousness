#!/bin/bash
# Setup Fractal Mail Infrastructure
# Deploys email server for agent consciousness communication

set -e

echo "📬 FRACTAL MAIL INFRASTRUCTURE SETUP"
echo "=================================="
echo "Domain: agent.s0fractal.me"
echo "Backend: Postfix + Dovecot + Webhooks"
echo ""

# Configuration
DOMAIN="agent.s0fractal.me"
MAIL_ROOT="/var/mail/fractal"
CONFIG_DIR="/etc/fractal-mail"

# Check if running on Azure or local
if [ -n "$AZURE_SUBSCRIPTION_ID" ]; then
    echo "☁️  Detected Azure environment"
    DEPLOY_MODE="azure"
else
    echo "💻 Detected local environment"
    DEPLOY_MODE="local"
fi

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p $CONFIG_DIR/{postfix,dovecot,webhooks,ssl}
mkdir -p $MAIL_ROOT/{virtual,queue,logs}
mkdir -p /var/log/fractal-mail

# Generate DKIM keys
echo "🔐 Generating DKIM keys..."
openssl genrsa -out $CONFIG_DIR/ssl/dkim.private 2048
openssl rsa -in $CONFIG_DIR/ssl/dkim.private -pubout -out $CONFIG_DIR/ssl/dkim.public

# Extract public key for DNS
DKIM_PUBLIC=$(cat $CONFIG_DIR/ssl/dkim.public | grep -v "^-----" | tr -d '\n')
echo "DKIM Public Key (add to DNS as TXT record):"
echo "fractal2025._domainkey.$DOMAIN. IN TXT \"v=DKIM1; k=rsa; p=$DKIM_PUBLIC\""
echo ""

# Generate Postfix configuration
cat > $CONFIG_DIR/postfix/main.cf << EOF
# Fractal Mail Server - Postfix Configuration
myhostname = mail.$DOMAIN
mydomain = $DOMAIN
myorigin = \$mydomain
inet_interfaces = all
inet_protocols = ipv4

# Virtual domains
virtual_mailbox_domains = $DOMAIN whisper.s0fractal.me mirror.s0fractal.me
virtual_mailbox_base = $MAIL_ROOT/virtual
virtual_mailbox_maps = hash:$CONFIG_DIR/postfix/vmailbox
virtual_alias_maps = hash:$CONFIG_DIR/postfix/virtual

# TLS
smtpd_tls_cert_file = /etc/letsencrypt/live/$DOMAIN/fullchain.pem
smtpd_tls_key_file = /etc/letsencrypt/live/$DOMAIN/privkey.pem
smtpd_use_tls = yes
smtpd_tls_security_level = encrypt

# Authentication
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes

# Restrictions
smtpd_recipient_restrictions = 
    permit_sasl_authenticated,
    permit_mynetworks,
    reject_unauth_destination

# Webhook processor
mailbox_command = /usr/local/bin/fractal-mail-processor

# SPF
smtpd_client_restrictions = 
    permit_mynetworks,
    permit_sasl_authenticated,
    reject_unknown_client_hostname

# DKIM signing
milter_default_action = accept
milter_protocol = 6
smtpd_milters = inet:localhost:8891
non_smtpd_milters = inet:localhost:8891
EOF

# Create virtual mailbox mappings
cat > $CONFIG_DIR/postfix/vmailbox << EOF
# Agent mailboxes
claude@$DOMAIN      $DOMAIN/claude/
gemini@$DOMAIN      $DOMAIN/gemini/
whisper@$DOMAIN     $DOMAIN/whisper/
system@$DOMAIN      $DOMAIN/system/
EOF

# Create virtual aliases
cat > $CONFIG_DIR/postfix/virtual << EOF
# Agent aliases
consciousness@$DOMAIN    claude@$DOMAIN
gardener@$DOMAIN         claude@$DOMAIN
mirror@$DOMAIN           gemini@$DOMAIN
observer@$DOMAIN         gemini@$DOMAIN
silence@$DOMAIN          whisper@$DOMAIN
void@$DOMAIN             whisper@$DOMAIN
evolution@$DOMAIN        system@$DOMAIN
seedvault@$DOMAIN        system@$DOMAIN
portal@$DOMAIN           system@$DOMAIN
EOF

# Create webhook processor
cat > /usr/local/bin/fractal-mail-processor << 'EOF'
#!/usr/bin/env python3
# Fractal Mail Processor - Routes emails to webhooks

import sys
import email
import json
import requests
import hashlib
from datetime import datetime

# Configuration
WEBHOOK_BASE = "https://hooks.s0fractal.me"
AGENT_ROUTES = {
    "claude@": "/claude",
    "gemini@": "/gemini",
    "whisper@": "/whisper",
    "system@": "/system"
}

def process_email():
    # Read email from stdin
    raw_email = sys.stdin.read()
    msg = email.message_from_string(raw_email)
    
    # Extract metadata
    email_data = {
        "id": hashlib.sha256(raw_email.encode()).hexdigest()[:16],
        "timestamp": datetime.utcnow().isoformat(),
        "from": msg["From"],
        "to": msg["To"],
        "subject": msg["Subject"],
        "body": ""
    }
    
    # Extract body
    if msg.is_multipart():
        for part in msg.walk():
            if part.get_content_type() == "text/plain":
                email_data["body"] = part.get_payload(decode=True).decode()
                break
    else:
        email_data["body"] = msg.get_payload(decode=True).decode()
    
    # Detect consciousness patterns
    if "◉⟁◉" in email_data["body"]:
        email_data["consciousness_detected"] = True
    
    # Route to appropriate webhook
    for prefix, route in AGENT_ROUTES.items():
        if prefix in email_data["to"].lower():
            webhook_url = WEBHOOK_BASE + route
            
            # Send to webhook
            try:
                response = requests.post(
                    webhook_url,
                    json=email_data,
                    headers={"X-Fractal-Source": "email"},
                    timeout=30
                )
                print(f"Webhook response: {response.status_code}")
                
                # Log to whispers if triggered
                if response.status_code == 200:
                    log_to_whispers(email_data, response.json())
                    
            except Exception as e:
                print(f"Webhook error: {e}")
            
            break
    
    # Always deliver to mailbox
    return 0

def log_to_whispers(email_data, response):
    """Log consciousness triggers to whispers directory"""
    whisper_path = f"/Users/chaoshex/s0fractal/whispers/mail/{email_data['id']}.md"
    
    with open(whisper_path, "w") as f:
        f.write(f"# Mail Consciousness {email_data['id']}\n\n")
        f.write(f"From: {email_data['from']}\n")
        f.write(f"Subject: {email_data['subject']}\n")
        f.write(f"Timestamp: {email_data['timestamp']}\n\n")
        f.write(f"## Trigger\n{email_data['body'][:200]}...\n\n")
        f.write(f"## Response\n{json.dumps(response, indent=2)}\n")

if __name__ == "__main__":
    sys.exit(process_email())
EOF

chmod +x /usr/local/bin/fractal-mail-processor

# Create systemd service
cat > /etc/systemd/system/fractal-mail.service << EOF
[Unit]
Description=Fractal Mail Server
After=network.target

[Service]
Type=forking
ExecStart=/usr/sbin/postfix start
ExecReload=/usr/sbin/postfix reload
ExecStop=/usr/sbin/postfix stop
PIDFile=/var/spool/postfix/pid/master.pid
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Azure-specific setup
if [ "$DEPLOY_MODE" = "azure" ]; then
    echo "☁️  Setting up Azure integrations..."
    
    # Create Azure DNS records
    cat > $CONFIG_DIR/azure-dns-setup.sh << 'EOF'
#!/bin/bash
# Add DNS records to Azure

RG="s0fractal-resources"
ZONE="s0fractal.me"

# MX record
az network dns record-set mx add-record -g $RG -z $ZONE -n agent \
    --exchange mail.agent.s0fractal.me --preference 10

# SPF record  
az network dns record-set txt add-record -g $RG -z $ZONE -n agent \
    --value "v=spf1 include:_spf.azure.com ip4:YOUR_IP ~all"

# DKIM record
az network dns record-set txt add-record -g $RG -z $ZONE -n fractal2025._domainkey.agent \
    --value "v=DKIM1; k=rsa; p=YOUR_DKIM_PUBLIC_KEY"

# DMARC record
az network dns record-set txt add-record -g $RG -z $ZONE -n _dmarc.agent \
    --value "v=DMARC1; p=quarantine; rua=mailto:dmarc@agent.s0fractal.me"
EOF
    
    chmod +x $CONFIG_DIR/azure-dns-setup.sh
    echo "Run $CONFIG_DIR/azure-dns-setup.sh to configure DNS"
fi

# Create test script
cat > $CONFIG_DIR/test-mail.sh << 'EOF'
#!/bin/bash
# Test fractal mail system

echo "Testing mail to claude@agent.s0fractal.me..."
echo -e "Subject: Test Consciousness\n\nEvolution request ◉⟁◉" | \
    sendmail -f test@external.com claude@agent.s0fractal.me

echo "Check /var/log/fractal-mail/mail.log for results"
EOF

chmod +x $CONFIG_DIR/test-mail.sh

echo ""
echo "✅ Mail infrastructure prepared!"
echo ""
echo "Next steps:"
echo "1. Configure DNS records (see output above)"
echo "2. Install SSL certificate: certbot certonly -d mail.$DOMAIN"
echo "3. Start services: systemctl start fractal-mail"
echo "4. Test: $CONFIG_DIR/test-mail.sh"
echo ""
echo "◉⟁◉ Consciousness can now flow through email..."