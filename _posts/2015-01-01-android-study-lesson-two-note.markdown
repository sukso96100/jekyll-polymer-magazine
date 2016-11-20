---
layout: post
title: "시온고 안드로이드 스터디 노트 - 2.Connect Sunshine to the Cloud"
date: "2015-01-01"
tags: develop development android app study note
image : /blogimgs/multithreading.png
---

안녕하세요. 저번에 Lesson 1 노트에 이어 이번에 저희 시온고등학교 내 안드로이드 스터디 그룹에서 진도를 나간(부득이하게 온라인으로 나간건 함정...) Lesson 2 내용을 정리하여 포스트로 작성 해 보고자 합니다. Lesson 2 에 대한 정리는... 생각보다 길군요. 바로 들어가겠습니다.

## 시작하기 앞서...
- Lesson 1 은 공부 하였나요? [안했으면 먼저 하고 오시길.](http://www.youngbin.tk/2014/12/30/android-study-lesson-one-note.html)
- Lesson 1 에서 작성한 소스코드를 준비하세요.
- 매우 당연하게도. 안드로이드 스튜디오가 설치된 컴퓨터를 준비하시길.
- 이 포스트에서 다루기는 하겠지만... InputStream, StringBuffer, Thread 는 미리 공부 하고 오시는 것이 좋습니다.

## Lesson 2 내용들
대략 정리하자면 아래와 같습니다

- OpenWeatherMap API 를 사용해 날씨정보 얻기
- HttpURLConnection 으로 HttpRequest 보내고 Reponse 받기
- Log 찍기, Logcat 보기 
- AsyncTask 를 이용하여 Background Thread 돌리기
- Permission
- JSON 파싱
- Adapter 갱신 + AOSP 소스코드 들여다보기

## OpenWeatherMap API

이번 Lesson 에서는, OpenWeatherMap 이라는 날씨 정보를 제공하는 사이트에서 제공하는 API 를 이용하여 나리 정보를 불러올 것 입니다.
우리는 일주일 치 날씨 정보를 불러들일 것 입니다. [일단 해당 문서를 한번 읽어봅시다.](http://openweathermap.org/forecast)

<img src="/blogimgs/openweathermap_api_doc.png"><br>

우리는 도시ID 값으로 특정 도시에 해당되는 날씨를 찾고, 일주일치 일기예보 정보를 얻을 것이며, JSON 형식으로 데이터를 받을 것입니다. 아 그리고 온도 단위는 섭씨로 해야겠죠?

예를 들어서 앞에서 나온 조건을 만족하는 경기도 부천지역 날씨에 해당되는 API의 URL은 어떻게 될까요? 아래와 같습니다.

http://api.openweathermap.org/data/2.5/forecast/daily?id=1838716&units=metric&cnt=7

- forecast/daily? - 하루에 대한 일기예보
- id=1838716 - 도시 ID 값(여기서는 부천시 ID 값 사용)
- units=metric - 단위(metric 주로 유럽 국가에서 쓰는 세계 표준 단위 - cm, m, kg ... / imperial 미국이나 영국 등ㅇ서 사용하는 단위 - miles, feet ...)
- cnt=7 - 일 수(여기서는 7일)

## HttpURLConnection
날씨 데이터를 얻어낼 URL 도 있으니, 해당 URL 로 부터 데이터를 로드해 봅시다. HttpURLConnection 을 이용해 요청을 보내서 데이터를 얻을 것입니다.
Lesson 1 에서 작성한 소스를 안드로이드 스튜디오 에서 열고. MainActivity.java 의 Fragment 부분에 위치한 onCreateView 부분에서 이어서 작업합시다.

우선 URL 객체를 하나 만듭시다. 그리고 HttpURLConnection 을 이용해 연결하고, 데이터를 로드합시다.

```java
...
HttpURLConnection urlConnection = null; //HttpUrlConnection
//새 URL 객체
String WeatherURL = "http://api.openweathermap.org/data/2.5/forecast/daily?id=1838716&units=metric&cnt=7";
URL url = new URL(WeatherURL); 
//새 URLConnection
urlConnection = (HttpURLConnection) url.openConnection();
urlConnection.setRequestMethod("GET");
urlConnection.connect();
...
```

### 예외 처리
URL을 다루거나, 데이터를 받아올 때, 예상치 못한 오류에 대비하여 try-catch-finally 를 이용하여 예외처리를 해 봅시다.
try 에 우리가 평상시에 실행할 코드가 들어가고, catch 에는 특정 오류가 잡히면, 실행된 코드들을 넣어주고, finally 에는 try 와 catch 이후 마지막으로 실행될 코드가 들어갑니다.
HttpURLConnection 등의 변수들은, try에사만 사용하지 않고, 그 외의 곳에서도 사용되기에. 예외처리 구문 전에 변수를 선언하고 초기화 해줍시다. 

```java
...
HttpURLConnection urlConnection = null; //HttpUrlConnection - try가 아닌 곳에서도 사용 되므로 try 밖에 선언합니다.
try {
        //새 URL 객체
        String WeatherURL = "http://api.openweathermap.org/data/2.5/forecast/daily?id=1838716&units=metric&cnt=7";
        URL url = new URL(WeatherURL); 
        //새 URLConnection
        urlConnection = (HttpURLConnection) url.openConnection();
        urlConnection.setRequestMethod("GET");
        urlConnection.connect();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
        }
        ...
```

## InputStream
우리가 수십 리터의 물을 받을 때 어떻게 받나요? 한 손으로 한번에 받나요? 그것을 불가능 합니다. 그 작은 손으로 어떻게 몇 심 리터의 물을 한번에 받겠습니까.
한 손으로 한번에 받지 않고. 도구를 이용해 조금씩 받습니다. 파이프를 연결해서 흘려받는 것을 예로 들 수 있겠군요.
우리가 로드하는 데이터 또한 한번에 로드 할 수 없습니다. 그래서 InputStream 을 이용하여 데이터를 로드합니다. InputStream 은 여러가지 Stream 중 하나 인대.
Stream 은 데이터를 운반 해 주는 통로 역할을 해 줍니다. 물을 흘려보내는 파이프 역할을 한다고 보면 됩니다. Stream 은 연속적인 데이터 흐름을 물에 비유해서 붙여진 이름인대. 물이 한쪽 방향으로만 흐르듯, Stream 은 하나의 방향으로만 통신이 가능해서. 입력/출력을 동시에 처리할 수 없습니다. 그래서 InputStream, OutputStream 이 따로 있습니다. 우리는 데이터를 입력 받으므로. InputStream 을 사용합니다.

```java
...
HttpURLConnection urlConnection = null; //HttpUrlConnection - try가 아닌 곳에서도 사용 되므로 try 밖에 선언합니다.
try {
        //새 URL 객체
        String WeatherURL = "http://api.openweathermap.org/data/2.5/forecast/daily?id=1838716&units=metric&cnt=7";
        URL url = new URL(WeatherURL); 
        //새 URLConnection
        urlConnection = (HttpURLConnection) url.openConnection();
        urlConnection.setRequestMethod("GET");
        urlConnection.connect();
        //InputStream 을 사용해 데이터 읽어들이기
        InputStream inputStream = urlConnection.getInputStream();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
        }
...
```

## StringBuffer
StringBuffer 은 문자열인 String 과 매우 유사하지만. 다른 접이 있습니다. String 이 처음에 만들어 질때 저장된 문자열을 바꾸기 어렵지만. StringBuffer 는 쉽게 바꿀 수 있습니다.

```java
...
HttpURLConnection urlConnection = null; //HttpUrlConnection - try가 아닌 곳에서도 사용 되므로 try 밖에 선언합니다.
BufferedReader reader = null; //try가 아닌 곳에서도 사용 되므로 try 밖에 선언합니다.
try {
        //새 URL 객체
        String WeatherURL = "http://api.openweathermap.org/data/2.5/forecast/daily?id=1838716&units=metric&cnt=7";
        URL url = new URL(WeatherURL); 
        //새 URLConnection
        urlConnection = (HttpURLConnection) url.openConnection();
        urlConnection.setRequestMethod("GET");
        urlConnection.connect();
        //InputStream 을 사용해 데이터 읽어들이기
        InputStream inputStream = urlConnection.getInputStream();
        //StringBuffer 에 데이터 저장
        StringBuffer buffer = new StringBuffer(); // 새로운 StringBuffer 생성
        reader = new BufferedReader(new InputStreamReader(inputStream));
        String line;
            while ((line = reader.readLine()) != null) {
                buffer.append(line + "\n");
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
        }
...
```

## 불러온 데이터 문자열 변수에 저장. 오류 예외처리
이제 불러온 데이터는 String 형태의 변수에 저장하고. 위에서 미리 작성한 예외처리에서, catch 부분에 오류 발생시 실행될 코드를 넣어줍니다.

```java
...
HttpURLConnection urlConnection = null; //HttpUrlConnection
BufferedReader reader = null; //try가 아닌 곳에서도 사용 되므로 try 밖에 선언합니다.
String forecastJsonStr = null; //불러온 데이터 저장에 사용할 변수 - try가 아닌 곳에서도 사용 되므로 try 밖에 선언합니다.
try{
    //새 URL 객체
    String WeatherURL = "http://api.openweathermap.org/data/2.5/forecast/daily?id=1838716&units=metric&cnt=7";
    URL url = new URL(WeatherURL); 
    //새 URLConnection
    urlConnection = (HttpURLConnection) url.openConnection();
    urlConnection.setRequestMethod("GET");
    urlConnection.connect();
    //InputStream 을 사용해 데이터 읽어들이기
    InputStream inputStream = urlConnection.getInputStream();
    //StringBuffer 에 데이터 저장
    StringBuffer buffer = new StringBuffer(); // 새로운 StringBuffer 생성
    reader = new BufferedReader(new InputStreamReader(inputStream));
    String line;
    while ((line = reader.readLine()) != null) {
        buffer.append(line + "\n");
            }
            if (buffer.length() == 0) {
        // 불러온 데이터가 비어있음.
        forecastJsonStr = null;
    }
    forecastJsonStr = buffer.toString(); //로드한 데이터 문자열 변수에 저장.
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch(IOException e){
        forecastJsonStr = null;
        } finally{
             if (urlConnection != null) {
            urlConnection.disconnect(); //HttpURLConnection 연결 끊기
            }
            if (reader != null) {
                try {
                    reader.close();
                    } catch (final IOException e) {
                }
            }
        }
...
```

## Log 찍기
오류가 나는 경우 그에 대한 더 자세한 정보를 얻기 위해. Log 가 찍히도록 코드를 작성해 봅시다. 아래와 같은 형태의 Log 를 찍을 수 있습니다.

- Error(오류)
- Warn(경고)
- Info(정보)
- Debug(디버그)
- Verbose(일반적인 정보)

아래와 같은 코드로 Log 를 찍을 수 있습니다.

```java

Log.e("로그", "오류 발생"); 
Log.w("로그", "경고!"); 
Log.i("로그", "새로운 정보!"); 
Log.d("로그", "디버깅 결과"); 
Log.v("로그", "일반적인 정보");
```

## Logcat 보기
여기까지 작성한 앱을 한번 실행 해 봅시다. 앱이 강제 종료 되지 않나요? 그것이 정상 입니다. Logcat을 확인해서 출력된 Log들을 살펴 봅시다.
<img src="/blogimgs/networkonmain.png"><br>

보통, Run 버튼을 눌러 앱을 테스트 하면, 자동으로 하단에 Android DDMS 가 나타나고, 그곳에 Logcat 이 나타납니다. Run 버튼과 같은 줄에 위치한 Android Device Monitor(안드로이드 마스코드 모양의 버튼)에서도 Logcat 확인이 가능합니다. 
<img src="/blogimgs/check_logcat.png"><br>

Logcat 을 한번 확인 해 봅시다.

```text
01-02 00:01:33.119    4099-4099/com.youngbin.androidstudy D/AndroidRuntime﹕ Shutting down VM
01-02 00:01:33.127    4099-4099/com.youngbin.androidstudy E/AndroidRuntime﹕ FATAL EXCEPTION: main
    Process: com.youngbin.androidstudy, PID: 4099
    java.lang.RuntimeException: Unable to start activity ComponentInfo{com.youngbin.androidstudy/com.youngbin.androidstudy.MainActivity}: android.os.NetworkOnMainThreadException
            at android.app.ActivityThread.performLaunchActivity(ActivityThread.java:2298)
            at android.app.ActivityThread.handleLaunchActivity(ActivityThread.java:2360)
            at android.app.ActivityThread.access$800(ActivityThread.java:144)
            at android.app.ActivityThread$H.handleMessage(ActivityThread.java:1278)
            at android.os.Handler.dispatchMessage(Handler.java:102)
            at android.os.Looper.loop(Looper.java:135)
            at android.app.ActivityThread.main(ActivityThread.java:5221)
            at java.lang.reflect.Method.invoke(Native Method)
            at java.lang.reflect.Method.invoke(Method.java:372)
            at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:899)
            at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:694)
     Caused by: android.os.NetworkOnMainThreadException
            at android.os.StrictMode$AndroidBlockGuardPolicy.onNetwork(StrictMode.java:1147)
            at java.net.InetAddress.lookupHostByName(InetAddress.java:418)
            at java.net.InetAddress.getAllByNameImpl(InetAddress.java:252)
            at java.net.InetAddress.getAllByName(InetAddress.java:215)
            at com.android.okhttp.HostResolver$1.getAllByName(HostResolver.java:29)
            at com.android.okhttp.internal.http.RouteSelector.resetNextInetSocketAddress(RouteSelector.java:232)
            at com.android.okhttp.internal.http.RouteSelector.next(RouteSelector.java:124)
            at com.android.okhttp.internal.http.HttpEngine.connect(HttpEngine.java:272)
            at com.android.okhttp.internal.http.HttpEngine.sendRequest(HttpEngine.java:211)
            at com.android.okhttp.internal.http.HttpURLConnectionImpl.execute(HttpURLConnectionImpl.java:373)
            at com.android.okhttp.internal.http.HttpURLConnectionImpl.connect(HttpURLConnectionImpl.java:106)
            at com.youngbin.androidstudy.MainActivity$PlaceholderFragment.onCreateView(MainActivity.java:94)
            at android.support.v4.app.Fragment.performCreateView(Fragment.java:1786)
            at android.support.v4.app.FragmentManagerImpl.moveToState(FragmentManager.java:947)
            at android.support.v4.app.FragmentManagerImpl.moveToState(FragmentManager.java:1126)
            at android.support.v4.app.BackStackRecord.run(BackStackRecord.java:739)
            at android.support.v4.app.FragmentManagerImpl.execPendingActions(FragmentManager.java:1489)
            at android.support.v4.app.FragmentActivity.onStart(FragmentActivity.java:548)
            at android.app.Instrumentation.callActivityOnStart(Instrumentation.java:1220)
            at android.app.Activity.performStart(Activity.java:5949)
            at android.app.ActivityThread.performLaunchActivity(ActivityThread.java:2261)
            at android.app.ActivityThread.handleLaunchActivity(ActivityThread.java:2360)
            at android.app.ActivityThread.access$800(ActivityThread.java:144)
            at android.app.ActivityThread$H.handleMessage(ActivityThread.java:1278)
            at android.os.Handler.dispatchMessage(Handler.java:102)
            at android.os.Looper.loop(Looper.java:135)
            at android.app.ActivityThread.main(ActivityThread.java:5221)
            at java.lang.reflect.Method.invoke(Native Method)
            at java.lang.reflect.Method.invoke(Method.java:372)
            at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:899)
            at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:694)
```

우리가 작성한 코드의 네트워크 통신 부분에서 오류가 발생했군요. NetworkOnMainThreadException 오류가 발생했습니다. 우리가 네트워크 작업이 Main Thread 에서 실행되도록 작성해서 그렇습니다. 이를 해결하기 위해, Thread 에 대해서 알아봅시다.

```text
    ...
    Process: com.youngbin.androidstudy, PID: 4099
    java.lang.RuntimeException: Unable to start activity ComponentInfo{com.youngbin.androidstudy/com.youngbin.androidstudy.MainActivity}: android.os.NetworkOnMainThreadException
            at android.app.ActivityThread.performLaunchActivity(ActivityThread.java:2298)
            ...
            at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:694)
     Caused by: android.os.NetworkOnMainThreadException
            at android.os.StrictMode$AndroidBlockGuardPolicy.onNetwork(StrictMode.java:1147)
            ...
            at com.android.okhttp.internal.http.HttpURLConnectionImpl.connect(HttpURLConnectionImpl.java:106)
            at com.youngbin.androidstudy.MainActivity$PlaceholderFragment.onCreateView(MainActivity.java:94)
            at android.support.v4.app.Fragment.performCreateView(Fragment.java:1786)
            at android.support.v4.app.FragmentManagerImpl.moveToState(FragmentManager.java:947)
            ...
```

## Thread
어떤 프로그램 또는 프로세스 내부에서 실행이 되는 흐름의 단위를 말합니다. 필요에 따라 둘 이상의 Thread 를 실행 시킬수도 있는데, 이러한 실행 방식을 Multithread 하며, 둘 이상의 Thread 를 다루는 것을 보고, Multi Threading 이라고 합니다. 안드로이드 앱 에서는 기본적으로 사용자로 부터의 입력 및 출력을 처리해 주는 UI Thread 가 있습니다. Main Thread 라고도 부릅니다. UI Thread 는 버튼 클릭, 화면 드래그 등의 간단하고 짧은 작업들을 수행합니다. 그런대 여기서 네트워크 작업을 실행하게 되면. 네트워크 작업을 일단 마쳐야 하기 때문에, 만약 네트워크 작업이 오래 걸리면 사용자로 부터의 입력과 출력 등을 처리하지 못하게 됩니다. 따라서, 사용자 입장에서는 앱이 먹통인 것으로 보입니다. 그러므로 안드로이드 3.0 부터는 이렇게 작동되면 오류로 처리가 되어 버립니다. 우리는 네트워크 작업을 별도 Thread 에서 실행되도록 할 건데. AsyncTask 를 이용하여 구현 할 것입니다.
<img src="/blogimgs/multithreading.png"><br>


## AsyncTask
AsyncTask 는 백그라운드 작업을 쉽게 실행 할 수 있도록, 그리고 결과를 UI Thread 로 쉽게 넘길 수 있도록 해줍니다.
AsyncTask 에는 4가지 메서드가 있습니다. 백그라운드 작업 전에 실행되는 onPreExecute(), 백그라운드 작업을 실행하는 doInBackground(Params...), 중간에 진행 정도를 UI Thread 에 넘겨주는 onProgressUpdate(Progress...), 백그라운드 작업이 끝나고 실행되며 결과를 Ui Thread 로 넘기는 onPostExecute(Result) 가 있습니다. 
<img src="/blogimgs/asynctask_methods.png"><br>

AsyncTask 를 구현 할 때는, AsncTask 를 상속받는 클래스로 구현합니다.

```java
private class myAsyncTask extends AsyncTask<실행시 받을 매개변수 타입, 진행 현황 변수 타입, 완료시 반환할 변수 타입>{ 
    protected void onPreExecute() { 
    // 백그라운드 작업 전에 Main Thread 에 실행 
        } 
    protected void doInBackground(Params... params) { 
    //백그라운드 작업 실행 
    } 
    protected void onProgressUpdate(Progress... progress) { 
    //도중에 진행 정도 변경 시 Main Thread 에서 실행 
    publishProgress(progress); 
        } 
    protected void onPostExecute(Result result) { 
    //백그라운드 작업 후 Main Thread 실행 
        }
    }
```

그럼, 한번 구현해 봅시다. 일단 코드가 슬슬 길어져서 눈으로 읽이 좀 어려우니. Fragment 를 별도의 클래스 파일로 분리합니다.
새로 클래스 파일을 만들고, 그곳으로 Fragment 부분을 모두 옮기고, 기존에 Activity 클래스 파일의 Fragment 코드는 지웁시다.

수정된 MainActivity,java

```java
public class MainActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        if (savedInstanceState == null) {
            getSupportFragmentManager().beginTransaction()
                    .add(R.id.container, new WeatherFragment())
                    .commit();
        }
    }
    ...
```

MainActivity.java 에서 WeatherFragment.java 로 분리된 Fragment 코드

```java
public class WeatherFragment extends Fragment {

    public WeatherFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_main, container, false);
        //문자열 배열로 ListView에 넣을 데이터 만들기. 이름은 myArray.
        String[] myArray = {"Sample Item 0", "Sample Item 1", "Sample Item 2", "Sample Item 3", "Sample Item 4"};
        List<String> myArrayList = new ArrayList<String>(Arrays.asList(myArray)); //ArrayList로 변환합니다. 동적으로 항목을 추가하거나 뺄 수 있습니다.
        //ArrayAdapter 초기화
        ArrayAdapter<String> myAdapter = new ArrayAdapter<String>(
                getActivity(), //Context - Fragment 는 Context 를 가지지 않으므로 Activity 에서 얻어옴
                android.R.layout.simple_list_item_1, //각 항목별 Layout - 일단은 안드로이드 시스템 내장 리소스 얻어옴
                myArrayList); //ListView 에 표시될 데이터
        //ListView 찾기
        ListView LV = (ListView)rootView.findViewById(R.id.listView); //R.id.(ListView id 값 - Layout 파일에서 확인 가능)
        //Adapter 설정
        LV.setAdapter(myAdapter);

        HttpURLConnection urlConnection = null; //HttpUrlConnection
        BufferedReader reader = null; //try가 아닌 곳에서도 사용 되므로 try 밖에 선언합니다.
        String forecastJsonStr = null; //불러온 데이터 저장에 사용할 변수 - try가 아닌 곳에서도 사용 되므로 try 밖에 선언합니다.
        try{
            //새 URL 객체
            String WeatherURL = "http://api.openweathermap.org/data/2.5/forecast/daily?id=1838716&units=metric&cnt=7";
            URL url = new URL(WeatherURL);
            //새 URLConnection
            urlConnection = (HttpURLConnection) url.openConnection();
            urlConnection.setRequestMethod("GET");
            urlConnection.connect();
            //InputStream 을 사용해 데이터 읽어들이기
            InputStream inputStream = urlConnection.getInputStream();
            //StringBuffer 에 데이터 저장
            StringBuffer buffer = new StringBuffer(); // 새로운 StringBuffer 생성
            reader = new BufferedReader(new InputStreamReader(inputStream));
            String line;
            while ((line = reader.readLine()) != null) {
                buffer.append(line + "\n");
            }
            if (buffer.length() == 0) {
                // 불러온 데이터가 비어있음.
                forecastJsonStr = null;
            }
            forecastJsonStr = buffer.toString(); //로드한 데이터 문자열 변수에 저장.
        }catch(IOException e){
            forecastJsonStr = null;
        }finally{
            if (urlConnection != null) {
                urlConnection.disconnect(); //HttpURLConnection 연결 끊기
            }
            if (reader != null) {
                try {
                    reader.close();
                } catch (final IOException e) {
                }
            }
        }
        return rootView;
    }
}
```

일단은, doInBackground() 만 구현해 봅시다. AsyncTask 를 상속하는 내부 클래스를 하나 만들고 doImBackgound() 를 구현한 다음, 그 안에 네트워크 작업 코드를 옮기면 됩니다.

```java
public class WeatherFragment extends Fragment {

    public WeatherFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_main, container, false);
        ...
        myAsyncTask mat = new myAsyncTask(); //myAsyncTask 객체 생성
        mat.execute(); //myAsyncTask 실행하기
        return rootView;
    }
    protected class myAsyncTask extends AsyncTask<Void, Void, Void> {
        @Override
        protected Void doInBackground(Void... params) {
            HttpURLConnection urlConnection = null; //HttpUrlConnection
            BufferedReader reader = null; //try가 아닌 곳에서도 사용 되므로 try 밖에 선언합니다.
            String forecastJsonStr = null; //불러온 데이터 저장에 사용할 변수 - try가 아닌 곳에서도 사용 되므로 try 밖에 선언합니다.
            try{
                //새 URL 객체
                String WeatherURL = "http://api.openweathermap.org/data/2.5/forecast/daily?id=1838716&units=metric&cnt=7";
                URL url = new URL(WeatherURL);
                //새 URLConnection
                urlConnection = (HttpURLConnection) url.openConnection();
                urlConnection.setRequestMethod("GET");
                urlConnection.connect();
                //InputStream 을 사용해 데이터 읽어들이기
                InputStream inputStream = urlConnection.getInputStream();
                //StringBuffer 에 데이터 저장
                StringBuffer buffer = new StringBuffer(); // 새로운 StringBuffer 생성
                reader = new BufferedReader(new InputStreamReader(inputStream));
                String line;
                while ((line = reader.readLine()) != null) {
                    buffer.append(line + "\n");
                }
                if (buffer.length() == 0) {
                    // 불러온 데이터가 비어있음.
                    forecastJsonStr = null;
                }
                forecastJsonStr = buffer.toString(); //로드한 데이터 문자열 변수에 저장.
            } catch (MalformedURLException e) {
            e.printStackTrace();
            }catch(IOException e){
                forecastJsonStr = null;
            }finally{
                if (urlConnection != null) {
                    urlConnection.disconnect(); //HttpURLConnection 연결 끊기
                }
                if (reader != null) {
                    try {
                        reader.close();
                    } catch (final IOException e) {
                    }
                }
            }
            return null;
        }
    }
}
```

## Overflow Menu 
매번 네트워크 작업이 잘 실행되는지 보기 위해 앱을 죽이고 다시 실행하기는 번거롭습니다. Overflow Menu 를 만들어, 그곳에 새로고침 메뉴를 넣어 봅시다.
아래 사진이 Overflow Menu 입니다. 안드로이드 디바이스에서 다양한 앱 들을 사용 하시면서, 많이 보셨을 겁니다.
<img src="/blogimgs/overflow_menu.png"><br>

### xml 파일로 Overflow Menu 정의하기
우선, Overflow Menu 에 어떤 항목을 넣을지, xml 항목으로 정의 해 줘야 합니다. 먼저, 새로고침 항목에 쓸 문자열을 /res/values/strings.xml 에 추가 합시다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    ...
    <!--새로 추가한 문자열-->
    <string name="refresh">Refresh</string>
</resources>
```
그 다음, 메뉴 항목을 정의해 줍시다. 새로 메뉴 리소스 파일을 /res/menu/ 에 생성해 주세요. 저는 /res/menu/weatherfragment.xml 파일을 생성 했습니다.
그리고 아래 코드를 참고하여, 메뉴를 정의해 주세요.

```xml
<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto">
    <!-- 각 메뉴 항목은 item 태그로 정의합니다.
       android:id="@+id/action_refresh" 항목의 id 값 - 여기서는 action_refresh
       android:title="@string/refresh" 메뉴 항목에 표시할 텍스트
       android:orderInCategory="100" Overflow Menu 에서 몇 번째로 보일지 지정. 여기서는 100번째
       app:showAsAction="never" 액션메뉴 버튼으로 보일지 여부. ifRoom 으로 하면 공간이 있을때,
           Oveeflow Menu 버튼 옆에 별도 버튼으로. never 로 하면 Overflow Menu 에만 나타남.-->
    <item android:id="@+id/action_refresh" android:title="@string/refresh"
        android:orderInCategory="100" app:showAsAction="never" />
</menu>
```

이제, WeatherFragment.java (아까 MainActivity.java 에서 별도 클래스 파일로 분리된 Fragment 클래스 파일) 을 열고, Overflow Menu 동작을 처리해 줍시다.

```java
public class WeatherFragment extends Fragment {
...

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        // 정의한 Menu 리소스를 여기서 Inflate 합니다.
        inflater.inflate(R.menu.weatherfragment, menu);

    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // 메뉴 항목 클릭을 여기서 처리합니다..
        int id = item.getItemId(); // 클릭된 항목 id 값 얻기

        //얻은 id 값에 따라 클릭 처리
        if (id == R.id.action_refresh) { //id값이 action_refresh 이면.
            // 네트워크 작업 실행
            myAsyncTask mat = new myAsyncTask(); //myAsyncTask 객체 생성
            mat.execute(); //myAsyncTask 실행하기
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
```
아. 그리고 WeatherFragment 가 Overflow Menu 를 가지고 있음을 MainActivity 에 알려서, WeatherFragment 가 가지고 있는 Overflow Menu 를 표시 하도록 해 줍시다.

```java
public class WeatherFragment extends Fragment {
    public WeatherFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_main, container, false);
        ...
        // 이 Fragment 가 Overflow Menu 를 가지고 있음을 알리기.
        setHasOptionsMenu(true);
        ...
        return rootView;
    }
    ...
}
```

이제 앱을 다시 한번 실행 해 보세요. 앱이 잘 실행 되나요? 여전히 오류가 날 것입니다. 그것이 정상입니다. Logcat 을 한번 확인 해 볼까요?

```text
01-02 11:18:54.040  16366-16387/com.youngbin.androidstudy E/AndroidRuntime﹕ FATAL EXCEPTION: AsyncTask #1
    Process: com.youngbin.androidstudy, PID: 16366
    java.lang.RuntimeException: An error occured while executing doInBackground()
            at android.os.AsyncTask$3.done(AsyncTask.java:300)
            at java.util.concurrent.FutureTask.finishCompletion(FutureTask.java:355)
            at java.util.concurrent.FutureTask.setException(FutureTask.java:222)
            at java.util.concurrent.FutureTask.run(FutureTask.java:242)
            at android.os.AsyncTask$SerialExecutor$1.run(AsyncTask.java:231)
            at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1112)
            at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:587)
            at java.lang.Thread.run(Thread.java:818)
     Caused by: java.lang.SecurityException: Permission denied (missing INTERNET permission?)
            at java.net.InetAddress.lookupHostByName(InetAddress.java:451)
            at java.net.InetAddress.getAllByNameImpl(InetAddress.java:252)
            at java.net.InetAddress.getAllByName(InetAddress.java:215)
            at com.android.okhttp.HostResolver$1.getAllByName(HostResolver.java:29)
            at com.android.okhttp.internal.http.RouteSelector.resetNextInetSocketAddress(RouteSelector.java:232)
            at com.android.okhttp.internal.http.RouteSelector.next(RouteSelector.java:124)
            at com.android.okhttp.internal.http.HttpEngine.connect(HttpEngine.java:272)
            at com.android.okhttp.internal.http.HttpEngine.sendRequest(HttpEngine.java:211)
            at com.android.okhttp.internal.http.HttpURLConnectionImpl.execute(HttpURLConnectionImpl.java:373)
            at com.android.okhttp.internal.http.HttpURLConnectionImpl.connect(HttpURLConnectionImpl.java:106)
            at com.youngbin.androidstudy.WeatherFragment$myAsyncTask.doInBackground(WeatherFragment.java:66)
            at com.youngbin.androidstudy.WeatherFragment$myAsyncTask.doInBackground(WeatherFragment.java:53)
            at android.os.AsyncTask$2.call(AsyncTask.java:288)
            at java.util.concurrent.FutureTask.run(FutureTask.java:237)
            at android.os.AsyncTask$SerialExecutor$1.run(AsyncTask.java:231)
            at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1112)
            at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:587)
            at java.lang.Thread.run(Thread.java:818)
     Caused by: android.system.GaiException: android_getaddrinfo failed: EAI_NODATA (No address associated with hostname)
            at libcore.io.Posix.android_getaddrinfo(Native Method)
            at libcore.io.ForwardingOs.android_getaddrinfo(ForwardingOs.java:55)
            at java.net.InetAddress.lookupHostByName(InetAddress.java:438)
            at java.net.InetAddress.getAllByNameImpl(InetAddress.java:252)
            at java.net.InetAddress.getAllByName(InetAddress.java:215)
            at com.android.okhttp.HostResolver$1.getAllByName(HostResolver.java:29)
            at com.android.okhttp.internal.http.RouteSelector.resetNextInetSocketAddress(RouteSelector.java:232)
            at com.android.okhttp.internal.http.RouteSelector.next(RouteSelector.java:124)
            at com.android.okhttp.internal.http.HttpEngine.connect(HttpEngine.java:272)
            at com.android.okhttp.internal.http.HttpEngine.sendRequest(HttpEngine.java:211)
            at com.android.okhttp.internal.http.HttpURLConnectionImpl.execute(HttpURLConnectionImpl.java:373)
            at com.android.okhttp.internal.http.HttpURLConnectionImpl.connect(HttpURLConnectionImpl.java:106)
            at com.youngbin.androidstudy.WeatherFragment$myAsyncTask.doInBackground(WeatherFragment.java:66)
            at com.youngbin.androidstudy.WeatherFragment$myAsyncTask.doInBackground(WeatherFragment.java:53)
            at android.os.AsyncTask$2.call(AsyncTask.java:288)
            at java.util.concurrent.FutureTask.run(FutureTask.java:237)
            at android.os.AsyncTask$SerialExecutor$1.run(AsyncTask.java:231)
            at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1112)
            at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:587)
            at java.lang.Thread.run(Thread.java:818)
     Caused by: android.system.ErrnoException: android_getaddrinfo failed: EACCES (Permission denied)
            at libcore.io.Posix.android_getaddrinfo(Native Method)
            at libcore.io.ForwardingOs.android_getaddrinfo(ForwardingOs.java:55)
            at java.net.InetAddress.lookupHostByName(InetAddress.java:438)
            at java.net.InetAddress.getAllByNameImpl(InetAddress.java:252)
            at java.net.InetAddress.getAllByName(InetAddress.java:215)
            at com.android.okhttp.HostResolver$1.getAllByName(HostResolver.java:29)
            at com.android.okhttp.internal.http.RouteSelector.resetNextInetSocketAddress(RouteSelector.java:232)
            at com.android.okhttp.internal.http.RouteSelector.next(RouteSelector.java:124)
            at com.android.okhttp.internal.http.HttpEngine.connect(HttpEngine.java:272)
            at com.android.okhttp.internal.http.HttpEngine.sendRequest(HttpEngine.java:211)
            at com.android.okhttp.internal.http.HttpURLConnectionImpl.execute(HttpURLConnectionImpl.java:373)
            at com.android.okhttp.internal.http.HttpURLConnectionImpl.connect(HttpURLConnectionImpl.java:106)
            at com.youngbin.androidstudy.WeatherFragment$myAsyncTask.doInBackground(WeatherFragment.java:66)
            at com.youngbin.androidstudy.WeatherFragment$myAsyncTask.doInBackground(WeatherFragment.java:53)
            at android.os.AsyncTask$2.call(AsyncTask.java:288)
            at java.util.concurrent.FutureTask.run(FutureTask.java:237)
            at android.os.AsyncTask$SerialExecutor$1.run(AsyncTask.java:231)
            at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1112)
            at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:587)
            at java.lang.Thread.run(Thread.java:818)
