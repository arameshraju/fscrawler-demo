# fscrawler-demo

Docker Compose setup that runs Elasticsearch, Kibana, and FSCrawler so you can index any host folder (default: `/data`) without installing the stack locally.

## Prerequisites
- Docker Desktop 4.24+ with Compose V2 enabled
- At least 4 GB RAM available for containers

## Getting started
1. **Pick the folder to index.** Create (or identify) a folder on your machine that you want FSCrawler to watch. On Linux/macOS that path can literally be `/data`. On Windows, use an absolute path such as `C:/Users/you/Documents/data`.
2. **Expose the folder to Compose.** Copy `.env.example` to `.env` and adjust `FSC_DATA_DIR` so Docker can bind-mount your folder.
3. **Review the crawler job.** `fscrawler/jobs/local-data/_settings.json` controls recursion depth, excludes, and the Elasticsearch index (`local-files`). Update it before starting the stack if you need different behavior.
4. **Start the stack.** Run `docker compose up -d` from the project root. Elasticsearch will listen on `localhost:9200`, Kibana on `localhost:5601`, and FSCrawler will scan your mounted folder every 15 minutes (`--loop 15`).
5. **Drop files in your folder.** FSCrawler reads from `/data` inside the container, which maps to whatever you set in `FSC_DATA_DIR`. Files are parsed and indexed into the `local-files` index automatically.

## Checking the results
- Kibana: Open http://localhost:5601, add the `local-files` data view, and explore documents.
- cURL / browser: `curl http://localhost:9200/local-files/_search?pretty` or visit the URL directly to inspect raw hits.
- Logs: `docker compose logs -f fscrawler` shows crawler activity and parsing errors.

## Customization tips
- **Multiple folders:** Duplicate `fscrawler/jobs/local-data`, adjust `name`/`index`, and add another FSCrawler service pointing at the new job.
- **Scheduling:** Change the `--loop` flag in `docker-compose.yml` to control how often the crawler re-runs. Use minutes as integers (`--loop 60`, `--loop 5`, etc.).
- **File filters:** Update `includes`/`excludes` in `_settings.json` to limit which files are indexed.
- **Security:** If you enable Elasticsearch security, set credentials in `_settings.json` (`username`, `password`, `ssl_keystore`) and turn `xpack.security.enabled=true` in `docker-compose.yml`.