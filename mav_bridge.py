import serial
import time
import math
import socket
from pymavlink.dialects.v20 import ardupilotmega as mavlink

STM32_PORT = "COM5"
ARDUINO_PORT = "COM6"
BAUD = 115200

ser_stm32 = serial.Serial(STM32_PORT, BAUD, timeout=0.1)
ser_arduino = serial.Serial(ARDUINO_PORT, BAUD, timeout=0.05)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

mav = mavlink.MAVLink(None)
mav.srcSystem = 1
mav.srcComponent = 1

print("Bridge running...")

last_heartbeat = 0
throttle_val = 1000

while True:
    now = time.time()
    if now - last_heartbeat >= 1.0:
        hb = mav.heartbeat_encode(
            mavlink.MAV_TYPE_FIXED_WING,
            mavlink.MAV_AUTOPILOT_GENERIC,
            mavlink.MAV_MODE_FLAG_AUTO_ENABLED,
            0,
            mavlink.MAV_STATE_ACTIVE
        )
        sock.sendto(hb.pack(mav), ('127.0.0.1', 14550))
        last_heartbeat = now

    try:
        arduino_line = ser_arduino.readline().decode(errors='ignore').strip()
        if "Throttle:" in arduino_line:
            throttle_val = int(arduino_line.split(':')[1])
    except:
        pass

    try:
        line = ser_stm32.readline().decode(errors='ignore').strip()
        if "ROLL=" not in line:
            continue

        parts = line.split()
        roll  = math.radians(float(parts[0].split('=')[1]))
        pitch = math.radians(float(parts[1].split('=')[1]))
        yaw   = math.radians(float(parts[2].split('=')[1]))

        t = int(time.time_ns() // 1000) & 0xFFFFFFFF
        att = mav.attitude_encode(t, roll, pitch, yaw, 0, 0, 0)
        sock.sendto(att.pack(mav), ('127.0.0.1', 14550))

        print(f"ATTITUDE roll={round(math.degrees(roll),1)} pitch={round(math.degrees(pitch),1)} yaw={round(math.degrees(yaw),1)} | THROTTLE={throttle_val}us")

    except Exception as e:
        print("Error:", e)