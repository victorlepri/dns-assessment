# DNS Assessment Tool

A cross-platform Bash script that performs an in-depth DNS and domain reputation assessment. It checks WHOIS data, DNS records, SSL certificates, subdomain enumeration, blacklist status, and more.

---

## 🛠 Features

- **WHOIS Lookup**: Retrieve domain registration details.
- **DNS Records**: Fetch A, AAAA, MX, TXT, CNAME, NS, SOA, and ANY records.
- **Email Security Checks**: Analyze SPF, DKIM, and DMARC configurations.
- **SSL/TLS Certificate Inspection**: View issuer, subject, and validity dates.
- **Website Accessibility**: Test HTTP and HTTPS responses.
- **Blacklist Verification**: Check domain against Spamhaus and SURBL.
- **Reverse DNS Lookup**: Identify PTR records for domain IPs.
- **DNSSEC Validation**: Confirm DNS Security Extensions.
- **Zone Transfer Test**: Attempt AXFR to detect misconfigurations.
- **Subdomain Enumeration**: Discover subdomains using `subfinder`.
- **DNS Performance Metrics**: Analyze query statistics.

---

## 📦 Dependencies

The script requires the following tools:

- `whois`
- `dig`
- `curl`
- `openssl`
- `subfinder`

Upon execution, the script checks for these dependencies. If any are missing, it prompts the user to install them. Installation methods vary based on the operating system:

- **macOS**: Uses Homebrew (`brew install`)
- **Linux**: Supports `apt-get`, `dnf`, and `zypper`
- **WSL (Windows Subsystem for Linux)**: Treated as Linux

*Note*: For Windows users not utilizing WSL, it's recommended to run the script within a WSL environment or a Unix-like terminal emulator.

---

## 🚀 Usage

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/victorlepri/dns-assessment.git
   cd dns-assessment
   ```

2. **Make the Script Executable**:

   ```bash
   chmod +x dns-assessment.sh
   ```

3. **Run the Script**:

   ```bash
   ./dns-assessment.sh
   ```

   You'll be prompted to enter the domain you wish to assess.

4. **View the Report**:

   After execution, a comprehensive report is saved in the `domain_reports/` directory with the filename format `<domain>_report.txt`.

---

## 🌐 Remote Execution

To run the script without cloning the repository:

```bash
curl -s https://raw.githubusercontent.com/victorlepri/dns-assessment/main/dns-assessment.sh | bash
```

---

## 📁 Output Directory

All assessment reports are stored in the `domain_reports/` directory. 

---

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your enhancements.

---

@victorlepri
👾
