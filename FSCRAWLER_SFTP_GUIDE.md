# FSCrawler SFTP Connection Guide

## Overview
FSCrawler supports crawling files from SFTP servers instead of local directories. This allows you to index remote files without downloading them locally.

## Prerequisites
- FSCrawler installed
- SFTP server details (host, port, username, password/key)
- Elasticsearch running

## Configuration Steps

### Step 1: Create SFTP Job Configuration

Navigate to FSCrawler config directory:
```
C:\Users\YourUsername\.fscrawler\
```

Create a new job or modify existing one:
```
C:\Users\YourUsername\.fscrawler\sftp_job\_settings.yaml
```

### Step 2: Basic SFTP Configuration

**_settings.yaml:**
```yaml
name: "sftp_job"
fs:
  url: "/remote/path/to/crawl"
  protocol: "sftp"
  server: "sftp.example.com"
  port: 22
  username: "your_username"
  password: "your_password"
  update_rate: "15m"
  excludes:
  - "*/~*"
  add_filesize: true
  remove_deleted: true
  index_content: true
  index_folders: true
elasticsearch:
  nodes:
  - url: "http://localhost:9200"
  bulk_size: 100
  flush_interval: "5s"
```

### Step 3: SFTP Authentication Methods

#### Method 1: Password Authentication (Simple)
```yaml
fs:
  url: "/home/user/documents"
  protocol: "sftp"
  server: "sftp.example.com"
  port: 22
  username: "ramesh"
  password: "your_secure_password"
```

#### Method 2: SSH Key Authentication (Recommended)
```yaml
fs:
  url: "/home/user/documents"
  protocol: "sftp"
  server: "sftp.example.com"
  port: 22
  username: "ramesh"
  pem_path: "C:/Users/YourUsername/.ssh/id_rsa"
```

#### Method 3: SSH Key with Passphrase
```yaml
fs:
  url: "/home/user/documents"
  protocol: "sftp"
  server: "sftp.example.com"
  port: 22
  username: "ramesh"
  pem_path: "C:/Users/YourUsername/.ssh/id_rsa"
  passphrase: "your_key_passphrase"
```

## Complete Configuration Examples

### Example 1: Corporate SFTP Server
```yaml
name: "corporate_docs"
fs:
  url: "/data/shared/documents"
  protocol: "sftp"
  server: "files.company.com"
  port: 2222
  username: "ramesh.engineer"
  password: "SecurePass123!"
  update_rate: "30m"
  excludes:
  - "*/~*"
  - "*/.git/*"
  - "*/node_modules/*"
  includes:
  - "*.pdf"
  - "*.docx"
  - "*.xlsx"
  - "*.txt"
  add_filesize: true
  remove_deleted: true
  index_content: true
  index_folders: true
  lang_detect: false
elasticsearch:
  nodes:
  - url: "http://localhost:9200"
  bulk_size: 100
  flush_interval: "5s"
```

### Example 2: Using SSH Key
```yaml
name: "remote_server"
fs:
  url: "/var/data/files"
  protocol: "sftp"
  server: "192.168.1.100"
  port: 22
  username: "admin"
  pem_path: "C:/Users/Ramesh/.ssh/server_key"
  update_rate: "1h"
  add_filesize: true
  remove_deleted: true
  index_content: true
elasticsearch:
  nodes:
  - url: "http://localhost:9200"
```

### Example 3: Multiple Directories (Requires Multiple Jobs)
For multiple SFTP paths, create separate jobs:

**Job 1: sftp_invoices**
```yaml
name: "sftp_invoices"
fs:
  url: "/invoices"
  protocol: "sftp"
  server: "sftp.company.com"
  port: 22
  username: "ramesh"
  password: "password123"
elasticsearch:
  nodes:
  - url: "http://localhost:9200"
  index: "invoices"
```

**Job 2: sftp_reports**
```yaml
name: "sftp_reports"
fs:
  url: "/reports"
  protocol: "sftp"
  server: "sftp.company.com"
  port: 22
  username: "ramesh"
  password: "password123"
elasticsearch:
  nodes:
  - url: "http://localhost:9200"
  index: "reports"
```

