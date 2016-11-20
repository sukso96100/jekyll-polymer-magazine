---
layout: post
title: "Fedora 에서 Oracle JDK 설치하고 설정하기"
date: "2014-12-13"
tags: tutorial develop development raspberry-pi linux fedora jdk oracle
---

제가 최근 리눅스 베포판을 우분투에서 페도라로 갈아 탔습니다. 페도라가 써보고 싶었기도 하고, 버그도 우분투에 비해 적고 개인적으로 즐겨 쓰는 GNOME 데스크탑 환경에 대한 지원이 상당히 좋아서 갈아타게 되었습니다. 안드로이드 개발을 하다보니, JDK를 기본적으로 설치하는대요. 페도라는 설치 및 설정 방법이 차이가 있어 간단히 방법을 글로 정리 해 보고자 합니다.

## 설치

간단합니다. 페도라의 경우 RPM 패키지를 사용하는대, 오라클에서 JDK를 RPM 패키지로 제공하고 있어, 그냥 받아다가 설치 하시면 됩니다.

먼저 아래 웹 페이지로 이동합니다.

<a href="http://www.oracle.com/technetwork/java/javase/downloads/index.html">http://www.oracle.com/technetwork/java/javase/downloads/index.html</a>

* JavaPlatform (JDK)항목을 누릅니다
* Java SE Development Kit 에서 " Accept License Agreement" 항목을 선택하여, 라이선스에 동의합니다.
* 그러면 바로 아래에서 파일을 받을 수 있게 됩니다. Linux 항목들 중, 자신의 시스템에 맞는 "RPM 패키지(*.rpm)"을 눌러서 다운로드 하세요.32비트 시스템이면 Linux x86, 64비트 시스템이면 Linux x64 의 RPM 패키지를 받으시면 됩니다.

패키지를 설치하려면, 그냥 다운로드 받은 것을 파일 탐색이로 찿아, 더블클릭으로 열어서 설치 하실수도 있고, 터미널에서 명령어로 설치도 가능합니다.

터미널에서 명령어로 설치하려면, 터미널을 열고, 다운로드 받은 파일이 있는 곳으로 접근하세요. 그리고 아래 명령어를 실행합니다.
```bash
# "<파일이름>" 은 다운로드 받은 파일의 이름으로 합니다
sudo rpm -i <파일이름>
# 명령어 예시 : sudo rpm -i jdk-8u25-linux-x64.rpm
```

##JAVA_HOME 및 PATH 변수 설정

Java로 작성된 프로그램들 중 일부는, JAVA_HOME 및 PATH 변수가 설정 되어있어야 실행이 가능하기도 합니다.(예를 들자면, Android Studio?) 사용중인 계정에 대해서만 설정 하거나, 시스템 전체적으로 설정하실 수 있습니다.

먼저 프로필 파일을 텍스트 에디터로 열어주세요. 
```bash
# "gedit" 은 텍스트 에디터 이름 입니다. 
# 다른 텍스트 에디터 사용시 gedit 대신 해당 에디터 이름을 입력하세요.

# 사용중인 계정에 대해서만 설정 할 경우
gedit ~/.bash_profile
# 시스템 전체적으로 설정 할 경우
# (시스템 영역에 접근하여 파일 수정시, 루트 권한이 필요하므로, 앞에 sudo를 붙입니다.)
sudo gedit /etc/profile
```

에디터로 열었으면, 가장 아래에 다음을 추가 하세요.
```bash
# <JDK경로>는 여러분의 시스템에 JDK 가 설치된 경로로 하시면 됩니다.
export JAVA_HOME=<JDK경로>
# 예시 : export JAVA_HOME=/usr/java/jdk1.8.0_25
export PATH=$JAVA_HOME/bin:$PATH
```

다 했으면, 저장하고 에디터를 닫습니다. 그리고 아래 명령어로 설정한 것을 적용 시키세요.

```bash
# 사용중인 계정에 대해서만 설정 한 경우
source ~/.bash_profile
# 시스템 전체적으로 설정 한 경우
source /etc/profile
```

잘 설정 되었는지 확인 해봅시다. 아래 명령어로 확인하세요.
```bash
java -version
```

"Java(TM) SE ... "로 출력이 되면 오라클 JDK로 잘 설정이 된 것입니다. 저의 경우는 64비트 시스템에서 JDK8을 설치/설정 했기 때문에, 아래와 같이 나옵니다.

```bash
[youngbin@youngbin-desktop ~]$ java -version
java version "1.8.0_25"
Java(TM) SE Runtime Environment (build 1.8.0_25-b17)
Java HotSpot(TM) 64-Bit Server VM (build 25.25-b02, mixed mode)
[youngbin@youngbin-desktop ~]$
```
