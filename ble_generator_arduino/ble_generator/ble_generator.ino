#include <SoftwareSerial.h>
SoftwareSerial HM10(2,3); // RX, TX

// Check Sec
#define SLEEP_TIME 1000 // (5, 10, 15) ms
#define MAX_COUNT 1
// Check MAC
String CHECK_UUID = "39ED98FF2900441A802F9C398FC199D2";

// Parse Buffer
byte buff[255] = {0};
byte buff_idx = 0;

// counting
int success = 0, fail = 0;
int count = MAX_COUNT;
bool check = false;
bool start = false;
bool sleepMode = false;
bool wakeUp = true;
unsigned long cur = 0;
unsigned long pre = 0; //이전시간
const long delayTime = 300; //잠들었다가 깨는 0.3초 대기시간
String dummyName = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";

void setup() {
  //기본 통신속도는 9600입니다.
  Serial.begin(9600);
  HM10.begin(9600);
//  Serial.println("Arduino UNO Start!");
}

void loop() {
  //HM10.println(dummyName);
  // Buffer check
  if (!wakeUp) {
    HM10.println(dummyName);
  }
  if (HM10.available()) {
    wakeUp = true;
    byte data = HM10.read();
    buff[buff_idx++] = data;
    if (data == '\n') {
      buff[buff_idx] = '\0';
      parse_buffer();
    }
    Serial.write(data);
  }

  if (!sleepMode && wakeUp) {
    if (count > 0 && !start) {
      count--;
      delay(100);
      HM10.println("AT+DISI?");
      start = true;
    } else if (count == 0 && !start) {
      count = MAX_COUNT;
      Serial.print("\nSUCCESS : ");
      Serial.println(success);
      Serial.print("Fail : ");
      Serial.println(fail);
      HM10.println("AT+SLEEP");
      pre = millis();
      sleepMode = true;
    }
    if (Serial.available()) {
      byte data = Serial.read();
      HM10.write(data);
    }
  }
  else {
    checkTime();
  }
}

void parse_buffer(){
  String line = buff;
  //Serial.println();
  if (line.substring(0, 8).equals("OK+DISC:")) {
    String mac = line.substring(17, 49);
    //Serial.println(mac);
    if (mac.equals(CHECK_UUID)) {
      check = true;
    }
  }
  if (line.substring(0, 8).equals("OK+DISCE")) {
    check ? success++ : fail++;
    check = false;
    start = false;
  }
  buff_idx = 0;
}

void checkTime() {
  cur = millis();
  if(cur - pre >= delayTime) {
    //Serial.println("SEND WAKEUP");
    wakeUp = false;
    count = MAX_COUNT;
    sleepMode = false;
  } 
}
