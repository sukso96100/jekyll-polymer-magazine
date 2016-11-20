---
layout: post
title: "(Update | #20)WhiteBeam Kernel For YP-GB1"
date: 2012-07-30
tags: migrated(old) android kernel development yp-gb1
---

오늘 아침에 일어나서 새로 컴파일한 커널입니다 ㅎㅎㅎㅎㅎ<br>
이번 업데이트에서는 BFQ i/o 스케쥴러를 세로 추가하였습니다.<br>
v2를 추가할려 했는대 혹시나 해서 <br>
2.6.35버전 커널용 v1r1버전 넣었습니다 ㅎㅎ<br>
나중에 v2버전으로 교체하도록 하겠습니다.<br>
<br>
아직 기본 스케쥴러는 SIO로 해 두었습니다.<br>
BFQ를 사용하고 싶으시면, NSTools같은 앱을 이용하시면 됩니다.<br><br>


-----------------------------------------------------------<br><br>

다운로드(2012.07.30일자 빌드, 버전#20)<br>
https://sourceforge.net/projects/wbcypgb1/files/WBK_YP-GB1_GB_20120730.tar/download<br><br>

-----------------------------------------------------------<br>

소스코드<br><br>
 <br>
커널소스 https://github.com/sukso96100/WhiteBeam-Kernel-For-YP-GB1<br>
initramfs(KRKPC) https://github.com/sukso96100/WBK_YP-GB1_GB_KRKPC_intiramfs<br>
initramfs(KRKPG) https://github.com/sukso96100/WBK_YP-GB1_initramfs_KRKPG<br>
<br>

-----------------------------------------------------------<br>