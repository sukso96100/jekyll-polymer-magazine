---
layout: post
title: "시온고 안드로이드 스터디 노트 - 3.New Activities And Intents"
date: "2015-01-11"
tags: develop development android app study note
image : /blogimgs/android_study_tshirts.jpg
---

Lesson 2 에 이어 Lesson 3 노트를 계속 합니다. 이번에는 스터디 맴버들이 Udacity 강의와 함께 보면서 공부 할 수 있도록. 일찍 노트를 작성하게 되었습니다.
저번 Lesson 2 에는 갑자기 어려운 내용이 나왔는대. Lesson 3 은 또 조금 쉬운 내용이내요. Udacity 강의가 하나의 앱을 개발하는 과정을 가지고 코스가 짜여있다 보니.
난이도가 들쭉날쭉 한 것 같내요. 이번 Lesson 3 에서는 새로운 Activity 를 만들고, Activity 사이에서 Intent 등을 이용해 통신하는 방법을 주로 다룹니다.

## 시작하기 앞서...
- Lesson 2 는 공부 하였나요? [안했으면 먼저 하고 오시길.](http://www.youngbin.tk/2015/01/01/android-study-lesson-two-note.html)
- Lesson 2 에서 작성한 소스코드를 준비하세요.

## Lesson 3 내용 요약.
- OnItemClickListener - ListView 각 항목 클릭 처리
- 새 Activity 생성.
- Intent 에 대해 알아보기.
- 명시적 인텐트 (Explicit Intent) 를 이용해 Activity 이동하기.
- PreferenceActivity 를 이용해 설정화면 만들기.
- 암시적 인텐트 (Implicit Intent) 에 대해 알아보기.
- BroadcastReceiver 와 Intent Filter 에 대해 알아보기.

## OnItemClickListener 로 ListView 각 항목 클릭 처리하기.
OnItemClickListener 를 등룩하여, 각 항목별 클릭을 처리해 봅시다. 일단 지금은, ListView 에서 각 항목을 클릭하면 해당 항목 내용이 Toast 메시지로 나타나도록 해 봅시다.
먼저 OnItemClickListener 를 등룩 해 줍시다.

```java
public class WeatherFragment extends Fragment {
...
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        ...
        mat.execute("1838716"); //myAsyncTask 실행하기
        //ListView 에 OnItemClickListener 등룩하기.
        LV.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                //각 항목 클릭시 실행될 코드를 여기에 입력합니다.
            }
        });
        return rootView;
    }
    ...
}
```

그리고 Adapter 에서 항목에 해당되는 데이터를 얻어서 Toast 메시지로 표시 해 줍시다. 아래 사진이 Toast 메시지가 나타났을 때 사진입니다. 다들 이미 많이 보셨을 겁니다.
<img src="/blogimgs/toast_message.png"><br>

```java
public class WeatherFragment extends Fragment {
...
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        ...
        mat.execute("1838716"); //myAsyncTask 실행하기
        //ListView 에 OnItemClickListener 등룩하기.
        LV.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                //각 항목 클릭시 실행될 코드를 여기에 입력합니다.
                String ForecastItem = myAdapter.getItem(position); //항목에 해당되는 데이터 얻기
                Toast.makeText(getActivity(), //Context 는 Activity 로부터 얻습니다.
                                ForecastItem, //Toast 로 표시할 문자열 입니다.
                                Toast.LENGTH_SHORT //Toast 메시지를 얼마나 긴 시간동안 표시할지 정합니다.
                                ).show(); // show() 메서드로 Toast 를 보여줍니다.
            }
        });
        return rootView;
    }
    ...
}
```

## Activity 하나 새로 만들기
Activity 를 하나 더 만들어 줍시다. 이 Activity 는 더 자세한 날씨 정보를 표시하는대 사용 할 겁니다.
아래 사진처럼, 패키지 디렉터리를 우클릭해서, 새로운 Activity 를 만들어 주세요. Blank Activity with Fragment 을 선택하여 생성합니다.
<img src="/blogimgs/create_new_blank_activity_with_fragment.png"><br>
이름은 DetailActivity 로 정하고, Hierarchical Parent(계층 부모)는 MainActiity 로 설정하여, 
DetailActivity 의 상위(또는 부모) Activity 가 MainActivity 가 되도록 합시다.
<img src="/blogimgs/new_blank_activity_with_fragment.png"><br>
Activity 를 하나 새로 만들었으나. 아직 우리가 이 Activity 를 실행 하고 있지 않습니다. Intent 를 이용해서 한번 실행해 봅시다.

## Intent
Intent 는 다른 앱 컴포넌트로부터 액션을 하도록 요청하거나(예를 들면 주소록 추가 화면 열기, 웹 브라우저를 열고 특정 웹사이트로 이동) 앱 컴포넌트들 사이에서 통신을 하는대 사용됩니다.
보통 아래와 같은 것들을 하기 위해서 Intent 를 많이 사용 합니다

- Activity 를 시작하기 위해
- Service 를 시작하기 위해 - Service 에 대해서는 추후 더 자세히 다룰 예정.
- Broadcast(방송)을 전달하기 위해

Intent 는 두가지 종류로 나뉩니다.

- Explicit Intent (명시적 인텐트)
>정확한 클래스 이름으로 어떤 앱 컴포넌트를 시작할지, 또는 통신할지 명시적으로 정합니다. 보통 자신이 개발하는 앱에 있는 다른 컴포넌트들을 시작하거나 통신하기 위해 명시적 인텐트를 사용합니다. 당연히 자신이 개발하는 앱 이니, 어떤 앱 컴포넌트가 있는지 앱 컴포넌트 이름은 뭔지 다 알고 있으니까요.

- Implicit Intent (암시적 인텐트)
>정확한 앱 컴포넌트를 명시하지 않습니다. 대신 수행할 일반적인 액션을 정의합니다. 특정 웹페이지를 웹 브라우저 앱에서 열기, 지도 앱에서 사용자 위치 보여주기 등을 예로 들 수 있습니다.

## Explicit Intent 를 사용하여 DetailActivity 시작하기
Explicit Intent 를 이용해 한번 DetailActivity 로 전환해 봅시다.

```java
public class WeatherFragment extends Fragment {
...
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        ...
        mat.execute("1838716"); //myAsyncTask 실행하기
        //ListView 에 OnItemClickListener 등룩하기.
        LV.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                //각 항목 클릭시 실행될 코드를 여기에 입력합니다.
                String ForecastItem = myAdapter.getItem(position); //항목에 해당되는 데이터 얻기
                //새로운 Intent 객체 만들기
                //getActivity() - Context 는 Activity 에서 얻습니다.
                //DetailFragment.class 대상 앱 컴포넌트 입니다.
                Intent DetailIntent = new Intent(getActivity(), DetailActivity.class);
                startActivity(DetailIntent); // Activity 시작하기
            }
        });
        return rootView;
    }
    ...
}
```

## Intent 에 Extra 첨부하기
Intent 를 이용해 통신을 할 때, Extra 를 첨부하여 간단한 데이터를 주고 받을 수 있습니다. DetailActivity에 날씨 정보를 Extra 로 첨부해 보내봅시다.
Intent.putExtra("키 이름", 보낼 데이터); 를 이용해 Extra를 넣고, 나중에 받을 때는 getIntent.getStringExtra() / getIntent.getIntExtra() 등으로 받아서 사용하면 됩니다. 우선 첨부해서 보내 봅시다.

```java
public class WeatherFragment extends Fragment {
...
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        ...
        mat.execute("1838716"); //myAsyncTask 실행하기
        //ListView 에 OnItemClickListener 등룩하기.
        LV.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                //각 항목 클릭시 실행될 코드를 여기에 입력합니다.
                String ForecastItem = myAdapter.getItem(position); //항목에 해당되는 데이터 얻기
                //새로운 Intent 객체 만들기
                //getActivity() - Context 는 Activity 에서 얻습니다.
                //DetailFragment.class 대상 앱 컴포넌트 입니다.
                Intent DetailIntent = new Intent(getActivity(), DetailActivity.class);
                // 키값은 weather_data, 첨부된 데이터는 String 형태인 ForecastItem 로 하였습니다.
                DetailIntent.putExtra("weather_data", ForecastItem); 
                startActivity(DetailIntent); // Activity 시작하기
            }
        });
        return rootView;
    }
    ...
}
```

이제, DetailActivity 에서 받아서 표시해 봅시다. DetailActivity 에서도, Fragment 에 코드를 작성할 겁니다. 마찬가지로 Fragment 의 onCreateView 메서드를 찾아 그곳에 코드를 작성합니다. 받은 Intent 는 Activity 가 가지고 있으므로 getActivity 를 이용해 Intent 를 얻습니다.

우선, 레이아웃 파일에서 날씨 정보를 표시할 TextView 를 작업합시다. 일단 기본적으로 들어가 있는 TextView 에 id 값만 지정해 줍시다.
저는 id 를 weather_data 로 하겠습니다.

```xml
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools" android:layout_width="match_parent"
    android:layout_height="match_parent" android:paddingLeft="@dimen/activity_horizontal_margin"
    android:paddingRight="@dimen/activity_horizontal_margin"
    android:paddingTop="@dimen/activity_vertical_margin"
    android:paddingBottom="@dimen/activity_vertical_margin"
    tools:context="com.youngbin.androidstudy.DetailActivity$PlaceholderFragment">

    <TextView android:text="@string/hello_world" 
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:id="@+id/weather_data"/>

</RelativeLayout>
```
그리고 이어서 Java 코드 작업을 해 줍시다.

```java
public class DetailActivity extends ActionBarActivity {
    ...
    /**
     * A placeholder fragment containing a simple view.
     */
    public static class PlaceholderFragment extends Fragment {

        public PlaceholderFragment() {
        }

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                 Bundle savedInstanceState) {

            View rootView = inflater.inflate(R.layout.fragment_detail, container, false);
            //날씨 정보 표시에 쓸 TextView 찾기           
            TextView WeatherTxt = (TextView)rootView.findViewById(R.id.weather_data);
            //Activity 가 받은 Intent 얻어내어, 같이 Extra 로 온 데이터 얻기
            String WeatherData = getActivity().getIntent().getStringExtra("weather_data");
            //TextView 내용을 얻은 데이터로 설정.
            WeatherTxt.setText(WeatherData);
            return rootView;
        }
    }
}
```

## PreferenceActivity 를 이용해 설정화면 만들기.
이번에는 PreferenceActivity를 이용해서 앱 설정 화면을 만들어 봅시다. 일단 우리가 만들 설정 화면에는 지역과 온도 단위 설정을 넣을것입니다.
안드로이드 스튜디오에 이러한 Activity 를 만들어 주는 기능이 있기는 하지만. 이는 구버전과 최신 버전 모두에 호환되는 코드가 자동으로 생성됩니다. 생성되는 코드가 좀 복잡하기에,
여기서는. 그냥 빈 Activity 를 하나 만들고 PreferenceActivity 를 상속하도록 수정 한 다음. 필요한 것들을 구현 하겠습니다. DetailActivity 를 생성하실 때와 비슷한 방법으로 하시면 됩니다. 대신 Blank Activity with Fragmnt 가 아닌 Blank Activity 를 선택하여 생성합니다. 이름은 SettingsActivity 로 하고 상위 Acivitiy 는 MainActivity 로 해 줍시다.

SettingsActivity 를 생성 하셨으면, 우선 xml 파일 먼저 작성 하겠습니다. res 디렉터리 안에, xml디렉터리를 하나 생성합니다. 그리고 그 안에 settings.xml 을 생성합시다.
지역 선택 설정은. 지역 id 코드를 입력 하도록 할 것입니다. 그러므로 EditTextPreference 를 사용하며, 온도 단위 설정은. 단위 목록에서 선택하여 설정 하므로, ListPreference 를 사용합니다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<PreferenceScreen xmlns:android="http://schemas.android.com/apk/res/android">
    <!--도시 id 설정-->
    <EditTextPreference
        android:key="pref_city_id"
        android:title="@string/pref_city_id"
        android:defaultValue="@string/pref_city_id_default_value" 
        android:inputType="text"
        android:singleLine="true"/>
    <!--온도 단위 설정-->
    <ListPreference
        android:key="pref_unit"
        android:title="@string/pref_unit"
        android:dialogTitle="@string/pref_unit_dialog"
        android:entries="@array/pref_unit_entry"
        android:entryValues="@array/pref_unit_entry_value"
        android:defaultValue="@string/pref_unit_default_value" />
</PreferenceScreen>
```

필요한 문자열도 strings.xml 에 추가 해 줍시다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    ...
    <string name="pref_city_id">City Id</string>
    <string name="pref_city_id_dialog">Type City Id</string>
    <string name="pref_city_id_default_value" translatable="false">1838716</string>
    
    <string name="pref_unit">Unit</string>
    <string name="pref_unit_default_value" translatable="false">metric</string>
    <string-array name="pref_unit_entry">
        <item>Metric</item>
        <item>Imperial</item>
    </string-array>
    <string-array name="pref_unit_entry_value">
        <item>metric</item>
        <item>imperial</item>
    </string-array>
</resources>
```

Java 클래스 파일도 슬슬 수정해 봅시다. 먼저 아래와 같이 PreferenceActivity 를 상속하도록 수정합시다.
그리고 onCreate 메서드에서 평소에 보던 setContentView(); 대신 addPreferencesFromResource(); 를 이용해 조금전 작성한 xml 파일을 로드합니다.

```java
public class SettingsActivity extends PreferenceActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.settings);
    }
}
```

클래스에 onPreferenceChangeListener를 구현하고, onPreferenceChangeListener에 Value 를 전달해 줄 메서드도 작성합니다.

```java
public class SettingsActivity extends PreferenceActivity 
    implements Preference.OnPreferenceChangeListener{
        @Override
        public void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            addPreferencesFromResource(R.xml.settings);
        }

        //onPreferenceChangeListener를 등룩하고, 설정 변경시 값을 onPreferenceChangeListener에 전달해줌.
        private void bindPreferenceSummaryToValue(Preference preference) {
        // 값 변경을 감지하기 위해 onPreferenceChangeListener 를 등룩합니다.
        preference.setOnPreferenceChangeListener(this);

        // onPreferenceChangeListener 를 설정의 현재 값으로 걸어줍니다.
        onPreferenceChange(preference,
                PreferenceManager
                        .getDefaultSharedPreferences(preference.getContext())
                        .getString(preference.getKey(), ""));
    }
        //설정이 변경되었음을 감지하는 인터페이스
        @Override
        public boolean onPreferenceChange(Preference preference, Object newValue) {
            return false;
        }
    }
```
onPreferenceChange메서드에 코드를 작성해서, 설정이 변경되면 선택한 내용이 설정 항목 제목 바로 아래 나타나는 Summary 로 나타나도록 해 줍시다.

```java
public class SettingsActivity extends PreferenceActivity 
    implements Preference.OnPreferenceChangeListener{
        @Override
        public void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            addPreferencesFromResource(R.xml.settings);
        }

        //onPreferenceChangeListener를 등룩하고, 설정 변경시 값을 onPreferenceChangeListener에 전달해줌.
        private void bindPreferenceSummaryToValue(Preference preference) {
        // 값 변경을 감지하기 위해 onPreferenceChangeListener 를 등룩합니다.
        preference.setOnPreferenceChangeListener(this);

        // onPreferenceChangeListener 를 설정의 현재 값으로 걸어줍니다.
        onPreferenceChange(preference,
                PreferenceManager
                        .getDefaultSharedPreferences(preference.getContext())
                        .getString(preference.getKey(), ""));
    }
        //설정이 변경되었음을 감지하는 인터페이스
        @Override
        public boolean onPreferenceChange(Preference preference, Object newValue) {
                String stringValue = newValue.toString();
            if (preference instanceof ListPreference) {
            // ListPreference 인 경우 목록에서 선택된 값을 얻어서 표시합니다.
            ListPreference listPreference = (ListPreference) preference;
            int prefIndex = listPreference.findIndexOfValue(stringValue);
            if (prefIndex >= 0) {
                preference.setSummary(listPreference.getEntries()[prefIndex]);
            }
        } else {
            // 다른 Preference 는 간단히 설정된 값으로 표시합니다.
            preference.setSummary(stringValue);
        }
        return true;
        }
    }
```



설정 화면을 만들었습니다. 이제 설정 사항이 앱이 작동할 때 적용 되도록 해 봅시다. WeatherFragment 를 수정하여 설정값이 사용되도록 합시다.
PreferenceActivity 에서 설정한 설정값들은 SharedPreference 의 보호된 공간에 저장 됩니다. 다시 저장된 값들을 불러오거나 수정 하는 경우에는.
SharedPreference 클래스를 이용하면 됩니다.

우선 설정값을 불러온 다음. 그 값을 AsyncTask 작업이 실행 될 때 AsyncTask 클래스로 넘겨줘야 하는대. 매번 메서드를 일일이 호출하기 번거로우니.
따로 하나의 메서드를 만들어서 묶어버리고. 우리가 만든 메서드만 한번씩 호출해 줍시다.

```java
public class WeatherFragment extends Fragment {
...
    void updateWeather(){
        SharedPreferences Pref = PreferenceManager.getDefaultSharedPreferences(getActivity());
        String CityId = Pref.getString("pref_city_id",
                getString(R.string.pref_city_id_default_value));
        String Unit = Pref.getString("pref_unit",
                getString(R.string.pref_unit_default_value));

        myAsyncTask mat = new myAsyncTask(); //myAsyncTask 객체 생성
        mat.execute(CityId,Unit); //myAsyncTask 실행하기
    }
    ...
}
```
우리가 기존에 호출한 AsyncTask 를 실행하는 메서드는 방금 추가한 updateWeather 메서드에서 호출되니 모두 지워줍시다.
아래와 같은 코드들을 지워주면 됩니다.

```java
myAsyncTask mat = new myAsyncTask(); //myAsyncTask 객체 생성
mat.execute(CityId,Unit); //myAsyncTask 실행하기
```

그리고 그 자리에 updateWeather() 를 호출해 줍시다. 그리고 AsyncTask 클래스에서 추가로 넘겨준 값도 사용하도록 수정해 줍시다.

```java
public class WeatherFragment extends Fragment {
    ArrayList<String> WeatherData;
    ArrayAdapter<String> myAdapter;

    public WeatherFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        ...
        //Adapter 설정
        LV.setAdapter(myAdapter);


        updateWeather();

        LV.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            ...
        });
        return rootView;
    }

    void updateWeather(){
        ...
    }

    protected class myAsyncTask extends AsyncTask<String, Void, String[]> {
        String forecastJsonStr = null;

        @Override
        protected String[] doInBackground(String... params) {
            HttpURLConnection urlConnection = null; //HttpUrlConnection
            BufferedReader reader = null;


            // 날시 데이터 URL 에 사용될 옵션
            String format = "json";
            String units = params[1];
            int numDays = 7;
            try {
                //새 URL 객체
                //UriBuilder 를 이용해 URL 만들기
                final String FORECAST_BASE_URL =
                        "http://api.openweathermap.org/data/2.5/forecast/daily?";
                final String QUERY_PARAM = "id";
                final String FORMAT_PARAM = "mode";
                final String UNITS_PARAM = "units";
                final String DAYS_PARAM = "cnt";


                Uri builtUri = Uri.parse(FORECAST_BASE_URL).buildUpon()
                        .appendQueryParameter(QUERY_PARAM, params[0])
                        .appendQueryParameter(FORMAT_PARAM, format)
                        .appendQueryParameter(UNITS_PARAM, units)
                        .appendQueryParameter(DAYS_PARAM, Integer.toString(numDays))
                        .build();

                ...
            } catch (IOException e) {
                forecastJsonStr = null;
            } finally {
                ...
            }

            try {
                ...
                return WeatherDataArray; //데이터 반환
            } catch (JSONException e) {
                e.printStackTrace();
            }
            return null;
        }

       ...
    }
   ...
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // 메뉴 항목 클릭을 여기서 처리합니다..
        int id = item.getItemId(); // 클릭된 항목 id 값 얻기

        //얻은 id 값에 따라 클릭 처리
        if (id == R.id.action_refresh) { //id값이 action_refresh 이면.
            // 네트워크 작업 실행
            updateWeather();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}

```

## Implicit Intent
암시적 인텐트는 앞에서 말했다 싶이 정확히 대상 앱 컴포넌트를 정해주지 않고, 그 대신 일반적인 액션을 정해줍니다.
이번에는 암시적 인텐트를 이용하여, OpenWeatherMap 사이트에서 날시를 볼수 있도록 하는 것과, 날시 정보를 공유하는 기능을 추가해 봅시다.
먼저 WeatherFragment 에서 사이트에서 날시 보기 기능을 추가해 줍시다.
Java 코드를 수정하기 앞서, Menu 항목을 추가해 줍시다. 앞서 만들어 둔 /res/menu/weatherfragment.xml 에 코드를 추가합니다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto">
    ...
    <item android:id="@+id/action_web" android:title="@string/web"
        app:showAsAction="never"/>
</menu>
```
필요한 문자열도 strings.xml 에 추가해 줍시다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    ...
    <string name="web">Open In Web Browser</string>
</resources>
```

WeatherFragment 클래스 파일에서 onOptionsItemSelected 메서드 부분을 수정해 줍시다.
SharedPreference 에서 도시ID 값을 불러와서 URL 완성에 사용합니다.
그리고 암시적 인텐트를 이용에 웹 브라우저에서 열리도록 해 줍시다. 액션은 ACTION_VIEW 로 해줍니다.

```java
public class WeatherFragment extends Fragment {
    ...
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // 메뉴 항목 클릭을 여기서 처리합니다..
        int id = item.getItemId(); // 클릭된 항목 id 값 얻기

        //얻은 id 값에 따라 클릭 처리
        if (id == R.id.action_refresh) { //id값이 action_refresh 이면.
           ...
        }else if(id == R.id.action_web){
            SharedPreferences Pref = PreferenceManager.getDefaultSharedPreferences(getActivity());
            String CityId = Pref.getString("pref_city_id",
                    getString(R.string.pref_city_id_default_value));
            String URL = "http://openweathermap.org/city/" + CityId;
            Uri webpage = Uri.parse(URL);
            Intent intent = new Intent(Intent.ACTION_VIEW, webpage);
                startActivity(intent);

        }

        return super.onOptionsItemSelected(item);
    }
}
```

이번에는 ShareActionProvider 를 이용해, DetailActivity 에 공유 버튼을 추가해 봅시다.
우리가 DetailActivity 를 생성할 때 같이 생성된 /res/menu/menu_detail.xml 을 편집해 줍시다.
showAsAction 은 ifRoom 으로 하여, 액션바에 공간이 있을 때 ActionButton 으로 나타나게 하고.
actionProviderClass 는 Android Support Library 에 있는 ShareActionProvider 로 해 줍니다.

```xml
<menu xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    tools:context="com.youngbin.androidstudy.DetailActivity">
    ...
    <item android:id="@+id/action_share"
        android:title="@string/share"
        app:showAsAction="ifRoom"
        app:actionProviderClass="android.support.v7.widget.ShareActionProvider"/>
</menu>
```
마찬가지로 필요한 문자열을 strings.xml 에 추가해 줍니다.

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    ...
    <string name="share">Share</string>
</resources>

```
이제 DetailActivity 클래스 파일을 수정해 봅시다. 우선 우리는 Fragment 에서 Menu Item 기능을 구현할 것이므로.
DetailActivity 를 생성할 때, 같이 Activity 쪽에 생성된 onCreateOptionsMenu 와 onOptionsItemSelected 메서드 부분을 통째로 지우고.
대신 Fragment 쪽에 메서드를 구현해 줍니다. 그리고 공유에 사용할 Implicit Intent 를 만들어 주는 메서드도 만들어 줍시다.
그리고, Fragment 부분의 onCreateView 메서드에서, setHasOptionsMenu(true); 메서드를 호출하여, Activity 에 Fragment 가 메뉴를 가지고 있음을 알려줍시다.

```java
public class DetailActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        ...
    }

    /**
     * A placeholder fragment containing a simple view.
     */
    public static class PlaceholderFragment extends Fragment {
        ...
        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                 Bundle savedInstanceState) {
                                 // 이 Fragment 가 Overflow Menu 를 가지고 있음을 알리기.
                                 setHasOptionsMenu(true);
                                 ...
        }

        @Override
        public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
            // 정의한 Menu 리소스를 여기서 Inflate 합니다.
            inflater.inflate(R.menu.menu_detail, menu);
            // 공유 버튼 찾기
            MenuItem menuItem = menu.findItem(R.id.action_share);

            // ShareActionProvider 얻기
            ShareActionProvider mShareActionProvider =
                    (ShareActionProvider) MenuItemCompat.getActionProvider(menuItem);

            // 공유 버튼에 사용할 Intent 를 만들어 주는 메서드를 호출합니다.
            if (mShareActionProvider != null ) {
                mShareActionProvider.setShareIntent(createShareForecastIntent());
            } else {
            }
        }

        @Override
        public boolean onOptionsItemSelected(MenuItem item) {
            // 메뉴 항목 클릭을 여기서 처리합니다..
            int id = item.getItemId(); // 클릭된 항목 id 값 얻기
            // Retrieve the share menu item

            return super.onOptionsItemSelected(item);
        }

        // 공유 버튼에 사용할 Intent 를 만들어 주는 메서드 입니다.
        private Intent createShareForecastIntent() {
            //액션은 ACTION_SEND 로 합니다.
            Intent shareIntent = new Intent(Intent.ACTION_SEND);
            //Flag 를 설정해 줍니다. 공유하기 위해 공유에 사용할 다른 앱의 하나의 Activity 만 열고, 
            //다시 돌아오면 열었던 Activity 는 꺼야 하기 때문에
            //FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET 로 해줍니다.
            shareIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET);
            //공유할 것의 형태입니다. 우리는 텍스트를 공유합니다.
            shareIntent.setType("text/plain");
            //보낼 데이터를 Extra 로 넣어줍니다.
            shareIntent.putExtra(Intent.EXTRA_TEXT,WeatherData);
            return shareIntent;
        }
    }
}
```

## BroadcastReceiver 와 Intent Filter
BroadcastReceiver는 말 단어 그대로 방송을 받는 앱 컴포넌트 입니다. 다른 앱이나 안드로이드 시스템에서 sendBroadcast() 메서드를 통해 보내진 Intent 를 받으며,
그에 따른 것들을 처리해 줍니다. 이때 어떤 Intent 를 받을지 Intent Filter 로 정의해 줍니다. 예를들어 USB케이블 연결에 대한 Intent Filter 를 설정하여, USB 케이블 연결시 보내지는 Intent 를 받아, USB 케이블이 연결되면 남은 스토리지 용량을 보여 주도록 할 수도 있습니다.

아래 코드가 BroadcastReceiver 를 상속하는 클래스 코드 예제 입니다. 간단히 onReceive 메서드 하나로 구성되어 있습니다.
onReceive 메서드에 Intent 를 수신하면 실행될 코드들을 넣어주시면 됩니다.

```java
public class MyReceiver extends BroadcastReceiver {
    public MyReceiver() {
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        // Intent 를 받으면 실행할 코드를 여기에 넣습니다.

    }
}
```

Broadcast가 Intent 를 받으려면, 등룩(Register)을 해 줘야 합니다. 두 가지 방법으로 등룩 해 줄 수 있습니다.
Manifest 에 정의하여 등룩하는 방법과, Java 코드를 이용해 필요할 때만 등룩하는 방법이 있습니다.

아래는 Manifest 에 등룩하는 방법의 에제 입니다. Manifest에 아래와 같은 코드를 넣어서 등룩합니다.
Intent Filter 태그 안에 어떤 Intent 를 받을지 Intent Filter 를 정의해 줍니다.
여기서는 전원 케이블 연결에 대한 Intent Filter 를 예시로 넣었습니다.

```xml
    <receiver
            android:name=".MyReceiver" >
            <intent-filter>
                <action android:name="android.intent.action.ACTION_POWER_CONNECTED"></action>
            </intent-filter>
        </receiver>
```

Java 코드를 이용해 동적으로 등룩하고 해제할 때 아래와 같은 코드를 이용합니다.

```java
//myReceiver 객체 생성
MyReceiver myReceiver = new MyReceiver();
//myReceiver 등룩
registerReceiver(myReceiver, new IntentFilter("android.intent.action.ACTION_POWER_CONNECTED"));
//myReceiver 등룩 해제
unregisterReceiver(myReceiver);
```

## 곁들여 보면 좋은 추가자료들...
- [Android Developers - AdapterView.OnItemClickListener](http://developer.android.com/reference/android/widget/AdapterView.OnItemClickListener.html)
- [Android Developers - Intents and Intent Filters](http://developer.android.com/guide/components/intents-filters.html)
- [Android Developers - Settings](http://developer.android.com/guide/topics/ui/settings.html)
- [Android Developers - Saving Key-Value Sets](http://developer.android.com/training/basics/data-storage/shared-preferences.html)
- [Android Developers - PreferenceActivity](http://developer.android.com/reference/android/preference/PreferenceActivity.html)
- [Android Developers - BroadcastReceiver](http://developer.android.com/reference/android/content/BroadcastReceiver.html)
