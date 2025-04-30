# DNS Assessment Tool

A cross-platform Bash script that performs comprehensive DNS and domain reputation assessments. This tool examines WHOIS data, DNS records, SSL certificates, subdomains, blacklist status, and various security parameters.

## Features

- **WHOIS Lookup**: Retrieve domain registration details
- **DNS Records Analysis**: Fetch A, AAAA, MX, TXT, CNAME, NS, SOA, and ANY records
- **Email Security Assessment**: Analyze SPF, DKIM, and DMARC configurations
- **SSL/TLS Certificate Inspection**: Examine issuer, subject, and validity dates
- **Website Accessibility Testing**: Verify HTTP and HTTPS responses
- **Blacklist Verification**: Check domain against Spamhaus and SURBL
- **Reverse DNS Lookup**: Identify PTR records for domain IPs
- **DNSSEC Validation**: Confirm DNS Security Extensions implementation
- **Zone Transfer Testing**: Attempt AXFR to detect misconfigurations
- **Subdomain Enumeration**: Discover subdomains using `subfinder`
- **DNS Performance Metrics**: Analyze query statistics

## Dependencies

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

**Note**: Windows users not utilizing WSL should run the script within a WSL environment or a Unix-like terminal emulator.

## Usage

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

## Output Directory

All assessment reports are stored in the `domain_reports/` directory. 

## Contributing

Contributions are welcome. Please fork the repository and submit a pull request with your enhancements.

---

@victorlepri
👾