---
layout: post
title: "(Update | #23)WhiteBeam Kernel For YP-GB1(KOR) and YP-G1(INTL)"
date: 2012-08-01
tags: migrated(old) android kernel development yp-gb1
---

허허허허 방금 새로 커널을 또 컴파일 하였습니다 ㅎㅎㅎㅎ<br>
이번 릴리즈에서는 어떤 것들이 변경되었냐면....<br><br>

-Tiny RCU 활성화 <br>
-jhash2에서 jhash3으로 업데이트(기기 반응속도 향상!)<br>
-커널을 LZMA방식으로 압축하였습니다, 그러므로 배포되는 커널 용량이 작아집니다.<br>
(#21 용량 : 6.7MB -> #23용량 : 4.7MB)<br><br>


이 외에는 별다른 변경사항은 없습니다 ㅎㅎ 이제는 cpu가버너나, i/o스케쥴러보단.<br>
다른 여러가지(?) 트윅들을 많이 넣을듯 싶내요 ㅎㅎㅎ<br><br>

----------------------------------------------------------------<br>

다운로드 링크(2012/08/01일자 빌드, 버전#23)<br>
http://sourceforge.net/projects/wbcypgb1/files/WBK_YP-GB1_YP-G1-INTL_GB_20120801.tar/download<br><br>

----------------------------------------------------------------<br>

소스코드<br><br>

커널소스 https://github.com/sukso96100/WhiteBeam-Kernel-For-YP-GB1<br>
initramfs(KRKPC)  https://github.com/sukso96100/WBK_YP-GB1_GB_KRKPC_intiramfs<br>
initramfs(KRKPG) https://github.com/sukso96100/WBK_YP-GB1_initramfs_KRKPG<br><br>

-------------------------------------------------------------------------------------------------------------------------<br><br>