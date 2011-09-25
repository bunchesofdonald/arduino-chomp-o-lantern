#include <Candle.h>
#include <Servo.h>

const int candlePin = 11;
const int greenLed  = 2;
const int ldrPin    = 5;
const int servoPin  = 7;

const int numChomps    = 5;
const int tripInterval = 500;

Candle candle;
Servo myservo;

unsigned long int nextReading = 0;

int threshold;

void setup() {
 pinMode(greenLed,OUTPUT);
 candle.setup(candlePin);
 randomSeed(analogRead(0));
 threshold = getAvgReading(ldrPin,100) - 20;
 myservo.attach(servoPin);
 myservo.write(0);
 Serial.begin(9600);
}

void loop() {
  candle.flicker();

  unsigned long int time = millis();
  if (time >= nextReading) {
    int ldrValue = getAvgReading(ldrPin,100);
    if(ldrValue < threshold) {
      digitalWrite(greenLed,HIGH);
      digitalWrite(candlePin,LOW);
      
      bite(numChomps);
      
      digitalWrite(greenLed,LOW);
    }
    
    threshold = ldrValue - 20;
    nextReading = time + tripInterval;
  }
}

int getAvgReading(int pin, int toTake) {
  unsigned long int reading = 0;
  
 for(int i = 0; i < toTake; i++) {
  reading += analogRead(pin);
 }
 
 int avgreading = reading / toTake;
 Serial.println(avgreading);
 return avgreading;
}

void bite (int chomps) {
  int pos = 0;
  int biteDelay = 500;
  int maxPos = 180;
  int minPos = 100;
  
  for(int i = 0; i < chomps; i++) {
     for(pos = minPos; pos < maxPos; pos += 60)
    {
      myservo.write(pos);
      delay(biteDelay);
    }
  
    for(pos = maxPos; pos > minPos; pos -= 60)
    {
      myservo.write(pos);
      delay(biteDelay);
    }
  }
  
  myservo.write(0);
  delay(500);
}
