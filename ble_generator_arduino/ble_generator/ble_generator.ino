#include <SoftwareSerial.h> 
#include <string.h>
#define TX 2
#define RX 3

//UUID ECBB5C5A458340228C89C4ADFC3071BE
SoftwareSerial BTSerial(TX, RX);
boolean checker = false;
unsigned long time=0,pre_time=0,buf=0;
byte bt_in;
char bf;
int T_count=0;
byte data;
char buff[200];
unsigned char buff_idx = 0;
unsigned char isParse = 0;
char uuid= "ECBB5C5A458340228C89C4ADFC3071BE";

void setup() {
   Serial.begin(9600);
   //pinMode(RX, INPUT);    //UART pin for Bluetooth
   //pinMode(TX, OUTPUT);
   BTSerial.begin(9600);
   //BTSerial.println("AT+ROLE1");
   //BTSerial.println("AT+IMME1");//IMME[] 모듈 동작 타입 설정
}

void loop(){
  if (BTSerial.available()) {
    Serial.write(BTSerial.read());
  }
  if (Serial.available()) {
    BTSerial.write(Serial.read());
  }
 /*
  if (BTSerial.available()) {
    char c = BTSerial.read();
    Serial.print(c);
    /*buff[buff_idx++] = c;
    
    if (c == '\n') {
      buff[buff_idx++] = '\0';
      buffParse();
    }*/
  
}


void buffParse() {
  char *ptr;
  unsigned char idx;
  ptr = strtok(buff, "+");
  ptr += strlen(ptr) + 1;
  if (!strncmp(ptr, "DISCE", 5)) {
  }
  else if (!strncmp(ptr, "DISC", 4)) {
    ptr = strtok(ptr, ":");
    while (ptr != NULL) {
      if (strlen(ptr) == 32) {
      // Serial.println(ptr);
       int com = strcmp(ptr,uuid);
       if(com == 0){ 
          checker = true;
          }
        else{
        
          checker = false;
           }
      }
      ptr = strtok(NULL, ":");
      
    }
  }
  buff_idx = 0;
}
