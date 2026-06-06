#include <Wire.h>
#include <math.h>

#define ACCEL_ADDR 0x19
#define MAG_ADDR   0x1E
#define LD9 PE12

// ---------------- ACCEL ----------------
void writeAccel(uint8_t reg, uint8_t value) {
  Wire.beginTransmission(ACCEL_ADDR);
  Wire.write(reg);
  Wire.write(value);
  Wire.endTransmission();
}

int16_t readAccel(uint8_t regL) {
  Wire.beginTransmission(ACCEL_ADDR);
  Wire.write(regL | 0x80);
  Wire.endTransmission(false);

  Wire.requestFrom(ACCEL_ADDR, (uint8_t)2);

  uint8_t lo = Wire.read();
  uint8_t hi = Wire.read();

  return (int16_t)((hi << 8) | lo);
}

// ---------------- MAG ----------------
void writeMag(uint8_t reg, uint8_t value) {
  Wire.beginTransmission(MAG_ADDR);
  Wire.write(reg);
  Wire.write(value);
  Wire.endTransmission();
}

int16_t readMag16(uint8_t reg) {
  Wire.beginTransmission(MAG_ADDR);
  Wire.write(reg);
  Wire.endTransmission(false);

  Wire.requestFrom(MAG_ADDR, (uint8_t)2);

  uint8_t hi = Wire.read();
  uint8_t lo = Wire.read();

  return (int16_t)((hi << 8) | lo);
}

// ---------------- SETUP ----------------
void setup() {
  pinMode(LD9, OUTPUT);

  Serial.begin(115200);
  delay(1000);

  Serial.println("\n===== STM32F3 AHRS BOOT =====");

  Wire.begin();

  // ---- device check ----
  Wire.beginTransmission(ACCEL_ADDR);
  bool accel_ok = (Wire.endTransmission() == 0);

  Wire.beginTransmission(MAG_ADDR);
  bool mag_ok = (Wire.endTransmission() == 0);

  Serial.print("[CHECK] Accel: ");
  Serial.println(accel_ok ? "OK" : "FAIL");

  Serial.print("[CHECK] Mag:   ");
  Serial.println(mag_ok ? "OK" : "FAIL");

  if (!accel_ok || !mag_ok) {
    Serial.println("Sensor failure - halting");
    while (1);
  }

  // ---- init sensors ----
  writeAccel(0x20, 0x47); // accel enable
  writeMag(0x00, 0x14);   // mag 30Hz
  writeMag(0x01, 0x20);
  writeMag(0x02, 0x00);

  Serial.println("[OK] Sensors initialized");
  Serial.println("Streaming AHRS data...\n");
}

// ---------------- LOOP ----------------
void loop() {

  static uint32_t last = 0;
  static uint32_t hb = 0;

  if (millis() - last < 20) return; // ~50Hz
  last = millis();

  // ---- accel ----
  int16_t ax = readAccel(0x28);
  int16_t ay = readAccel(0x2A);
  int16_t az = readAccel(0x2C);

  // ---- mag ----
  int16_t mx = readMag16(0x03);
  int16_t mz = readMag16(0x05);
  int16_t my = readMag16(0x07);

  // ---- roll ----
  float roll = atan2((float)ay, (float)az) * 180.0 / PI;

  // ---- pitch ----
  float pitch = atan2(-(float)ax,
                sqrt((float)ay*ay + (float)az*az))
                * 180.0 / PI;

  // ---- yaw ----
  float yaw = atan2((float)my, (float)mx) * 180.0 / PI;
  if (yaw < 0) yaw += 360.0;

  // ---- heartbeat LED ----
  digitalWrite(LD9, !digitalRead(LD9));

  // ---- output ----
  Serial.print("ROLL=");
  Serial.print(roll, 2);

  Serial.print(" PITCH=");
  Serial.print(pitch, 2);

  Serial.print(" YAW=");
  Serial.println(yaw, 2);

  // optional heartbeat line every ~2 sec
  if (millis() - hb > 2000) {
    Serial.println("[HB] STM32F3 AHRS alive");
    hb = millis();
  }
}
