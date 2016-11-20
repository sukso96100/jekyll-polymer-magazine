---
layout: post
title: "SimpleCV 로 움직임 감지하기"
date: "2014-11-08"
tags: tutorial python simplecv develop development raspberry-pi linux computer-vision motion
---

SimpleCV를 이용하면 어렴지 않게 카메라를 통해 움직임을 감지해 낼 수 있습니다.
복잡한 것은 SimpleCV가 거의 다 해주니 우리는 제공되는 API를 잘 활용하면, 금방 만들어 낼 수 있습니다.
이 글은 여러분들이 이미 SimpleCV를 설치 하셨다는 가정 하에 쓴 글 입니다. 아직 설치 하지 않으셨다면.
<a href="http://www.youngbin.tk/tutorial/python/simplecv/develop/development/raspberry-pi/linux/computer-vision/2014/11/02/how-to-install-simplecv-framework/">먼저 설치를 먼저 하신 다음,</a> 이 글을 보시는 것이 좋습니다.

## 움직임을 감지하는 과정
먼저 움직임을 감지하는 과정을 생각 해 봅시다. 움직임을 감지하려면, 사진 두 장을 얻어 차이를 봐야 합니다.
같은 장소, 같은 카메라에서, 비슷한 시간에 초 또는 분 간격으로 시간차이를 두고 찍혔는대.
두 사진 사이 차이가 있다면, 사진에 찍힌 것들이 움직여서 차이가 있는 것 이겠죠?
그렇다면 아래와 같이 감지 방법을 생각해 볼 수 있습니다.

0. 임계값을 정한다, 두 사진 사이 다른 정도를 비교해서, 움직임 감지 기준으로 사용할 값이다.
1. 카메라에서 사진 하나 얻어서 기준 이미지로 정한다.
2. 사진 하나를 더 얻는다.
3. 기준 이미지와 추가로 얻은 이미지를 비교한다.
4. 비교했을 때, 다른 정도가 정해진 것 보다 크다면, 움직임을 감지한 것으로 인식한다
  * 추가로 얻은 이미지를 새로운 기준 이미지로 정한다
  * "2." 부터 다시 반복한다
5. 비교했을 때, 다른 정도가 정해진 것 보다 작다면, "2." 부터 다시 반복한다

## 코드로 작성해 보기
위 과정들을 한번 코드로 옮겨 봅시다.

먼저 필요한 모듈들을 임포트(import) 합시다.
여기서는 SimpleCV의 모듈들을 모두 임포트 합니다.
한글 입력이 필요한 경우 인코딩도 지정합시다.
```python
#-*- coding: utf-8 -*-
from SimpleCV import *
```

그 다음, 움직임 감지 여부 기준으로 쓸, 임계값을 정합시다.
```python
#임계값
threshold = 1.0
```

카메라를 초기화 하고, 이미지 하나를 얻어, 기준 이미지로 정합시다.
기준 이미지 이름은 "refImg" 로 정해봅시다.
```python
#카메라 초기화
cam = Camera()

#카메라에서 이미지 얻어 기준 이미지로 정하기
print "기준 이미지 얻는중"
refImg = cam.getImage()
```

