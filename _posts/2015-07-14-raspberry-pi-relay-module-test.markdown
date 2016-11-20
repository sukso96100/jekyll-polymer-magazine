---
layout: post
title: "라즈베리파이 모델B+ 릴레이 모듈 테스트."
date: 2015-07-14
tags: raspberry-pi linux tutorial tips
image: /blogimgs/connect_relay_to_rpi_with_jumper.png
---
최근 가지고 있던 라즈베리파이에, 릴레이 모듈을 연결해서 뭐 하나 만들어 보는 중 입니다.
라즈베리파이와 릴레이 모듈을 연결하여, 방에 있는 가전제품 전원은 제어해 보려구요.

이미 소프트웨어 파트는 거의 다 되었습니다. 라즈베리파이에서 잘 돌아가나 확인하고 고치기만 하면 됩니다.
뒷북이긴 하지만, 모듈 연결해서 테스트 한것부터 시작해서 이것저것 포스팅 하려 합니다.

일단 이 포스트에서 릴레이 모듈 연결해서 테스트 하는 것 먼저 다루도록 하겠습니다.

먼저 부품을 구입해야 겠죠? 전 이미 가지고 있던 라즈베리파이1 모델 B+ 랑 8채널 릴레이 모듈을 하나 구입했습니다.
전 [한진데이타의 릴레이 모듈](http://toolparts.co.kr/front/php/product.php?product_no=45658&main_cate_no=&display_group=)을 구매했습니다. 전 구입시 점퍼 케이블도 같이 구입했습니다.

아래 그림을 참고해서 릴레이 모듈을 점퍼 케이블을 이용해 연결해 봅시다.
그림에는 파이와 릴레이 사이 연결할 부분만 표시해 두었습니다.
<img src="/blogimgs/connect_relay_to_rpi_with_jumper.png"><br>

연결 하셨스면. 이제 테스트를 한번 해 봅시다.
아래 Python 스크립트로 테스트 해 봅시다. 단순히 릴레이 모듈 각 체널 스위치 켜고 끄는 스크립트 입니다.
소스코드는 Raspbian 에서 실행됨을 가정하고 작성하였습니다. Raspbian 사용 중이시라면 실행시 문제가 없을 겁니다.
```python
import RPi.GPIO as GPIO
import time

print "Ready?"
time.sleep(5)

print "Setting GPIO Mode as BCM"
GPIO.setmode(GPIO.BCM)

print "Setting Up GPIO from 2 to 9"
GPIO.setup(2, GPIO.OUT)
GPIO.setup(3, GPIO.OUT)
GPIO.setup(4, GPIO.OUT)
GPIO.setup(5, GPIO.OUT)
GPIO.setup(6, GPIO.OUT)
GPIO.setup(7, GPIO.OUT)
GPIO.setup(8, GPIO.OUT)
GPIO.setup(9, GPIO.OUT)

print "Testing Relay Module Control with GPIO"

for i in range(2, 10):
    GPIO.output(i,True)
    time.sleep(1)
    print("GPIO %d is True" % (i))

for i in range(2, 10):
    GPIO.output(i,False)
    time.sleep(1)
    print("GPIO %d is False" % (i))

print "Done Testing. Cleaning Up GPIO"
GPIO.cleanup()
```

소스코드를 Python 파일(.py)로 저장하고. 아래 명령으로 실행해 봅시다.
예를들어 파일명이 relay.py 면, 다음과 같은 명령으로 실행합니다.
참고로 GPIO 사용시 루트 권한이 필요하므로. 앞에 sudo 를 붙여 실행합니다.
```python
sudo python relay.py
```

잘 작동하나요? 아래 영상처럼 작동한다면, 잘 작동하는 겁니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/TvI9tKXkbiQ" frameborder="0" allowfullscreen> </iframe>

여기까지 릴레이 모듈 테스트 였습니다. 다음 포스트에서 나머지 내용들을 다루겠습니다.
