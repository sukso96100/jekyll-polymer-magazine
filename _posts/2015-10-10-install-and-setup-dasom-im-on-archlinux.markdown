---
layout: post
title: "아치리눅스에서 다솜 입력기 설치 및 설정하여 사용하기"
date: 2015-10-10
tags: korean-input linux archlinux dasom-im
---
어제(10.09) 다솜 입력기 정식 버전이 나왔습니다. 그래서 아치 리눅스에서 사용하려고, 제가 패키징 하여 AUR에 올렸습니다.
기존 Fcitx 지우고 다솜 입력기 설치하여 사용했는데, 다른 입력기에 비해 사용하기 편하더군요.
아래 과정을 거쳐서 설치하시고 설정하시면, 사용하실 수 있습니다.

### 설치하기

[dasom-git](https://aur.archlinux.org/packages/dasom-git/) 패키지를 AUR 에서 받아 설치합니다.
[yaourt](https://wiki.archlinux.org/index.php/Yaourt) 같은 AUR 도구를 사용하세요.
```bash
yaourt -S dasom-git
```

### libindicator 빌드 오류 해결하기.
다솜 입력기는 libappindicator-gtk3 를 요구하는데, 이 패키지는 libindicator 패키지를 요구합니다.
그런데, libindicator 패키지를 빌드하는 중 아래와 같은 오류가 발생하는 경우가 있습니다.
```bash
/usr/bin/ld: cannot find -lglib-2.0-lm
```
이러한 오류를 방지하려면, 빌드에 앞서 아래와 같이, PKGBUILD 수정을 원하냐고 물을 때, y를 눌러, PKGBUILD 를 수정해야 합니다.
```bash
Edit PKGBUILD ? [Y/n] ("A" to abort)
```
그리고, PKGBUILD 에서 build() 부분의 cd 명령어와 ./configure 사이에 다음을 추가합니다.(두 군데 있는데, 두 군데 모두 추가합니다.)
```bash
sed -i 's/LIBINDICATOR_LIBS+="$LIBM"/LIBINDICATOR_LIBS+=" $LIBM"/g' ./configure
```
저장 후, 빌드를 계속하여 설치합니다.

### 입력기 설정하기
다른 입력기와 설정 방법은 거의 동일합니다.

먼저, ~/.xprofile 파일을 아래와 같이 수정하여 저장합니다.
```bash
export GTK_IM_MODULE=dasom
export QT_IM_MODULE=dasom
export XMODIFIERS="@im=dasom"
dasom-daemon &
dasom-indicator &
```

그리고, 그놈 셸을 사용하시는 경우, 아래 명령을 추가로 실행합니다.
```bash
gsettings set org.gnome.settings-daemon.plugins.keyboard active false
gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/IMModule':<'dasom'>}"
```

이제, 로그아웃 후 다시 로그인 하시면, 다솜 입력기를 사용하실 수 있습니다,

### 참고자료 & 관련자료
- [다솜 입력기 소스코드](https://github.com/cogniti/dasom)
- [다솜 입력기 AUR](https://aur.archlinux.org/packages/dasom-git/)
- [아치 위키 - Korean input (한국어)](https://wiki.archlinux.org/index.php/Korean_input_%28%ED%95%9C%EA%B5%AD%EC%96%B4%29)
- [AUR - libindicator](https://aur.archlinux.org/pkgbase/libindicator/)
- [Arch Linux Forums - Fcitx not work in Gnome 3.16](https://bbs.archlinux.org/viewtopic.php?id=196069)
- [우분투 한국 커뮤니티 포럼 - 다솜 입력기 1.0 출시합니다.](https://forum.ubuntu-kr.org/viewtopic.php?f=6&t=28301)
