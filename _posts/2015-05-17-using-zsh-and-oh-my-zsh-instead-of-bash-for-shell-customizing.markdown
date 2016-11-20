---
layout: post
title: "zsh 와 oh my zsh 를 이용해 셸 꾸미기(대신 bash 버리기)"
date: "2015-05-17"
tags: update tips tutorial shell linux ubuntu archlinux fedora zsh oh_my_zsh
image : /blogimgs/zsh-is-awesome.png
---

보통 우리가 리눅스나 맥에서 터미널을 사용할 때 사용하게 되는 명령줄은 셸 bash 입니다.<br>
이 게시물에서는 기존에 우리가 쓰던 bash 대신 zsh 를 설치하고, zsh 에 대한 간단한 설명과 꾸미는 방법을 간단히 다뤄보고자 합니다.

## bash? zsh?
- bash(Bourne-again shell) 은 오늘날 리눅스, 맥 OS X 등 다양한 OS 에서 기본으로 사용되는 셸 입니다. 1989 년에 발표되어 지금까지 쓰이고 있습니다.
- zsh 는 bash 의 동생 격 정도(?) 라고 볼 수 있습니다. 1990년에 발표되어 사용되고 있습니다. bash 에 호환되며, 테마, 자동완성(명령줄 옵션까지 자동완성 해주는...) 등 강력한 기능 들이 특징입니다.

## zsh 는 뭐가 좋나요?

- 자동완성 기능이 좋습니다. (명령줄 치다 옵션 같은것 기억 안날때, Tab 키 누르면 그 뒤에 나올 것들을 추천해 줍니다.)
- 명령어 치다가 잘못된 철자 자동으로 고쳐줍니다 (Tab 키 누르면 자동으로...)
- oh my zsh 를 같이 사용하면 더 강력합니다.(보통 oh my zsh 는 zsh 사용시 같이 사용합니다)
    - oh my zsh 사용시 플러그인과 다양한 테마를 사용하실 수 있습니다.

## zsh 설치 및 초기설정 하기.

설명은 대충 끝났으니 설치해 봅시다. 보통의 경우 이미 설치된 경우가 많지만, 그렇치 않은 경우도 있습니다.
설치 안되어 있는 경우는, 터미널을 열고, 아래 명령줄을 실행하셔서 설치합니다.
리눅스의 경우 보통 배포판별로 패키지 저장소에 있는 zsh 를 패키지 관리자로 설치하시면 됩니다.

Arch Linux

```bash
 sudo pacman -S zsh
```

Debian based distros(Debian, Ubuntu, Linux Mint, etc.)

```bash
 sudo apt-get install zsh
```

Fedora

```bash
 sudo yum install zsh
```

설치 후, 기본 셸을 zsh 로 변경해 줍시다. 아래 명령줄을 실행하세요.

```bash
 chsh -s /usr/local/bin/zsh
```

변경 후, 터미널을 닫고 다시 새로 열어주세요. 아래 명령줄로 zsh 로 변경 되었는지 확인합
니다.
```bash
 echo $SHELL
 zsh --version
```

.zshrc 설정을 하려면 아래 명령줄을 이용하세요, 쉽게 설정 가능합니다.<br>
oh my zsh 설치 시 .zshrc 파일 설정을 해 주기에 반드시 하실 필요는 없습니
다.
```bash
 zsh /usr/share/zsh/functions/Newuser/zsh-newuser-install -f
```

## oh my zsh 설치

별거 없습니다. 아래 명령줄 중 하나를 실행하세요.

curl 을 이용하여 설치하기

```bash
 curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
```

wget 을 이용하여 설치하기

```bash
 wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
```

## 테마 적용하기

테마를 적용하려면, .zshrc 수정 후 저장합니다.ZSH_THEME 값을 원하시는 테마 이름으로 바꾸시면 됩니다. <br>
[여기](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes)에서 어떤 테마가 있는지 살펴보세요.
전 agnoster 테마로 설정하겠습니다.

```bash
...
ZSH_THEME="agnoster"
...
```

agnoster 를 포함한 일부 테마는 특수한 폰트를 요구합니다 [여기](https://github.com/powerline/fonts) 에서 <br>
Download ZIP 을 눌러 폰트를 받으신 후, 압축을 풀어 해당 폴더에서 다음과 같은 명령줄을 실행하여 폰트를 설치합
니다.
```bash
./install.sh
```

## 끝!
<img src="/blogimgs/zsh-is-awesome.png"><br>
전 여기까지만 알려드릴거고 나머지 다른 커스터마이징은 oh my zsh 문서를 읽어보세요.<br>
제가 사용중인 zsh 모습은 사진과 같습니다. 참고로 색상 팔레트는 솔라리스 사용중 입니다. gnome-terminal 의 경우 내장되어 있습니다.<br>
터미널 폰트는 Ubuntu Mono derivative Powerline 사용 중입니다.<br>

- [oh my zsh 위키](https://github.com/robbyrussell/oh-my-zsh/wiki)
- [oh my zsh 커스터마이징](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization)
- [oh my zsh 웹사이트](http://ohmyz.sh/)
- [No, Really. Use Zsh.](http://fendrich.se/blog/2012/09/28/no/)
