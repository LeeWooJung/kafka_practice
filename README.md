# Architecture

Docker를 활용한 Kafka와 MySQL 데이터 파이프라인

## [MySQL](https://github.com/LeeWooJung/kafka_practice/tree/main/mysql)

* image

    ``` bash
    mysql:8.0
    ```

* port: 3306 사용
* /db/initdb.d 에서 database 정의
* /db/config 에서 binlog 활성화

### Sourcedb

* 소스 데이터 저장
* 변경 데이터 캡쳐를 위한 Binlog 활성화
* Debezium Connector(Source Connector)로 Kafka와 연결

### Sinkdb

* Kafka 토픽에서 데이터를 받아, 동기화된 데이터 저장
* JDBC Connector(Sink Connector)로 Kafka와 연결

## [Source Connector](https://github.com/LeeWooJung/kafka_practice/tree/main/connector#source-connector)

**debezium connector 사용**

Source connector 설정
``` bash
source-connector.json
```

Source connector 실행파일
``` bash
setup-source-connectors.sh
```


* image

    ``` bash
    debezium/connect:2.7.3.Final
    ```

* port: 8083 사용
* zookeeper, mysql과 연결
* kafka, zookeeper, mysql에 의존

## Kafka

### Zookeeper

**Kafka 클러스터 관리**

* image

    ``` bash
    wurstmeister/zookeeper:latest
    ```

* port: 2181 사용

### Kafka

Message 브로커 역할

* image

    ``` bash
    wurstmeister/kafka:latest
    ```

* port : 9092 사용
* zookeeper와 연결

### Kafka Connect

데이터 소스와 싱크 간의 연결

## [Sink Connector](https://github.com/LeeWooJung/kafka_practice/tree/main/connector#sink-connector)

**jdbc connector 사용**

Sink connector 설정
``` bash
sink-connector.json
```

Sink connector 실행파일
``` bash
setup-sink-connectors.sh
```


* DockerFile로 정의

    - image
        ``` bash
        confluentinc/cp-kafka-connect:7.4.0
        ```
    - MySQL JDBC 드라이버 다운로드
    - Kafka JDBC Sink Connector 다운로드

* Port: 8084 사용
* kafka, zookeeper, mysql에 의존