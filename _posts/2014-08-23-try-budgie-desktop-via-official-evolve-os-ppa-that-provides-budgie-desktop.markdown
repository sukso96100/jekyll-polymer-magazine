---
layout: post
title: "Budgie Desktop을 공식 Evolve OS PPA를 통해 사용해 보세요"
date: "2014-08-23"
tags: update budgie-desktop ubuntu ppa
---
<img class="image-wrapper" src="{{ site.url }}/blogimgs/evolve-os-ppa.png"><br>

이제 우분투용 Budgie Desktop 패키지가 공식 Evolve OS PPA를 통해서도 배포됩니다.<br>
Evolve OS PPA에서는 Budgie Desktop뿐만 아니라, 다른 Evolve OS 소프트웨어 또한 제공할 예정입니다.<br>
<br>
그리고 운이 좋은건지, 제가 공식 Evolve OS PPA 관리를 하게 되었습니다. 저는 Budgie Desktop 패키지를 관리하고 있습니다.<br>
앞으로는 더 잘 관리하여 더 좋은 패키지를 제공해 드리겠습니다.^^<br>
<br>
Evolve OS 공식 PPA 를 통해서 Budgie Desktop을 설치하실 분들은, 아래 명령어를 실행하시기 바랍니다.<br>

```bash
sudo add-apt-repository ppa:evolve-os/ppa
sudo apt-get update
sudo apt-get install budgie-desktop
```

저의 기존 비공식 Budgie Desktop PPA는 계속 관리됩니다. 여기에는 불안정 패키지도 업로드 됩니다.<br>
제 비공식 PPA사용을 여전히 사용하실 분은 아래 명령어를 이용하시면 됩니다.<br>

```bash
sudo add-apt-repository ppa:sukso96100/budgie-desktop
sudo apt-get update
sudo apt-get install budgie-desktop
```
