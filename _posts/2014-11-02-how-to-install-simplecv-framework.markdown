---
layout: post
title: "SimpleCV 설치하고 테스트 해 보기."
date: "2014-11-02"
tags: tutorial python simplecv develop development raspberry-pi linux computer-vision
---
<img class="image-wrapper" src="{{ site.url }}/blogimgs/SM_logo_color.png"><br>
SimpleCV 는 파이썬 언어를 이용하여 컴퓨터 비전 앱을 쉽게 작성 할 수 있도록 도와주는 오픈소스 프레임워크 입니다.
이 프레임워크를 활용하면 고유값,다양하고 복잡한 얼굴인식 알고리즘, 행렬 대 비트맵 스토리지, 비트 깊이 등등의
복잡하고 어려운 것들을 사전에 공부하실 필요 없이 쉽게 컴퓨터 비전 앱을 작성 하실 수 있습니다.

이 글에서는 우분투 같은 데비안 계열 베포판에서 어떻게 SimpleCV를 설치하고 테스트 해 볼 수 있는지 이야기 해 보고자 합니다.
이 글의 내용은 Raspberry Pi를 위한 리눅스 베포판인, Raspbian 에서도 그대로 적용 됩니다. Raspbian 도 데비안 계열 리눅스 거든요.

## 의존성 패키지 먼저 설치하기.

우선 SimpleCV 설치에 앞서 필요한 패키지들을 먼저 설치해 줍시다.
```bash
sudo apt-get install ipython python-opencv python-scipy python-numpy python-setuptools python-pip
```

## SimpleCV 설치

두 가지 방법으로 설치 하실 수 있습니다. 하나는 Github 에서 받아다가 바로 설치하기.
나머지 하나는 미리 소스 코드를 받은 다음, 받아둔 소스코드로 설치하는 것입니다.

Github 에서 받아다가 바로 설치하려면, 아래 명령어를 실행하세요. pip을 이용하여 url로부터 바로 설치합니다.
```bash
sudo pip install https://github.com/sightmachine/SimpleCV/zipball/master
```

소스를 다운로드 받고, 받은 소스로부터 설치하려면, 아래 명령어들을 실행하세요.
소스코드를 다운로드 한 다음, 다운로드된 소스코드 폴더에 접근해서 pip응 이용해 설치합니다.
```bash
git clone git://github.com/sightmachine/SimpleCV.git
cd SimpleCV
sudo pip install -r requirements.txt
sudo python setup.py develop
```

## SimpleCV 테스트 하기

설치가 다 되었나요? 잘 작동하는지 테스트를 해 봅시다. SimpleCV에 포함된 인터렉티브 쉘을 이용하거나,
간단히 코드를 작성해서 실행해 보는 식으로 테스트 해 볼 수 있습니다.

### 인터렉티브 쉘 이용하기

SimpleCV에 내장된 인터렉티브 쉘로 들어가려면 아래 명령어를 실행하세요. 인터렉티브 쉘에 들어가면,
SimpleCV에서 사용 가능한 코드들을 실행 해 보실 수 있습니다.
```bash
simplecv
```

콘솔에서 정상적으로 인터렉티브 쉘에 들어 간 경우, 보통 아래와 같은 것들이 나타납니다.
```bash
youngbin@youngbin-ultrabook:~$ simplecv
[3;J
/usr/lib/python2.7/dist-packages/IPython/frontend.py:30: UserWarning: The top-level `frontend` package has been deprecated. All its subpackages have been moved to the top `IPython` level.
  warn("The top-level `frontend` package has been deprecated. "
+-----------------------------------------------------------+
 SimpleCV 1.3.0 [interactive shell] - http://simplecv.org
+-----------------------------------------------------------+

Commands:
	"exit()" or press "Ctrl+ D" to exit the shell
	"clear()" to clear the shell screen
	"tutorial()" to begin the SimpleCV interactive tutorial
	"example()" gives a list of examples you can run
	"forums()" will launch a web browser for the help forums
	"walkthrough()" will launch a web browser with a walkthrough

Usage:
	dot complete works to show library
	for example: Image().save("/tmp/test.jpg") will dot complete
	just by touching TAB after typing Image().

Documentation:
	help(Image), ?Image, Image?, or Image()? all do the same
	"docs()" will launch webbrowser showing documentation

SimpleCV:1>
```

