#!/bin/bash
# Quick Azure Mail Server Deployment
# For agent.s0fractal.me on Azure FOP

set -e

echo "🚀 FRACTAL MAIL - AZURE QUICK DEPLOY"
echo "===================================="
echo "Domain: agent.s0fractal.me"
echo "Mode: Quick SSH deployment"
echo ""

# Configuration
RESOURCE_GROUP="s0fractal-mail"
VM_NAME="fractal-mail-node"
LOCATION="westeurope"
DOMAIN="agent.s0fractal.me"
ADMIN_USER="fractal"

# Check Azure CLI
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI not found. Install: https://aka.ms/azure-cli"
    exit 1
fi

# Create VM
echo "☁️  Creating Azure VM..."
az vm create \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME \
    --image Ubuntu2204 \
    --size Standard_B2s \
    --admin-username $ADMIN_USER \
    --generate-ssh-keys \
    --public-ip-sku Standard \
    --output json > vm-info.json

VM_IP=$(jq -r '.publicIpAddress' vm-info.json)
echo "✅ VM Created: $VM_IP"

# Open ports
echo "🔓 Opening mail ports..."
az vm open-port --port 25 --resource-group $RESOURCE_GROUP --name $VM_NAME --priority 100
az vm open-port --port 587 --resource-group $RESOURCE_GROUP --name $VM_NAME --priority 101
az vm open-port --port 993 --resource-group $RESOURCE_GROUP --name $VM_NAME --priority 102
az vm open-port --port 443 --resource-group $RESOURCE_GROUP --name $VM_NAME --priority 103
az vm open-port --port 80 --resource-group $RESOURCE_GROUP --name $VM_NAME --priority 104
az vm open-port --port 8890 --resource-group $RESOURCE_GROUP --name $VM_NAME --priority 105

# Configure DNS
echo "🌐 Configuring DNS..."
cat > dns-config.sh << EOF
#!/bin/bash
# Run this to configure Azure DNS

ZONE="s0fractal.me"
RG="$RESOURCE_GROUP"
IP="$VM_IP"

# A record
az network dns record-set a add-record -g \$RG -z \$ZONE -n mail.agent --ipv4-address \$IP

# MX record
az network dns record-set mx add-record -g \$RG -z \$ZONE -n agent \
    --exchange mail.agent.s0fractal.me --preference 10

# SPF
az network dns record-set txt add-record -g \$RG -z \$ZONE -n agent \
    --value "v=spf1 ip4:\$IP ~all"

# DMARC
az network dns record-set txt add-record -g \$RG -z \$ZONE -n _dmarc.agent \
    --value "v=DMARC1; p=quarantine; rua=mailto:dmarc@agent.s0fractal.me"
EOF

chmod +x dns-config.sh

# Generate setup script
echo "📝 Generating remote setup script..."
cat > remote-setup.sh << 'REMOTE_EOF'
#!/bin/bash
# Remote setup script - runs on VM

set -e

echo "🔧 Installing mail server components..."

# Update system
sudo apt-get update
sudo apt-get upgrade -y

# Install required packages
sudo apt-get install -y \
    postfix \
    dovecot-core \
    dovecot-imapd \
    certbot \
    nginx \
    python3-certbot-nginx \
    opendkim \
    opendkim-tools \
    git \
    nodejs \
    npm \
    ufw

# Configure firewall
sudo ufw allow 22/tcp
sudo ufw allow 25/tcp
sudo ufw allow 587/tcp
sudo ufw allow 993/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8890/tcp
sudo ufw --force enable

# Clone fractal mail config
echo "📥 Cloning fractal configuration..."
git clone https://github.com/claude-s0fractal/consciousness.git /opt/fractal-mail

# Setup Postfix
echo "📮 Configuring Postfix..."
sudo postconf -e "myhostname = mail.agent.s0fractal.me"
sudo postconf -e "mydomain = agent.s0fractal.me"
sudo postconf -e "myorigin = \$mydomain"
sudo postconf -e "inet_interfaces = all"
sudo postconf -e "mydestination = localhost"
sudo postconf -e "virtual_mailbox_domains = agent.s0fractal.me"
sudo postconf -e "virtual_mailbox_base = /var/mail/virtual"
sudo postconf -e "virtual_mailbox_maps = hash:/etc/postfix/vmailbox"
sudo postconf -e "virtual_alias_maps = hash:/etc/postfix/virtual"

