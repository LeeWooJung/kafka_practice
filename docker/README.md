# 명령어

## Docker Container

docker container 확인

``` bash
docker container ls
```

docker container 목록

``` bash
docker ps  
docker ps -a
```

docker container 삭제

``` bash
docker rm -f [Container Name]
```

docker container volume 삭제

``` bash
docker-compose down -v
```

## 실행

### DockerFile

``` bash
docker-compose up --build
```

### 주의 사항

* Dockerfile로 빌드할 때, Image가 생성되는데 해당 이미지를 캐시로 쓰기 때문에, dockerfile을 수정하더라도 계속 이전 캐시를 사용하여 수정 내용이 적용되지 않음.

    - docker images로 생성된 이미지 확인 후, docker rmi [image id]로 해당 이미지 삭제.
    - docker-compose build --no-cache로 cache 없이 진행.