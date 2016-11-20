---
layout: post
image: /blogimgs/slackbot0_0.png
date: 2016-05-27
title: "Node.js로 Slack 회의록봇 만들기. - 회의 내용 처리 및 저장"
tags: nodejs slack bot json node-filesystem
---
저번 포스팅에 이어, 이번 포스팅에서는 대화 내용을 JSON 형식으로 처리하여 저장하는 부분을 다뤄보겠습니다.

## 메시지 저장할 배열 생성
메시지를 저장할 배열을 하나 생성합시다.

```js
var array = [];
```

## 메시지 내용에 따라 꼬리표 붙여서 저장하기
메시지의 내용에 따라 꼬리표 같은 것을 붙여서 저장합시다. 제가 작업한 회의록봇의 경우 메시지 시작 단어에 따라,
안건, 메모, 대화(나머지) 정도로 분류했습니다.

```js
...
if(message.text.startsWith("안건 :")){
  // 안건으로 분류하여 처리
}else if(message.text.startsWith("메모 :")){
  // 메모로 분류하여 처리
}else {
  // 기타 - 회의 대화 내용으로 처리
}
```

여기에서 메모와 안건의 경우는 앞에 `메모 :`, `안건 :` 이 붙어있는 메시지를 분류하는데, 저장 할 때 여전히 `메모 :`, `안건 :` 이 붙어 있는 경우
잘 정돈된 느낌이 나지 않으니 때고 저장합시다. 그리고 JSON 객체 형태로 아까 만든 배열에 저장합시다.

먼저 앞에 붙은 `안건 :`, `메모 :` 를 때고.

```js
...
if(message.text.startsWith("안건 :")){
  // 안건으로 분류하여 처리
  var subject = message.text.replace("안건 :","");
}else if(message.text.startsWith("메모 :")){
  var memo = message.text.replace("메모 :","");
  // 메모로 분류하여 처리
}else {
  // 기타 - 회의 대화 내용으로 처리
}
```

JSON 객체로 만들어서 아까 만든 베열에 넣어 줍시다. 저의 경우에는 다음과 같은 형태의 JSON 객체를 만들어 배열에 넣어 주었습니다.

```js
array.push({"type":"subject", // type 속성으로 메모/안건/대화 분류
          "time": moment().utcOffset(timezone).format(timeformat), // time - 기록 시간 속성 - moment.js 이용하여 현제시각 기록
          "text": subject}); // text - 대화 내용 텍스트
```

그럼 이제 아래와 같은 방식으로 코드를 작성할 수 있습니다.

```js
...
if(message.text.startsWith("안건 :")){
  // 안건으로 분류하여 처리
  var subject = message.text.replace("안건 :","");
  data.push({"type":"subject  ", "time": moment().utcOffset(timezone).format(timeformat), "text": subject});
}else if(message.text.startsWith("메모 :")){
  var memo = message.text.replace("메모 :","");
  data.push({"type":"memo", "time": moment().utcOffset(timezone).format(timeformat), "text": memo});
  // 메모로 분류하여 처리
}else {
  // 기타 - 회의 대화 내용으로 처리
  data.push({"type":"talk", "time": moment().utcOffset(timezone).format(timeformat), "text": message.text});
}
```

대화 내용의 경우, 해당 메시지를 작성한 사람의 이름을 포함하여 저장해 봅시다.
이전 포스트에서 우리가 메시지 수신 이벤트를 통해 받은 `message`는 `user` 속성을 포함하고 있는데.
이 속성의 값은 메시지롤 보낸 사람의 고유값 입니다. 그대로 사용하면 나중에 누가 한 말인지 알기 어려우므로,
고유값을 이용해 말 한 사람의 이름을 찾아서 대화 내용에 넣어 줍시다.

`rtm.getUserById("사용자ID값")` 을 통해 사용자 객체를 얻을 수 있고. 이 객체의 `name` 속성으로 사용자 이름을 얻을 수 있습니다.

```js
var user = rtm.getUserById(message.user).name;
```

그러면 아래와 같이 작성하여 사용자 이름을 넣어 저장할 수 있습니다.

```js
...
var user = rtm.getUserById(message.user).name;
data.push({"type":"talk",
"time": moment().utcOffset(timezone).format(timeformat),
 "text": user + " : " + message.text});
...
```

## 마크다운 문법으로 정리하여 `*.md` 파일로 저장하기
  배열에 저장한 것을 하나씩 꺼내서, 아래와 같은 형식의 마크다운 문서로 작성하도록 코드를 작성해 봅시다.
  
