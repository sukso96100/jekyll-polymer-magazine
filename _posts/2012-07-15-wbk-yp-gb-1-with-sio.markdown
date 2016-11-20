---
layout: post
title: "(업데이트)WhiteBeam kernel for YP-GB1"
date: 2012-07-15
tags: migrated(old) android kernel development yp-gb1
---

오늘 새로 빌드한 커널입니다.<br>
SIO 스케쥴러 (Simple I/O 스케쥴러)를 세로 추가했고, 그밖에 다른건 없습니다 ㅎㅎ.<br>
혹시나 해서 기본 스케쥴러 CFQ 스케쥴러로 해놨으니 SIO 스케쥴러 사용 원하시는분들은 .<br>
NStools(플레이 스토어에서 구할 수 있음)을 받아서 그걸로 스케쥴러 변경하시면 됩니다..<br>
기기는 YP-GB1, 펌웨어는 KRKPC 사용하시는 분들만 이 커널을 사용 가능합니다..<br>
.<br>
다운로드 링크 (2012/07/15 일자 빌드).<br>
http://sourceforge.net/projects/wbcypgb1/files/WBK_YP-GB1_GB_20120715.tar/download.<br>
.<br>
소스코드(Github).<br>
https://github.com/sukso96100/WhiteBeam-Kernel-For-YP-GB1.<br>
.<br>
※소스코드는 빌드한 날 로부터 적어도 2~3일내로 수정된부분이 업대이트 됩니다..<br>
.<br>
p.s 도네이션(기부) 한번 받아볼까 생각중인대 괜찮을까요? 도네이션 받은것들은,.<br>
개발에 사용할 기기를 사거나 가능할지 모르것다만.. 개발하는대 쓸 노트북 살 생각입니다..<br>
가상머신으로 작업하는대, 너부 버벅여서 말이죠;; 작업하기가.. 쩝.. 멀티부팅 하기에는.<br>
파티션이 지금 두갠대 하나는 윈도우 하나는 백업용 크리;;.<br>