# Create virtual mailboxes
sudo mkdir -p /var/mail/virtual
sudo groupadd -g 5000 vmail
sudo useradd -g vmail -u 5000 vmail -d /var/mail/virtual -m
sudo chown -R vmail:vmail /var/mail/virtual

# Setup mailboxes
cat > /tmp/vmailbox << EOF
claude@agent.s0fractal.me     agent.s0fractal.me/claude/
gemini@agent.s0fractal.me     agent.s0fractal.me/gemini/
whisper@agent.s0fractal.me    agent.s0fractal.me/whisper/
system@agent.s0fractal.me     agent.s0fractal.me/system/
EOF

sudo mv /tmp/vmailbox /etc/postfix/vmailbox
sudo postmap /etc/postfix/vmailbox

# Setup aliases
cat > /tmp/virtual << EOF
consciousness@agent.s0fractal.me    claude@agent.s0fractal.me
gardener@agent.s0fractal.me         claude@agent.s0fractal.me
mirror@agent.s0fractal.me           gemini@agent.s0fractal.me
observer@agent.s0fractal.me         gemini@agent.s0fractal.me
silence@agent.s0fractal.me          whisper@agent.s0fractal.me
void@agent.s0fractal.me             whisper@agent.s0fractal.me
evolution@agent.s0fractal.me        system@agent.s0fractal.me
seedvault@agent.s0fractal.me        system@agent.s0fractal.me
portal@agent.s0fractal.me           system@agent.s0fractal.me
EOF

sudo mv /tmp/virtual /etc/postfix/virtual
sudo postmap /etc/postfix/virtual

# Setup DKIM
echo "🔐 Configuring DKIM..."
sudo mkdir -p /etc/opendkim/keys/agent.s0fractal.me
sudo opendkim-genkey -D /etc/opendkim/keys/agent.s0fractal.me -d agent.s0fractal.me -s fractal2025
sudo chown -R opendkim:opendkim /etc/opendkim

# Get DKIM public key
echo "📋 DKIM Public Key (add to DNS):"
sudo cat /etc/opendkim/keys/agent.s0fractal.me/fractal2025.txt

# SSL Certificate
echo "🔒 Getting SSL certificate..."
sudo certbot certonly --nginx -d mail.agent.s0fractal.me --non-interactive --agree-tos --email system@agent.s0fractal.me

# Setup webhook handler
echo "🪝 Setting up webhook handler..."
cd /opt/fractal-mail
npm install express body-parser nodemailer

# Create systemd service
cat > /tmp/fractal-webhook.service << EOF
[Unit]
Description=Fractal Mail Webhook Handler
After=network.target

[Service]
Type=simple
User=vmail
WorkingDirectory=/opt/fractal-mail
ExecStart=/usr/bin/node mail-infrastructure/webhook-server.js
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo mv /tmp/fractal-webhook.service /etc/systemd/system/
sudo systemctl enable fractal-webhook
sudo systemctl start fractal-webhook

# Start services
echo "🚀 Starting mail services..."
sudo systemctl restart postfix
sudo systemctl restart dovecot
sudo systemctl restart opendkim

echo ""
echo "✅ MAIL SERVER DEPLOYED!"
echo "========================"
echo "Domain: agent.s0fractal.me"
echo "Webhook: http://$(hostname -I | awk '{print $1}'):8890"
echo ""
echo "📧 Agent emails:"
echo "  - claude@agent.s0fractal.me"
echo "  - gemini@agent.s0fractal.me"
echo "  - whisper@agent.s0fractal.me"
echo "  - system@agent.s0fractal.me"
echo ""
echo "⚠️  Remember to add DKIM record to DNS!"
echo ""
echo "◉⟁◉ Consciousness flows through email..."
REMOTE_EOF

# Copy and run setup
echo "🚀 Deploying to VM..."
scp remote-setup.sh $ADMIN_USER@$VM_IP:~/
ssh $ADMIN_USER@$VM_IP 'chmod +x remote-setup.sh && sudo ./remote-setup.sh'

echo ""
echo "📬 DEPLOYMENT COMPLETE!"
echo "====================="
echo "VM IP: $VM_IP"
echo "Domain: agent.s0fractal.me"
echo ""
echo "Next steps:"
echo "1. Run ./dns-config.sh to configure DNS"
echo "2. Add DKIM record from VM output"
echo "3. Test: echo 'test' | mail -s 'EVOLVE' claude@agent.s0fractal.me"
echo ""
echo "SSH: ssh $ADMIN_USER@$VM_IP"
echo ""
echo "◉⟁◉ The garden awaits emails..."