---
layout: post
title: "Budgie Desktop을 비공식 PPA를 통해 사용해보세요."
date: 2014-07-29
tags: budgie-desktop ubuntu ppa
---

요즘 시간 날때, Budgie Desktop 이라는 데스크탑 환경을 우분투용으로 패키징하여,<br>
저의 개인 PPA에 올려서 배포하고 있습니다. Ubuntu에서 사용해 보고 싶으신 분들은,<br>
저의 PPA를 한번 사용해 보시면 좋으실 것 같습니다.<br><br>

현재 저의 PPA에 있는 Budgie Desktop 패키지는 Ubuntu 14.04 Trusty Thar 와,<br>
Ubuntu 14.10 Utopic Unicorn 용 패키지가 있습니다.<br>
빌드는 시간날때 해서 불규칙적으로(?) 올립니다.<br>
이 글 작성시간 기준으로	5.1r1버전의 패키지까지 PPA에 업로드 되어 있습니다.<br><br>

Ubuntu 14.04 또는 14.10사용하시는 분이시면, 사용하실 수 있습니다.<br>
터미널에서 아래 명령어를 실행하시면, PPA를 추가하고, Budgie Desktop을 설치하실 수 있습니다.<br><br>

<pre>
sudo add-apt-repository ppa:sukso96100/budgie-desktop
sudo apt-get update
sudo apt-get install budgie-desktop
</pre>
<br><br>
참고로, Budgie Desktop은 아직 기능도 많이 부족하고, 불안정하며. 현재 개발되고 있습니다.<br>
메인 데스크탑 환경으로 사용하시기에는 불편하신 점이 많으실 수도 있습니다.<br><br>

<img class="image-wrapper" src="{{ site.url }}/blogimgs/menu_51.png"><br>
이미지 출처 - https://evolve-os.com/release_images/menu_51.png
