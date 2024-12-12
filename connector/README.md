# Connector

Postman을 사용하여 Connector 연결 명령을 json을 이용하여 전송

## Json 명령 사용 이유

Kafka Connect REST API의 표준 방법.

* 동적 설정 변경

    Json을 사용하여 컨테이너 실행 중에도 새로운 커넥터를 등록하거나 기존 커넥터의 설정을 업데이트 할 수 있음.

* 분리된 설정 관리

    데이터베이스, Kafka, Debezium Connector 등 각각의 설정을 개별적으로 관리할 수 있음. 필요에 따라 다양한 데이터베이스 소스를 동적으로 추가 가능.

* 표준화된 접근 방식

    Kafka Connect의 REST API는 다양한 소스 및 싱크 커텍터를 지원하며, 동일한 방식으로 설정을 관리.

## Source Connector

### Debezium

* Source Connector로 주로 사용됨.
* CDC에 특화되어 있으며, 변경 이벤트를 감지해 Kafka Topic으로 전송하는 데 특화됨.
* Debezium의 Kafka Topic 데이터는 Before, After 필드를 가진 Json 포맷이며, 이를 기반으로 MySQL 테이블에 데이터를 반영할 로직이 필요.

### JSON

``` json
{
    "name": "mysql-source-connector",
    "config": {
        "connector.class": "io.debezium.connector.mysql.MySqlConnector",
        "tasks.max" : "1",
        "database.hostname": "mysql",
        "database.port": "3306",
        "database.dbname": "sourcedb",
        "database.user": "debezium",
        "database.password": "0000",
        "database.server.id" : "1234",
        "database.server.name": "mysql-source",
        "table.include.list": "sourcedb.employee",
        "topic.prefix" : "topic-test",
        "database.history.kafka.bootstrap.servers": "kafka:29092",
        "database.history.kafka.topic": "db_history.sourcedb",
        "schema.history.internal.kafka.topic": "schema-changes.sourcedb",
        "schema.history.internal.kafka.bootstrap.servers": "kafka:29092",
        "transforms": "unwrap, AddTimestamp",
        "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
        "transforms.unwrap.delete.handling.mode": "drop",
        "transforms.AddTimestamp.type": "org.apache.kafka.connect.transforms.InsertField$Value",
        "transforms.AddTimestamp.timestamp.field": "time"
    }
}
```

* database.hostname

    MySQL 서버의 호스트 이름 또는 IP 주소

* database.port

    MySQL 서버의 포트 번호

* database.user, database.password

    MySQL에 연결할 사용자 계정과 비밀번호

* database.server.id

    Debezium이 MySQL의 binlog(바이너리로그)를 읽을 때 사용할 고유한 서버 ID. 단, MySQL 서버 설정의 server-id와는 별개로 Debezium이 MySQL binlog를 읽는 자체 서버 ID를 지정.

* database.history.kafka.bootstrap.servers

    Kafka 클러스터의 호스트와 포트 (Kafka 브로커 주소)

* database.history.kafka.topic

    Debezium이 스키마 변경 이력을 저장할 Kafka 토핑 이름

* topic.prefix

    Kafka 토픽 이름의 접두사

* table.include.list

    모니터링할 테이블 목록

* CF. **Kafka TOPIC Name**

    topic.prefix + . + table.include.list로 topic이 생성됨.

* transforms.unwrap

    * type

        "org.apache.kafka.connect.transforms.InsertField$Value": Debezium이 기본적으로 생성하는 before, after 필드에서 after 값만 추출하여 토픽에 출력

* transforms.unwrap.delete.handling.mode

    * drop

        삭제 이벤트를 무시하도록 설정

## Sink Connector

* Debezium 자체에서는 지원하지 않음.
* 일반적으로 Kafka 데이터를 외부 데이터베이스(MySQL, Postgre SQL 등)에 내보내기 위해 JDBC Connector를 사용.

### JDBC Sink Connector

* 범용성

    JDBC Sink Connector는 MySQL, PostgreSQL, Oracle 등 여러 데이터베이스와 호환되며, 다양한 데이터베이스에 데이터를 내보낼 수 있음.

* 자동 테이블 생성 및 스키마 진화 지원

    auto.create 및 auto.evolve를 통해 Kafka 메시지를 기반으로 대상 데이터베이스에 테이블을 자동으로 생성하거나 업데이트 할 수 있음.

* 간편한 설정

    Kafka Topic의 데이터를 단순히 대상 데이터베이스로 보내는 데 적합하며, 별도의 추가 기능 없이 작동.

### Debezium

Debezum 자체로 Sink 역할을 수행할 수는 없지만, Source Connector에서 캡처된 변경 이벤트를 MySQL에 다시 적용하려는 경우, 아래와 같은 방법을 사용할 수 있음.

* Kafka Streams 또는 Kafka Connect JDBC 활용

    Kafka Streams(복잡한 데이터 처리 요구사항에 적합)를 사용해 Debezium의 이벤트 데이터를 처리하고 MySQL에 쓰는 애플리케이션 개발 가능.

### JSON

``` json
{
  "name": "mysql-sink-connector",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
    "tasks.max": "1",
    "topics": "topic-test.sourcedb.employee",
    "connection.url": "jdbc:mysql://mysql:3306/sinkdb?user=root&password=0000",
    "table.name.format": "employee_history",
    "auto.create": "true",
    "auto.evolve": "true",
    "insert.mode": "upsert",
    "pk.fields": "identification_id",
    "pk.mode": "record_key",
    "fields.whitelist": "identification_id,name,department, created_time",
    "transforms": "AddTimestamp",
    "transforms.AddTimestamp.type": "org.apache.kafka.connect.transforms.InsertField$Value",
    "transforms.AddTimestamp.timestamp.field": "created_time"
  }
}
```