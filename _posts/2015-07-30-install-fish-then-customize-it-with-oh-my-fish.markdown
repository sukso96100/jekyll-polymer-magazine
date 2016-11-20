---
layout: post
title: "Fish 셸 설치하고, Oh My Fish 로 커스터마이징 하기"
date: 2015-07-30
tags: fish_shell oh_my_fish update tips tutorial shell linux ubuntu archlinux fedora
image: /blogimgs/fish-shell.png
---

필자는 기본적으로 리눅스 배포판에 있는 bash 를 사용하다가, 전에 한번 zsh 로 갈아탔고.
이번에는, fish 라는 셸로 갈아 탔습니다. 주변 친구 몇명이 쓰길래, 한번 써보려고 설치해 봤더니, zsh 보다 더 편리하고. 커스터마이징 하기도 좋더군요.

이 포스트에서는 fish 셸을 설치하여 기본 셸로 설정하는 것과, Oh My Fish(Oh My Zsh 에 영감을 받아 만들어 졌다고 하네요.)를 이용해 커스터마이징 하는법을 다룹니다.

### 그래서, Fish 는 또 뭐가 좋나요?
fishshell.com 의 설명을 인용해 설명합니다.

- 자동완성 : 지금까지 제가 써온 셸(그래봤자 bash, zsh 뿐이지만...) 중에 가장 강력합니다. 사용한 명령줄 기록에 기반하여, 실행할 명령을 자동으로 추천해줍니다.
- 쉽고 편리한 스크립팅
- Man Page  자동생성
- 터미널에서 다양한 색상을 볼 수 있습니다.
- 웹 기반 설정 : GUI 사용 가능한 경우, 웹에서 fish 를 설정하실 수 있습니다.
- 구문 강조

### Fish 설치하고, 기본 셸로 설정하기.
별로 어렵지 않습니다. 배포판에 내장된 패키지 관리자로 설치하고, 명령줄 하나 실행해서 기본 셸로 설정하시면 됩니다.

#### Ubuntu
PPA 에서 패키지를 받아 설치합니다.

```bash
sudo apt-add-repository ppa:fish-shell/release-2
sudo apt-get update
sudo apt-get install fish
```

#### CentOS, Debian, Fedora, openSUSE, RHEL

다음 웹페이지를 방문하여, 본인의 배포판에 해당되는 것을 클릭하면 나오는 안내를 따라서 설치하세요.

[Install package shells:fish:release:2 / fish](http://software.opensuse.org/download.html?project=shells%3Afish%3Arelease%3A2&package=fish)

#### Arch Linux
pacamn을 이용해 ArchLinux 공식 저장소에서 받아 설치합니다.
```bash
sudo pacman -S fish
```

#### Gentoo linux
내장된 패키지 관리자를 이용하여 설치합니다.
```bash
su -
emerge fish
```

#### 기본 셸로 설정하기
다음 명령을 실행합니다.
```bash
chsh -s /usr/bin/fish
```

이제, 터미널을 다시 켜서 fish 셸이 나오는지 확인합니다. 나오지 않는다면, 로그아웃 후 다시 로그인 합니다.

### Oh My Fish 로 커스터마이징 하기

설치는 명령줄 하나면 됩니다.
```bash
curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/tools/install.fish | fish
```

이제 테마와 플러그인을 설치해 봅시다.
저는 'theme' 플러그인과 'agnoster' 테마를 설치할 겁니다. 그러기 위해서, 설정파일인, "~/.config/fish/config.fish"
를 열어줍시다.<br> 평소 사용하시는 텍스트 에디터로 열어주세요. 가장 하단에 다음을 추가해 줍시다.
```bash
Theme 'agnoster'
Plugin 'theme'
```

저장 후, 터미널을 열고 다음 명령을 실행합니다. 우리가 조금 전에 설정 파일에 명시한 플러그인과 테마를 설치합니다.
```bash
omf install
```

테마를 변경해 봅시다. 우리가 설치한, 'theme' 플러그인으로 쉽게 변경이 가능합니다.
```bash
# 설치된 테마 목록 보기
theme -l
# agnoster 테마 적용하기
theme agnoster
```

 더 많은 테마와 플러그인은 [여기](https://github.com/oh-my-fish?page=1) 에서 찾으실 수 있습니다.
 설정 파일에 사용할 테마나 플러그인을``` Theme '테마이름' Plugin '플러그인 이름'```형식으로 정의하시면 됩니다.

여기까지 작성하도록 하겠습니다. 자세한 사항은 아래 링크들을 참조하시면 좋을 것 같습니다.
<img src="/blogimgs/awesome-fish.png"><br>

- [fish shell](http://fishshell.com/)
- [fish shell 문서](http://fishshell.com/docs/current/)
- [Oh My Fish - GitHub 저장소](https://github.com/oh-my-fish/oh-my-fish)
- [Oh My Fish - 플러그인 및 테마](https://github.com/oh-my-fish)
- [Oh My Fish Wiki](https://github.com/oh-my-fish/oh-my-fish/wiki)
