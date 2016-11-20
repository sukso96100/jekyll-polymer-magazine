---
layout: post
title: "자기소개서 연습도구(ResumeUtil) 업데이트와 SSL 적용 안내"
date: "2015-02-15"
tags: web app update university_enterance introworkout resumeutil
---

이번에 설 기념 해서(?) 작년 8월 쯤... 모의면접 준비하다 자기소개서 양식 파일이 *.hwp 여서 빡쳐서 즉석에서 만든
자기소개서 연습 도구 웹사이트 대폭 수정하게 되었습니다. 처음에 이름 딱히 없다가, 작년 말 되어서 IntroWorkout 이였다가,
이번에는 ResumeUtil 로 이름 정했습니다. 앞으로 이름은 이걸로 고정할 겁니다 ㅇㅅㅇ 이름 바뀐 만큼, UI도 바뀌고 새로운 첨삭 기능도 추가했습니다.
UI 는 Polymer 를 이용해 다시 만들었습니다. 첨삭 기능의 경우, 사용자 계정 페이지에서 첨삭받기를 켜시면. 본인 양식에 대한 첨삭을 받으실 수 있고.(그래봤자 댓글추가지만...)
다른 사람의 공개된 양식을 첨삭하시려면, "첨삭하기" 로 이동하신 후, 첨삭할 사람의 계정이름을 입력하시면 됩니다.

<img src="/blogimgs/resumeutil0.png">
<img src="/blogimgs/resumeutil1.png">
<img src="/blogimgs/resumeutil2.png">
<img src="/blogimgs/resumeutil3.png">

그리고 이번에 지금 이 github pages 에 제가 사용중인 도메인인 youngbin.tk 에 SSL 을 적용 했습니다.
CloudFlare 에서 무료로 준다길래 적용 했습니다 ㅎㅎㅎ. 일부 웹사이트에서는 외부 리소스(사진, 영상, 스타일시트, 스크립트)들이 http:// 로 오는 경우도 있어서,
보안이 덜 되었다고 나올수도 있습니다. 저에게 예기 해 주시면 됩니다.

<img src="/blogimgs/ssl.png">