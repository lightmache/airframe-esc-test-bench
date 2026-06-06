import serial
import time
import math
from pymavlink import mavutil

# -------------------------
# CONFIG
# -------------------------
SERIAL_PORT = "COM5"
BAUD = 115200

# -------------------------
# CONNECT STM32 SERIAL
# -------------------------
ser = serial.Serial(SERIAL_PORT, BAUD, timeout=1)

# -------------------------
# MAVLINK CONNECTION (to QGC)
# -------------------------
master = mavutil.mavlink_connection('udpout:127.0.0.1:14550')

print("MAVLink bridge started on", SERIAL_PORT)

# -------------------------
# TIME BASE (IMPORTANT FIX)
# -------------------------
start_time = time.monotonic()

# -------------------------
# MAIN LOOP
# -------------------------
while True:
    line = ser.readline().decode(errors='ignore').strip()

    if not line:
        continue

    # Only process valid IMU lines
    if "ROLL=" not in line:
        continue

    try:
        # Example expected format:
        # ROLL=0.52 PITCH=-0.19 YAW=73.16

        parts = line.split()

        roll = float(parts[0].split('=')[1])
        pitch = float(parts[1].split('=')[1])
        yaw = float(parts[2].split('=')[1])

        # Convert degrees → radians
        roll = math.radians(roll)
        pitch = math.radians(pitch)
        yaw = math.radians(yaw)

        # MAVLink-safe timestamp (FIXED)
        t = int((time.monotonic() - start_time) * 1000) & 0xFFFFFFFF

        # Send MAVLink attitude packet
        master.mav.attitude_send(
            t,      # time_boot_ms
            roll,
            pitch,
            yaw,
            0.0,    # rollspeed
            0.0,    # pitchspeed
            0.0     # yawspeed
        )

        print(f"Sent: {roll:.3f} {pitch:.3f} {yaw:.3f}")

    except Exception as e:
        print("Parse error:", e, "Line:", line)