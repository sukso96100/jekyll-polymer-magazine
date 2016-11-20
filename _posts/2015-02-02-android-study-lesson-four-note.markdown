---
layout: post
title: "시온고 안드로이드 스터디 노트 - 4.Lifecycle and Databases"
date: "2015-02-02"
tags: develop development android app study note
---

Lesson 4 ~ 6 에 대한 정리는 뒤늦게 하게 되었군요. 이 부분은 어려운 내용이 많다보니 Udacity 코스의 내용과 저희 스터디에서 다룬 내용하고 차이가 많습니다.
저는 저희 스터디에서 다룬 내용들만을 다루고자 합니다.

## 스터디에서 다룬 Lesson 4 내용
- 각종 앱 컴포넌트들의 생명주기(Lifecycle)
- Realm 데이터베이스

## Activity 의 생명주기(Lifecycle)
말 그대로 Activity 의 생명주기에 관한 내용입니다. Activity 가 시작이 되어 종료 될 때 까지 어떤 일이 벌어지는지에 관한 내용입니다.
Activity 가 실행되는 동안, 여러 Lifecycle 메서드들이 호출 되는대, 어떤 상황에서 어떤 메서드가 호출되는지 알아봅시다.

<img src="/blogimgs/basic-lifecycle.png"><br>

위 사진은 Activity 의 생명주기를 그림으로 나타낸 것 입니다. 그림에는 Activity 의 상태와, 상태에 따라 호출되는 메서드들이 나와 있습니다.

앱 아이콘 클릭으로 Activity 가 켜지거나, startActivity(); 에 의해 Activity 가 시작되면, onCreate() 가 호출됩니다. 그리고 바로 onStart() 가 시작되어 사용자에게 화면이 보이게 됩니다. 다음으로 onResume() 이 호출되어 사용자와 Activity가 상호작용을 할 수 있게 됩니다.(예를 들면 버튼 클릭) 그러다가 Activity 위에 조그마한 다이얼로그나 팝업 같은 것이 나와 화면에 계속 Activity 가 보이긴 하지만, 잠시 상호작용을 멈출 때 onPause() 가 호출됩니다. 그리고 다시 돌아오면 onResume() 이 호출되어 상호작용기 계속 됩니다. 다른 앱 또는 다른 Activity 로 전환하여, 보고 있던 Activity 가 종료되지 않았지만 화면에 보이지 않아 백그라운드 상태가 될 때, onStop() 가 호출 됩니다. 그러다가 다시 돌아오면, onRestart() 이 호출되어 사용자와의 상호작용이 계속 되고. 사용자가 뒤로가기 버튼 등으로 Activity 를 종료 시키면, onDestory() 가 호출되며 Activity 가 종료 됩니다.

### onCreate()
Activity 가 새로 시작 될 때(앱 아이콘을 눌러서 시작되든, startActivity() 로 시작되든) 호출됩니다.
주로 onCreate() 메서드 안에는 주로 레이아웃을 로드하며 화면에 표시하는 코드와 클릭처리 등의 UI 처리와 관련된 코드들이 많이 들어갑니다.
우리가 작성하는 대부분의 코드가 이 메서드 안에 작성 됩니다.

### onStart()
필자는 거의 써본적이 없는 메서드 입니다. onCreate() 또는 onRestart() 가 호출되고 바로 다음으로 호출됩니다.

### onResume()
onStart() 바로 다음 또는 Paused 상태 (잠시 사용자와의 상호작용이 중지된 상태) 에서 돌아올 떄 호출 됩니다.
Activity 위에 다이얼로그 창이 나타났다가 사라져서 사용자와의 상호작용을 계속 하는 때를 예로 들 수 있습니다.

### onPause()
Activity 가 잠시 백그라운드 상태고 갈 때나, Activity 위에 다이얼로그 같은 것이 나타나서 Paused 상태로 갈 때 호출됩니다.
보통 이 메서드 안에는 화면 상태를 저장하는 코드(이메일 앱을 예로 들면, 메일 작성하다가 나와서 작성중인 것이 임시 저장하는 경우)라던가,
각종 센서 사용을 멈추는 코드들이 들어갑니다. 백그라운드로 가서 Paused 된 Activity 는 곧 onStop() 이 호출 되면서, 
Stop 상태(또는 숨겨진 상태) 가 됩니다.(완전히 꺼진 상태는 아님)

### onStop()
Activity 가 화면상에 보이지 않는 백그라운드 상태가 될 때 호출됩니다. 보통 대부분의 리소스 사용을 중지하는 코드를 이 메서드 안에 넣습니다.

### onDestory()
Activity 가 완전히 종료 될 때 호출됩니다. 우리가 앱을 사용하다가 종료 하기 위해 뒤로가기 버튼을 누르면, 일부 앱은 "종료 하시겠습니까" 같은 다이얼로그가 나타나면서,
종료를 확인하기도 하고. 뒤로가가 한번 더 누르면 앱이 종료된다는 Toast 메시지가 나타나기도 하는대. 이런 것들이 보통 onDestory() 를 사용한 것 들입니다.

