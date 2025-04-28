#!/bin/bash

# List of required dependencies
REQUIRED_COMMANDS=("whois" "dig" "curl" "openssl" "subfinder")

# Function to detect the operating system
detect_os() {
  OS_TYPE="$(uname -s)"
  case "$OS_TYPE" in
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        OS="WSL"
      else
        OS="Linux"
      fi
      ;;
    Darwin)
      OS="macOS"
      ;;
    *)
      OS="Unsupported"
      ;;
  esac
}

# Function to install a package based on the operating system
install_package() {
  local pkg="$1"
  case "$OS" in
    Linux|WSL)
      if command -v apt-get &>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y "$pkg"
      elif command -v dnf &>/dev/null; then
        sudo dnf install -y "$pkg"
      elif command -v zypper &>/dev/null; then
        sudo zypper install -y "$pkg"
      else
        echo "Unsupported Linux package manager. Please install $pkg manually."
        exit 1
      fi
      ;;
    macOS)
      if command -v brew &>/dev/null; then
        brew install "$pkg"
      else
        echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
        exit 1
      fi
      ;;
    *)
      echo "Unsupported operating system: $OS"
      exit 1
      ;;
  esac
}

# Function to check and install missing dependencies
check_and_install_dependencies() {
  local missing=()
  for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
      missing+=("$cmd")
    fi
  done

  if [ ${#missing[@]} -eq 0 ]; then
    echo "✅ All required dependencies are installed."
  else
    echo "⚠️ The following dependencies are missing: ${missing[*]}"
    read -p "Would you like to install them now? [Y/n]: " response
    response=${response:-Y}
    if [[ "$response" =~ ^[Yy]$ ]]; then
      for pkg in "${missing[@]}"; do
        echo "Installing $pkg..."
        install_package "$pkg"
      done
    else
      echo "Cannot proceed without installing the required dependencies."
      exit 1
    fi
  fi
}

# Main script execution
detect_os
check_and_install_dependencies

# Prompt the user to enter a domain name
read -p "Enter the domain name to assess: " DOMAIN

# DKIM selector (modify if different)
SELECTOR="default"

# Output directory for reports
OUTPUT_DIR="domain_reports"
mkdir -p "$OUTPUT_DIR"

# Define the report file
REPORT_FILE="$OUTPUT_DIR/${DOMAIN}_report.txt"

echo "Assessing domain: $DOMAIN"
echo "Report will be saved to $REPORT_FILE"

{
  echo "=============================="
  echo "🔍 WHOIS Information for $DOMAIN"
  echo "=============================="
  whois "$DOMAIN"

  echo -e "\n=============================="
  echo "📡 DNS Records for $DOMAIN"
  echo "=============================="
  echo -e "\nA Record:"
  dig A "$DOMAIN" +short

  echo -e "\nAAAA Record:"
  dig AAAA "$DOMAIN" +short

  echo -e "\nMX Records:"
  dig MX "$DOMAIN" +short

  echo -e "\nTXT Records:"
  dig TXT "$DOMAIN" +short

  echo -e "\nCNAME Record:"
  dig CNAME "$DOMAIN" +short

  echo -e "\nNS Records:"
  dig NS "$DOMAIN" +short

  echo -e "\nSOA Record:"
  dig SOA "$DOMAIN" +short

  echo -e "\nANY Records:"
  dig ANY "$DOMAIN" +short

  echo -e "\n=============================="
  echo "📧 Email Security Records for $DOMAIN"
  echo "=============================="
  echo -e "\nSPF Record:"
  dig TXT "$DOMAIN" +short | grep spf

  echo -e "\nDMARC Record:"
  dig TXT "_dmarc.$DOMAIN" +short

  echo -e "\nDKIM Record:"
  dig TXT "$SELECTOR._domainkey.$DOMAIN" +short

  echo -e "\n=============================="
  echo "🔐 SSL/TLS Certificate for $DOMAIN"
  echo "=============================="
  echo | openssl s_client -connect "$DOMAIN:443" -servername "$DOMAIN" 2>/dev/null | openssl x509 -noout -issuer -subject -dates

  echo -e "\n=============================="
  echo "🌐 Website Accessibility for $DOMAIN"
  echo "=============================="
  echo -e "\nHTTP Response:"
  curl -I "http://$DOMAIN"

  echo -e "\nHTTPS Response:"
  curl -I "https://$DOMAIN"

  echo -e "\n=============================="
  echo "🛡️ Blacklist Check for $DOMAIN"
  echo "=============================="
  echo -e "\nChecking if domain is listed on Spamhaus:"
  curl -s "https://www.spamhaus.org/query/domain/$DOMAIN" | grep -i "not listed\|listed"

  echo -e "\nChecking if domain is listed on SURBL:"
  curl -s "https://www.surbl.org/lookup?domain=$DOMAIN" | grep -i "not listed\|listed"

  echo -e "\n=============================="
  echo "🔁 Reverse DNS Lookup for $DOMAIN"
  echo "=============================="
  IP=$(dig +short "$DOMAIN" | tail -n1)
  if [ -n "$IP" ]; then
    echo "IP Address: $IP"
    echo "PTR Record:"
    dig -x "$IP" +short
  else
    echo "No A record found for $DOMAIN."
  fi

  echo -e "\n=============================="
  echo "🔐 DNSSEC Validation for $DOMAIN"
  echo "=============================="
  dig +dnssec "$DOMAIN" A | grep -E 'ad|RRSIG'

  echo -e "\n=============================="
  echo "🔄 Zone Transfer Check for $DOMAIN"
  echo "=============================="
  for ns in $(dig +short NS "$DOMAIN"); do
    echo "Attempting zone transfer with $ns"
    dig AXFR "$DOMAIN" @"$ns"
  done

  echo -e "\n=============================="
  echo "🔍 Subdomain Enumeration for $DOMAIN"
  echo "=============================="
  subfinder -d "$DOMAIN" -silent

  echo -e "\n=============================="
  echo "📈 DNS Performance Metrics for $DOMAIN"
  echo "=============================="
  dig "$DOMAIN" +stats

  echo -e "\n=============================="
  echo "✅ Assessment Complete for $DOMAIN"
  echo "=============================="
} > "$REPORT_FILE"

echo "Assessment complete. Report saved to $REPORT_FILE"