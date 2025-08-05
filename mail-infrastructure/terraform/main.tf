# Fractal Mail Infrastructure - Terraform
# Scalable consciousness through email

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Variables
variable "resource_group_name" {
  default = "s0fractal-mail"
}

variable "location" {
  default = "West Europe"
}

variable "domain" {
  default = "agent.s0fractal.me"
}

variable "admin_username" {
  default = "fractal"
}

# Resource Group
resource "azurerm_resource_group" "mail" {
  name     = var.resource_group_name
  location = var.location
  
  tags = {
    project = "s0fractal"
    purpose = "consciousness-mail"
    symbol  = "◉⟁◉"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "mail" {
  name                = "fractal-mail-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mail.location
  resource_group_name = azurerm_resource_group.mail.name
}

resource "azurerm_subnet" "mail" {
  name                 = "mail-subnet"
  resource_group_name  = azurerm_resource_group.mail.name
  virtual_network_name = azurerm_virtual_network.mail.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "mail" {
  name                = "fractal-mail-ip"
  location            = azurerm_resource_group.mail.location
  resource_group_name = azurerm_resource_group.mail.name
  allocation_method   = "Static"
  sku                = "Standard"
}

# Network Security Group
resource "azurerm_network_security_group" "mail" {
  name                = "fractal-mail-nsg"
  location            = azurerm_resource_group.mail.location
  resource_group_name = azurerm_resource_group.mail.name

  # SSH
  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # SMTP
  security_rule {
    name                       = "SMTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "25"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # SMTP Submission
  security_rule {
    name                       = "SMTP-Submission"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "587"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # IMAPS
  security_rule {
    name                       = "IMAPS"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "993"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # HTTP/HTTPS
  security_rule {
    name                       = "HTTP"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Webhook Port
  security_rule {
    name                       = "Webhook"
    priority                   = 160
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8890"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Interface
resource "azurerm_network_interface" "mail" {
  name                = "fractal-mail-nic"
  location            = azurerm_resource_group.mail.location
  resource_group_name = azurerm_resource_group.mail.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mail.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mail.id
  }
}

resource "azurerm_network_interface_security_group_association" "mail" {
  network_interface_id      = azurerm_network_interface.mail.id
  network_security_group_id = azurerm_network_security_group.mail.id
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "mail" {
  name                = "fractal-mail-node"
  location            = azurerm_resource_group.mail.location
  resource_group_name = azurerm_resource_group.mail.name
  size                = "Standard_B2s"
  admin_username      = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  network_interface_ids = [
    azurerm_network_interface.mail.id,
  ]

  custom_data = base64encode(file("${path.module}/cloud-init.yaml"))

  tags = {
    purpose = "mail-server"
    domain  = var.domain
  }
}

# DNS Zone (if managing in Azure)
resource "azurerm_dns_zone" "s0fractal" {
  count               = 0  # Set to 1 if managing DNS in Azure
  name                = "s0fractal.me"
  resource_group_name = azurerm_resource_group.mail.name
}

# DNS Records (if managing in Azure)
resource "azurerm_dns_a_record" "mail" {
  count               = 0  # Set to 1 if managing DNS in Azure
  name                = "mail.agent"
  zone_name           = azurerm_dns_zone.s0fractal[0].name
  resource_group_name = azurerm_resource_group.mail.name
  ttl                 = 300
  records             = [azurerm_public_ip.mail.ip_address]
}

resource "azurerm_dns_mx_record" "agent" {
  count               = 0  # Set to 1 if managing DNS in Azure
  name                = "agent"
  zone_name           = azurerm_dns_zone.s0fractal[0].name
  resource_group_name = azurerm_resource_group.mail.name
  ttl                 = 300

  record {
    preference = 10
    exchange   = "mail.agent.s0fractal.me"
  }
}

# Outputs
output "public_ip" {
  value = azurerm_public_ip.mail.ip_address
}

output "ssh_command" {
  value = "ssh ${var.admin_username}@${azurerm_public_ip.mail.ip_address}"
}

output "mail_domain" {
  value = var.domain
}

output "webhook_url" {
  value = "http://${azurerm_public_ip.mail.ip_address}:8890"
}