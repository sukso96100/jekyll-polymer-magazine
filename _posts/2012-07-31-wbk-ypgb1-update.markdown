---
layout: post
title: "(Update | #21)WhiteBeam Kernel For YP-GB1"
date: 2012-07-31
tags: migrated(old) android kernel development yp-gb1
---

내.. 오늘 아침에 빌드해놓고 좀 늦게 내놓내요;; ㅎㅎㅎ<br>
오늘 릴리즈느 변경 사항이 아니고, 이 커널에 들어간 특징(?)<br>
아니면 지금까지 넣은 것들이라고 할수 있는것들을 나열하도록 하겠습니다..<br><br>

-------------------------------------------------------------------------------------------------------------------------<br><br>

-삼성전자가 배포한 YP-GB1 진저브레드 커널소스 기반(리눅스 커널 버전 : 2.6.35.7)<br><br>

-Live OC (퍼센트 다위로 CPU오버클럭이 가능합니다, 기기가 루팅되어 있어야 하며, NSTools로 오버클럭 값 변경이 가능합니다)<br><br>

-init.d지원 (system/etc/init.d 폴더에 원하시는 init.d스크립트를 넣으세요<br><br>

참고로 파일 이름은 모두 다음과 같이 설정해주셔야 합니다.<br><br>

S(숫자)(이름)<확장자없음><br><br>

예를들면,<br><br>

S01zipalign<br><br>

이렇게 해주시면 됩니다. )<br><br>

-i/o 스케쥴러 : CFQ, Deadline, Noop, SIO(기본), VR, BFQ(v1r1)<br><br>

-리드 어헤드 트윅(SD카드 읽는속도 증가)<br><br>

-최대 손가락 10개 인식가능<br><br>

-커스텀 부트로고<br><br>

-커스텀 부트애니메이션(안드로이드 표준 부트애니메이션) 지원<br><br>

-CWM(SteveS님 소스코드로부터 추가)<br><br>

-CPU 가버너 : conservative, userspace, powersave, ondemand, performance, SmartassV2(기본), lulzactive<br><br>

<br>
-------------------------------------------------------------------------------------------------------------------------<br><br>

다운로드 링크(2012.07.31 일자 빌드, 버전#21)<br>
http://sourceforge.net/projects/wbcypgb1/files/WBK_YP-GB1_GB_20120731.tar/download<br>

소스코드<br><br>

커널소스 https://github.com/sukso96100/WhiteBeam-Kernel-For-YP-GB1
initramfs(KRKPC)  https://github.com/sukso96100/WBK_YP-GB1_GB_KRKPC_intiramfs
initramfs(KRKPG) https://github.com/sukso96100/WBK_YP-GB1_initramfs_KRKPG

-------------------------------------------------------------------------------------------------------------------------<br><br>

EDIT(2012/08/01) : S_m_O_k   님에 의해서<br>
이 커널이 갤럭시 플레시어 국제버전(YP-G1 INTL)에서도 작동됨이 확인되었습니다,<br>
S_m_O_k님 감사합니다.<br>
