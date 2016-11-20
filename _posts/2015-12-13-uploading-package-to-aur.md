---
layout: post
date: 2015-12-13
title: "AUR 에 아치리눅스 패키지 올리기"
tags: archlinux aur packaging linux note update tip tips
---

아치리눅스에서 패키지를 설치하다 보면, 공식 저장소나 공식 미러가 아닌, 
[AUR(Arch User Repository)](https://wiki.archlinux.org/index.php/Arch_User_Repository) 에서 패키지를 받는 경우도 있습니다.
보통 공식 저장소에서 제공되지 않는 것들을 AUR 을 통해 받습니다. 이러한 패키지들은 사용자들이 패키징해서 올려둔 것인데,
이 포스트를 통해 AUR 에 패키지를(정확히는 AUR 에 패키지 빌드에 필요한 사항을 기술한 파일인 PKGBUILD 라는 파일 및 스크립트를)
한번 올려봅시다.

## 준비

먼저 AUR 사용자 계정과, ssh 키 한쌍을 준비합니다. AUR 계정은 [여기](https://aur.archlinux.org/register/) 에서 하나 새로 만드실 수 있고,
 `ssh` 키는 아래 명령어로 하나 새로 생성하실 수 있습니다. 생성된 `ssh` 키 쌍은 보통 `~/.ssh`에 저장 됩니다.
 
```bash
ssh-keygen
```

AUR 웹사이트에서 로그인 하신 뒤, "My Account" 로 가셔서, "SSH Public Key:" 에 조금전 생성한 ssh키 쌍의 공개키를 넣습니다.

아래는 AUR 에 패키지를 올릴떄의 규칙 입니다. 계속하기 앞서 읽어보시고 넘어가세요.

- 내가 AUR 에 올리려는 패키지가 이미 공식 저장소 또는 AUR 에 올라와 있는 지 여부를 확인하세요.
 - 중복된 패키지를 올리는 것은 허용되지 않습니다.
- 바이너리가 포함되어 있거나, 스크립트나 패키지 정보 등이 부실하게 기술된 패키지들은 경고 없이 제거됩니다.
- 올리려는 것이 올바른 것인지 확인하세요. 패키지 빌드에 필요한 정보를 기술하는 `PKGBUILD` 작성 시, 모든 기여자들은 [Arch packaging standards](https://wiki.archlinux.org/index.php/Arch_packaging_standards)를 준수해야 합니다.
- 올리려는 패키지가 유용한지 홧인하세요.
- 패키지에 대해(또는 빌드나 제출과정에 대해) 불확실 하시다면, [AUR 메일링 리스트](https://mailman.archlinux.org/mailman/listinfo/aur-general) 나 [AUR 포럼](https://bbs.archlinux.org/viewforum.php?id=4) 에 작성하신 `PKGBUILD` 를 제출하여 리뷰를 받으세요.
- 패키지를 올리기 전에 패키지를 몇번 빌드해서 경험을 쌓으세요.
- AUR 이나 공식 저장소의 패키지들은 일반적으로 소프트웨어나 소프트웨어 연관 컨텐츠를 설치하는 것을 의도로 합니다.

## 새로 올리기
아래와 같이 본인이 패키징할 소프트웨어 이름의 `git` 저장소를 하나 복제합니다. (네, 새로 만드는 게 아니고 복제 합니다.)

```bash
git clone ssh://aur@aur.archlinux.org/<원하는 패키지 이름>.git
```

예를 들어, `hello`라는 패키지를 올리려면, `hello`라는 저장소를 복제합니다. 

```bash
git clone ssh://aur@aur.archlinux.org/hello.git
```

그리고, 이제 복제된 저장소 폴더에 PKGBUILD 와 설치 스크립트 등을 넣어줍시다.

## PKGBUILD 작성하기
`PKGBUILD` 는 패키지 빌드에 필요한 정보듣. 예를 들자면, 버전, 의존성 패키지, 라이선스 등을 기술해 둔 파일입니다.
이것을 기반으로 하여, 패키지가 빌드되고, 패키지 메타 데이터를 기술하는 `.SRCINFO` 파일이 생성됩니다.

아래는 `PKGBUILD` 작성 예시 입니다. 예시를 보면서 각 변수가 무엇을 의미하는지 알아봅시다.

```bash
# Maintainer: Your Name <youremail@domain.com>
pkgname=NAME
pkgver=VERSION
pkgrel=1
pkgdesc=""
arch=()
url=""
license=('GPL')
groups=()
depends=()
makedepends=()
optdepends=()
provides=()
conflicts=()
replaces=()
backup=()
options=()
install=
changelog=
source=($pkgname-$pkgver.tar.gz)
noextract=()
md5sums=() #autofill using updpkgsums

build() {
  cd "$pkgname-$pkgver"

  ./configure --prefix=/usr
  make
}

package() {
  cd "$pkgname-$pkgver"

  make DESTDIR="$pkgdir/" install
}
```

### pkgbase
분할 패키지(하나의 소스트리에서 여러 패키지가 분리되어 빌드되는 경우)를 `PKGBUILD` 에 기술하는 경우 pkgname 보다 상위 개념으로 쓰이는 변수 입니다.
보통은 따로 기술되지 않으며, 기술되지 않으면, pkgname 이 pkgbase 로 사용됩니다.

### pkgname
패키지 이름입니다. 원하시는 패키지 이름 영문으로 넣으시면 됩니다.

### pkgver
패키지 버전입니다

### pkgrel
패키지 릴리즈 번호입니다. 동일 버전에서 2회 이상 릴리즈 하는경우 숫자를 1씩 더하여 쓰고, 새 버전이 나오면 다시 1로 되돌려 씁니다.

### pkgdesc
패키지에 관한 간단한 설명입니다.

### arch
페키지가 지원하는 CPU 아키텍쳐를 기술합니다.(예 : 'i686' 'x86_64')

### url
패키지가 설치하는 소프트웨어의 웹사이트 주소 등을 여기에 기술합니다.

### license
패키징하는 소프트웨어의 라이선스를 여기에 넣습니다.(예 : GPL, LGPL, MIT)

### groups
패키지가 속한 그룹을 여기에 모두 기술합니다.

### depends
패키지가 설치하는 소프트웨어가 실행 시 의존하는 패키지를 여기에 모두 기술합니다.

### optdepends
선택적으로 설치해도 상관없는 의존성 패키지를 여기에 기술합니다.

### makedepends
컴파일 시 필요한 패키지를 여기에 모두 기술합니다.

### provides
패키징 하고있는 소프트웨어와 같은 기능이나 특징을 제공하면서, 같이 설치되어 쓰일 수 있는 패키지를 여기에 기술합니다.

### conflicts
같이 설치될 수 없는, 같이 설치하면 충돌되는 패키지를 여기에 기술합니다.

### replaces
패키징 하고있는 패키지가 대체하는 패키지를 기술합니다.

### source
패키징할 소프트웨어의 소스코드 경로나 저장소 주소 등을 기술합니다.

### build()
패키징할 소프트웨어를 컴파일 하기 위해 실행해야 할 명령어를 기술합니다.

### package()
패키지를 생성하기 위해 실행하야 할 명령어를 기술합니다.

## 설치 스크립트 작성하기
필요한 경우, 패키지 설치/업그레이드/삭제 시 실행할 스크립트를 작성해 줍니다.
아래는 설치 스크립트 파일 예시 입니다.

```bash 
# This is a default template for a post-install scriptlet.
# Uncomment only required functions and remove any functions
# you don't need (and this header).

## arg 1:  the new package version
#pre_install() {
	# do something here
#}

## arg 1:  the new package version
#post_install() {
	# do something here
#}

## arg 1:  the new package version
## arg 2:  the old package version
#pre_upgrade() {
	# do something here
#}

## arg 1:  the new package version
## arg 2:  the old package version
#post_upgrade() {
	# do something here
#}

## arg 1:  the old package version
#pre_remove() {
	# do something here
#}

## arg 1:  the old package version
#post_remove() {
	# do something here
#}
```

몇가지 함수가 있는데, 살펴봅시다.

### pre_install()
패키지 설치 전에 실행할 명령어를 넣습니다.

### post_install()
패키지 설치 후에 실행할 명령어를 넣습니다.

### pre_upgrade()
패키지 업그레이드 전에 실행할 명령어를 넣습니다.

### post_upgrade()
패키지 업그레이드 후에 실행할 명령어를 넣습니다.

### pre_remove()
패키지 제거 전에 실행할 명령어를 넣습니다.

### post_remove()
패키지 제거 후에 실행할 명령어를 넣습니다.

## 업로드 하기
먼저 `pkgbuild-introspection` 패키지를 설치 하지 않으신 경우, 설치 하시고.

```bash 
sudo pacman -S pkgbuild-introspection
```

다음 명령어를 순서대로 실행해서 올립니다.

```bash 
cd <패키지 git 저장소 폴더>
mksrcinfo
git add .
git commit -m "<변경사항>"
git push
```

패키지가 잘 올라간 경우, 올라간 패키지를 AUR 에서 검색하실 수 있습니다.

---

## 참고자료

- [Arch User Repository](https://wiki.archlinux.org/index.php/Arch_User_Repository)
- [Arch packaging standards](https://wiki.archlinux.org/index.php/Arch_packaging_standards)
- [PKGBUILD](https://wiki.archlinux.org/index.php/PKGBUILD#changelog)
