---
layout: post
title: "라즈베리파이 모델B+ 에 아치리눅스ARM 설치하기."
date: 2015-07-11
tags: raspberry-pi linux tutorial tips archlinux
---

필자는 원래 라즈베라파이에 모델 B+에 Raspbian (라즈베리파이를 위해 만들어진 버전의 Debian GNU/Linux)를 설치하여 사용해 왔습니다. 
지금까지는 별 불편함이 없었으나, 이번에 Node.js 로 작성한 것을 테스트 하려다 보니 패키지 문제 때문에 제대로 테스트 하지 못했습니다.
nodejs, npm 패키지 모두 있었지만, 설치해도 제대로 작동하지 않는 듯 했다. npm 은 생각처럼 잘 작동하지도 않았습니다.

그러던 중, 아치리눅스ARM 을 발견했는데, 아치 리눅스 답게 패키지도 많고, 최신버전이더군요.
당장 아치 리눅스로 갈아타기로 했습니다.

그 방법을 이 글에서 소개하고자 합니다. 참고로 이 글에서는 라즈베리파이 2 가 아닌
기존버전의 라즈베라파이 모델 B+ 에 설치하는 법을 다룹니다.(제가 가진것이 모델 B+라... ㅎㅎㅎ)

먼저 리눅스 베포판이 설치된 컴퓨터(또는 노트북) 과 sd 카드를 컴퓨터와 연결할 도구를 준비하시고.
컴퓨터에 sd 카드를 연결합니다.

터미널을 열고, 루트 계정으로 전환합시다. 대부분의 명령을 실행할 때, 루트권한이 필요해서 그렇습니다.
앞에 sudo 를 붙이는 것도 좋치만, 루트로 전환하는 것이 편할 수도 있습니다.

```bash
sudo su
```

fdisk 를 이용하여 파티션 작업을 합니다. sd카드가 마운트 된 위치를 확인하신 후,
fdisk 를 실행합니다. 저의 경우에는 sd카드가 /dev/sdb 에 마운트 되어 있어, 다음과 같은 명령을 실행했습니다.
```bash
fdisk /dev/sdb
```

이제 다음 사항을 그대로 따라하세요!

- o 를 입력하여 파티견 테이블을 생성합니다.
- p를 입력하여, 파티션을 확인합니다. 목록에 파티션이 없어야 합니다.
- 파티션을 만듭시다. n 을 입력하세요, 그리고 p 를 입력하여 주 파티션으로 지정합니다. 
1 을 입력하여 첫번째 파티션으로 지정합니다. Enter 키를 눌러 first sector 사이즈는 기본값을 사용합시다. 
100MiB 보다 큰 용량의 숫자를 입력(Byte 단위로)하여 last sector 사이즈를 정합니다.
- t 입력 후, c 를 입력하여 첫번째 파티션 타입을 W95 FAT32 (LBA) 로 지정합니다.
- n, p, 2, Enter 키 2번 을 입력하셔서 두번쨰 파티션을 만듭니다.
- w 를 입력하여 파티션 설정을 적용하고 fdisk 에서 빠져 나옵니다.

이번에는 파일 시스템을 만들어 줍시다. 먼저 아래 명령줄들을 실행하여, fat 파일 시스템을 만들고 마운트 합니다.
```bash
mkfs.vfat /dev/sdb1
mkdir boot
mount /dev/sdb1 boot
```
다음으로, ext4 파일 시스템을 만들고 마운트 합니다. 아래 명령줄들을 실행하세요.
```bash
mkfs.ext4 /dev/sdb2
mkdir root
mount /dev/sdb2 root
```

루트 파일시스템을 다운로드 받아 sdb2 를 마운트한 root 폴더에 압축을 풀어줍시다.
```bash
wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz
bsdtar -xpf ArchLinuxARM-rpi-latest.tar.gz -C root
sync
```

boot 파일들을 첫번째 파티션을 마운트한 boot 폴더로 옮깁니다.
```bash
mv root/boot/* boot
```
설치가 끝났습니다. 이제 마운트를 해제하세요.
```bash
umount boot root
```

만들어둔 폴더들과 다운받은 파일은 불필요 하신 경우 지줘줍시다.
```bash
rm -rf boot
rm -rf root
rm ArchLinuxARM-rpi-latest.tar.gz
```
다 되었습니다. 이제 sd카드를 라즈베리파이에 삽입하시고, 부팅하셔서 사용하세요!
ssh나 시리얼로 연결하실 수 있습니다. 기본으로 있는 계정은 root 이며, 기본 비밀번호도 root 입니다.