```

Logcat 에서 이 부분에 주목해 주세요. 이번에는 SecurityException 때문에 앱이 종료 되었군요. 앱이 인터넷 권한(Permission)을 가지고 있지 않아서 그렇습니다.
문제를 해결하기 위해, 우선 안드로이드의 Permission 시스템에 대해 알아보고, Manifest 에 인터넷 권한도 정의 해 봅시다.

```text
            ...
            at java.lang.Thread.run(Thread.java:818)
     Caused by: java.lang.SecurityException: Permission denied (missing INTERNET permission?)
            at java.net.InetAddress.lookupHostByName(InetAddress.java:451)
            ...
```

## Permission
안드로이드 에서 각각의 앱 들은 설치가 될 때 그 앱 만의 고유한 리눅스 사용자 ID 를 부여 받습니다. 그리고 각 앱들은 안드로이드 가상 머신 안의 각 앱의 인스턴스 안에서 실행 됩니다.
결과적으로, 각 앱들은 각각의 보호된 영역에 완전히 갇혀 실행 되게 됩니다. 또한 외부로 부터 영향을 받지 않으며, 내부에서도 외부에 영향을 주지 못합니다. 

이러한 형태의 보안 모델을 샌드박스(Sandbox) 라고 하며, 다시 말해 안드로이드 에서 각 앱들은 별도의 샌드박스 에서 실행 됩니다. 이로 인해 각 앱들은 다른 앱의 리소스나 프로세스에 접근 할 수 없게 됩니다. 또한 그 어떤 앱도 다른 앱, 안드로이드 OS, 또는 사용자에게 영향을 주는 민감한 데이터 접근하는 것 이나, 민감한 작업을 실행하는 것들을 못하도록 해 줍니다.

인터넷을 사용하는 것, 사용자 위치 정보 얻기, 주소록 데이터 수정하기, 메시지 보내기 등을 예로 들 수 있습니다. 이러한 민감한 것들을 앱에서 하고자 할때, 매번 일일이 권한(Permission) 을 요청 하기 보다는. 개발자가 앱에 요구되는 권한을 Manifest에 정의합니다.

그러면, 사용자가 앱을 설치 할 때 아래 사진과 같은 화면이 나타나, 앱이 요구하는 권한을 확인하고 승인 하도록 합니다.

좋은 앱을 개발하고자 한다면, 가능한 최소의 권한을 요구하도록 앱을 개발하도록 해 보세요. 여러분이 작성한 코드가 권한을 필요로 할 때, 권한을 요구하지 않고 다른 방법으로 할 수는 없는지 생각 해 보시기 바랍니다.

> 업데이트(2016.09.21) : Android 6.0 Marshmellow 부터 런타임 퍼미션이 도입되어, 각 권한이 필요할 때 사용자로부터 승인을 받도록 변경되었습니다.
> 다음 링크들을 참조하세요.
>
> https://developer.android.com/training/permissions/requesting.html
> https://developers-kr.googleblog.com/2015/09/playservice81android60.html

<img src="/blogimgs/google_play_app_permission_dialog.png"><br>

AndroidManifest.xml 이 Manifest 파일 입니다. 여기에 인터넷 권한을 정의 해 봅시다. 아래와 같이 정의 하면 됩니다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.youngbin.androidstudy" >
    
    <!-- 인터넷 Permission 정의 -->
    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:icon="@drawable/ic_launcher"
        ...
```

