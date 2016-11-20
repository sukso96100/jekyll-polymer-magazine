---
layout: post
title: "아치리눅스에서 Brackets Live Preview 동작 안되는 현상 고치기"
date: "2015-02-18"
tags: web update tips tutorial
---

아치 리눅스에서 Brackets 를 사용하는 경우에, 라이브 프리뷰를 사용하고자 하면,
Brackets 이 크롬을 찾지 못해 라이브 프리뷰가 시작되지 못하는 문제가 있습니다.
아래와 같은 명령어로 심볼릭 링크를 걸어주면 문제를 해결할 수 있습니다.

```bash
ln -s /usr/bin/google-chrome-stable /usr/bin/google-chrome
```