## Running SFTP Jobs

### First Run (Create Job)
```cmd
cd C:\path\to\fscrawler
bin\fscrawler sftp_job
```

Answer **Y** when asked to create the job.

### Edit Configuration
Edit the file:
```
C:\Users\YourUsername\.fscrawler\sftp_job\_settings.yaml
```

Add your SFTP details as shown above.

### Run the Job
```cmd
bin\fscrawler sftp_job
```

### Run Continuously
```cmd
bin\fscrawler sftp_job --loop 1
```

### Run in Background (PowerShell)
```powershell
Start-Process -FilePath "bin\fscrawler.bat" -ArgumentList "sftp_job --loop 1" -NoNewWindow
```

## Troubleshooting SFTP Connection

### Issue 1: Connection Refused
**Error:** `Connection refused`

**Check:**
1. Verify SFTP server is running
2. Check firewall allows outbound port 22 (or custom port)
3. Test connection manually:
```cmd
sftp username@sftp.example.com
```

### Issue 2: Authentication Failed
**Error:** `Auth fail`

**Solutions:**
```yaml
# Try with explicit auth method
fs:
  ...
  username: "ramesh"
  password: "password"
  # OR
  pem_path: "C:/path/to/key"
```

### Issue 3: Permission Denied on Path
**Error:** `Permission denied: /remote/path`

**Fix:**
- Verify the user has read access to the path
- Use absolute path from user's home directory
- Test manually: `sftp> ls /remote/path`

### Issue 4: SSH Key Not Working
**Checklist:**
- Key file exists at specified path
- Path uses forward slashes: `C:/Users/Name/.ssh/id_rsa`
- Key file has correct permissions
- Key format is correct (OpenSSH format)

**Convert PuTTY key to OpenSSH:**
```cmd
# Use PuTTYgen to export as OpenSSH key
```

### Issue 5: Host Key Verification Failed
**Error:** `Host key verification failed`

**Solution 1 - Add to known_hosts:**
```cmd
ssh username@sftp.example.com
# Accept the host key
```

**Solution 2 - Disable strict checking (less secure):**
```yaml
fs:
  ...
  # FSCrawler usually accepts unknown hosts automatically
  # If issues persist, check FSCrawler version
```

## Testing SFTP Connection Before FSCrawler

### Test with Command Line SFTP
```cmd
# Windows (using OpenSSH)
sftp username@sftp.example.com

# Test specific port
sftp -P 2222 username@sftp.example.com

# With key
sftp -i C:/Users/Name/.ssh/id_rsa username@sftp.example.com
```

### Test with WinSCP (Windows GUI)
1. Download WinSCP
2. Create new session with your SFTP details
3. If WinSCP connects, FSCrawler should too

### Test with FileZilla
1. Open FileZilla
2. Host: `sftp://sftp.example.com`
3. Username/Password
4. Port: 22
5. Connect

## Performance Tuning for SFTP

### Optimize Update Rate
```yaml
fs:
  update_rate: "1h"  # Check every hour instead of 15m
```

### Limit File Types
```yaml
fs:
  includes:
  - "*.pdf"
  - "*.docx"
  excludes:
  - "*.log"
  - "*.tmp"
```

### Adjust Bulk Size
```yaml
elasticsearch:
  bulk_size: 50  # Smaller for remote files
  flush_interval: "10s"
```

## Security Best Practices

### 1. Use SSH Keys Instead of Passwords
```yaml
fs:
  username: "ramesh"
  pem_path: "C:/Users/Ramesh/.ssh/id_rsa_fscrawler"
  # Remove password field
```

### 2. Restrict SFTP User Permissions
On SFTP server, create dedicated user:
```bash
# Create read-only user
sudo useradd -m -s /bin/bash fscrawler_readonly
sudo passwd fscrawler_readonly

# Set permissions
sudo chmod 755 /data/to/crawl
```

