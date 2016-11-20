---
layout: post
title: "(Update | 2012.07.27 | #16)WhiteBeam Kernel For YP-GB1"
date: 2012-07-27
tags: migrated(old) android kernel development yp-gb1
---

음.. 어제 커널 빌드할때 썻던 램디스크만 바꿔서 컴파일하니 제대로 플레싱이 되내요..<br>
어제 그 컴파일후 테스트해보니 플레싱 실패뜨는 커널은 갤플카페에 곶.아 에디션으로 내놓았죠(?)ㅋㅋㅋ<br>
일단은 이번 업데이트 변경사항은..<br>

-SmartassV2 가버너 추가<br>
(소스는 아래 URL로부터 가져온 소스를 사용했습니다http://cafe.naver.com/androiddevforum/341)<br><br>

이 가버너에 대해 간단히 말하자면(?) :<br>
Interactive 기반의 Smartass 가버너의 두번쨰 버전입니다,<br>
성능과 절전이 우수하다고 하네요(?)<br>
출처 : http://hi_des.blog.me/40157343730<br><br>


가 끝입니다(?)<br>
 이거말고 원래 cwm5를 그 terrsilent였나 그 커널 럄디스크 소스 써먹어서 넣어볼려 했는대,<br>
어제 그걸 넣고 하니 기기가 곶.아 가 되더군요. 그래서 그 커널을 곶.아 에디션으로..<br><br>


가버너를 새로 추가했으니 아직은 ondemand를 기본가버너로 해놨습니다.<br>
SmartassV2 사용 원하시는 분들은 NSTools나 기타 cpu클럭이나 가버너 관리할수있는 앱으로, 변경해주시면 됩니다. <br><br>

일단은 제 커널 쓰시는 분들 업데이트 해주셔요 ㅎㅎ<br><br>


다운로드(2012.07.26일자 #16 번쨰 빌드)<br>
http://sourceforge.net/projects/wbcypgb1/files/WBK_YP-GB1_GB_20120727.tar/download<br><br>

소스코드<br>

커널 소스:<br>
https://github.com/sukso96100/WhiteBeam-Kernel-For-YP-GB1<br><br>

Initramfs(KRKPC):<br>
https://github.com/sukso96100/WBK_YP-GB1_GB_KRKPC_intiramfs<br>
