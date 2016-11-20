---
layout: post
title: "시온고 안드로이드 스터디 노트 - 1.Create Project Sunshine"
date: "2014-12-30"
tags: develop development android app study note
image : /blogimgs/android_study_lesson_one_cover.jpg
---

몇 주 전 부터 교내에서 친구 몇명 모아서 안드로이드 스터디를 하고 있습니다. 구글 코리아 측에서 스터디 그룹 프로그램을 해서 해 보게 되었는대. 2차 지필평가로 인해 진도가 많이 밀렸습니다. Udacity(udacity.com) 에 있는 Developing Android Apps코스를 기반으로 진행 중입니다. 7~8개의 레슨으로 구성 되어 있는대. 레슨 하나가 마무리 될 때마다. 이렇게 글로 정리를 해 보고자 합니다. 한참 진도가 늦습니다만... 일단 드디어 레슨 1 을 마무리 했으므로. 레슨 1 을 정리해 보고자 합니다.

## 시작하기 앞서...

- Java 프로그래밍을 접해보신 적이 없나요? 먼저 공부 하고 오시는 것이 좋습니다. 아래 사이트들이 유용합니다.
 - [생활코딩 Java 코스](http://opentutorials.org/course/1223)
 - [점프 투 자바 Ebook](https://wikidocs.net/book/31)
- Java 객체 지향 프로그래밍 개념에 대해 이해 하고 계셔야 이 글을 원할히 이해 하실 수 있습니다.
- 하나 이상의 안드로이드 디바이스와 USB 케이블을 준비하세요.

## 레슨 1 의 내용들
레슨 1 은 대략 아래와 같은 내용으로 구성되어 있습니다. 하나씩 자세히 알아봅시다. 스터디 에서는 가장 처음에 Git에 대해서도 다뤘고, 간단히 안드로이드 플랫폼에 대한 설명도 했었으나, Git 사용법은 검색 좀 해보면 나오고, 안드로이드가 뭔지는 다들 알기 때문에 이 글에서는 생략 하겠습니다.

- JDK, 안드로이드 스튜디오 설치
- 필요한 SDK 도구 받기, 프로젝트 생성, 테스트 하기
- View 를 배치하여 간단한 UI 만들기
- Layout (FrameLayout, RelativeLayout, LinearLayout)
- ListView 와 Adapter

## JDK 설치하기
안드로이드 앱을 Java 로 작성하고. 우리가 안드로이드 앱 개발에 사용할 도구가 JDK를 유구하기에. 우선, JDK를 설치 하여야 합니다.

### JDK 설치파일 다운로드
Ubuntu, Arch Linux 계열 리눅스를 사용하시면, 이 부분을 건너 뛰세요.

 * [Oracle](http://oracle.com)웹사이트에 접속하세요.
 * Downloads 메뉴에 마우스를 올리면, 다양한 하위 메뉴가 나타나는대. 좌측에 있는 Popular Downloads 섹션에 있는 Java for Developers 를 선택합니다.
 * JDK 항목을 선택합니다
 * Java SE Development Kit 섹션에서 다운로드 받습니다. 먼저 Accept License Agreement 를 클릭하여, 라이선스에 동의하고, 자신의 시스템에 맞는 것으로 다운로드 합니다.

### Winidows
 * 다운로드 받은 설치 파일을 실행하여, 설치 마법사의 안내에 따라 설치를 진행합니다.

### Linux - RPM 패키지 사용 하는경우
 * 다운로드 받은 RPM 파일을 아래 명령어를 사용하여 설치하거나, GUI 기반의 패키지 설치 프로그램이 있다면, 그냥 클릭해서 설치합니다.

```bash
# "<파일이름>" 은 다운로드 받은 파일의 이름으로 합니다
sudo rpm -i <파일이름>
# 명령어 예시 : sudo rpm -i jdk-8u25-linux-x64.rpm
```

### Linux - Ubuntu 계열
터미널에서 다음 명령어로, WebUpd8 JDK 저장소를 추가하고, 설치를 진행합니다.(아래 명령어는 JDK8을 설치합니다)

```bash
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
```

### Linux - Arch Linux 계열
간단히 AUR에서 받아다 설치합니다. 아래 명령어를 실행하세요.

```bash
yaourt -S jdk
```

### Linux - 그 외 배포판
 * 먼저 루트 권한이 필요합니다. 루트로 전환하거나. 매번 명령어 앞에 sudo 를 붙여서 실행하세요. 여기에서를 루트로 전환하여 하는 방법을 소개합니다. 아래 명령어로, 루트로 전환합니다.

```bash
sudo -i
```
 * JDK를 설치할 디렉터리에 접근합니다. 예를들어, /usr/java/ 라면. 아래 명령어를 실행하여 접근합니다

```bash
cd /usr/java/
```

 * 다운로드한 *.tar.gz 파일을 지금 접근중인 경로로 옮기거나 복사합니다. 여기에서는 복사합니다.

```bash
cp (*.tar.gz 파일의 상위 경로)/(해당 파일 이름).tar.gz (해당 파일 이름).tar.gz 
```

 * 압축을 해제합니다.

```bash
tar zxvf (해당 파일 이름).tar.gz
```

## JAVA_HOME, Path 변수 설정하기.
Java 로 작성된 프로그램을 실행하기 위해, JAVA_HOME 변수와, Path 변수를 설정해 주어야 합니다.

### Windows
 * 제어판 > 시스템 으로 이동하고, 좌측에서 "고급 시스템 설정"을 누릅니다.
 * 새로 열리는 "시스템 속성" 창에서 "고급" 탭으로 이동합니다.
 * 하단에 위치한 "환경 변수" 눌러서, 환경 변수 설정창을 엽니다.
 * 사용자 변수나 시스템 변수 섹션에 JAVA_HOME 이 이미 있으면, 지우고 "새로 만들기" 를 클릭하여 새로 생성합니다.
 * 변수 이름은 JAVA_HOME, 변수 값은 JDK 경로로 합니다 (예 : C:\Program Files\Java\jdk1.7.0_11)
 * 시스템 변수 섹션에서 Path 를 찾아보세요. 있으면 편집하고, 없으면 새로 생성하세요.
 * 변수 이름은 Path, 변수 값은 ;%JAVA_HOME%bin; 를 입력합니다. 이미 값이 다른 것이 있다면, 가장 뒤에 추가합니다.

### Linux
먼저 프로필 파일을 텍스트 에디터로 열어주세요. 

```bash
# "gedit" 은 텍스트 에디터 이름 입니다. 
# 다른 텍스트 에디터 사용시 gedit 대신 해당 에디터 이름을 입력하세요.

# 사용중인 계정에 대해서만 설정 할 경우
gedit ~/.bash_profile
# 시스템 전체적으로 설정 할 경우
# (시스템 영역에 접근하여 파일 수정시, 루트 권한이 필요하므로, 앞에 sudo를 붙입니다.)
sudo gedit /etc/profile
```

에디터로 열었으면, 가장 아래에 다음을 추가 하세요.

```bash
# <JDK경로>는 여러분의 시스템에 JDK 가 설치된 경로로 하시면 됩니다.
export JAVA_HOME=<JDK경로>
# 예시 : export JAVA_HOME=/usr/java/jdk1.8.0_25
export PATH=$JAVA_HOME/bin:$PATH

```

다 했으면, 저장하고 에디터를 닫습니다. 그리고 아래 명령어로 설정한 것을 적용 시키세요.

```bash
# 사용중인 계정에 대해서만 설정 한 경우
source ~/.bash_profile
# 시스템 전체적으로 설정 한 경우
source /etc/profile
```

### JDK 작동여부 확인
아래 명령어를 실행하여 확인합니다.

```bash
java -version
```

## Android Studio 설치
http://developer.android.com/sdk/index.html
위 URL 에 접속하여 Android Studio 를 다운로드 하세요.

- Windows 는, 다운로드 받은 것을 실행하여, 설치 마법사에 따라 설치를 진행합니다
- Linux 에서는, 다운로드 반은 파일 압축을 풀고, bin 폴더 안의 studio.sh 를 실행하세요.

## 필요한 SDK 도구 설치
앱 개발 및 빌드에 필요한 각종 API 패키지나 빌드툴 등을 SDK Manager 를 통해 다운로드 합시다.

- Android Studio 를 처음 실행 하시는 경우, Welcome to Android Studio 창이 나타납니다.
- Configure > SDK Manager 항목으로 들어가서 SDK Manager 를 켭니다.
- 필요한 항목을 선택하여 다운로드 합니다. 보통 최신 버전의 안드로이드 버전에 해당되는 항목과 Extra 항목을 다운로드 받습니다.
- Install ** packages 버튼 (**는 선택한 항목 수)을 클릭하여 설치합니다.
- 완료되면, SDK Manager 를 닫고, Welcome to Android Studio 창에서 상위 목록으로 이동합니다.

## 새로운 프로젝트 생성
이제 프로젝트를 하나 새롭게 생성 해 봅시다. 생성 과정 중에 Minimum SDK, Target SDK, Package Name 등을 정하게 됩니다.

- Welcome to Android Studio 화면에서 Start a new Android Studio project 를 선택합니다.
- Application name 에 원하는 앱 이름을, Package name 에 원하시는 앱의 Package name을, Project location 에는 프로젝트를 어디에 둘지 경로를 설정합니다. 프로젝트 경로는 영어로만 이뤄져 있어야 합니다.

### Package Name 정하기
 * Package Name 은 각 앱의 고유한 이름으로, 다른 앱과 구별하는대 사용됩니다.
 * 보통 회사 도메인(Company domain)을 거꾸로 하여 사용합니다.
 * 다른 앱의 것과 중복 될 수 없읍니다. 
 * Package Name 예시 : Company domain 이 example.com 이고, 앱 이름이 appname 이면, Package Name 은 com.example.appname

다음 화면으로 넘어가서 어떤 디바이스를 위한 앱을 개발할지 선택하고, Minimum SDK 를 지정합니다. 이 글에서는 휴대전화/태블릿 앱을 개발한다고 보고 Phone and Tablet 만 선택하고 Minimum SDK 를 선택하겠습니다.

### Minimum SDK, Target SDK
 * Minimum SDK 와 Target SDK 는 앱이 실행할수 있는 안드로이드 버전을 나타냅니다.
 * Minimum SDK : 앱이 동작하기 위해서 필요한 최소 버전을 의미합니다.
 * Target SDK : 앱의 동작이 확인된 최신의 안드로이드 버전을 의미합니다. 보통 가장 최근 출시된 안드로이드 버전으로 설정합니다.
 * Android Developers 사이트에 있는 [Dashboard](http://developer.android.com/about/dashboards/index.html)를 이용해 보세요. Minimum SDK, Target SDK 를 정하시는 대 도움이 됩니다.

다음 화면에서 새로 만들 Activity 형태를 선택합니다. 지금은 Blank Activity with Fragment 를 선택합니다. 그리고 마지막으로 Activity 이름을 지정하고 프로젝트 생성을 마칩니다.

## 안드로이드 디바이스에서 테스트 하기
- 설정 > 개발자 옵션 으로 이동하여, "USB 디버깅" 항목을 체크하여 USB 디버깅을 활성화 합니다.
- 만약 사용중인 안드로이드 버전이 4.2 이상이라면, 기본적으로 개발자 옵션이 숨겨져 있으므로. 설정 > 휴대전화 정보(또는 태블릿 정보) 에서 빌드 번호는 7회 연타하여 개발자 옵션이 보이도록 하세요.
- 디바이스를 컴퓨터와 USB 케이블을 이용해 연결합니다.
- Android Studio 프로젝트 화면에서 상단 메뉴에 위치한. Run 버튼(초록색 색상의 동영상 플레이어 재생버튼 아이콘 모양을 하고 있음)을 누릅니다.
- 앱이 빌드되며 빌드가 완료하면 디바이스 선택 창이 나옵니다. 디바이스를 선택하고 계속합니다
- 기다리면, 여러분들의 안드로이드 디바이스에 테스트 하고자 하는 앱이 설치되고 실행 됩니다.

## Gradle 빌드 시스템
<img src="/blogimgs/app_build.png"><br>
안드로이드 스튜디오에서, 앱은 Gradle 이라는 빌드 시스템에 의해 빌드 됩니다. Gradle 은 일종의 세련된(?) 빌드 시스템으로 안드로이드 스튜디오와 함께 공개 되었습니다. DSL 이라는 선언문 형태의 언어로 빌드 스크립트를 작성하여 빌드를 설정합니다. 간단히 빌드 과정에 대해 알아봅시다.

- 안드로이드 프로젝트 빌드가 시작됩니다.
- Gradle 에 의해서 앱이 빌드 됩니다.
- 앱은 Gradle 에 의해 *.apk 파일로 빌드 됩니다. 이 안에는 여러분들의 코드가 안드로이드 런타임들(ART 또는 Dalvik)이 읽을 수 있는 Byte Code 로 변환되어 포함되어 있고, 컴파일된 리소스와 Manifest 가 있습니다.
- Jar Signer 로 앱 개발자를 확인 할 수 있게 빌드된 *.apk 파일에 서명 합니다.
- 빌드가 끝났습니다. adb(Android Debug Bridge)를 통해 안드로이드 디바이스에 앱이 설치됩니다.

### Windows 를 사용 하십니까?
별도로 USB 드라이버를 설치해야, Android Studio 에서 디바이스를 인식 할 수 있습니다. 설치 방법은 제조사 마다 차이가 있으므로, 여기에서는 다루지 않겠습니다. 구글링 하시면 금방 알아내실 수 있습니다.

## 코드 살펴보기 
기본적으로 생성된 코드를 한번 살펴 봅시다. 좌측 프로젝트 탐색 메뉴에서 MainActivity.java 를 열어주세요.
<img src="/blogimgs/mainactivity.png"><br>

코드의 상단에는 아래와 같은 내용이 있습니다.
MainActivity 클래스가 정의 되어 있는 것을 보실 수 있습니다.

```java
//ActionBarActivity 를 상속 하는 MainActivity 클래스가 정의되어 있습니다.
public class MainActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ...
```

그리고 스크롤을 하다 보면 다음과 같이 PlaceholderFragment 클래스가 MainActivity 클래스 내부에 정의 되어 있습니다.

```java
/**
     * A placeholder fragment containing a simple view.
     */
    public static class PlaceholderFragment extends Fragment {

        public PlaceholderFragment() {
        }

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                 Bundle savedInstanceState) {
            View rootView = inflater.inflate(R.layout.fragment_main, container, false);
            return rootView;
        }
    }
    ...
```

Activity 는 뭐고, Fragment 는 뭘까요?

- Activity 는 안드로이드 앱 에서의 하나의 화면을 의미합니다. 보통 레이아웃을 정의하는 xml 파일과, 동작을 처리하는 Java 소스 파일로 구성됩니다.
- Fragment 는 Activity 내부에 표시 될 수 있는 화면 모듈 입니다. Activity 처럼 xml로 레이아웃을 정의하고 Java 로 동작을 처리 합니다. 하나의 Activity 에 여려 Fragment 를 포함 시키실 수 있습니다. Activity 내부에 표시되는 화면 모듈이라서, Activity 가 없으면 화면에 표시되지 못합니다.
<img src="/blogimgs/activity_and_fragment.png"><br>

## 레이아웃 만들기
간단한 Fragment 레이아웃을 하나 만들어 봅시다. 좌측 프로젝트 탐색 메뉴에서 fragment_main.xml 파일을 열어주세요.

<img src="/blogimgs/fragment_layout.png"><br>
사진과 같은 화면이 보이나요? 왼쪽 팔레트에서 원하시는 뷰(View) 를 마우스로 드래그해서 배치해 보세요. 안드로이드 에서는 화면에 표시되는 각각의 구성요소(예 : 버튼, 텍스트, 이미지 등) 을 통틀어서 뷰(View) 라고 합니다. View 도 종류가 매우 다양합니다. 

## 각종 View 에 대해 알아봅시다.
View 도 상당히 그 종류가 다양합니다. 나눠보자면 대략 이렇게 나눠집니다.

- Widget (TextView, Button, ImageView ...)
- ViewGroup
 - AdapterView(ListView, GridView ...)
 - Layout (FrameLayout, RelativeLayout, LinearLayout)
 
### Widget 
 딱히 자세히 설명하지 않아도 될 것 같내요. 버튼이나 텍스트, 드롭다운 박스, 텍스트 같은 조그마한 컨트롤이나 기본적인 요소 들입니다.(예 : TextView, Button, ImageVIew, Spinner ...)
 
### ViewGroup
 하나 이상의 View 를 포함 내부에 할 수 있는 View 입니다.(예 : 각종 Layout, AdapterView)
 
### Layout
 Layout 은 여러 뷰들을 화면상에 어떻게 배치할지 정해주는 ViewGroup 입니다. 대표적으로 FrameLayout, LinearLayout, RelativeLayout 이 있습니다.
 
 - FrameLayout : 하나의 View 로 한 화면 전체를 가득 체우고자 할 때 사용합니다.
 - LinearLayout : 수평 또는 수직 방향으로 View 를 나란히 배치해 주는 Layout 입니다.
 - RelativeLayout : 다른 View 나 화면 가장자리 등을 중심으로 하여 관계적으로 배치해 주는 Layout 입니다.
 <img src="/blogimgs/layout_managers.png"><br>
 
### AdapterView
목록과 같이 일련의 데이터들을 표시 하고자 할때 사용합니다. 데이터들을 화면에 표시할 때, Adapter 를 이용하여 표시해서 AdapterView 라고 합니다. (예 : ListView, GridView ...)

## 간단한 ListView 구현하기
아래와 같은 과정을 거쳐, 간단한 ListView 를 구현해 봅시다.

### 화면 ListView 체우기.
fragment_main.xml 파일을 수정하여, Layout 을 변경해 봅시다. 우리는 화면을 ListView로 가득 체울 것이므로. FrameLayout 을 사용하고 그 내부에 RelativeLayout 을 배치 할 것입니다.

먼저 fragment_main.xml 을 열고, 하단에 탭을 Design 에서 Text 로 변경하여, 텍스트 편집 화면으로 바꾸세요. 아래와 같은 코드가 보이나요?

```xml
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools" android:layout_width="match_parent"
    android:layout_height="match_parent" android:paddingLeft="@dimen/activity_horizontal_margin"
    android:paddingRight="@dimen/activity_horizontal_margin"
    android:paddingTop="@dimen/activity_vertical_margin"
    android:paddingBottom="@dimen/activity_vertical_margin"
    tools:context=".MainActivity$PlaceholderFragment">

    <TextView android:text="@string/hello_world" android:layout_width="wrap_content"
        android:layout_height="wrap_content" />

</RelativeLayout>
```

이 코드에서, RelativeLayout을 FramgLayout 으로 변경하고. 기존에 내부에 있던 TextView 를 지운다음, ListView 를 넣읍시다. 그러면 아래와 같이 코드가 바뀝니다.

```xml
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools" android:layout_width="match_parent"
    android:layout_height="match_parent" android:paddingLeft="@dimen/activity_horizontal_margin"
    android:paddingRight="@dimen/activity_horizontal_margin"
    android:paddingTop="@dimen/activity_vertical_margin"
    android:paddingBottom="@dimen/activity_vertical_margin"
    tools:context=".MainActivity$PlaceholderFragment">

   <ListView
       android:layout_width="match_parent"
       android:layout_height="match_parent"
       android:id="@+id/listView"/>

</FrameLayout>
```

### Java 코드 작성하기
MainActivity.java 를 열어 동작을 구현해 봅시다. 우리는 Fragment 에 동작을 구현할 것이므로, Framgnet 코드를 먼저 찾으세요. 아래와 같은 코드를 찾았나요?

```java
/**
     * A placeholder fragment containing a simple view.
     */
    public static class PlaceholderFragment extends Fragment {

        public PlaceholderFragment() {
        }

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                 Bundle savedInstanceState) {
            View rootView = inflater.inflate(R.layout.fragment_main, container, false);
            return rootView;
        }
    }
    ...
```

문자열 배열로 ListView 에 넣을 데이터를 하나 만듭시다. 이름은 myArray 라고 하겠습니다.
String[] 현태로 데이터를 만들고, 나중에 유동적으로 데이러를 넣고 빼기 위해, List<String>형태로 변환 하겠습니다

```java
...

        public PlaceholderFragment() {
        }

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                 Bundle savedInstanceState) {
            View rootView = inflater.inflate(R.layout.fragment_main, container, false);
            //문자열 배열로 ListView에 넣을 데이터 만들기. 이름은 myArray.
            String[] myArray = {"Sample Item 0", "Sample Item 1", "Sample Item 2", "Sample Item 3", "Sample Item 4"};
            List<String> myArrayList = new ArrayList<String>(Arrays.asList(myArray)); //ArrayList로 변환합니다. 동적으로 항목을 추가하거나 뺄 수 있습니다.
            return rootView;
        }
    }
    ...
```

그리고 우리가 준비한 데이터와 ListView 사이에서 다리 역할을 하는 Adapter 를 하나 초기화 해서 만들어 줘야 합니다. 먼저 Adapter 에 대해 알아 봅시다.

### Adapter
Adapter 는 언급한 바와 같이, AdapterView 와 AdapterView에 표시될 데이터 사이에서 다리 역할을 해 줍니다. Adapter 는 처음에 초기화 될때 매개변수로 받은 데이터를 가지게 되고 가진 데이터를 관리하며, AdapterView 에 표시될 View 를 필요한 만큼 가지고 있는 데이터에서 항목을 확인해 각 데이터에 해당되는 View 를 만들어 줍니다.

- AdapterView 가 Adapter 에 표시할 View 를 만들어 달라고 예기합니다. 예를들어 0~4번 항목 데이터에 해당되는 View 를 만들어 달라고 한다고 합니다.
- Adapter 는 자신이 처음에 받은 데이터에서 0~4번 항목에 해당되는 데이터가 무엇인지 확인합니다.
- 확인 되었으면 해당 데이터에 대한 View 를 Adapter 가 만들어 냅니다.
- 만들어진 View 가 AdapterView 에 전달되어 화면상에 표시 됩니다.

### ArrayAdapter 초기화 하기
우리는 다양한 Adapter 중. ArrayAdapter 를 사용 할 것 입니다. 아래와 같이 초기화 합니다. 몇가지 매개변수를 요구하는대, 아래 코드를 참고해서 입력 하시면 됩니다.

```java
...
        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                 Bundle savedInstanceState) {
            View rootView = inflater.inflate(R.layout.fragment_main, container, false);
            //문자열 배열로 ListView에 넣을 데이터 만들기. 이름은 myArray.
            String[] myArray = {"Sample Item 0", "Sample Item 1", "Sample Item 2", "Sample Item 3", "Sample Item 4"};
            List<String> myArrayList = new ArrayList<String>(Arrays.asList(myArray));

            //ArrayAdapter 초기화
            ArrayAdapter<String> myAdapter = new ArrayAdapter<String>(
                    getActivity(), //Context - Fragment 는 Context 를 가지지 않으므로 Activity 에서 얻어옴
                    android.R.layout.simple_list_item_1, //각 항목별 Layout - 일단은 안드로이드 시스템 내장 리소스 얻어옴
                    myArrayㅣ냣); //ListView 에 표시될 데이터
            return rootView;
        }
    ...
```

### Context
- 시스템 서비스에 접근하거나 앱의 서비스에 접근하기 위해 사용 됩니다.
- Context 를 이용해 앱의 리소스나 클래스를 얻는대 사용할 수 있습니다. 예를 들면 새 Activity 로 이동하는대 사용하거나, 앱에 포함된 이미지를 로드하는대 쓰입니다.

### ListView 찾기
findViewById 를 이용해 ListView를 id값으로 찾습니다.

```java
...
        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                 Bundle savedInstanceState) {
            View rootView = inflater.inflate(R.layout.fragment_main, container, false);
            //문자열 배열로 ListView에 넣을 데이터 만들기. 이름은 myArray.
            String[] myArray = {"Sample Item 0", "Sample Item 1", "Sample Item 2", "Sample Item 3", "Sample Item 4"};
            List<String> myArrayList = new ArrayList<String>(Arrays.asList(myArray));
            //ArrayAdapter 초기화
            ArrayAdapter<String> myAdapter = new ArrayAdapter<String>(
                    getActivity(), //Context - Fragment 는 Context 를 가지지 않으므로 Activity 에서 얻어옴
                    android.R.layout.simple_list_item_1, //각 항목별 Layout - 일단은 안드로이드 시스템 내장 리소스 얻어옴
                    myArrayList); //ListView 에 표시될 데이터
            //ListView 찾기
            ListView LV = (ListView)rootView.findViewById(R.id.listView); //R.id.(ListView id 값 - Layout 파일에서 확인 가능)
            return rootView;
        }
    ...
```

## ListView 에 Adapter 설정하기
마지막으로 LitView 에 Adapter 를 설정해 ListView 와 Adapter 가 서로 작용하도록 합시다.

```java
...
        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                 Bundle savedInstanceState) {
            View rootView = inflater.inflate(R.layout.fragment_main, container, false);
            //문자열 배열로 ListView에 넣을 데이터 만들기. 이름은 myArray.
            String[] myArray = {"Sample Item 0", "Sample Item 1", "Sample Item 2", "Sample Item 3", "Sample Item 4"};
            List<String> myArrayList = new ArrayList<String>(Arrays.asList(myArray));
            //ArrayAdapter 초기화
            ArrayAdapter<String> myAdapter = new ArrayAdapter<String>(
                    getActivity(), //Context - Fragment 는 Context 를 가지지 않으므로 Activity 에서 얻어옴
                    android.R.layout.simple_list_item_1, //각 항목별 Layout - 일단은 안드로이드 시스템 내장 리소스 얻어옴
                    myArrayList); //ListView 에 표시될 데이터
            //ListView 찾기
            ListView LV = (ListView)rootView.findViewById(R.id.listView); //R.id.(ListView id 값 - Layout 파일에서 확인 가능)
            //Adapter 설정
            LV.setAdapter(myAdapter);
            return rootView;
        }
    ...
```

## 앱 실행 결과
 <img src="/blogimgs/study_lesson1_result.png"><br>
 
 사진과 같이 잘 나오나요? Lesson 1 내용은 여기까지 입니다. 
 
## 소스코드
Lesson 1 에 해당되는 소스코드 입니다.
[https://github.com/sukso96100/zionhs_android_study/tree/lesson1](https://github.com/sukso96100/zionhs_android_study/tree/lesson1)
 
## 곁들여 보면 좋은 추가자료들...
- [Building Your First App](http://developer.android.com/training/basics/firstapp/index.html)
- [Activities](http://developer.android.com/guide/components/activities.html)
- [Fragments](http://developer.android.com/guide/components/fragments.html)
- [User Interface - UI Overview](http://developer.android.com/guide/topics/ui/overview.html)
- [User Interface - Layouts](http://developer.android.com/guide/topics/ui/declaring-layout.html)
- [ListView](http://developer.android.com/guide/topics/ui/layout/listview.html)
- [Dadhboards](http://developer.android.com/about/dashboards/index.html)
- [Context](http://developer.android.com/reference/android/content/Context.html)