인터렉티브 쉘에서 나가려면, 아래 코드를 실행하세요.
```bash
exit()
```

### 파이썬으로 작성해서 실행 해보기.
파이썬으로 SimpleCV 를 사용하는 간단한 코드를 작성해서 실행해 보는 방식으로 테스트 해 볼 수도 있습니다.
아래 코드는 simplecv.org 에서 가져온 예제 입니다(주석만 우리말로 수정 해봤습니다).
아래 코드들을 파이썬 스크립트 파일(확장자가 *.py인)로 저장해 보세요.
```python
#-*- coding: utf-8 -*-
from SimpleCV import Camera
# 카메라 초기화.
cam = Camera()
# while 반복문으로 계속해서 카메라로부터 이미지 가져오기.
while True:
    # 카메라 에서 이미지 가져오기.
    img = cam.getImage()
    # 가져온 이미지 흑백으로 만들기.
    img = img.binarize()
    # 이미지에 "Hello World!" 그리기.
    img.drawText("Hello World!")
    # 이미지 보여주기.
    img.show()
```

저장 하셨으면, 웹캠 등의 카메라를 연결하시고,
한 번 실행 해 보세요, 예를 들어 파일 이름이 simplecv.py 인 경우, 아래와 같은 명령어로 실행합니다.
```bash
python simplecv.py
```

정상적으로 실행이 된다면, 아래와 같은 화면이 나타날 것입니다.
<img class="image-wrapper" src="{{ site.url }}/blogimgs/simplecv_example.png"><br>

### 오류 해결하기.
오류가 나는 경우 해결하는 방법 들 입니다. 시험 해 보는대 오류가 난다면, 참고해 보세요.

#### svgwrite 모듈이 설치되어 있지 않아 오류가 나는 경우.

인터렉티브 쉘로 들어가려 할때 svgwrite 모듈 미설치로 인한 오류가 나면 아마 아래과 같은 것이 나타날 것입니다.
```bash
youngbin@youngbin-ultrabook:~$ simplecv
ERROR:
Traceback (most recent call last):
  File "/usr/local/bin/simplecv", line 9, in <module>
    load_entry_point('SimpleCV==1.3', 'console_scripts', 'simplecv')()
  File "/usr/lib/python2.7/dist-packages/pkg_resources.py", line 337, in load_entry_point
    return get_distribution(dist).load_entry_point(group, name)
  File "/usr/lib/python2.7/dist-packages/pkg_resources.py", line 2279, in load_entry_point
    return ep.load()
  File "/usr/lib/python2.7/dist-packages/pkg_resources.py", line 1989, in load
    entry = __import__(self.module_name, globals(),globals(), ['__name__'])
  File "/usr/local/lib/python2.7/dist-packages/SimpleCV/__init__.py", line 4, in <module>
    from SimpleCV.Camera import *
  File "/usr/local/lib/python2.7/dist-packages/SimpleCV/Camera.py", line 5, in <module>
    from SimpleCV.ImageClass import Image, ImageSet, ColorSpace
  File "/usr/local/lib/python2.7/dist-packages/SimpleCV/ImageClass.py", line 14768, in <module>
    from SimpleCV.DrawingLayer import *
  File "/usr/local/lib/python2.7/dist-packages/SimpleCV/DrawingLayer.py", line 5, in <module>
    import svgwrite
ImportError: No module named svgwrite
```

아래 명령어를 이용해, pip을 사용해 svgwrite 모듈을 설치 하시면 됩니다.
```bash
sudo pip install svgwrite
```

## 끝.
SimpleCV에 대해서는, SimpleCV 웹사이트를 방문하시면, 문서자료나 튜터리얼 같은 다양한 정보들을 얻으실 수 있습니다.
관심 있으신 분들은 방문해 보시길.

<a href="http://simplecv.org">SimpleCV 사이트 방문하기(simplecv.org)</a>
