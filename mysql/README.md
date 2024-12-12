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

## Sourcedb

Sourcedb Schema에서 Debezium Connector를 사용하여 Kafka와 연결.

### Table

* employee

### Data 삽입

예시

``` sql
INSERT INTO sourcedb.employee (identification_id, identification_pw, name, department) VALUES ('emp01', 'pw01', 'John Doe', 'IT');
```

## Sinkdb

### Table

* sinkdb.employee_history

### Data 확인

예시

``` sql
SELECT * FROM sinkdb.employee_history;
```