---
layout: post
image: /blogimgs/slackbot0_0.png
date: 2016-05-24
title: "Node.js로 Slack 회의록봇 만들기. - 메시지 받아 처리하기"
tags: nodejs slack bot
---
저번 주 즈음에(?) 활동하던 소모임에서 운영진이 되었고, Slack을 통해서 소모임 운영 얘기를 하게 되었습니다.  
그러다 보니 Slack 에서 회의를 하게 되는 경우도 생겼는데, 이 경우에 회의 내용을 기록하는 봇이 하나 필요하지 않을까 싶어서 이번에 회의 기록 봇을 하나 만들었습니다.  
완성해서 지금 사용하고 있고, 개발 과정을 이 포스팅으로 정리해 보고자 합니다.

## 봇 사용자 생성 & 토큰 받기
봇 사용자가 없는 경우 [여기](https://my.slack.com/services/new/bot) 에서 봇 사용자를 새로 생성합니다.
봇을 새로 만드시는 경우 아래와 같은 화면을 보실 수 있습니다. 봇 사용자의 `@username`에 원하는 봇 사용자의 사용자 이름을 넣고,
 `Add bot integration` 를 클릭하여 봇 사용자를 생성합니다.

<img src="/blogimgs/slackbot0_1.png">

봇 사용자가 생성되면, 아래와 같은 화면이 나타나고, API 토큰을 확인하실 수 있습니다. 이제 이 토큰으로 봇을 만듭니다.

<img src="/blogimgs/slackbot0_2.png">

> 주의 : API 토큰이 온라인 상에 노출되지 않도록 주의하세요. 노출되는 경우 Slack 대화내용이 노출될 수 있습니다.

## 채널에서 메시지 받기.
봇이 받는 메시지에 따라서 채널에 메시지를 보내거나 작업을 수행해야 하니, Slack 채널에서 메시지를 받아야 합니다.   
그러려면,`package.json`이 있는 작업 폴더에서 `@slack/client` 패키지를 설치해야 합니다.  

```bash
# package.json 이 없는 경우, 다음 명령으로 새로 만듭니다.
npm init

# @slack/client 패키지를 작업 폴더에 설치합니다.
npm install --save @slack/client
```

파일을 하나 만들고 본격적으로 코딩을 합니다. 저는 `index.js` 로 했습니다.
먼저 RTM(Real Time Messsaging)클라이언트를 생성해야 합니다. 아래와 같은 코드를 통해 생성 할 수 있습니다.
앞서 봇 사용자 생성을 통해 얻은 토큰이 여기에서 필요합니다.

```js
//RTM 클라이언트 모듈
var RtmClient = require('@slack/client').RtmClient;

...

//봇 사용자 토큰
var token = '<봇-사용자-API-토큰>';

//새로 RTM 클라이언트 생성(logLevel 은 debug 로)
var rtm = new RtmClient(token, {logLevel: 'debug'});

//생성한 RTM 클라이언트 시작.
rtm.start();
```

봇과 Slack 연결 확인하려면, 아래 코드와 같이 `RTM.AUTHENTICATED` 이벤트를 통해 연결 여부를 알 수 있습니다.

```js
...
//클라이언트 이벤트 모듈
var CLIENT_EVENTS = require('@slack/client').CLIENT_EVENTS;
...
//RTM.AUTHENTICATED 이벤트 받기
rtm.on(CLIENT_EVENTS.RTM.AUTHENTICATED, function (rtmStartData) {
  console.log(`Logged in as ${rtmStartData.self.name} of team ${rtmStartData.team.name}, but not yet connected to a channel`);
});
```

이제 Slack 에 올라오는 메시지를 받아 봅시다. `RTM_EVENTS` 모듈을 불러오고, `MESSAGE` 이벤트를 통해 메시지를 받을 수 있습니다.

```js
//RTM_EVENTS 모듈
var RTM_EVENTS = require('@slack/client').RTM_EVENTS;

//Slack 팀으로부터의 모든 메시지 받기
rtm.on(RTM_EVENTS.MESSAGE, function (message) {
  //메시지 받았을 때 수행할 작업을 여기에 작성합니다.
});

//팀에서 채널이 새로 생성 되었다는 메시지 받기.
rtm.on(RTM_EVENTS.CHANNEL_CREATED, function (message) {
  //해당 메시지를 받았을떄 수행할 작업을 여기에 작성.
});
```

## 메시지 처리하기 & 채널에 응답 올리기
이제 받은 메시지를 처리하고, 메시지에 대한 응답을 채널에 보냅니다. 앞서 작성한 메시지를 받는 코드를 보면, 콜백을 통해 `message` 를 받는것을 볼 수 있습니다.

```js
//Slack 팀으로부터의 모든 메시지 받기
rtm.on(RTM_EVENTS.MESSAGE, function (message) {
  //메시지 받았을 때 수행할 작업을 여기에 작성합니다.
});
```

이 `message` 에는, 메시지 내용, 메시지를 보낸 채널, 메시지를 보낸 사람 정보 등이 담겨 있습니다. 이를 이용하여 회의시작, 종료 등을 차리할 수 있습니다.

```js
// 메시지 내용 얻기
message.text;

// 메시지를 보낸 채널 고유번호 얻기
message.channel;

// 메시지 보낸 사람 고유번호 얻기
message.user;
```

저는 아래과 같은 방식으로 코드를 작성하여, 회의 시작과 종료를 처리 했습니다.

```js
var isRecording = false; //회의 내용 기록 여부(회의 진행중 여부)
var channel = undefined; //채널 고유값 저장할 변수
var user = undefined;
...
rtm.on(RTM_EVENTS.MESSAGE, function (message) {
  var text = message.text;
  if(text.includes("회의")&&text.includes("시작")){
    //메시지 내용에 "회의" 와 "시작" 이 포함되어 있고
    if(isRecording==false){
      //회의중이 아니면(isRecording 이 false 이면)
      //회의 시작 처리
      channel = message.channel;
      user = message.user;
      isRecording = true;
    }else{
      //회의중이 아니면(isRecording 이 true 이면)
      //이미 회의중 처리
    }
  }else if(text.includes("회의")&&text.includes("종료")&&isRecording==true){
    //메시지 내용에 "회의" 와 "종료" 이 포함 isRecording이 true 이고
    if(channel == message.channel&&user == message.user){
      //회의를 시작한 채널과 사용자의 고유번호값이 channel, user에 저장된 것과 같으면
      //회의 종료 처리
      isRecording = false;
      channel = undefined;
      user = undefined;
    }else {
      //그렇치 않다면
      //아무것도 하지 않음(회의 내용 계속 기록)
    }
  }
});
```

각 상황에 따라 채널에 메시지도 보내봅시다. 앞에서 생성한 `rtm`객체가 가진 `rtm.sendMessage();` 를 이용하여 보낼 수 있습니다.

```js
//다음과 같은 코드를 이용하여 보낼 수 있습니다.
rtm.sendMessage('<보낼 메시지 내용>', '<메시지를 보낼 채널 또는 DM(Direct Message)의 고유번호 값>');

//메시지 보낸 후, 콜백을 받아 작업을 수행 하려면, 아래과 같이 작성합니다.
rtm.sendMessage('<보낼 메시지 내용>', '<메시지를 보낼 채널 또는 DM(Direct Message)의 고유번호 값>', function messageSent() {
   //메시지 보낸 후 수행할 작업 내용
 });
```

이제 이를 앞에서 작성한 조건문으로 메시지 처리하는 코드에 끼워넣어, 아래와 같이 작성할 수 있습니다.

```js
...
var isRecording = false; //회의 내용 기록 여부(회의 진행중 여부)
var channel = undefined; //채널 고유값 저장할 변수
var user = undefined;
...
rtm.on(RTM_EVENTS.MESSAGE, function (message) {
  var text = message.text;
  if(text.includes("회의")&&text.includes("시작")){
    //메시지 내용에 "회의" 와 "시작" 이 포함되어 있고
    if(isRecording==false){
      channel = message.channel;
      user = message.user;
      isRecording = true;
      rtm.sendMessage("회의가 시작되었습니다.", message.channel);
    }else{
      rtm.sendMessage("이미 진행중인 회의가 있습니다.", message.channel);
    }
  }else if(text.includes("회의")&&text.includes("종료")&&isRecording==true){
    //메시지 내용에 "회의" 와 "종료" 이 포함 isRecording이 true 이고
    if(channel == message.channel&&user == message.user){
      isRecording = false;
      channel = undefined;
      user = undefined;
      rtm.sendMessage("회의가 종료되었습니다.", message.channel);
    }else {
      rtm.sendMessage("회의를 시작한 사람이 회의를 시작한 채널에서 회의를 종료해야 합니다.", message.channel);
    }
  }
});
```

여기까지 일단은 메시지 받은것을 처리해서, 회의 기록을 시작/종료 하는 것에 대한 포스팅 이였고.
다음 포스팅에서는 회의 내용 기록하는 것과 회의 종료시 파일로 처리하는 것을 다루도록 하겠습니다.

## 참고문헌
- [slackhq/node-slack-sdk: Slack client library for node.js](https://github.com/slackhq/node-slack-sdk)
- [Bot Users](https://api.slack.com/bot-users)
