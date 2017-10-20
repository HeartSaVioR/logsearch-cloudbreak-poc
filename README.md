# logsearch-storm-poc

## Build image
```bash
docker build -t logsearch-storm-poc:v1.0 .
```

## Run container
```bash
docker run -d --name logsearch logsearch-storm-poc:v1.0
```
(note: Solr port=8886, Log Search port=61888)

## Usage example for testing
```bash
mkdir /my/path/logs
# put the log file into that directory
```
```bash
docker run -d --name logsearch -p 8886:8886 -p 61888:61888 -v /my/path/logs:/logs logsaerch-storm-poc:v1.0
```
