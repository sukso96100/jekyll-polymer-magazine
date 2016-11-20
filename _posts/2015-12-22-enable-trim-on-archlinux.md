---
layout: post
date: 2015-12-22
title: "아치리눅스에서 SSD TRIM 사용하기"
tags: archlinux ssd trim linux note update tip tips
---

하드디스크에서 파일을 지우면, 디스크에서 완전히 파일을 지우지 않고 
위치를 알려주는 연결만 끊었습니다. 그리고 다른 새 파일을 저장할 때, 덮어쓰기 했습니다.
완전히 지우고 새로 저장 하기엔 시간이 오래 걸리는 것이 그 이유입니다.
실제로 Windows 나 리눅스에서 파일을 지우거나 디스크를 "빠른 포맷" 으로 포맷하면, 파일이 완전히 지워지지 않고,
연결만 끊김니다. 나중에 덮어씌우면 되니까요.

하드디스크와 달리, SSD 는 덮어쓰기 기능이 없습니다. 그래서 실제로 파일을 완전히 지워주고 새로 저장해 줘야 합니다.
그런대 기존 OS 에서는 하드디스크에서 하던 것처럼 연결만 끊어서 SSD 에 불필요한 파일이 쌓이게 되고,
SSD 의 성능 감소로 이어지게 됩니다. 그래서 파일을 지울때 연결만 지우는 것이 아닌 실제 파일까지 모두 지우는 TRIM 기능이 필요합니다.

Windows 의 경우 7 부터 기본적으로 이 기능이 켜져 있고, 리눅스의 경우는 Ubuntu 나 Linux Mint 가 최근 기본적으로 켜져서 나온다고 합니다.
아치 리눅스의 경우는, 아치를 기반으로 하는 배포판의 경우는 켜져 있는 경우도 있지만, 다른 아치리눅스 배포판이나 원래의 아치리눅스의 경우,
그렇치 않은 경우가 많으므로. 이번 포스트에서 SSD TRIM 을 아치리눅스에서 하는 방법을 알아봅시다.

## 수동으로 TRIM 하기
`fstrim`을 이용하여 TRIM 합니다.

```bash
sudo fstrim <TRIM할 리눅스 파티션> -v
```
예를들어 `/` 파티션을 TRIM 하는경우 아래와 같이 실행합니다.

```bash
sudo fstrim / -v
```

## 마운트 옵션 변경하기
대부분의 리눅스 배포판에서 사용되는 방법입니다. `/etc/fstab`을 수정합니다.
먼저 TRIM 할 파티션의 UUID 를 알아야 합니다. 아래 명령으로 UUID 를 알아냅니다.

```bash
lsblk -f
```

```bash
youngbin@youngbin-ultrabook ~> lsblk -f
NAME   FSTYPE LABEL        UUID                                 MOUNTPOINT
sda                                                             
├─sda1 ntfs   복구         66A8C7F0A8C7BCB5                     
├─sda2 vfat                1AC9-8CF1                            
├─sda3                                                          
├─sda4 ntfs   WINDOWS_MAIN 38B8006AB8002948                     
├─sda5 vfat                59C9-02ED                            /boot/efi
└─sda6 ext4                f50f4abf-fdcc-4263-9a5a-9ce0f9e080d8 /
sdb  
```

텍스트 에디터로 `/etc/fstab` 을 엽니다.

```bash
sudo gedit /etc/fstab
```

원하는 파티션에, `discard` 옵션을 추가합니다. `discard` 옵션은 파일이 지워질 때마다 TRIM 이 실행되도록 해 주는 옵션입니다.

> 수정 전 예시

```bash
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
#
UUID=f50f4abf-fdcc-4263-9a5a-9ce0f9e080d8 / ext4 defaults,rw,noatime 0 1
UUID=59C9-02ED /boot/efi vfat defaults,rw,noatime 0 0
```

> 수정 후 예시

```bash
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
#
UUID=f50f4abf-fdcc-4263-9a5a-9ce0f9e080d8 / ext4 defaults,rw,noatime,discard 0 1
UUID=59C9-02ED /boot/efi vfat defaults,rw,noatime 0 0
```

저장 후 재부팅 합니다.

## systemd 서비스 이용.
제일 간단한 방법이 아닐까 싶습니다. 아치리눅스에서 제공하는 `fstrim.service` 또는, `fstrim.timer` 를 켜주면 됩니다.
아래 명령어를 이용해 켤 수 있습니다.

부팅할 때 마다 TRIM 하려면, `fstrim.service` 를 켭니다.

```bash
sudo systemctl enable fstrim.service
```

1주일에 한번씩 TRIM 하려면, `fstrim.timer` 를 켭니다.

```bash
sudo systemctl enable fstrim.timer
```

---

지금까지, 아치리눅스에서 TRIM 켜는 법을 알아봤습니다. 
리눅스에서 SSD 를 사용 하신다면 TRIM 이 켜져있나 확인 하시고, 꼭 켜시기 바랍니다.

## 참고자료

- [Solid State Drives - ArchWiki](https://wiki.archlinux.org/index.php/Solid_State_Drives)
- [리눅스를 SSD 사용에 최적화 하는 방법 - 서지스원](http://sergeswin.com/980)
- [Linux환경에서 SSD 성능 최적화하기 - 그대 안의 작은 호수](http://www.smallake.kr/?p=7709)
