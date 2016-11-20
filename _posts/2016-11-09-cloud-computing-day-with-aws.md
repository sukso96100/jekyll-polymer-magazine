---
layout: post
image: /blogimgs/cloud-computing-day-with-aws-0.jpg
date: 2016-11-09
title: "아마존과 함께하는 클라우드 컴퓨팅 데이 참여 후기"
description: "나름 많은 것을 배운 세미나(?)"
tags: aws cloud seminar update note review
---
오늘(2016.11.09) 경기창조경제혁신센터에서 열렸던 아마존과 함께하는 클라우드 컴퓨팅 데이에 참석하고 왔습니다.
갔다 온 김에 가서 들은 내용을 들으면서 필기한 내용 기반으로, 포스팅으로 정리해 보고자 합니다.
 개인적으로 서버리스에 대해 다룬 세션과 서비스 확장에 대해 다룬 세션이 좋았습니다.

## 키노트 세션
간단하게 AWS 에 대해 소개하는 내용이 주를 이뤘습니다. 언제부터 AWS 가 시작 되었고, 올해 새로 리전을 설립한 지역 등에 대해 소개해 주셨습니다.

![Keynote Session](/blogimgs/cloud-computing-day-with-aws-1.jpg)

## AWS 에서 작은 서비스 구현하기
청중들에게 웹사이트를 통해 먼저 몇가지 질문을 하고 세션이 시작되었습니다.
먼저 백그라운드 지식을 다뤘는데, AWS 에 어떤 서비스가 있는지(EC2, S3, Lambda, Kinesis, CloudFront 등) 간단히 집고 넘어갔습니다.
그리고 클라우드로 마이그레이션 하는 경우나 아마존 웹서비스 활용 시나리오에 대해 몇가지 소개해 주셨습니다.

![AWS 에서 작은 서비스 구현하기](/blogimgs/cloud-computing-day-with-aws-2.jpg)
![투표](/blogimgs/cloud-computing-day-with-aws-3.jpg)
![시나리오 예제](/blogimgs/cloud-computing-day-with-aws-4.jpg)


### 온프레미스에서 클라우드로 마이그레이션
- 한번에 옮기기 : 클라우드의 장점 등이 희석될 수 있음.
- 작은 서비스 위주로, 비즈니스에 영향 없게 클라우드로 이전하기
 - 서버리스가 적합함
  - 완전 관리형 : 관리 요소 없음
  - 개발자 생산성 : 중요한 코드에 집중
  - 지속적인 스케일링 : 자동으로 스케일
  - AWS 에는 서버리스 옵션이 매우 다양함

### 시나리오 1 - 평소에는 사용률이 낮고 가끔씩 부하가 엄청 커지는 경우
- 기존 시스템
 - 클라이언트 - 백엔드 로직 - 데이터베이스
- AWS
 - Serverless Microservice : API Gateway - Lambda - DynamoDB

#### AWS Lambda
- 이벤트에 대한 응답으로 작성한 코드를 실행하는 컴퓨팅 서비스
- 관리한 코드 없음
- 지속적으로 확장
- 1초 이하 단위로 과금
- Python, Java, Node.js 등으로 코드 작성 가능
- 구성요소)
 - 람다 함수 - 사용자가 작성
 - 이벤트 소스 - 함수 실행 시기?
 - 람다 서비스
 - 함수 네트워킹 환경

#### AWS Lambda 사용 사례
- PlayOn! - 비디오 스트림 처리
- 스퀘어에닉스 - 개임 내 사진 추가 작업 - 썸네일, 워터마크 추가 작업 등
 - 기존 3~4 시간 소요 되던 것이 15초로 단축됨

### 시나리오 2
- 게임 서비스
 - 매출을 위해 이벤트를 자주 함.
  - 데이터 기반의 의사 결정이 필요
   - 그러나 인력과 경험 모두 부족
- 다음과 같은 방식으로 구성하는 것을 고려할 수 있음
 - 람다(매일 12시 30분 게임 서버 확장) - 람다(1시/6시 이벤트 개시/종료) - SNS(푸시 메시지 전송) - Kinesis - 람다(스트림 처리) - S3 - 람다(데이터 처리) - Elasticsearch

### 시나리오 3
- 웹사이트 크롤링
 - 특정 시간에만 작동하는 작업을 위해 서버 유지 / 서버 오류시 대처
 - AWS Labda 의 Scheduled Event 사용 - 리눅스의 CRON 과 유사한 기능
- API Gateway
 - REST API 관리
 - DDoS 방어 기능
 - API 스테이징

## 클라우드를 통해 내 서비스 무한대로 확장하기
처음에는 적은 사용자로 시작한 서비스가 시간에 따라 사용자 수가 늘면서 어떤 방식으로 구성을 변경하고 확장하면 좋은지,
사용자 수에 따라서 나눠서 알아보는 시간을 가졌습니다.

![클라우드를 통해 내 서비스 무한대로 확장하기](/blogimgs/cloud-computing-day-with-aws-5.jpg)
![사용자가 만명~십만명 일 때](/blogimgs/cloud-computing-day-with-aws-6.jpg)

### 사용자 1명
- Route53 - Elastic IP - EC2 Instance
- 더 큰 인스턴스 필요한 경우, 쉽게 수직적으로 인스턴스 스케일 업 가능
 - 예시 : t2.nano -> t2.micro -> t2.small ...

