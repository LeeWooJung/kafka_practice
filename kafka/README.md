# 명령어

## Docker

Docker에서 실행중인 Kafka 실행

``` bash
docker exec -it [Container Name] /bin/bash
```

## Kafka

Topic 확인

``` bash
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic [topic name] --from-beginning
```