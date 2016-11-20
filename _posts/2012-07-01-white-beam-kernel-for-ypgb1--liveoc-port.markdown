---
layout: post
title: "White Beam Kernel for YP-GB1 | LiveOC port"
date: 2012-07-01
tags: migrated(old) android kernel development yp-gb1
---

음.. 커널 조금씩 개발중인대,<br>
오늘은 라이브oc 포팅했습니다.<br>
라이브 OC를 넣어서 사용자가 직접 오버클럭 클럭값을 바꿀 수 있는대,<br>
퍼샌트로 지정하는식으로 오버클럭이 가능하게 해줍니다 ㅎㅎ<br>
<br>
일단은 컴파일 되었고 작동도 잘 되는듯 하니(?) 배포합니다.<br>
<br>
다운로드는 아래 링크 따라가시면 됩니다.<br>
http://sourceforge.net/projects/wbcypgb1/files/WBK_YP-GB1_LiveOCport_tested_20120701.tar/download<br>
<br>
참고로 라이브 OC는 Ezekeel이라는 커널 개발자분의 소스를 썻으니, 가져온곳 출처도 남겨야 겠죠(?) 아래는 소스 가져온 곳 링크입니다.<br>
https://github.com/Ezekeel/GLaDOS-nexus-s/commit/c16ccc05e72abf33e9fd06c8a09373db44346ece<br>
<br><br>

Live OC기능을 사용하실려면, NSTools 라는 앱이 있어야 클럭값 변경이 가능합니다.<br>
https://play.google.com/store/apps/details?id=mobi.cyann.nstools&amp;feature=search_result#?t=W251bGwsMSwxLDEsIm1vYmkuY3lhbm4ubnN0b29scyJd<br>
<br>
커널 플레싱 방법은, 커널을 다운받으시고, 기기를 다운로드 모드로 진입한후 컴퓨터와 연결하고, 컴퓨터에서는 오딘이란 프로그램(검색하면 쉽게 구할수 있습니다.) 을 켜고, PDA눌러서 다운받은 커널 파일(확장자는 .tar) 선택하고, start 눌러서 플래싱 하시면 됩니다.
<br><br>
아, YP-GB1 KRKPC펌웨어에서만 됩니다.<br>

![Device Info]({{ site.url }}/blogimgs/SC20120701-181312.png)
![Device Info]({{ site.url }}/blogimgs/SC20120701-175608.png)
