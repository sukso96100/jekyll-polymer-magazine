---
layout: post
date: 2015-11-07
title: "AWS EC2 인스턴스 생성하기"
tags: aws server tip tutorial note update
---

[AWS 프리티어에 가입하는 내용을 다루는 저번 글에]({{ "/2015/10/25/starting-aws-free-teer.html" | prepend: site.baseurl }}) 이어,
이 글에서는 AWS 에서 제공하는 가상서버에 해당되는 EC2 인스턴스를 프리티어를 통해 제공하는 선을 넘지 않는 한도에서 생성해 보도록 합시다.

먼저, AWS 콘솔에 로그인 하세요. 본인의 AWS 계정으로 로그인 하면 됩니다. 그럼 아래 사진처럼, AWS 제품들이 나타납니다.
우측 상단에서, 어느 위치의 서버를 사용할 것인지 선택합니다. 저는 싱가포르로 선택 했습니다. 그 다음, "Compute" 부분의 "EC2" 를 선택합니다.
<img src="/blogimgs/ec2_1.png"><br>

그러면 아래 사진처럼, EC2 자원 상태를 대략적으로 보여주는 페이지가 나옵니다. 여기서, "Launch Instance" 를 클릭하여, 새 인스턴스 생성을 시작합니다.
<img src="/blogimgs/ec2_2.png"><br>

인스턴스에 설치하여 사용할 OS 를 선택합니다. 본인이 사용하기 편한 것으로 선택 하시면 됩니다. 저는 Ubuntu 를 선호하므로, Ubuntu 14.04 LTS 를 선택했습니다.
<img src="/blogimgs/ec2_3.png"><br>

인스턴스 타입을 선택합니다. 프리티어의 경우는 t2.micro 까지만 무료로 제공합니다. 더 나은 CPU나 메모리 등이 필요하신 경우, 요금을 추가로 지불 하셔야 합니다.
<img src="/blogimgs/ec2_4.png"><br>

인스턴스 세부사항 설정 화면입니다. 꼭 필요한 경우에만 수정하고, 아니면 그냥 넘어갑니다.
<img src="/blogimgs/ec2_5.png"><br>

필요하신 경우 스토리지를 추가합니다. 프리티어 사용자들은 최대 30GB 까지 무료로 사용 가능합니다.
<img src="/blogimgs/ec2_6.png"><br>

태그를 달아 인스턴스의 이름 등을 지정합니다.
<img src="/blogimgs/ec2_7.png"><br>

시큐리티 그룹을 설정합니다. 어느 IP 로 부터의 접속을 허용할지, 어느 포트를 열지 등을 설정합니다.
<img src="/blogimgs/ec2_8.png"><br>

설정이 다 되었습니다. 이제 인스턴스를 런치하기 앞서, 본인이 지정한 새로 런치될 인스턴스의 세부사항을 다시한번 확인합니다. 그리고 "Launch" 를 눌러 개속합니다.
<img src="/blogimgs/ec2_9.png"><br>

인스턴스에 안전하게 접속하기 위해, EC2 접속에는 키 페어가 사용됩니다. 키 페어가 있는 경우, Choose an existiing key pair 를 선택하시고, 바로 아래에서 키 페어를 고릅니다.
<img src="/blogimgs/ec2_10.png"><br>

없는 경우, Create a new key pair 를 선택하고, 키 페어 이름을 입력합니다. 그리고, "Download key pair" 를 눌러 키 페어 파일을 받습니다.
 이 키 페어 파일은 한 번만 받을 수 있으므로, 분실하지 않도록 잘 보관해야 합니다. 키 페어 선택 후 "Launch Instance"를 눌러 인스턴스를 생성합니다.
<img src="/blogimgs/ec2_11.png"><br>

다 되었네요, 잠시 기다립니다.
<img src="/blogimgs/ec2_12.png"><br>

인스턴스가 런치(생성) 되고 작동중 상태가 되었습니다. 이제 인스턴스에 아파치 웹 서버 등을 올려 웹사이트를 돌리는 등. 원하는 작업을 하실 수 있습니다.
<img src="/blogimgs/ec2_13.png"><br>
