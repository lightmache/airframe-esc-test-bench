import serial
import time
import math
import socket
from pymavlink import mavutil
from pymavlink.dialects.v20 import ardupilotmega as mavlink

SERIAL_PORT = "COM5"
BAUD = 115200

ser = serial.Serial(SERIAL_PORT, BAUD, timeout=1)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

mav = mavlink.MAVLink(None)
mav.srcSystem = 1
mav.srcComponent = 1

print("Bridge running...")

last_heartbeat = 0

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

    line = ser.readline().decode(errors='ignore').strip()
    if "ROLL=" not in line:
        continue

    try:
        parts = line.split()
        roll  = math.radians(float(parts[0].split('=')[1]))
        pitch = math.radians(float(parts[1].split('=')[1]))
        yaw   = math.radians(float(parts[2].split('=')[1]))

        t = int(time.time_ns() // 1000) & 0xFFFFFFFF

        att = mav.attitude_encode(t, roll, pitch, yaw, 0, 0, 0)
        sock.sendto(att.pack(mav), ('127.0.0.1', 14550))
        print("Sent:", round(math.degrees(roll),1), round(math.degrees(pitch),1), round(math.degrees(yaw),1))

    except Exception as e:
        print("Error:", e, "Line:", line)