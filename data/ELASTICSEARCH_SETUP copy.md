# Elasticsearch Docker Setup - Simple Steps

## Prerequisites
- Docker installed on your local machine
- Docker Compose (usually comes with Docker Desktop)

## Setup Steps

### Step 1: Create the docker-compose.yml file
Save the provided `docker-compose.yml` file in your project directory.

### Step 2: Start Elasticsearch
Open terminal in the directory containing docker-compose.yml and run:
```bash
docker-compose up -d
```

This will:
- Download Elasticsearch and Kibana images (first time only)
- Start both containers in detached mode
- Create a persistent volume for data

### Step 3: Verify Elasticsearch is running
Wait about 30-60 seconds for Elasticsearch to start, then check:
```bash
curl http://localhost:9200
```

You should see a JSON response with cluster information.

### Step 4: Access the services
- **Elasticsearch**: http://localhost:9200
- **Kibana (Web UI)**: http://localhost:5601

## Basic Commands

### Check container status
```bash
docker-compose ps
```

### View logs
```bash
docker-compose logs -f elasticsearch
```

### Stop services
```bash
docker-compose stop
```

### Start services again
```bash
docker-compose start
```

### Remove everything (including data)
```bash
docker-compose down -v
```

## Test Elasticsearch

### Create an index
```bash
curl -X PUT "http://localhost:9200/my-index"
```

### Add a document
```bash
curl -X POST "http://localhost:9200/my-index/_doc/1" \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "Ramesh",
    "role": "Senior Java & Data Engineer",
    "experience": 14
  }'
```

### Search documents
```bash
curl -X GET "http://localhost:9200/my-index/_search?pretty"
```

## Configuration Notes

- **Memory**: Set to 512MB (adjust in ES_JAVA_OPTS if needed)
- **Security**: Disabled for local development (xpack.security.enabled=false)
- **Mode**: Single-node cluster (discovery.type=single-node)
- **Data**: Persisted in Docker volume 'elasticsearch_data'

## Troubleshooting

### Container won't start
Check if ports 9200, 9300, or 5601 are already in use:
```bash
docker-compose logs elasticsearch
```

### Increase memory if needed
Edit docker-compose.yml and change:
```yaml
- "ES_JAVA_OPTS=-Xms1g -Xmx1g"
```

### Reset everything
```bash
docker-compose down -v
docker-compose up -d
```

## Next Steps

Once running, you can:
1. Use Kibana Dev Tools at http://localhost:5601/app/dev_tools
2. Connect from your Java applications
3. Use with FSCrawler for document indexing
4. Build your search applications

## For FSCrawler Integration

Since you're working with FSCrawler, this Elasticsearch instance is ready to accept indexed documents. Just configure FSCrawler to point to http://localhost:9200.
