---
layout: post
date: 2016-03-25
title: "Dokku 설치 및 설정하기"
image: /blogimgs/dokku_logo.png
tags: linux note update tip tips docker dokku
---

개인적으로 AWS EC2 인스턴스에 Dokku 라는 것을 설치해서 사용하는 중인데요.
Dokku 는 Heroku 와 같은 일종의 PaaS(Platform as a Service) 들 중 하나 입니다.
Docker를 활용하며, 약 200줄 짜리의 셸 스크립트 등으로 구성되어 있습니다.
대부분의 PaaS 와 다른 점이 있다면, Dokku 는 서비스를 제공하는 업체나 회사의 서버가 아닌, 사용자의 서버에서 돌아갑니다.
이 글을 통해 Dokku 를 설치하는 방법과 설정하는 방법을 알아봅시다.

## 설치
먼저 Dokku 를 설치할 서버의 셸에 접속합니다.

### Debian GNU/Linux 계열 배포판
Dokku 팀 쪽에서 제공하는 스크립트를 이용하여 설치합니다.

```bash
$ wget https://raw.githubusercontent.com/dokku/dokku/v0.4.14/bootstrap.sh
$ sudo DOKKU_TAG=v0.4.14 bash bootstrap.sh
```

### Arch Linux
AUR 로부터 [dokku](https://aur.archlinux.org/packages/dokku/) 패키지를 빌드하여 설치합니다.

```bash
yaourt -S dokku
```

## 초기 설정

### DNS 설정

필요한 경우, Dokku 가 설치된 서버에 도메인을 연결해 줍시다. 연결된 도메인은 Dokku 를 통해 배포된 앱의 주소로 사용됩니다.
아래와 같은 방법으로, DNS 를 설정합니다. 설정에 문제가 없는 경우, ssh 로 연결시 해당 도메인으로 연결 할 수 있어야 합니다.

```
(레코드 타입 / 이름 / 값(또는 서버 IP))
A / example.com / <서버 IP 주소>
A / *.example.com / <서버 IP 주소>
```

### 웹 브라우저에서 Dokku 초기 설정 하기

설치와 DNS 설정 등을 마쳤다면, 이번에는 서버 쪽에서 Dokku 초기 설정을 할 차례입니다.
웹 브라우저를 열고, 주소창에 서버의 IP 주소나 도메인을 쳐서 이동하세요. 아래 이미지와 같은 화면이 나타날 것입니다.

<img src="/blogimgs/dokku_setup.png"><br>

> 이미지 출처 : https://assets.digitalocean.com/articles/dokku_intro/dokku_setup.png

DNS 설정을 통해, 도메인을 서버와 연결할 경우 다음과 같이 설정합니다.

- Hostname 에 본인이 서버와 연결한 도메인을 입력합니다. (예시 : example.com)
- "Use virtualhost naming for apps" 항목을 체크 합니다.
 - 이렇게 하면, Dokku 를 통해 배포된 앱 들을 <앱-이름>.example.com 을 통해 이용할 수 있습니다.

## Dokku 를 통해 앱 배포하기

이제 Dokku 를 통해 앱을 배포해 봅시다. 먼저, 서버에 접속해서 앱을 하나 생성합시다.

```bash
dokku apps:create <원하는-앱-이름>
```

### 앱에 데이터베이스 연결하기
생성된 앱에는 기본적으로 데이터베이스가 연결되어 있지 않습니다. 필요한 경우 아래 과정을 거쳐, 데이터 베이스를 연결합니다.

먼저 Dokku 에서 사용 가능한 데이터베이스 플러그인을 설치합니다.
 [여기](http://dokku.viewdocs.io/dokku/plugins/#official-plugins-beta) 에서 어떤 플러그인이 있는지 확인 할 수 있습니다.

이 포스트에서는 PostgreSQL 플러그인을 예로 들어 설치합니다.

```bash
# PostgreSQL 플러그인 설치
sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git

# PostgreSQL 서비스 생성
dokku postgres:create <원하는-DB-서비스-이름>
```

이제 DB 서비스와 앱을 연결합시다.

```bash
dokku postgres:link <앱과-연결할-DB-서비스> <DB-서비스를-연결할-앱>
```

### 앱 배포하기
배포는 git 을 이용해 이뤄집니다. 먼저 배포할 앱의 디렉터리에 접근합니다.
그 다음, git 저장소를 초기화 하지 않은 경우, 초기화 하고, 리모트를 추가합니다.

```bash
cd <배포할-앱의-디렉터리>

# git 저장소가 아닌경우 새로 초기화
git init

# 서버의 Dokku 앱을 리모트로 추가
git remote add dokku dokku@example.com:<배포할-앱의-이름>
```

수정 사항을 커밋하고, 푸시하여 앱을 배포합니다.

```bash
git add .
git commit -m "Update"

# 앱 배포하기
git push dokku master
```

앱 배포가 성공적으로 된 경우, 아래와 같은 것을 보실 수 있게 됩니다.

```
=====> Application deployed:
       http://<배포된-앱-이름>.example.com
```

## 참고문헌 및 참고 웹페이지
- [Getting Started with Dokku](http://dokku.viewdocs.io/dokku/installation/)
- [How to Use the DigitalOcean Dokku Application](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-dokku-application)
- [DNS Configuration](http://dokku.viewdocs.io/dokku/dns/)
- [Deploying to Dokku](http://dokku.viewdocs.io/dokku/application-deployment/)
