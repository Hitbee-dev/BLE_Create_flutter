# BLE GENERATOR APP.ver(flutter)

used library :
 
getX = https://pub.dev/packages/get

uuid = https://pub.dev/packages/uuid

ble = https://pub.dev/packages/beacon_broadcast

# Example

https://user-images.githubusercontent.com/83276163/126537738-481c578a-b5ba-47af-95d5-7da5bbf2953b.MP4

# Arduino
![arduino](https://user-images.githubusercontent.com/83276163/126538137-7452a2b1-38ca-4841-a8e8-70bb55f61eaf.png)

시리얼 모니터에서 AT+DISC?, AT+DISI? 입력으로 확인 가능

# Problem

IOS = O
Android = X

IOS는 정상작동 되나, Android에서는 정상작동하지 않음

![android](https://user-images.githubusercontent.com/83276163/126538528-33c53f57-d389-4d5a-8191-260ac220621c.png)

Android에서 로그를 보면 정상적으로 BLE 신호를 전송하고 있다고 출력되나, 실제 BLE신호를 전송하지 않음

-Test Device = Galaxy S7, Galaxy Note9

BLE 라이브러리 개발자 Github에 제공된 Example파일로 실행 해 보아도 동일 현상 발생