### 3. Use Separate SSH Key for FSCrawler
```cmd
# Generate dedicated key
ssh-keygen -t rsa -b 4096 -f C:\Users\Ramesh\.ssh\id_rsa_fscrawler

# Copy public key to server
type C:\Users\Ramesh\.ssh\id_rsa_fscrawler.pub
# Paste into server's ~/.ssh/authorized_keys
```

### 4. Don't Store Passwords in Plain Text
Use environment variables (requires custom wrapper script):
```yaml
fs:
  username: "${SFTP_USER}"
  password: "${SFTP_PASS}"
```

## Monitoring SFTP Jobs

### Check Job Status
```cmd
curl "http://localhost:9200/_cat/indices?v" | findstr sftp_job
```

### View Crawl Stats
```cmd
curl "http://localhost:9200/sftp_job/_count"
```

### Monitor Logs
Watch FSCrawler console output for:
```
INFO  Indexing SFTP [sftp.example.com:/remote/path]
INFO  10 files has been indexed
```

## Advanced SFTP Features

### 1. Crawl Multiple SFTP Servers
Create separate jobs for each server:
```cmd
bin\fscrawler sftp_server1 --loop 1
bin\fscrawler sftp_server2 --loop 1
```

### 2. Schedule SFTP Crawls (Windows Task Scheduler)
```cmd
# Create batch file: crawl_sftp.bat
@echo off
cd C:\fscrawler
bin\fscrawler sftp_job --loop 0
```

Add to Task Scheduler to run every hour.

### 3. Index to Different Elasticsearch Indices
```yaml
elasticsearch:
  index: "sftp_documents"  # Custom index name
  nodes:
  - url: "http://localhost:9200"
```

## Complete Working Example

### Server Setup (Linux SFTP Server)
```bash
# Create directory
sudo mkdir -p /var/sftp/documents
sudo chown ramesh:ramesh /var/sftp/documents

# Add some test files
echo "Test Document 1" > /var/sftp/documents/test1.txt
echo "Test Document 2" > /var/sftp/documents/test2.txt
```

### FSCrawler Configuration
**_settings.yaml:**
```yaml
name: "sftp_docs"
fs:
  url: "/var/sftp/documents"
  protocol: "sftp"
  server: "192.168.1.50"
  port: 22
  username: "ramesh"
  password: "SecurePassword123"
  update_rate: "30m"
  excludes:
  - "*/.*"
  add_filesize: true
  remove_deleted: true
  index_content: true
  index_folders: true
elasticsearch:
  nodes:
  - url: "http://localhost:9200"
  index: "sftp_docs"
  bulk_size: 100
  flush_interval: "5s"
```

### Run and Verify
```cmd
# Start FSCrawler
bin\fscrawler sftp_docs

# Verify indexing
curl "http://localhost:9200/sftp_docs/_search?pretty"

# Count documents
curl "http://localhost:9200/sftp_docs/_count"
```

## Comparison: Local vs SFTP

| Feature | Local (`file://`) | SFTP |
|---------|------------------|------|
| Speed | Faster | Slower (network) |
| Access | Direct disk | Network connection |
| Authentication | File permissions | Username/password or key |
| Use Case | Local files | Remote servers |
| Setup | Simple | Needs credentials |

## Next Steps After SFTP Setup

1. **Monitor Performance:** Check indexing speed
2. **Optimize Filters:** Exclude unnecessary files
3. **Schedule Runs:** Use Task Scheduler for automation
4. **Set Up Alerts:** Monitor for connection failures
5. **Document Management:** Track indexed vs skipped files

## Quick Reference

```yaml
# Minimal SFTP config
fs:
  url: "/remote/path"
  protocol: "sftp"
  server: "host.com"
  port: 22
  username: "user"
  password: "pass"
```

```cmd
# Create and run SFTP job
bin\fscrawler sftp_job

# Run continuously
bin\fscrawler sftp_job --loop 1

# Check results
curl "http://localhost:9200/sftp_job/_count"
```
