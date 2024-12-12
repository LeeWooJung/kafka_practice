# 명령어

## Docker

Docker에서 MySQL 접속

``` bash
docker exec -it [Container Name] /bin/bash
```

## 실행

root 접속

``` bash
mysql -u root -p
```

## Schema 전환

sourcedb schema 사용

``` bash
use sourcedb;
```

sinkdb schema 사용

``` bash
use sinkdb;
```