아래는 기준 이미지 예시 입니다.<br>
(출처 : http://tutorial.simplecv.org/en/latest/examples/image-math.html#image-arithmetic)<br>
<img class="image-wrapper" src="{{ site.url }}/blogimgs/image-math-person1.png"><br>


기준 이미지와 비교할 이미지를 하나 더 얻습니다.
추가로 얻은 이미지를 "img" 라고 정합시다. 그리고 기준 이미지와의 차이를 얻어 봅시다.
단순히 5와 2의 차이를 "5 - 2"로 계산하듯, "기준이미지 - 새 이미지" 로 차이를 얻으면 됩니다.
그럼 여기선, "refImg - img" 로 하면 되죠. 두 이미지 사이에서 얻은 차이는 diff 로 정합시다.
```python
#새 이미지 얻기
img = cam.getImage()
#두 이미지 사이 차이 얻기
diff = refImg - img
```

아래는 추가로 얻은 이미지 예시 입니다.<br>
(출처 : http://tutorial.simplecv.org/en/latest/examples/image-math.html#image-arithmetic)<br>
<img class="image-wrapper" src="{{ site.url }}/blogimgs/image-math-person2.png"><br>

기준 이미지에서, 추가로 얻은 이미지 사이 차이를 나타낸 이미지 예시 입니다.<br>
(출처 : http://tutorial.simplecv.org/en/latest/examples/image-math.html#image-arithmetic)<br>
<img class="image-wrapper" src="{{ site.url }}/blogimgs/image-math-person-sub.png"><br>

diff 이미지에는 차이가 있는 부분만 나타나는대, 그것을 수치상으로 표현해서.
처음에 정한 임계값과 비교해 봅시다. 임계값 보다 크면, 기준 이미지를 갱신하고,
그렇치 않으면 기준 이미지를 그대로 유지해 봅시다.
```python
#getNumpy()는 이미지를 다차원 배열로 나타냄
#getNumpy().mean() 은 getNumpy()로 얻은 다차원 배열을 실수로 나타냄
if imgmath.getNumpy().mean() > threshold:
  #차이가 임계값 보다 크면
  print "움직임 감지됨"
  #기준 이미지 갱신
  refImg = img
  print "기준 이미지 갱신"
  print "갱신시각" + time.strftime("%H:%M:%S")
else:
  #그렇치 않다면
  print "기준 이미지와 큰 차이 없음 기준 이미지 유지"
```

대략적인 코드가 다 짜여 졌군요. 위 코드를 다 이으면 완전한 코드가 완성 되지만.
이미지를 지속적으로 얻어서 비교하지 못하는 코드가 됩니다. 한번만 비교하고 끝나기 때문입나다.
추가로 이미지를 얻는 부분부터 끝까지, 무한 반목을 감싸서 프로그램이 종료 될때까지 계속 움직임을 인식하도록 해 봅시다.
그리고 화면에 카메라에서 얻은 이미지도 계속 표시해 봅시다.
```python
#무한 반복
while True:
    #새 이미지 얻기
    img = cam.getImage()
    # show()는 이미지를 화면상에 보여줍니다.
    img.show()

    #기준 이미지와 새 이미지 사이 차이 얻기
    imgmath = refImg - img
    #getNumpy()는 이미지를 다차원 배열로 나타냄
    #getNumpy().mean() 은 getNumpy()로 얻은 다차원 배열을 실수로 나타냄
    if imgmath.getNumpy().mean() > threshold:
        #차이가 임계값 보다 크면
        print "움직임 감지됨"
        #기준 이미지 갱신
        refImg = img
        print "기준 이미지 갱신"
        print "갱신시각" + time.strftime("%H:%M:%S")
    else:
        #그렇치 않다면
        print "기준 이미지와 큰 차이 없음 기준 이미지 유지"
```

이제 다 되었습니다. 완성된 코드는 아래와 같습니다.
저장 하신 후 한번 실행 해 보세요.
```python
#-*- coding: utf-8 -*-
from SimpleCV import *

#임계값
threshold = 1.0

#카메라 초기화
cam = Camera()

#카메라에서 이미지 얻어 기준 이미지로 정하기
print "기준 이미지 얻는중"
refImg = cam.getImage()

while True:
    #새 이미지 얻기
    img = cam.getImage()
    # show()는 이미지를 화면상에 보여줍니다.
    img.show()

    #기준 이미지와 새 이미지 사이 차이 얻기
    imgmath = refImg - img
    #getNumpy()는 이미지를 다차원 배열로 나타냄
    #getNumpy().mean() 은 getNumpy()로 얻은 다차원 배열을 실수로 나타냄
    if imgmath.getNumpy().mean() > threshold:
        #차이가 임계값 보다 크면
        print "움직임 감지됨"
        #기준 이미지 갱신
        refImg = img
        print "기준 이미지 갱신"
        print "갱신시각" + time.strftime("%H:%M:%S")
    else:
        #그렇치 않다면
        print "기준 이미지와 큰 차이 없음 기준 이미지 유지"
```
