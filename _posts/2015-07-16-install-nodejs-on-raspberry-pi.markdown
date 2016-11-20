---
layout: post
title: "라즈베리파이에 Node.js 설치하기"
date: 2015-07-16
tags: raspberry-pi linux tutorial tips nodejs
image: /blogimgs/node_arm.png
---

라즈베리파이에 Node.js 를 설치해 봅시다. Node.js 로 작성한 앱을 실행하려면 필요하니, 설치해 봅시다.

직접 컴파일 하여 설치 하는 법과, 미리 빌드된 패키지를 사용하여 설치하는 법이 있습니다.
이 포스트에서는 두 방법 모두 다 다룰겁니다.

### 컴파일하여 설치하기
방법은 쉬우나, 시간이 너무 오래 걸립니다. 필자는 권장하고 싶지 않은 방법입니다.

시작하기 앞서, 아래 프로그램들이 설치 되었는지 확인하시고, 설치 안된 것들은 모두 설치하세요.

 - GCC 4.2 이상
 - G++ 4.2 이상
 - Python 2.6 또는 2.7
 - GNU Make 3.81 이상
 - libexecinfo (FreeBSD 와 OpenBSD 사용시만)

그리고 아래 명령을 순차적으로 실행하여, 소스코드를 받고, 컴파일하여, 설치합니다.
컴파일 시간이 매우 오래 걸리니(사양이 낮은 라즈베리파이에서 빌드하므로...), 차 한잔 하시거나 한숨 주무시고 오시는 것이 좋습니다.
```bash
wget https://nodejs.org/dist/v0.12.7/node-v0.12.7.tar.gz
tar xvzf node-v0.12.7.tar.gz
cd node-v0.12.7
./configure
make
sudo make install
```

### 미리 빌드된 패키지로 설치하기

Nathaniel Johnson 이 빌드해 둔 패키지를 다운로드하여 설치합니다.
미리 빌드된 것을 설치하기에, 금방 설치가 가능합니다.(적어도 직접 컴파일 할 때 보다 훨씬 빨리...)

아래 명령들을 순서대로 실행하여, 패키지를 받고 설치합니다.
```bash
wget http://node-arm.herokuapp.com/node_latest_armhf.deb
sudo dpkg -i node_latest_armhf.deb
```

### 설치 잘 되었나 확인하기.
설치 후, Node.js 와 Npm 버전 띄우는 명령으로 설치가 잘 되었는지 확인해 보세요.
참고로 최근 버전의 Node.js 는 설치시 Npm 도 같이 설치 됩니다.
```bash
node -v
npm -v
```
