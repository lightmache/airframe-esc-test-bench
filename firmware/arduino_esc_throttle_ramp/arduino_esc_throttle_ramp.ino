#include <Servo.h>
Servo esc;
int throttle = 1000;

void setup() {
  Serial.begin(115200);
  esc.attach(9);
  esc.writeMicroseconds(1000);
  delay(3000);
  Serial.println("ESC armed");
}

void loop() {
  for (throttle = 1000; throttle <= 1800; throttle += 5) {
    esc.writeMicroseconds(throttle);
    Serial.print("Throttle:");
    Serial.println(throttle);
    delay(50);
  }
  for (throttle = 1800; throttle >= 1000; throttle -= 5) {
    esc.writeMicroseconds(throttle);
    Serial.print("Throttle:");
    Serial.println(throttle);
    delay(50);
  }
}
