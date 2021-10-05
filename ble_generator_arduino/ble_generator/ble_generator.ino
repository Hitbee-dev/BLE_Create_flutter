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
bool uuid_check = false;
extern volatile unsigned long timer0_millis;
unsigned long cur_uuid = 0;
unsigned long pre_uuid = 0;
unsigned long result_uuid = 0;
unsigned long cur_sleep = 0;
unsigned long pre_sleep = 0; //이전시간
const long delayTime = 5000; //잠들었다가 깨는 0.3초 대기시간
String dummyName = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";

void setup() {
  //기본 통신속도는 9600입니다.
  Serial.begin(9600);
  HM10.begin(9600);
//  Serial.println("Arduino UNO Start!");
}

void loop() {
  if (wakeUp && sleepMode) {
    bufferFlush();
  }
  // Buffer check
  if (!wakeUp) {
    HM10.println(dummyName);
    timer0_millis = 0;
    result_uuid = 0;
    Serial.println("Wakeup");
    HM10.read();
  }
  if (!sleepMode && HM10.available()) {
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
      delay(50);
      HM10.println("AT+DISI?");
      if(uuid_check == false) {
        cur_uuid = millis(); 
      }
      start = true;
    } else if (count == 0 && !start) {
      count = MAX_COUNT;
      Serial.print("SUCCESS : ");
      Serial.println(success);
      Serial.print("Fail : ");
      Serial.println(fail);
      HM10.println("AT+SLEEP");
      pre_sleep = millis();
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
  if (line.substring(0, 8).equals("OK+DISC:")) {
    String mac = line.substring(17, 49);
    if (mac.equals(CHECK_UUID)) {
      check = true;
      pre_uuid = millis();
      result_uuid = pre_uuid - cur_uuid;
      Serial.print("\nUUID Search Time : ");
      Serial.println(result_uuid);
      Serial.print("\nUUID Search Current Time : ");
      Serial.println(cur_uuid);
      Serial.print("\nUUID Search Prevent Time : ");
      Serial.println(pre_uuid);
      pre_uuid = cur_uuid;
      uuid_check = true;
      success++;
      HM10.println("AT+SLEEP");
      pre_sleep = millis();
      sleepMode = true;
      check = false;
      start = false;
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
  cur_sleep = millis();
  if(cur_sleep - pre_sleep >= delayTime) {
    wakeUp = false;
    count = MAX_COUNT;
    sleepMode = false;
  } 
}

void bufferFlush() {
  HM10.read();
}