### 사용자 1명 이상
- 기능에 따라 인스턴스 분리하여 운영
- 웹서버용 인스턴스와 DB 서버 인스턴스
 - DB 서버의 경우, 직접 EC2 인스턴스 에 DB 서버 소프트웨어를 설치하여 직접 관리하거나,
 - 또는 관리형 DB 서비스 선택(DynamoDB, Aurora 등)

### 사용자 천명 이상
- 천명이 넘을 때 부터는 가용성에 신경 써야 함.(서비스 다운으로 인해 서비스 사용 불가 상태가 있어서는 안됨)
 - 서비스 중단시 이미지 하락
 - 이중화와 Fail Over 고려
- ELB(Elastic Load Balancing)
 - 관리형 로드 벨런싱
 - 트래픽 분산 등에 사용
 - 고가용성 / 헬스 체크 / 세션 유지 / SSL 오프로드 / 모니터링과 로깅 / 셀프 힐링 및 셀프 스케일링

### 사용자 십만명 이상
- ELB를 이용하여 트래픽을 수천개의 인스턴스에 분산
- 성능, 효율성을 높일 있는 아키텍처를 고려해야 함
 - 부하를 줄이는 것이 핵심!
 - 주위로 일부 부하 분산
  - 정적 콘텐츠는 웹서버에서 S3(오브젝트 기반 스토리지) 와 CloudFront 로 이전
  - 웹서버가 가진 세션 정보를 이전 - DynamoDB 나 ElasticCache 활용
- 오토스케일링
 - 자동으로 인스턴스 스케일 업/다운
 - 클라우드워치 메트릭 기반으로 구동

#### 자동화
- 앱 개발에 집중하기! AWS 에서 다양한 배포 자동화 서비스를 제공함
 - 코딩 - CodeCommit
 - 빌드/테스트 - CodePipeline
 - 배포 - CodeDeploy
 - 구축 - CloudFormation
 - 모니터링 - CloudWatch
 - 기타 - AWS OpsWorks, AWS Elastic Beanstalk(컨테이너)

#### 마이크로 서비스
- 내부 서비스를 작게 분리하여 느슨하게 결합
- 작은 서비스간 인터렉션 결합 제거 후, API 로 통신
- 클라우드 기반으로 확장/증설 고려하여 개발

새로 만들기 보다는, 이미 있는 것을 활용하자 - 메일 보내기, 등

### 천만 사용자
데이터베이스의 쓰기 마스터 노드 상에 경쟁 이슈가 잠재적으로 발생할 수 있음
- 커스텀 솔루션 구축 시작
- 다중 리전
- 전체 스택에 대한 서비스 이해
- aws.amazon.com/architecture

## 메가존과 함꼐하는 클라우드 컴퓨팅
AWS의 프리미어 컨설팅 파트너인 메가존에서 세션을 진행했습니다. HPC on AWS 에 대해 주로 예기했습니다.
HPC 가 처음 듣는 단어여서 뭔 의미인가 했더니, High Performance Computing(고성능 컴퓨팅) 의 약자 였더군요.
아마존 웹서비스에서 어떻게 고성능 컴퓨팅을 구현하여 비용을 절약할 수 있는지에 대해 주로 다뤘습니다.

![Keynote Session](/blogimgs/cloud-computing-day-with-aws-7.jpg)
![Keynote Session](/blogimgs/cloud-computing-day-with-aws-8.jpg)
![Keynote Session](/blogimgs/cloud-computing-day-with-aws-9.jpg)

- AWS 기반 HPC
 - 유연한 가격 정책으로 비용 절감
 - 무제한 확장
 - 효율적인 클러스터 인프라 관리
 - 보다 빠른 결과 도출
 - 온 디멘드 병렬 클러스터
 - 공동 작업률 향상
- HPC 를 위한 AWS 구성
 - 주로 EC2 인스턴스 유형에 대한 소개
 - 스팟 인스턴스
  - 온디멘드 보다 통상 90퍼센트 저렴하게 사용하여 비용 절감

## Big Data On AWS
아마존 웹서비스에서 빅 데이터를 다루는 것에 대한 세션 이였는데... 이때 졸아서(...) 제대로 듣질 못했네요.(연사분께 죄송합니다...)
스토리지가 제일 중요하다고 한 부분이 기억에 남는 세션이였습니다. 안정적이고 안전한 스토리지가 있어야, 데이터를 쌓아서, 그것으로 뭔갈 할 수 있고, 그렇치 않아서 유실되거나 하면 아무것도 못하는 경우가 있을 수 있기 때문이라고 하더군요. S3 의 내구성이 아주 좋으니, AWS 를 사용한다면, S3　를 활용하라는 내용이 기억이 나는군요.

![Big Data On AWS](/blogimgs/cloud-computing-day-with-aws-10.jpg)
![음... 이게 뭐였더라...](/blogimgs/cloud-computing-day-with-aws-11.jpg)

## 경품 추첨
헤드셋 두개랑 아마존 에코 하나 뿌렸는데, 별 기대 안했습니다.
긴팔 티셔츠 하나랑 보조 배터리 받았으면 됬죠 뭐(?)

![Keynote Session](/blogimgs/cloud-computing-day-with-aws-12.jpg)
