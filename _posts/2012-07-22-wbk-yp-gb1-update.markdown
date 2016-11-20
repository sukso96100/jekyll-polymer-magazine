---
layout: post
title: "(업데이트)WhiteBeam kernel for YP-GB1"
date: 2012-07-22
tags: migrated(old) android kernel development yp-gb1
---

2012/07/22 일자 빌드한 커널입니다.<br>
기기는 YP-GB1, 펌웨어는 KRKPC사용하시는 분만 이 커널 사용 가능합니다<br>
이번 업데이트에서는 다음과 같은 사항이 변경/추가 되었습니다.<br>
<br>
☞init.d 사용자 쉘 스크립트 지원<br>
☞부트로고 변경(이 게시글 하단 사진 참고)<br>
☞Read ahead 트윅(SD card읽는속도 향상<br>
<br>
※커스텀 부트애니매이션 원래 할려고 했는대 이상하게 안되서 제외했습니다;; 커스텀 부팅애니 가능하게 좀 도와주실분?<br>
<br>
이거 외에는 추가적으로 변경/추가/삭제 된것은 없내요.<br>
WhiteBeam Kernel For YP-GB1쓰시는 분들 새 버전으로 갈아타주셔요 ㅎㅎ<br>
<br>

커널 플레싱 방법은 다들 아시리라 믿겠습니다. <br>
기기를 다운로드 모드로 전환→컴퓨터에서 오딘(검색하면 금방 구할 수 있음) 실행→pda눌러서 커널 불러오기→기기를 컴퓨터와 연결→start눌러 플레싱<br>

<br>
-------------------------------------------------<br>
<br>
다운로드 링크(2012.07.22일자 빌드)<br>
http://sourceforge.net/projects/wbcypgb1/files/WBK_YP-GB1_GB_20120722.tar/download<br>
<br>
소스코드(GitHub)<br>
-커널<br>
https://github.com/sukso96100/WhiteBeam-Kernel-For-YP-GB1<br>
-initramfs(램디스크) | KRKPC<br>
https://github.com/sukso96100/WBK_YP-GB1_GB_KRKPC_intiramfs <br>
<br>
------------------------------------------------- <br>


