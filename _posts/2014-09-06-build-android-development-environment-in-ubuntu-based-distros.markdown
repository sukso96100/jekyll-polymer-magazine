---
layout: post
title: "우분투 계열 리눅스 베포판에서 안드로이드 개발환경 구축하기."
date: "2014-09-06"
tags: android app develop tutorial
---

친구가 안드로이드 앱 개발을 시작해서, 글로 정리해 줄 겸 다른 분들도 보시라고 블로그에 올려봅니다.

우분투 리눅스 계열 배포판에서 안드로이드 개발환경을 구축하는 법을 말해보고자 합니다.
이 게시물은 여러분들께서 우분투 계열 리눅스를 사용하시고 계신다고 가정하고 작성하였습니다.
도움이 되셨스면 좋겠습니다^^

---

## JDK 설치하기

먼저 안드로이드를 개발하려면, 안드로이드 앱을 Java로 작상하기에, JDK(Java Development Kit) 을 먼저 설치해야 합니다.
우분투에서는 기본적으로 오픈JDK 를 제공해 주는대, 그건 불안정해서 쓰기 좀 그러니. 여기서는 오라클 JDK를 설치 해 봅시다.

오라클 JDK는 라이선스 문제로, 기본적으로 우분투 패키지 저장소에서 제공되지 않으므로. 별도의 저장소를 추가 후 설치해야 합니다.
여기서는 <a href="https://launchpad.net/~webupd8team/+archive/ubuntu/java">WebUpd8 Team의 오라클 Java PPA 저장소</a>를 추가해 봅시다.

터미널을 열고, 아래 명령어를 실행하여 저장소 정보를 추가하고 설치합니다.
```bash
#오라클 자바 저장소 추가
sudo add-apt-repository ppa:webupd8team/java
#저장소 정보 업데이트
sudo apt-get update
#오라클 자바7 설치하기
sudo apt-get install oracle-java7-installer
```

---

## Android Studio 설치하기

JDK를 설치하였으면, 안드로이드 앱 개발에 사용할, 안드로이드 스튜디오를 설치합시다.

안드로이드 스튜디오는, Android Developers(d.android.com) 에서 배포하는 압축 패키지 파일을 받아, 압축을 풀고 실행하거나,
PPA 저장소를 추가하여 설치하는 법이 있습니다.

### 압축 패키지를 받아 풀고 실행하기.

아래 링크를 방문하여, 파란색 "Download Android Studio" 버튼을 눌러서 압축 패키지를 받으세요.
<a href="http://developer.android.com/sdk/installing/studio.html">http://developer.android.com/sdk/installing/studio.html</a>

다운로드 받은 압축 패키지의 압축을 풀으세요. 가능한 상위 디렉터리에 풀어두시는 것을 권장합니다.
앛축 풀린 폴더의 /bin 폴더에 들어가서, studio.sh를 실행하면, 안드로이드 스튜디오가 실행됩니다.
파일 관리자에서 실행되지 않으면, 터미널에서 실행해보세요.
예를 들어, 압축 풀린 안드로이드 스튜디오 파일들이, ~/다운로드/android-studio/ 에 있다면, 아래와 같은 명령어를 실행하면 됩니다.

```bash
cd ~/다운로드/android-studio/bin
./studio.sh
```

### PPA 로부터 설치하기.

<a href="https://launchpad.net/~paolorotolo/+archive/ubuntu/android-studio">Paolo Rotolo 의 PPA</a>로 부터 설치해 봅시다.
아래 명령어로, PPA를 추가하고 설치를 진행하세요.

```bash
sudo add-apt-repository ppa:paolorotolo/android-studio
sudo apt-get update
sudo apt-get install android-studio
```

설치 완료 후, 프로그램 메뉴에서 Android Studio 를 찿아 실행하세요.

---

## 필요한 SDK 도구 다운로드 하기

먼저 Android SDK Manager를 실행하세요.

### 처음 SDK Manager를 실행하는 경우 / 열린 프로젝트가 없는 경우

이 경우에는, Welcome to Android Studio 화면이 나옵니다.
여기서, Configure > SDK Manager 로 들어가면, Android SDK Manager가 실행됩니다.

### 열린 프로젝트가 있는경우.

상단 메뉴모음에서, Tools > Android > SDK Manager 로 진입하여 실행합니다.

---

필요한 것들을 선택하시고, Install [n] Packages 를 눌러 설치하세요.

보통 설치하는 항목들은 아래와 같습니다.

* Tools 항목들
* 앱 테스트에 사용될 기기에 설치된 안드로이드 버전에 해당되는 항목들
* Extras 항목들

다운로드 및 설치에 시간이 많이 걸리니, 차 한잔 하면서 기다려 봅시다.

---

환경 구축은 여기까지 입니다. 이제 본격적으로 안드로이드 앱을 개발해 보세요.
