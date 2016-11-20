---
layout: post
date: 2016-03-25
title: "Let's Encrypt 를 이용해 Dokku 앱 HTTPS 연결 지원하기"
image: /blogimgs/LE_stacked1_L.png
tags: linux note update tip tips docker dokku letsencrypt
---

웹사이트들을 이용하다 보면, 보안을 위해 HTTPS 연결 지원을 하는 경우를 어렵지 않게 볼 수 있습니다.
보통 HTTPS 연결을 지원하려면, TLS/SSL 인증서를 발급받아야 합니다. 
그런대, TLS/SSL 인증서를 발급할 때 일정 금액을 지불해야 하다보니.
개인 사이트에 사용하는 경우에는 부담이 되는 경우가 있을 수가 있습니다.

Let's Encrypt 를 이용하면 이러한 부담 없이 TLS/SSL 인증서를 무료로 발급할 수 있습니다.
Let's Encrypt 는 TLS/SSL 인증 서비스를 무료로 제공하는 서비스입니다.
현제 퍼블릭 베타 단계를 거치고 있는 중입니다.
ISRG(Internet Security Research Group) 에서 서비스를 제공합니다.

Dokku 에서는 플러그인이 있어 이를 이용해 쉽게 인증서를 발급하고, 배포된 앱에 대해 HTTPS 연결을 지원할 수 있습니다.
지금부터 어떻게 하는지 알아봅시다.

## 플러그인 설치
Let's Encrypt 플러그인을 설치하려면, Dokku 가 설치된 시스템에서 아래 명령을 실행합니다.

```bash
sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
```

이미 설치되어 있으나 이전 버전인 경우, 업그레이드 해 줍시다.

```bash
sudo dokku plugin:update letsencrypt
```

## 사용법
사용법은 간단합니다. 먼저 인증서를 발급할 앱에 인증서 발급에 사용할 이메일 주소를 설정해 줍니다.

```bash
dokku config:set --no-restart <대상-앱-이름> DOKKU_LETSENCRYPT_EMAIL=example@example.com
```

그리고 인증서를 발급하세요.

```bash
dokku letsencrypt <대상-앱-이름>
```

필요한 경우 인증서를 갱신하거나 취소합니다.

```bash
dokku letsencrypt <대상-앱-이름>             # 대상 앱에 대해 인증서를 발급하거나 갱신합니다.
dokku letsencrypt:auto-renew                # 인증서 갱신이 필요한 모든 앱의 인증서를 갱신합니다.
dokku letsencrypt:auto-renew <대상-앱-이름>  # 대상 앱에 대해 인증서를 갱신합니다.
dokku letsencrypt:ls                        # Let's Enccrypt 인증서를 사용중인 앱의 목록을 봅니다.
dokku letsencrypt:revoke <대상-앱-이름>      # 대상 앱에 대한 인증서를 취소합니다.
```

인증서가 발급된 앱에 대해서는 Dokku 에 내장된 `certs:*` 명령을 사용하실 수 있습니다.

## 주의사항
- 앱 URL 에 `/` 와 같은 올바르지 않은 문자가 포함되어 있으면 안됩니다. 인증서 발급 시 발급 오류의 원인이 됩니다.
필요한 경우, `/home/dokku/VHOST` 그리고, `/home/dokku/<앱-이름>/VHOST` 에서 URL 을 수정하여, 올바르지 않은 문자를 지워 줍시다.
- Dokku 를 통해 배포중인 앱의 수가 매우 많은 경우, 각 앱의 서브도메인마다 인증서를 발급하지 않도록 주의합니다.
[동일한 최상위 도메인에 대해 발급 가능한 서로 다른 인증서 수가 제한되어 있습니다.](https://community.letsencrypt.org/t/rate-limits-for-lets-encrypt/6769)

## 참고문헌 및 참고 웹페이지
- [Let's Encrypt](https://letsencrypt.org/)
- [About - Let's Encrypt](https://letsencrypt.org/about)
- [dokku/dokku-letsencrypt : BETA: Automatic Let's Encrypt TLS Certificate installation for dokku https://blog.semicolonsoftware.de/securing-dokku-with-lets-encrypt-tls-certificates/](https://github.com/dokku/dokku-letsencrypt)
- [Dokku 에서 Let's Encrypt 인증서 발급 오류.](https://hashcode.co.kr/questions/1542/dokku-%EC%97%90%EC%84%9C-lets-encrypt-%EC%9D%B8%EC%A6%9D%EC%84%9C-%EB%B0%9C%EA%B8%89-%EC%98%A4%EB%A5%98)
- [Rate Limits for Let’s Encrypt](https://community.letsencrypt.org/t/rate-limits-for-lets-encrypt/6769)
