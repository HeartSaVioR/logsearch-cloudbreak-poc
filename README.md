# logsearch-cloudbreak-poc

## Build image
```bash
docker build -t logsaerch-cloudbreak-poc:v1.0 .
```

## Run container
```bash
docker run -d --name logsearch -p 61888:61888 -p 8983:8983 logsaerch-cloudbreak-poc:v1.0
```
