# FSCrawler Setup Guide - Windows

## Prerequisites
✅ FSCrawler downloaded on Windows machine
✅ Elasticsearch running (use docker-compose from previous setup)
✅ data/ folder ready to crawl

## Step-by-Step Setup

### Step 1: First Time Setup
When you run FSCrawler for the first time, it will create the configuration:

1. Open **Command Prompt** or **PowerShell**
2. Navigate to your FSCrawler folder:
   ```cmd
   cd C:\path\to\fscrawler
   ```

3. Run FSCrawler to create initial config:
   ```cmd
   bin\fscrawler my_docs
   ```

4. FSCrawler will ask: **"Do you want to create job my_docs? (Y/N)"**
   - Type: **Y** and press Enter

5. It will create a folder: `%USERPROFILE%\.fscrawler\my_docs\`

### Step 2: Configure the Data Folder Path

1. Stop FSCrawler (Ctrl+C if running)

2. Open the configuration file:
   ```
   %USERPROFILE%\.fscrawler\my_docs\_settings.yaml
   ```
   
   On Windows, this is typically:
   ```
   C:\Users\YourUsername\.fscrawler\my_docs\_settings.yaml
   ```

3. Replace the content with this (adjust the path to your data folder):
   ```yaml
   name: "my_docs"
   fs:
     url: "C:/Users/YourUsername/path/to/data"
     update_rate: "15m"
     excludes:
     - "*/~*"
     json_support: false
     filename_as_id: false
     add_filesize: true
     remove_deleted: true
     add_as_inner_object: false
     store_source: false
     index_content: true
     attributes_support: false
     raw_metadata: false
     xml_support: false
     index_folders: true
     lang_detect: false
   elasticsearch:
     nodes:
     - url: "http://localhost:9200"
     bulk_size: 100
     flush_interval: "5s"
   ```

   **Important**: Use forward slashes (/) in the path, not backslashes (\)

### Step 3: Example Path Configurations

If your FSCrawler is at: `C:\fscrawler-es7-2.10`
And your data folder is at: `C:\fscrawler-es7-2.10\data`

Then set:
```yaml
fs:
  url: "C:/fscrawler-es7-2.10/data"
```

Or if data is in current directory, you can use relative path:
```yaml
fs:
  url: "./data"
```

### Step 4: Start Elasticsearch (if not running)
```cmd
docker-compose up -d
```

Wait 30 seconds for Elasticsearch to be ready.

### Step 5: Run FSCrawler

From your FSCrawler directory:
```cmd
bin\fscrawler my_docs
```

You should see output like:
```
[INFO] Starting FS crawler
[INFO] Indexing C:/path/to/data folder
[INFO] 10 files has been indexed...
```

### Step 6: Verify Indexing

Open browser and go to:
```
http://localhost:9200/my_docs/_search?pretty
```

Or use Kibana Dev Tools at:
```
http://localhost:5601/app/dev_tools
```

## Common Commands

### Run FSCrawler in Loop Mode (continuous monitoring)
```cmd
bin\fscrawler my_docs --loop 1
```
This checks for changes every 1 iteration.

### Run Once and Exit
```cmd
bin\fscrawler my_docs --loop 0
```

### Reset and Re-index Everything
```cmd
bin\fscrawler my_docs --restart
```

### Check Configuration
```cmd
type %USERPROFILE%\.fscrawler\my_docs\_settings.yaml
```

## Configuration Options Explained

```yaml
url: "C:/path/to/data"           # Folder to crawl
update_rate: "15m"                # Check for changes every 15 minutes
excludes: ["*/~*"]                # Exclude temp files
add_filesize: true                # Include file size in index
remove_deleted: true              # Remove docs when files deleted
index_content: true               # Index file content (not just metadata)
index_folders: true               # Index folder names too
```

## Supported File Types

FSCrawler automatically handles:
- **Documents**: PDF, DOC, DOCX, XLS, XLSX, PPT, PPTX
- **Text**: TXT, RTF, HTML, XML, JSON
- **Images**: Can extract text from images (OCR if configured)
- **Archives**: ZIP (if configured)
- Many more formats via Apache Tika

## Troubleshooting

### "Cannot connect to Elasticsearch"
Check if Elasticsearch is running:
```cmd
curl http://localhost:9200
```

### "Access Denied" errors
Run Command Prompt as Administrator, or check folder permissions.

### Files not being indexed
1. Check the path is correct (use forward slashes)
2. Check file permissions
3. Look at FSCrawler logs for errors

### Re-index from scratch
```cmd
bin\fscrawler my_docs --restart
```

## Quick Test Setup

1. Create test data:
   ```cmd
   mkdir data
   echo "Hello World" > data\test.txt
   echo "Sample document" > data\sample.txt
   ```

2. Run FSCrawler:
   ```cmd
   bin\fscrawler my_docs
   ```

3. Search:
   ```
   http://localhost:9200/my_docs/_search?q=Hello
   ```

## Advanced: Create Batch File for Easy Start

Create `run-fscrawler.bat` in your FSCrawler folder:
```batch
@echo off
cd /d "%~dp0"
bin\fscrawler my_docs --loop 1
pause
```

Double-click this file to start FSCrawler!

## Next Steps

Once data is indexed:
1. Use Kibana to explore: http://localhost:5601
2. Build search applications using Elasticsearch API
3. Query from Java applications
4. Create dashboards and visualizations

## Example Searches

### Search for keyword
```
GET my_docs/_search
{
  "query": {
    "match": {
      "content": "your search term"
    }
  }
}
```

### Get all indexed files
```
GET my_docs/_search
{
  "query": {
    "match_all": {}
  }
}
```

### Filter by file type
```
GET my_docs/_search
{
  "query": {
    "term": {
      "file.extension": "pdf"
    }
  }
}
```
