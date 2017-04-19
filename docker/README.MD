# Cheatsheet

## Remove all docker containers:
```
docker rm $(docker ps -a -q)
```

## Remove all docker images:
```
docker rmi $(docker images -q)
```

## Get container IP
```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mssql-express
```