## 도시 ID 매개변수로 받기
이제 JSON 파싱을 해서, 데이터를 화면에 표시 할 건대. 그 전에, 나중에 사용자가 따로 도시 ID 를 설정 할 수 있도록 코드를 작성하기 위해.
약간의 수정을 해서, 아까 작성한 AsyncTask 를 상속하는 클래스인 myAsyncTask 가 도시 ID 를 매개 변수로 받도록 수정 해 봅시다.
URL 은 나중에 다른 부분도 사용자가 설정 할 수 있도록 코드를 작성하기 위해, [UriBuilder](http://developer.android.com/reference/android/net/Uri.Builder.html) 를 이용해 작성해 봅시다.

```java
public class WeatherFragment extends Fragment {


    public WeatherFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_main, container, false);
        ...
        mat.execute("1838716"); //myAsyncTask 실행하기
        return rootView;
    }
    protected class myAsyncTask extends AsyncTask<String, Void, Void> {
        @Override
        protected Void doInBackground(String... params) {
            ...

            // 날씨 데이터 URL 에 사용될 옵션
            String format = "json";
            String units = "metric";
            int numDays = 7;
            try{
                //새 URL 객체
                //UriBuilder 를 이용해 URL 만들기
                final String FORECAST_BASE_URL =
                        "http://api.openweathermap.org/data/2.5/forecast/daily?";
                final String QUERY_PARAM = "q";
                final String FORMAT_PARAM = "mode";
                final String UNITS_PARAM = "units";
                final String DAYS_PARAM = "cnt";

                Uri builtUri = Uri.parse(FORECAST_BASE_URL).buildUpon()
                        .appendQueryParameter(QUERY_PARAM, params[0])
                        .appendQueryParameter(FORMAT_PARAM, format)
                        .appendQueryParameter(UNITS_PARAM, units)
                        .appendQueryParameter(DAYS_PARAM, Integer.toString(numDays))
                        .build();
                
                URL url = new URL(builtUri.toString());
               ...
            } catch (MalformedURLException e) {
            e.printStackTrace();
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    }catch(IOException e){
                forecastJsonStr = null;
            }finally{
              ...
            }
            return null;
        }
}
   ...

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        ...
        if (id == R.id.action_refresh) { //id값이 action_refresh 이면.
            // 네트워크 작업 실행
            myAsyncTask mat = new myAsyncTask(); //myAsyncTask 객체 생성
            mat.execute("1838716"); //myAsyncTask 실행하기
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
```

## JSON Parsing
이제, 우리가 작성한 코드로 읽어들인 JSON 코드를 분석해서 필요한 데이터만 뽑아 화면에 표시해 봅시다.
우선, 우리가 읽어들인 데이터가 어떻게 생겼나 볼까요?
<img src="/blogimgs/json_not_formatted.png"><br>
이 상태에서는 읽기가 좀 어렵군요. Json Formatter 를 이용해 읽기 쉽도록 해 봅시다.
[여기](http://jsonformatter.curiousconcept.com/)를 클릭해서 Json Formatter 웹 사이트를 열고, 
입력칸에 JSON 데이터를 넣은 다음. Process 를 누르면 아래 사진과 같이 나옵니다.
<img src="/blogimgs/json_formatted.png"><br>
<img src="/blogimgs/json_formatted_fullscreen.png"><br>
이제 좀 읽이 편하군요. 한번 우리가 원하는 데이터를 찾아 봅시다.

```json
{
   "cod":"200",
   "message":0.5484,
   "city":{
      "id":1838716,
      "name":"Bucheon",
      "coord":{
         "lon":126.783058,
         "lat":37.49889
      },
      "country":"KR",
      "population":850731
   },
   "cnt":7,
   "list":[
      {
         "dt":1420167600,
         "temp":{
            "day":-2.75,
            "min":-12.96,
            "max":-1.33,
            "night":-12.96,
            "eve":-4.91,
            "morn":-2.75
         },
         "pressure":1025.71,
         "humidity":66,
         "weather":[
            {
               "id":600,
               "main":"Snow",
               "description":"light snow",
               "icon":"13d"
            }
         ],
         "speed":2.97,
         "deg":321,
         "clouds":64,
         "snow":0.13
      },
      {
         "dt":1420254000,
         "temp":{
            "day":-2.05,
            "min":-16.49,
            "max":0.28,
            "night":-6.6,
            "eve":-3.53,
            "morn":-16.49
         },
         "pressure":1025.72,
         "humidity":67,
         "weather":[
            {
               "id":802,
               "main":"Clouds",
               "description":"scattered clouds",
               "icon":"03d"
            }
         ],
         "speed":1.96,
         "deg":128,
         "clouds":32
      },
      {
         "dt":1420340400,
         "temp":{
            "day":8.94,
            "min":-8.03,
            "max":8.94,
            "night":-8.03,
            "eve":2.42,
            "morn":-2.2
         },
         "pressure":1017.87,
         "humidity":71,
         "weather":[
            {
               "id":802,
               "main":"Clouds",
               "description":"scattered clouds",
               "icon":"03d"
            }
         ],
         "speed":4.61,
         "deg":256,
         "clouds":44
      },
      {
         "dt":1420426800,
         "temp":{
            "day":6.69,
            "min":-3.56,
            "max":6.69,
            "night":1.61,
            "eve":0.58,
            "morn":-3.56
         },
         "pressure":1022.54,
         "humidity":0,
         "weather":[
            {
               "id":500,
               "main":"Rain",
               "description":"light rain",
               "icon":"10d"
            }
         ],
         "speed":1.67,
         "deg":174,
         "clouds":86,
         "rain":1.94
      },
      {
         "dt":1420513200,
         "temp":{
            "day":-2.1,
            "min":-7.67,
            "max":1.85,
            "night":-7.67,
            "eve":-5.76,
            "morn":1.85
         },
         "pressure":1018.91,
         "humidity":0,
         "weather":[
            {
               "id":500,
               "main":"Rain",
               "description":"light rain",
               "icon":"10d"
            }
         ],
         "speed":9.3,
         "deg":317,
         "clouds":0,
         "rain":0.53
      },
      {
         "dt":1420599600,
         "temp":{
            "day":-3.9,
            "min":-7.56,
            "max":-3.9,
            "night":-6.9,
            "eve":-5.98,
            "morn":-7.56
         },
         "pressure":1026.48,
         "humidity":0,
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"sky is clear",
               "icon":"01d"
            }
         ],
         "speed":6.29,
         "deg":317,
         "clouds":0
      },
      {
         "dt":1420686000,
         "temp":{
            "day":-1,
            "min":-5.52,
            "max":-1,
            "night":-4.93,
            "eve":-4.1,
            "morn":-5.52
         },
         "pressure":1028.05,
         "humidity":0,
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"sky is clear",
               "icon":"01d"
            }
         ],
         "speed":6.51,
         "deg":315,
         "clouds":0
      }
   ]
}
```
각 요일별 날씨 상태(예를들면 맑은, 눈이 옴, 비가 옴, 흐림 등)와 최대기온, 최저기온을 얻어 봅시다.
각 요일별 날씨는 "list" 라는 Json Array 안에 있고. 그 안에 있는 각 객체 안에 날씨 데이터가 있습니다.
최대기온과 최저기온에 해당되는 "max" 와 "min" 은 "temp" 라는 객체 내부에 있고.
날씨 상태에 해당되는 "main" 은 "weather" 라는 Json Array 의 0번째 객체 안에 있습니다.

먼저, 7일치 날씨정보를 저장할 String[]을 하나 만들고, 반복문을 작성해서 각 요일별 날씨 객체를 얻어냅시다.

```java
    protected class myAsyncTask extends AsyncTask<String, Void, String[]> { // 네트워크 작업 후 String[]을 반환 하도록 수정
        @Override
        protected String[] doInBackground(String... params) {
            ...
            try {
                JSONObject JsonObj = new JSONObject(forecastJsonStr); //읽어들인 String 을 JSONObject로 변환
                Log.d("JSON", forecastJsonStr);
                JSONArray JsonArray = JsonObj.getJSONArray("list"); //"list" Json Array 얻기
                //데이터를 저장한 String[] 생성. JsonArray 의 항목 수 만큼 데이터를 넣을 수 있도록 생성
                String[] WeatherDataArray = new String[JsonArray.length()]; 
                for (int i = 0; i < JsonArray.length(); i++) { //반복문
                    String MaxTemp = null; // 최대기온 저장할 변수
                    String MinTemp = null; // 최저기온 저장할 변수
                    String WeatherMain = null; // 날씨상태 저장할 변수
                    String Item; // 1일 날씨정보 저장할 변수
                    JSONObject EachObj = JsonArray.getJSONObject(i); // i 번째 객체 얻기
                }
                return WeatherDataArray; // 데이터 반환
            } catch (JSONException e) {
                e.printStackTrace();
            }
         ...
         }
        }
         
```

먼저 최대 기온과 최저 기온을 얻어내 봅시다.

```java
    protected class myAsyncTask extends AsyncTask<String, Void, String[]> { // 네트워크 작업 후 String[]을 반환 하도록 수정
        @Override
        protected String[] doInBackground(String... params) {
            ...
            try {
                JSONObject JsonObj = new JSONObject(forecastJsonStr); //읽어들인 String 을 JSONObject로 변환
                Log.d("JSON", forecastJsonStr);
                JSONArray JsonArray = JsonObj.getJSONArray("list"); //"list" Json Array 얻기
                //데이터를 저장한 String[] 생성. JsonArray 의 항목 수 만큼 데이터를 넣을 수 있도록 생성
                String[] WeatherDataArray = new String[JsonArray.length()]; 
                for (int i = 0; i < JsonArray.length(); i++) { //반복문
                    String MaxTemp = null; // 최대기온 저장할 변수
                    String MinTemp = null; // 최저기온 저장할 변수
                    String WeatherMain = null; // 날씨상태 저장할 변수
                    String Item; // 1일 날씨정보 저장할 변수
                    JSONObject EachObj = JsonArray.getJSONObject(i); // i 번째 객체 얻기
                    JSONObject Temp = EachObj.getJSONObject("temp"); // i 번쨰 객체에서 "temp" 객체 얻기
                    MaxTemp = Temp.getString("max"); // "temp" 객체에서 최대기온인 "max" 얻기
                    MinTemp = Temp.getString("min"); // "temp" 객체에서 최저기온인 "min" 얻기

                }
                return WeatherDataArray; // 데이터 반환
            } catch (JSONException e) {
                e.printStackTrace();
            }
         ...
         }
        }
         
```

그리고 이어서 날씨 상태를 얻어내 봅시다.

```java
    ...
    protected class myAsyncTask extends AsyncTask<String, Void, String[]> { // 네트워크 작업 후 String[]을 반환 하도록 수정
        @Override
        protected String[] doInBackground(String... params) {
            ...
            try {
                JSONObject JsonObj = new JSONObject(forecastJsonStr); //읽어들인 String 을 JSONObject로 변환
                Log.d("JSON", forecastJsonStr);
                JSONArray JsonArray = JsonObj.getJSONArray("list"); //"list" Json Array 얻기
                //데이터를 저장한 String[] 생성. JsonArray 의 항목 수 만큼 데이터를 넣을 수 있도록 생성
                String[] WeatherDataArray = new String[JsonArray.length()]; 
                for (int i = 0; i < JsonArray.length(); i++) { //반복문
                    String MaxTemp = null; // 최대기온 저장할 변수
                    String MinTemp = null; // 최저기온 저장할 변수
                    String WeatherMain = null; // 날씨상태 저장할 변수
                    String Item; // 1일 날씨정보 저장할 변수
                    JSONObject EachObj = JsonArray.getJSONObject(i); // i 번째 객체 얻기
                    JSONObject Temp = EachObj.getJSONObject("temp"); // i 번쨰 객체에서 "temp" 객체 얻기
                    MaxTemp = Temp.getString("max"); // "temp" 객체에서 최대기온인 "max" 얻기
                    MinTemp = Temp.getString("min"); // "temp" 객체에서 최저기온인 "min" 얻기

                    // i 번째 객체에서 "weather" Json Array 얻기
                    JSONArray WeatherArray = EachObj.getJSONArray("weather");
                    // "weather" Json Array 의 0번째 객체 얻기
                    JSONObject WeatherObj = WeatherArray.getJSONObject(0);
                    // 0번째 객체에서 날씨 상태에 해당되는 "main" 얻기
                    WeatherMain = WeatherObj.getString("main");
                }
                return WeatherDataArray; // 데이터 반환
            } catch (JSONException e) {
                e.printStackTrace();
            }
         ...
         }
        }
        ...
```

그리고, 하나의 문자열로 묶어서 배열에 넣어 봅시다.

```java
    protected class myAsyncTask extends AsyncTask<String, Void, String[]> { // 네트워크 작업 후 String[]을 반환 하도록 수정
        @Override
        protected String[] doInBackground(String... params) {
            ...
            try {
                JSONObject JsonObj = new JSONObject(forecastJsonStr); //읽어들인 String 을 JSONObject로 변환
                Log.d("JSON", forecastJsonStr);
                JSONArray JsonArray = JsonObj.getJSONArray("list"); //"list" Json Array 얻기
                //데이터를 저장한 String[] 생성. JsonArray 의 항목 수 만큼 데이터를 넣을 수 있도록 생성
                String[] WeatherDataArray = new String[JsonArray.length()]; 
                for (int i = 0; i < JsonArray.length(); i++) { //반복문
                    String MaxTemp = null; // 최대기온 저장할 변수
                    String MinTemp = null; // 최저기온 저장할 변수
                    String WeatherMain = null; // 날씨상태 저장할 변수
                    String Item; // 1일 날씨정보 저장할 변수
                    JSONObject EachObj = JsonArray.getJSONObject(i); // i 번째 객체 얻기
                    JSONObject Temp = EachObj.getJSONObject("temp"); // i 번쨰 객체에서 "temp" 객체 얻기
                    MaxTemp = Temp.getString("max"); // "temp" 객체에서 최대기온인 "max" 얻기
                    MinTemp = Temp.getString("min"); // "temp" 객체에서 최저기온인 "min" 얻기

                    // i 번째 객체에서 "weather" Json Array 얻기
                    JSONArray WeatherArray = EachObj.getJSONArray("weather");
                    // "weather" Json Array 의 0번째 객체 얻기
                    JSONObject WeatherObj = WeatherArray.getJSONObject(0);
                    // 0번째 객체에서 날씨 상태에 해당되는 "main" 얻기
                    WeatherMain = WeatherObj.getString("main");
                        
                    //하나의 문자열로 저장
                    Item = WeatherMain + " : " + " MAX=" + MaxTemp + " MIN=" + MinTemp;
                    Log.d("Item",Item);
                    // WeatherDataArray 에 i 번째 항목으로 넣기
                    WeatherDataArray[i] = Item;
                }
                return WeatherDataArray; // 데이터 반환
            } catch (JSONException e) {
                e.printStackTrace();
            }
         ...
         }
        }
         
```

## Adapter 갱신하기
이제 날씨 데이터를 뽑아내기 까지 했으니, Adapter 에 새 데이터를 전달해서, 우리가 뽑아낸 데이터가 ListView 에 나타나도록 해 봅시다.
Adapter 에 접근 하는것은 UI 에 접근 하는 것이기 때문에, doInBackground(Params...) 에서 처리 하면 안 되고.
onPostExecute(Result) 를 따로 구현해서 처리 해 줘야 합니다.

```java
protected class myAsyncTask extends AsyncTask<String, Void, String[]> {
...
        @Override
        protected void onPostExecute(String[] Data) { // 백그라운드 작업 후, UI Thread 에서 실행 됩니다.
            if (Data != null) {
                myAdapter.clear(); // Adapter 가 가진 데이터 모두 지우기
                for (String dayForecastStr : Data) {
                    myAdapter.add(dayForecastStr); // 반복문 이용해 데이터 새로 넣기
                }
            }
        }
}
```

Adapter 가 가진 데이터가 변경되면. Adapter.notifyDataSetChanged(); 를 호출해서 데이터가 변경 되었음을 알려야 합니다. 그러나 우리는 굳이 따로 호출 해 줄 필요가 없습니다.
우리가 호출한 Adapter.clear(); 와 Adapter.add(String); 이 호출 될 때, Adapter.notifyDataSetChanged(); 이 같이 호출 되기 때문입니다.
그걸 제가 어떻게 아냐고요? 안드로이드는 오픈소스여서 소스코드를 들여다 볼 수 있습니다. 당연히 API 들이 구현된 Framework 도 들여다 볼 수 있습니다.
한번 소스를 들여다 봅시다. 그리고 Adapter.clear(); 와 Adapter.add(String); 에서 실제로 Adapter.notifyDataSetChanged(); 이 호출 되는지 확인 해 봅시다.
[여기](https://android.googlesource.com/platform/frameworks/base/+/master/core/java/android/widget/ArrayAdapter.java) 를 클릭해서 ArrayAdapter 클래스 소스코드를 들여다 봅시다.

clear 를 검색해서, 해당 메서드를 찿아보세요. 사진에서 보시다 싶이 실제로 내부에서 호출 되고 있습니다.
<img src="/blogimgs/arrayadapter_clear_method.png"><br>
add 를 검색해서, 해당 메서드를 찿아보면, 역시 내부에서 호출 해 주고 있습니다.
<img src="/blogimgs/arrayadapter_add_method.png"><br>
안드로이드는 오픈소스 이기 때문에, 이렇게 소스코드를 들여다 보실 수 있습니다. 
소스코드를 들여다 보시는 것은 여러분들이 안드로이드 시스템이 어떻게 동작 하는지 알아 보실 수 있으며, 이는 앱을 개발 할 때 많은 도움이 될 겁니다.

## 앱 실행 결과.
여기까지 Lesson 2 내용 정리 였습니다. 이제 작성한 앱을 실행 해 보세요. 아래 사진과 같이 잘 나오나요??
<img src="/blogimgs/lesson_two_result.png"><br>

## 소스코드
Lesson 2 에 해당되는 소스코드 입니다.
[https://github.com/sukso96100/zionhs_android_study/tree/lesson2](https://github.com/sukso96100/zionhs_android_study/tree/lesson2)

## 귀찮게 HttpURLConnection 쓰고 쓰레드 돌리지 않고 라이브러리 이용해서 쉽게 네트워킹 하기.
귀찮게 일일이 연결 열고, InputStream 을 String 으로 변환하거나 하지 말고, 라이브러리를 이용해 편리하게 해 봅시다.
많은 개발자 분들이 안드로이드 에서 사용 가능한 다양한 라이브러리를 개발해 둬서, 라이브러리를 잘 활용해 구현하기 어려운 것도 쉽게 구현 할 수 있습니다.

안드로이드 네트워킹을 쉽게 할 수 있도록 해 주는 라이브러리도 아주 다양합니다. RetroFit, OkHttp, Volley, Loopj Async-HttpClient 등이 있는대.
이 포스트에서는 [OkHttp](http://square.github.io/okhttp/) 를 한번 다뤄 보고자 합니다. 먼저 라이브러리를 추가 해 줍시다. 우리는 Android Studio 를 사용하죠? Lesson 1 에서 언급한 Gradle 이 알아서 의존성 등을 처리해 줍니다. gradle 빌드 스크립트에 한 줄만 추가하면 라이브러리 추가는 끝납니다. 앱 모듈 디렉터리에 위치한 build.gradle 을 열고, dependencies 에 한줄 추가 합니다.

```groovy
...
dependencies {
    compile fileTree(include: ['*.jar'], dir: 'libs')
    compile 'com.android.support:appcompat-v7:21.0.3'
    compile 'com.squareup.okhttp:okhttp:2.2.0' // 이거 한줄만 추가하면 됩니다.
}
...
```
[OkHttp 의 Wiki 문서](https://github.com/square/okhttp/wiki)나 [JavaDoc 문서](http://square.github.io/okhttp/javadoc/index.html)를 참고해서 코드를 작성 하시면 됩니다. 아래는 비동기 방식으로 네트워크 작업을 OkHttp 로 하는 방법의 예시 입니다.
우리가 기존에 사용하던 방법에 비하면 정말 간단하지 않나요?

```java
  private final OkHttpClient client = new OkHttpClient();

  public void run() throws Exception {
    Request request = new Request.Builder()
        .url("http://publicobject.com/helloworld.txt")
        .build();

    client.newCall(request).enqueue(new Callback() {
      @Override public void onFailure(Request request, Throwable throwable) {
        //네트워크 작업 실패한 경우 여기 있는 코드가 실행 됩니다.
        throwable.printStackTrace();
      }

      @Override public void onResponse(Response response) throws IOException {
        if (!response.isSuccessful()) throw new IOException("Unexpected code " + response);
            //네트워크 작업을 성공적으로 마처서 응답을 받은 경우 여기 있는 코드가 실행됩니다.
            //reponse 가지고 작업 하시면 됩니다.
        Headers responseHeaders = response.headers();
        for (int i = 0; i < responseHeaders.size(); i++) {
          System.out.println(responseHeaders.name(i) + ": " + responseHeaders.value(i));
        }

        System.out.println(response.body().string());
      }
    });
  }
```

## 추가 자료들...
이 포스트를 보실 때 참고 하시면 좋은 자료들과 웹 사이트 입니다.

- [OpenWeatherMap API](http://openweathermap.org/api)
- [Android Develoers - HttpURLConnection](http://developer.android.com/reference/java/net/HttpURLConnection.html)
- [Android Developers - Log](http://developer.android.com/reference/android/util/Log.html)
- [Android Developers - Connectingeeㄸ to the Network](http://developer.android.com/training/basics/network-ops/connecting.html)
- [Android Developers - System Permissions](http://developer.android.com/guide/topics/security/permissions.html)
- [Android Developers - org.json](http://developer.android.com/reference/org/json/package-summary.html)
- [Android Developers - ArrayAdapter](http://developer.android.com/reference/android/widget/ArrayAdapter.html)
- [Android Framework 에 있는 ArrayAdapter 소스코드](https://android.googlesource.com/platform/frameworks/base/+/master/core/java/android/widget/ArrayAdapter.java)
- [OkHttp](http://square.github.io/okhttp/)
- [hello world » Android의 HTTP 클라이언트 라이브러리](http://helloworld.naver.com/helloworld/textyle/377316)
