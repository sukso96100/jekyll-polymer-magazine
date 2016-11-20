---
layout: post
title: "(Update | 2012.07.24)WhiteBeam Kernel for YP-GB1 -- CWM사용가능"
date: 2012-07-24
tags: migrated(old) android kernel development yp-gb1
---

 내.. 하루만에 또 업데이트 하내요(?)<br>
뭐 이번에는 대단한건지는 모르겠지만.. 유용한거 하나 추가 했습니다..<br>
일단 수정한 사항은 아래와 같습니다.<br>
<br>
-CWM (ColckWorkMod)리커버리를 추가하였습니다, 혹시나 해서 테스트 해봤는대,<br>
백업/복원 잘 되고, zip파일 플레싱은 현재 superuser만 시험삼아 플레싱 해보았고 커널은 <br>
아직 플레싱을 해보지 않아서 장담은 못합니다, 일단 기본적인 기능은 잘 작동합니다.<br>
다만.. 구버전이라는 엄청난 함정이..<br>
<br>
(CWM소스를 일일이 받아 포팅한 것은 아니고 XDA의 SteveS님 소스를 사용하여 추가했습니다.<br>
<br>
소스를 가져온 출처 : https://github.com/sdonati84/Galaxy-Player-4.0-Kernel/tree/ )<br>
<br>
-init.d 여전히 안된다고들 하셔서;; 일단은 init.rc다시한번 수정했습니다, 이번에도 안되면<br>
init.rc에 비지박스를 사용하여 init.d 사용자 쉘스크립트를 실행하도록 하든가 userinit.sh 자체를 다른걸로 쓰든가 할 예정입니다.<br>
<br><br>

-------------------------------------------------<br>
<br>
이 외에 변경된 사항은 없습니다.<br>
제 커널 쓰시는분들 업대이트 해주시세요.<br>
오류가 나거나 저에게 피드백 주실분은 이 블로그 우측 상단<br>
'SNS Profiles'에 제 SNS프로파일 링크 있으니 그거타고 이동하셔서 거기다가<br>
글 남겨주셔도 되고, 제 이메일로 보내셔도 되고 이 블로그 방명록(GUESTBOOK)에<br>
남겨주셔도 됩니다.<br><br>

-------------------------------------------------<br>

커널 플레싱 방법을 다들 아시겠지만 혹시나 해서 알려드립니다.<br><br>

기기를 다운로드 모드로 전환→컴퓨터에서 오딘(검색하면 금방 구할 수 있음) <br>
실행→pda눌러서 커널 불러오기→기기를 컴퓨터와 연결→start눌러 플레싱
<br><br>
-------------------------------------------------<br>

<br>
다운로드 링크(2012/07/24일자 빌드)<br>
http://sourceforge.net/projects/wbcypgb1/files/WBK_YP-GB1_GB_20120724.tar/download<br>

<br>
소스코드(GitHub)<br>
-커널<br>
https://github.com/sukso96100/WhiteBeam-Kernel-For-YP-GB1<br>
-initramfs(램디스크) | KRKPC<br>
https://github.com/sukso96100/WBK_YP-GB1_GB_KRKPC_intiramfs <br>
<br>

-------------------------------------------------<br>

◎도네이트(기부) 받습니다, 저의 개발을 금전적으로(?) 지원을 해주고 싶거나,<br>
개발한것들이 마음에 들거나 하셔서 저에게 도네이트(기부)를 해주시고 싶으신 분들은 아래<br>
URL을 눌러 도네이트 페이지로 이동하시고 도네이트(기부)하시기 전 꼼꼼히 읽어보시고 <br>
저에게 도네이트(기부) 해주시면 되겠습니다.<br>
http://hybdms.blogspot.kr/p/donate-me.html<br>
<br>
------------------------------------------------- <br>