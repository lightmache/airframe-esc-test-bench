# MAVLink Telemetry Pipeline — Current Status

## System Overview

A telemetry pipeline has been implemented to stream attitude data from an STM32F3 microcontroller into a MAVLink-compatible format using a Python bridge.

The intended end-to-end architecture is:

STM32F3 → Serial USB → Python MAVLink Bridge → UDP → QGroundControl

---

## What Has Been Implemented

### 1. STM32F3 Firmware
- Outputs real-time attitude estimates in ASCII format:
  ROLL=... PITCH=... YAW=...
- Sensor fusion currently based on accelerometer + magnetometer data
- Continuous streaming over USB serial interface

---

### 2. Python MAVLink Bridge
- Reads serial data from STM32 (COM5)
- Parses roll, pitch, yaw values
- Converts values from degrees to radians (required by MAVLink)
- Constructs MAVLink ATTITUDE messages using pymavlink
- Transmits MAVLink packets via UDP to 127.0.0.1:14550

---

### 3. MAVLink Transport Layer
- UDP socket is active on localhost port 14550
- MAVLink ATTITUDE messages are being continuously transmitted
- No runtime errors observed in the bridge

---

## What Has Been Validated

✔ STM32 serial data stream is active and updating  
✔ Python successfully reads and parses IMU data  
✔ MAVLink ATTITUDE messages are being generated  
✔ UDP telemetry stream is active and transmitting  

---

## What Has NOT Been Validated

❌ QGroundControl integration has not yet been tested  
❌ No visual confirmation of attitude display  
❌ No verification of MAVLink decoding in ground station  

---

## Current Engineering Status

The system is currently at transport-layer completion, meaning:

- Data flows end-to-end from embedded hardware to network output
- MAVLink packets are correctly formed and transmitted
- However, ground station ingestion has not yet been confirmed

---

## Key Limitation

- No gyroscope integration (L3GD20 not yet implemented)
- No advanced AHRS filter (Madgwick/Mahony not yet applied)
- Attitude estimation is still based on basic accelerometer + magnetometer fusion

---

## Summary

A functional STM32 → Python → MAVLink → UDP telemetry pipeline has been implemented and is actively streaming attitude data.

However, full system validation is still pending QGroundControl integration, which will confirm end-to-end visual and protocol correctness.

---

## Next Steps

1. Launch QGroundControl
2. Verify UDP connection on 127.0.0.1:14550
3. Confirm vehicle detection
4. Validate live artificial horizon movement
5. Proceed with L3GD20 gyroscope integration