## Realm 데이터베이스
안드로이드에는 SQLite 데이터 베이스를 이용해 데이터를 저장하고 불러올 수 있습니다만... 상당히 복잡 하더군요... 그리고 ContentProvider... Ah...
그래서 저희는 Realm 데이터 베이스를 다루는 것으로 대신 했습니다.

Realm 을 사용하려면 일단, build.gradle 의 dependencies 에 의존성으로 Realm 을 추가해 줘야 합니다.
```groovy
...
dependencies {
    compile fileTree(include: ['*.jar'], dir: 'libs')
    compile 'com.android.support:appcompat-v7:21.0.3'
    compile 'com.squareup.okhttp:okhttp:2.2.0' 
    compile 'io.realm:realm-android:0.78.0' // 이거 한줄만 추가하면 됩니다.
}
...
```

### 데이터 모델 정의하기
클래스 파일을 하나 새로 생성하세요. 데이터 모델을 정의하는 클래스로 사용할 것입니다.
데이터 모델을 정의하는 클래스는 RealmObject 를 상속 받고, 클래스에는 데이터 한 열 마다 어떤 데이터가 들어갈지 변수로 정의하고.
getter 와 setter 메서드를 작성해 줍니다. 아래는 스터디를 통해 작성된 것입니다. 하루치 일기예보 데이터 모델을 정의한 것입니다.
한 열에 날씨 상태, 최대기온, 최저기온을 저장하도록 정의되어 있습니다.
```java
public class WeatherDataModel extends RealmObject {
    private String State;
    private String Max;
    private String Min;

    public String getState() {
        return State;
    }

    public void setState(String state) {
        this.State = state;
    }

    public String getMax() {
        return Max;
    }

    public void setMax(String max) {
        this.Max = max;
    }

    public String getMin() {
        return Min;
    }

    public void setMin(String min) {
        this.Min = min;
    }
}
```

### 쓰기 작업
모든 쓰기(추가, 삭제, 수정) 작업은 아래와 같이 쓰기 트랜젝션 안에서 이루어 집니다.
```java
// Realm 인스턴스 얻기
Realm realm = Realm.getInstance(this);

realm.beginTransaction();

//여기에서 쓰기 작업이 이뤄집니다.

realm.commitTransaction();
```

### 데이터 캐싱을 관리할 클래스 작성하기.

클래스를 새로 하나 더 만듭시다. 데이터를 관리해 주는 클래스로 사용할 것입니다.
생성자를 작성하고, 생성자에서 Realm 인스턴스를 얻어줍시다.
```java
public class WeatherDataManager {
    Realm realm;
    String TAG = "WeatherDataManager";
    public WeatherDataManager(Context context){
        //Realm 인스턴스 얻기
        realm = Realm.getInstance(context);
    }
}
```

우선, 캐시를 저장하는 메서드를 새로 작성합시다. 캐시를 저장하는 메서드에는 기존 데이터를 모두 지우고 새로 얻은 데이터를 저장하는 코드를 넣을 겁니다.
캐시를 저장하는 메서드를 작성하기 앞서, 데이터를 모두 쿼리하여 불러오는 메서드를 작성합시다.
```java
public class WeatherDataManager {
    Realm realm;
    String TAG = "WeatherDataManager";
    public WeatherDataManager(Context context){
        //Realm 인스턴스 얻기
        realm = Realm.getInstance(context);
    }
    
     //모든 캐시 데이터 로드하는 함수
    private RealmResults<WeatherDataModel> queryAll(){
        //쿼리하기
        RealmQuery<WeatherDataModel> query = realm.where(WeatherDataModel.class);
        //쿼리한 것에서 모두 다 로드
        RealmResults<WeatherDataModel> results = query.findAll();
        return results;
    }
     
}
```

이제 캐시를 저장하는 메서드를 작업합니다. 우선, 기존 데이터를 비워줍시다.

```java
public class WeatherDataManager {
    Realm realm;
    String TAG = "WeatherDataManager";
    public WeatherDataManager(Context context){
        //Realm 인스턴스 얻기
        realm = Realm.getInstance(context);
    }
    
    //이전 캐시 데이터를 비우고 새로 캐시를 저장하는 함수
    public void dropOldAndSaveNew(
            String[] State, String[] Max, String[] Min, int number){

        Log.d(TAG, "Caching Data");
        //모든 데이터 쿼리하여 불러오기
        RealmResults<WeatherDataModel> result = queryAll();
        //데이터 처리 시작
        realm.beginTransaction();
        //모두 지우기
        result.clear();
        realm.commitTransaction();

    }
    
     //모든 캐시 데이터 로드하는 함수
    private RealmResults<WeatherDataModel> queryAll(){
     ...
    }
     
}
```

