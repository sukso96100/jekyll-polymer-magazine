---
layout: post
date: 2015-11-16
title: "Ubuntu Server 에 Docker 설치하고 설정하기."
tags: aws server docker ubuntu linux tip tutorial note update
---

필자는 AWS EC2 VM에 도커(Docker)를 한번 설치하여, 이것저것 개발한 웹 앱과 서버 등을 돌려보기로 했습니다. 그러면서 포스팅으로도 정리하려 합니다. 먼저, 설치/설정을 대략 했는데, 이 포스트로 그 과정을 정리합니다.

## Docker??

도커(Docker)는, 리눅스 컨테이너 기술을 기반으로, 앱을 배포할 때 필요한 모든 것을 하나의 컨테이너에 담아 OS에 상관없이 앱을 패키징하여 배포할 수 있도록 해 주는 프로그램 입니다. 기존 가상머신을 이용하여 배포를 하는 경우에는, 호스트 OS 위에 가성머신을 올리고, 각 가상머신 마다 게스트 OS와 바이너리 및 라이브러리를 넣어 그 위애 앱 하나씩 올려 배포한다면. 도커의 경우에는, 호스트 OS 위에 바로 도커 엔진이 그 위에 바로 각 앱과 바이너리 및 라이브러리가 포함된 컨테이너가 있는 구조 입니다.

<img src="/blogimgs/vm-diagram.png">

> VM의 구조
> 출처 : https://www.docker.com/what-docker

<img src="/blogimgs/docker-diagram.png">

> Docker의 구조
> 출처 : https://www.docker.com/what-docker

## 설치해 봅시다.
필자는 EC2 인스턴스에 우분투 서버 14.04LTS 를 돌리므로 이를 기준으로 설명 하겠습니다.

먼저 사용중인 커널 버전이 3.10 이상이고 64bit 커널인지 확인합니다.

```bash
uname -r
```

우분투 12.04LTS의 경우, 커널 버전이 3.13 이상이여야 합니다. 아래 명령어로, 커널을 업그레이드 합니다.

```bash
sudo apt-get update
sudo apt-get install linux-image-generic-lts-trusty
sudo reboot
```

필요한 버전의 커널을 설치 하였다면, 이제 Docker 를 설치 합시다. 설치에 curl 이 필요 하므로, 먼저 curl 이 설치 되어 있는지 확인합니다.

```bash
which curl
```

설치 되어 있지 않다면, 설치 합니다.

```bash
sudo apt-get update
sudo apt-get install curl
```

아래 명령으로, 최신 버전의 Docker 를 설치합니다.

```bash
curl -sSL https://get.docker.com/ | sh
```

설치가 잘 되었는지 확인합니다.

```bash
sudo docker run hello-world
```


## (설정하기) Docker 그룹 만들기.
Docker 는 TCP 소켓 대신, 유닉스 소켓에 붙어 있습니다. 기본적으로 이 유닉스 소켓은 `root`사용자의 소유이며,
다른 사용자들은 `sudo`를 사용하여 접근할 수 있습니다. Docker 데몬의 경우는 그래서 항상 `root` 사용자로 실행됩니다.

`docker`명령어 사용시, `sudo`를 사용하지 않으려면, `docker` 유닉스 그룹을 만들고, 그 안에 사용자를 추가합니다.

 - `sudo`를 사용가능한 사용자로 로그인 합니다. 예를 들어 `ubuntu`라는 사용자로 로그인 합니다.
 - `docker` 그룹을 만들고, 그 안에 `ubuntu`사용자를 추가 합니다.
 
 ```bash
sudo usermod -aG docker ubuntu
 ```
 - `sudo없이 `docker` 명령이 실행 되는지 확인합니다.
 
 ```bash
 docker run hello-world
 ```

## (설정하기) 부팅시 Docker 데몬 자동 시작되도록 설정하기.

우분투 15.04 이상은, `systemd`로 서비스를 관리합니다. 아래 명령으로 부팅시 자동시작 되도록 설정합니다.

 ```bash
sudo systemctl enable docker
 ```

우분투 14.10 이하는, `upstart` 로 서비스를 관리하는데, 위의 과정에서 설치중 자동으로 설정되므로, 따로 설정하실 필요가 없습니다.

---

이번 포스트는 여기까지 입니다. 아래 링크를 참조하시면 좀 더 도움이 될 겁니다.

## 참고 및 추가자료 링크

 - [What is Docker](https://www.docker.com/what-docker)
 - [Installation on Ubuntu](https://docs.docker.com/v1.8/installation/ubuntulinux)
