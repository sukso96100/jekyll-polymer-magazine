---
layout: post
title: "EnhanceIO 를 이용하여, SSD를 캐싱용으로 사용하기."
date: 2015-09-04
tags: enhanceio linux tip tutorial ssd_caching archlinux
---

사용중이신 노트북이나 데스크탑에 500GB~1TB 정도 되는 하드디스크와 100GB~200GB정도 되는 SSD를 장착하여 같이 사용 하시나요?
이러한 환경에서 EnhanceIO 를 이용하시면, SSD를 하드디스크 캐싱에 사용하실 수 있습니다.
bcache 를 이용해서도 SSD에 캐싱을 할 수 있지만, 하드디스크와 SSD 모두 포맷하고 bcache 디바이스로 변환해야 SSD 에 캐싱이 가능하다는 번거로움이 있습니다.
반면 EnhanceIO 는 그럴 필요 없이 쉽게 설정하셔서 사용 하실 수 있습니다.
이 포스트에서는 리눅스에서 EnhanceIO 를 설치하고, SSD 캐싱을 설정하는 법을 다룹니다.

## 설치
### ArchLinux
enhanceio-dkms-git 패키지를 AUR 에서 설치합니다.
```bash
yaourt -S enhanceio-dkms-git
```
### Ubuntu
ppa:enhanceio/daily PPA를 추가하고, enhanceio 패키지를 설치합니다.
```bash
sudo add-apt-repository ppa:enhanceio/daily
sudo apt-get update
sudo apt-get install enhanceio
```

## 설정
간단합니다. eio_cli를 이용하여, 명령줄 하나만 실행하시면 됩니다.
```bash
sudo eio_cli create -d [마운트된 하드디스크 또는 하드디스크 파티션 경로] -s [마운트된 SSD 또는 SSD 파티션 경로] -c my_first_enhanceio
```
