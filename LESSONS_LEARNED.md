# Lessons Learned — STM32 MAVLink Pipeline

## 1. Python Installation on Windows
**Problem:** Windows had a Microsoft Store alias hijacking the python command even though Python 3.12 was installed.
**Fix:** Delete the stub files:
Remove-Item C:\Users\micah\AppData\Local\Microsoft\WindowsApps\python.exe -Force
Remove-Item C:\Users\micah\AppData\Local\Microsoft\WindowsApps\python3.exe -Force
**Lesson:** Always verify where.exe python points to the real install, not the Store alias.

## 2. WSL Cannot Access Windows COM Ports
**Problem:** STM32 appears as COM5 in Windows but is not accessible from WSL without usbipd bridging.
**Fix:** Run the Python MAVLink bridge in Windows PowerShell, not WSL.
**Lesson:** Keep the hardware layer and the bridge script on the same OS.

## 3. pymavlink udpout Does Not Bind a Socket
**Problem:** mavutil.mavlink_connection udpout fires packets out but never binds a socket, so QGC AutoConnect never received them.
**Fix:** Use a raw Python UDP socket via socket.sendto() directly to port 14550.
**Lesson:** pymavlink udpout is one-way blind fire. For QGC AutoConnect use raw sockets.

## 4. MAVLink Timestamp Overflow
**Problem:** int(time.time() * 1000) produces a value larger than uint32 max causing MAVLink format errors on every packet.
**Fix:** t = int(time.time_ns() // 1000) & 0xFFFFFFFF
**Lesson:** MAVLink time_boot_ms is uint32. Always mask epoch-derived timestamps.

## 5. QGC Requires HEARTBEAT to Detect Vehicle
**Problem:** Sending only ATTITUDE messages produced no vehicle in QGC.
**Fix:** Send a HEARTBEAT at 1Hz with MAV_TYPE_FIXED_WING and MAV_STATE_ACTIVE.
**Lesson:** QGC will not display or connect to a vehicle without a valid HEARTBEAT stream.

## 6. QGC Not Ready Without GPS
**Problem:** QGC shows Not Ready and map view only with no artificial horizon because no GPS fix is present.
**Status:** Expected behavior for a bench testbed with no GPS.
**Workaround:** Use MAVLink Inspector to verify live ATTITUDE data.

## 7. Verified Pipeline
STM32F3 Discovery
LSM303DLHC accel and mag via I2C
Roll Pitch Yaw computed on-chip
Serial 115200 baud COM5
Python mav_bridge.py in Windows PowerShell
Raw UDP socket 127.0.0.1:14550
QGroundControl v5.0.8
ATTITUDE at 93.6Hz confirmed in MAVLink Inspector