그리고 반복문을 이용해 저장해 줍니다.
```java
public class WeatherDataManager {
    Realm realm;
    String TAG = "WeatherDataManager";
    public WeatherDataManager(Context context){
        //Realm 인스턴스 얻기
        realm = Realm.getInstance(context);
    }
    
    //이전 캐시 데이터를 비우고 새로 캐시를 저장하는 함수
    public void dropOldAndSaveNew(
            String[] State, String[] Max, String[] Min, int number){

        Log.d(TAG, "Caching Data");
        //모든 데이터 쿼리하여 불러오기
        RealmResults<WeatherDataModel> result = queryAll();
        //데이터 처리 시작
        realm.beginTransaction();
        //모두 지우기
        result.clear();
        realm.commitTransaction();

        for(int i=0;i<number;i++){
            realm.beginTransaction();
            //새로 데이터 객체 생성
            WeatherDataModel Data = realm.createObject(WeatherDataModel.class);
            //각 필드마다 데이터 설정
            Data.setState(State[i]);
            Data.setMax(Max[i]);
            Data.setMin(Min[i]);
            realm.commitTransaction();
        }
        Log.d(TAG, "Done Caching");
    }
    
     //모든 캐시 데이터 로드하는 함수
    private RealmResults<WeatherDataModel> queryAll(){
     ...
    }
     
}
```

저장된 데이터를 로드하는 4가지 메서드 또한 작성해 줍니다.
3개의 메서드는 각각 상태, 최대, 최저 값을 따로 로드하여 배열로 반환하고.
나머지 하나는 3가지 값을 한 항목으로 합쳐서 배열로 반환해 줍니다.
```java
public class WeatherDataManager {
    Realm realm;
    String TAG = "WeatherDataManager";
    public WeatherDataManager(Context context){
        //Realm 인스턴스 얻기
        realm = Realm.getInstance(context);
    }
    
    //이전 캐시 데이터를 비우고 새로 캐시를 저장하는 함수
    public void dropOldAndSaveNew(
            String[] State, String[] Max, String[] Min, int number){
            ...
    }
    
    //날씨 상태 데이터 로드하는 함수
    public String[] loadStateArrayList(){
        Log.d(TAG, "Loading From Cache");
        //캐시된 데이터 모두 로드
        RealmResults<WeatherDataModel> result = queryAll();
        String[] List = new String[result.size()];
        for (int i = 0; i < result.size(); i++) {
            WeatherDataModel w = result.get(i);
            List[i] = w.getState();
        }
        return List;
    }

    //최대기온 데이터 로드하는 함수
    public String[] loadMaxArrayList(){
        Log.d(TAG, "Loading From Cache");
        //캐시된 데이터 모두 로드
        RealmResults<WeatherDataModel> result = queryAll();
        String[] List = new String[result.size()];
        for (int i = 0; i < result.size(); i++) {
            WeatherDataModel w = result.get(i);
            List[i] = w.getMax();
        }
        return List;
    }

    //최저기온 데이터 로드하는 함수 
    public String[] loadMinArrayList(){
        Log.d(TAG, "Loading From Cache");
        //캐시된 데이터 모두 로드 
        RealmResults<WeatherDataModel> result = queryAll();
        String[] List = new String[result.size()];
        for (int i = 0; i < result.size(); i++) {
            WeatherDataModel w = result.get(i);
            List[i] = w.getMin();
        }
        return List;
    }

    //화면에 표시할 데이터 로드
    public String[] loadDataFromRealm(){
        Log.d(TAG, "Loading From Cache");
        RealmResults<WeatherDataModel> result = queryAll();
        String[] List = new String[result.size()];
        for (int i = 0; i < result.size(); i++) {
            WeatherDataModel w = result.get(i);
            String Item = w.getState() + " : " + " MAX=" + w.getMax() + " MIN=" + w.getMin();
            List[i] = Item;
        }
        Log.d(TAG, "Done Loading From Cache");
        return List;
    }

    
     //모든 캐시 데이터 로드하는 함수
    private RealmResults<WeatherDataModel> queryAll(){
     ...
    }
     
}
```

### 데이터 캐싱 해보기

우리가 작성한 데이터 관리 클래스에서 메서드를 호출해 캐싱 해 봅시다. 아래는 예시 코드입니다.
```java
//인스턴스 얻기
WeatherDataManager manager = new WeatherDataManager(Context);
...
String[] State;
String[] Max;
String[] Min;
...

//캐싱
manager.dropOldAndSaveNew(State, Max, Min, 7);
//캐시 로드
State = manager.loadStateArrayList();
Max = manager.loadMaxArrayList();
Min = manager.loadMinArrayList();
```

## 참고 자료

- [Realm Java Docs](http://realm.io/kr/docs/java/0.78.0/)
- [Managing the Activity Lifecycle](http://developer.android.com/training/basics/activity-lifecycle/index.html)