```md
## 회의 정보
- Slack 팀 이름 :
- 회의 시작/종료인 :
- 회의 시작 시각 :
- 회의 종료 시각 :

## 안건
- 안건 0

## 메모
- 메모 0

## 회의 내용
- A : 회의 내용 0[기록시각]
```

###회의 정보 부분 처리하기

회의 정보 부분은 배열의 가장 첫 요소와 가장 마지막 요소, 그리고 앞서 메시지 수신 이벤트로 받은 `message` 객체를 이용합니다.
**팀 이름** 은, 앞서 사용자 이름을 얻는 방법과 비슷 합니다. `rtm.getTeamById("팀ID값")` 로 팀 객체를 얻고, 이 객체의 `name` 속성으로 팀 이름을 얻습니다.
팀 ID 값은, `message` 객체의 `team` 속성에서 얻을 수 있습니다.
**회의 시작/종료인** 의 경우, 배열의 가장 첫 요소에 있는 사용자 이름을 사용할 수도 있고, 회의 기록 시작 처리할때, 해당 메시지를 보낸 사용자 이름을 별도로 변수를 하나 만들어 보관 해 두고 이를 사용할 수도 있습니다.
**회의 시작 시각과 종료 시각** 은 배열의 가장 첫 요소와 가장 마지막 요소를 이용합니다.

이를 종합하면, 아래와 같은 방식으로 코드를 작성 할 수 있습니다.

```js
...
var username;
...
//회의 시작 처리시 사용자 이름 저장
username = rtm.dataStore.getTeamById(msg.user).name + "("+msg.user+")";
...
var mdData = "";//마크다운 문법으로 처리한 데이터를 저장 해 둘 변수
//팀 이름 얻기
var teamname = rtm.dataStore.getTeamById(msg.team).name + "("+msg.team+")";

// 회의 정보 부분 처리
mdData += "\n## 회의 정보\n";
mdData += "- Slack 팀 이름 : " + teamname +"\n";
// mdData += "- Slack 채널 이름 : " + channelname +"\n";
mdData += "- 회의 시작 및 종료한 사용자 : " + username +"\n";
mdData += "- 회의 시작 시각 : " + data[0].time +"\n";
mdData += "- 회의 종료 시각 : " + data[data.length - 1].time +"\n";
```

### 안건, 메모, 회의 내용 부분 처리하기.
앞서 배열에 넣을 때, 구분을 위해 각 객체마다 `type` 속성을 넣어 두었기 때문에, 이 속성의 값에 따라 처리하면 됩니다.
아래 코드 처럼 반복문 내부에 조건문을 넣어 처리 할 수 있습니다.

```js
// 안건 부분 처리
 mdData += "\n\n## 안건\n";
 for(var i=0; i<data.length; i++){
   if(data[i].type=="subject"){ //type 속성 값이 subject 이면 문서에서 안건 부분 쪽에 넣기
     mdData += "- "+data[i].text + "[" + data[i].time + "]" + "\n";
   }
 }
```

## 파일로 저장
`fs` 모듈을 이용하여 마크다운 문법으로 정리한 것을 저장할 수 있습니다.
파일 쓰기를 해야 하므로, `writeFile()`를 이용합니다. 파일 저장 처리에 대한 콜백을 받고 싶지 않다면, `writeFileSync()` 를 이용하는 방법도 있습니다.

```js
var fs = require('fs');
...
//writeFile(파일이름, 쓰기 작업할 데이터, 인코딩, 콜백);
fs.writeFile(teamname+"@"+jsonData[0].time+'.md', mdData, 'utf8',
 function(){
    //파일 쓰기 작업 완료 후 실행할 작업을 여기에 기술합니다.
  });
}
```

이제 마크다운 문법으로 회의 내용을 정리하여 파일로 저장까지 했습니다. 그럼 이제 클라우드에 업로드를 해야 겠죠?
다음 포스팅 에서는 Node.js 에서 구글 드라이브에 파일을 업로드 하는 방법에 대해 포스팅 하겠습니다.

## 참고문헌
- [File System Node.js v6.2.1 Manual & Documentation](https://nodejs.org/api/fs.html#fs_fs_writefile_file_data_options_callback)
- [fs 모듈(File System) - node.js - opentutorials.org](https://opentutorials.org/module/938/7373)
- [Moment.js](http://momentjs.com/)
- [slackhq/node-slack-sdk: Slack client library for node.js](https://github.com/slackhq/node-slack-sdk)
