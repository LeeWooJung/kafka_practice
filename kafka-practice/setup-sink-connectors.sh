#!/bin/bash

# Kafka Connect 준비 상태 체크 함수
wait_for_connect() {
  local url=$1
  local retries=30  # 최대 30초 대기
  local count=0

  echo "Waiting for Kafka Connect Sink at $url ..."
  until curl -s $url | grep -q "version"; do
    count=$((count + 1))
    if [ $count -ge $retries ]; then
      echo "Kafka Connect Sink did not start within the timeout period."
      exit 1
    fi
    sleep 1
  done
  echo "Kafka Connect Sink is ready!"
}

# Source Connector 설정
wait_for_connect "http://localhost:8083/"

# Sink Connector 설정
curl -X POST -H "Content-Type: application/json" --data @/config/sink-connector.json http://localhost:8083/connectors
