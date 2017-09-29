# logsearch-cloudbreak-poc

## Build image
```bash
docker build -t logsearch-cloudbreak-poc:v1.0 .
```

## Run container
```bash
docker run -d --name logsearch logsearch-cloudbreak-poc:v1.0
```
(note: Solr port=8886, Log Search port=61888)
