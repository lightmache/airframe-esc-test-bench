# STM32F3 → MAVLink → QGroundControl Workflow

## Overview

This project builds a minimal flight telemetry pipeline:

STM32F3 IMU → Serial → Python MAVLink bridge → QGroundControl

---

## Hardware

- STM32F3 Discovery board
- LSM303DLHC (accelerometer + magnetometer)
- L3GD20 (gyroscope - future upgrade)

---

## Firmware Output Format

The STM32 outputs:

ROLL=0.xx PITCH=0.xx YAW=0.xx

This is the required format for the MAVLink bridge.

---

## Python Environment Setup

Create virtual environment:

python3 -m venv venv
source venv/bin/activate

Install dependencies:

pip install pymavlink pyserial

---

## MAVLink Bridge

The Python script:

1. Reads STM32 serial output
2. Parses roll/pitch/yaw
3. Converts degrees → radians
4. Sends MAVLink ATTITUDE messages
5. Outputs to UDP 127.0.0.1:14550

---

## QGroundControl

No configuration required.

It automatically connects to:

udp:127.0.0.1:14550

Expected behavior:
- Vehicle appears
- Artificial horizon moves
- Attitude updates in real time

---

## Execution Order

1. Flash STM32 firmware
2. Start serial streaming
3. Activate Python venv
4. Run MAVLink bridge
5. Open QGroundControl

---

## System Architecture

STM32F3 (AHRS)
    ↓
Serial USB stream
    ↓
Python MAVLink translator
    ↓
QGroundControl

---

## Limitations (current state)

- No gyro fusion yet
- No EKF / Madgwick filter
- No flight control outputs

---

## Next Steps

- Add gyro integration (L3GD20)
- Implement AHRS filter
- Move MAVLink directly onto STM32 (optional)
