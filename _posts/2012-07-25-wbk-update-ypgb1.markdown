---
layout: post
title: "(Update | 2012.07.25)WhiteBeam Kernel For YP-GB1"
date: 2012-07-25
tags: migrated(old) android kernel development yp-gb1
---

dmb문제를 고쳐, 하루만에!!(?) 업데이트 릴리즈 합니다 ㅎㅎ<br>
dmb이제 정상적으로 작동 됩니다, 이번 업데이트는 dmb 다시 작동하게 한것 밖에 없내요;;<br>
<br>
p.s 그 뭐냐 리드미만 밑고 컴파일하다보니 이런 문제가 생긴 것 같내요(?) 리드미에는 분명,<br>
make palladio_rev01_defconfig을 치라 되있는대 해당 palladio_rev01_defconfig에는 dmb과년 내용이 없더군요;; <br>
바로옆에 보니 왼 palladio_kor_defconfig이 있길래 make palladio_kor_defconfig 치고 그다음 컴파일하니 dmb잘되내요;; <br>
이번 업대이트 하면서 리드미 파일을 100%확신하면 안된다는 교훈을 얻었습니다 ㅎㅎㅎ<br><br>

-------------------------------------------------<br><br>

<br>

커널 플레싱 방법을 다들 아시겠지만 혹시나 해서 알려드립니다.<br>

기기를 다운로드 모드로 전환→컴퓨터에서 오딘(검색하면 금방 구할 수 있음) <br>
실행→pda눌러서 커널 불러오기→기기를 컴퓨터와 연결→start눌러 플레싱
<br><br>


-------------------------------------------------<br>


다운로드 링크(2012/07/24일자 빌드)<br>
http://sourceforge.net/projects/wbcypgb1/files/WBK_YP-GB1_GB_20120725.tar/download<br>
<br><br>

소스코드(GitHub)<br>
-커널<br>
https://github.com/sukso96100/WhiteBeam-Kernel-For-YP-GB1<br><br>
-initramfs(램디스크) | KRKPC<br>
https://github.com/sukso96100/WBK_YP-GB1_GB_KRKPC_intiramfs <br><br>

<br>


-------------------------------------------------<br>


