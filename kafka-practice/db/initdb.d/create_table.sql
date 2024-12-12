-- debezium 권한 부여
CREATE USER 'debezium'@'%' IDENTIFIED BY '0000';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debezium'@'%';
FLUSH PRIVILEGES;


-- source 데이터베이스 및 테이블 생성
CREATE DATABASE sourcedb;

use sourcedb;

CREATE TABLE employee (
  identification_id VARCHAR(255),
  identification_pw VARCHAR(255),
  name VARCHAR(255),
  department VARCHAR(255),
  PRIMARY KEY (identification_id)
);

CREATE DATABASE sinkdb;

use sinkdb;

CREATE TABLE employee_history (
  identification_id VARCHAR(255),
  name VARCHAR(255),
  department VARCHAR(255),
  created_time TIMESTAMP,
  PRIMARY KEY (identification_id)
);