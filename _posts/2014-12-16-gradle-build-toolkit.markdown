---
layout: post
title: "Gradle Built Toolkit"
date: "2014-12-16"
tags: tutorial develop development android gradle app migrated(old)
---

이 노트는 저번 2014.05.03 GDG Korea Android Gradle Codelab에서 배운 내용을 기록해 두기 위해 개인적으로 간단히 정리하는 노트 입니다.

## Gradle이 뭐죠?
Grradle은 소프트웨어 빌드 툴킷들 중 하나 입니다. Gradle이전에 많이 사용되었던 Ant와 Maven의 장점들을 합쳐서 이 두개의 빌드 툴킷의 대안으로 나온 빌드 툴킷 입니다.
Ant가 소프트웨어를 빌드하는대 초점을 맞추고, Maven이 빌드를 설정하는대 초점을 맞추었다면, Gradle은 둘 다 초점을 맞추었습니다.

## 이럴 때 Gradle을 유용하게 쓸 수 있습니다.
개발중인 앱의 소스 디렉터리에서 테스트버전과 배포용 버전의 버전 숫자를 다르게 하여 한번에 빌드하기
유료앱과 무료앱 소스코드를 나눠서 관리하지 않고, 하나의 프로젝트 디렉터리에서 관리하고 빌드도 한번에 하기
빌드를 엄청 자주 할 때.....

## Gradle스크립트를 작성 할 때는.....
동적인 부분은 자바 가성머신에서 작동하는 Groovy(그루비)를, 정적인 부분은 DSL(도메인 고유 언어)를 사용하여 작성합니다.

## Gradle스크립트 쓰기!
Gradle 을 통해 실행되는 기본 단위를 "Task(태스크)" 라고 합니다. 각 태스크는 의존 관계에 따라서 한번씩만 실행 됩니다.
플러그인을 이용하여 선언문 형태로 쓰거나, Groovy로 명령문 형태로 작성이 가능합니다.

## 알아두기
gradle-wrapper 는 Gradle이 설치되어 있지 않은경우, 자동으로 설치 해 줍니다. 
Gradle은 JDK위에서 작동합니다. 쓸려면 JDK(Java Development Kit) 먼저 설치하세요.

Gradle 빌드 스크립트 예제(개인적으로 작성했습니다.)
http://gist.github.com/sukso96100/4ae0db5827be2eddff6f

```groovy lineos%}
/* Gradle 빌드 스크립트 예제
 *
 * 아래 GitHub 저장소를 참조하여 작성하였습니다.
 * https://github.com/GDG-Korea/GradleCodeLab
 */
 
buildscript {
    repositories {
	//메이븐 중앙 저장소를 사용하도록 명시
        mavenCentral()
    }
    dependencies {
	//안드로이드 플러그인 클래스경로 설정
        classpath 'com.android.tools.build:gradle:0.10.+'
    }
}
 
//안드로이드 플러그인 적용
apply plugin: 'android'
 
//안드로이드 관련 설정
android {
	compileSdkVersion 19 //앱을 빌드하는대 안드로이드 SDK 버전 19를 사용하도록 설정
    	buildToolsVersion '19.0.3' //앱을 빌드하는대 19.0.3 버전의 빌드툴을 사용하도록 설정
 
	//앱 서명 관련 설정값
	signingConfigs {
    	    codelabConfig {
   	         storeFile file("../keystore/codelab.jks") //서명에 쓸 키스토어 파일 경로
        	    storePassword "********" //키스토어 비밀번호
        	    keyAlias "codelab" //서명에 쓸 키스토어 키 별명
        	    keyPassword "********" //위 키 별명에 대한 비밀번호
        	}
    	}
 
	//하나의 프로젝트 디렉터리에서 두가지 앱이 나눠져 빌드되도록 하는 설정
    productFlavors {
	//피카소 앱 빌드 설정
        picasso {
	//위에 작성한 앱 서명 관련 설정값을 이 앱(피카소 앱) 서명에 사용
	signingConfig signingConfigs.codelabConfig
        }
 
	//고흐 앱 빌드 설정
        gogh {
            packageName "org.gdgkoradandroid.gogh" //패키지네임(앱의 고유이름) 설정
            versionCode 1 //앱의 버전코드
            versionName "1.0.0" //앱의 버전네임
		//위에 작성한 앱 서명 관련 설정값을 이 앱(고흐 앱) 서명에 사용
	    signingConfig signingConfigs.codelabConfig
        }
    }
 
}
 
repositories {
	//메이븐 중앙 저장소를 사용하도록 명시
    mavenCentral()
}
 
//앱 빌드에 필요한 의존성 라이브러리 설정
dependencies {
    compile 'com.android.support:support-v4:19.0.+' //안드로이드 하위 호환성을 위한 서포트 라이브러리(안드로이드SDK 디렉터리에서 가져옴)
    compile 'com.squareup.picasso:picasso:2.2.0' //이미지 다운로딩 라이브러리(메이븐 중앙 저장소에서 가져옴)
    compile 'com.squareup.okhttp:okhttp:1.5.4' //HTTP+SPDY클라이언트 라이브러리(메이븐 중앙 저장소에서 가져옴)
}
```

## 참고하면 좋은 웹사이트들.....
* <a href="http://kwonnam.pe.kr/wiki/gradle">권남 위키 Gradle문서</a>
* <a href="http://docs.google.com/presentation/d/1A0drtBqJxE-OzCs5vt7Calouz3cOOmdaebXunRFoVxA/pub?start=false&loop=false&delayms=3000#slide=id.p">GDG Korea Android Gradle Codelab 발표자료</a>
* <a href="http://tools.android.com/tech-docs/new-build-system">New Build Syste</a>
* <a href="http://tools.android.com/tech-docs/new-build-system/user-guide">Gradle Android Plugin User Guide</a>
* <a href="http://www.gradle.org/">Gradle 홈페이지</a>
