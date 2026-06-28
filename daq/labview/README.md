# LabVIEW Instrumentation Suite

This directory contains the LabVIEW-based Data Acquisition (DAQ) and instrumentation logic for the airframe-esc-test-bench project.

## Overview
The suite bridges embedded hardware (STM32/Arduino) with a host PC for real-time visualization and logging of propulsion system behavior.

## Key Features
* **Serial Resource Management**: Automated VISA resource handling.
* **Synchronous Data Pipeline**: Producer-consumer architecture for parsing ASCII serial streams.
* **Real-Time Visualization**: Waveform monitoring for throttle and sensor feedback.

## Architecture
1. **Physical Layer**: UART serial communication.
2. **Translation Layer**: VISA Read -> Fract/Exp String to Number conversion.
3. **Visualization Layer**: Real-time logging to .lvm/.csv format.

## Troubleshooting & Lessons Learned
* **Data Integrity**: Sending raw numeric strings (e.g., Serial.println(averageValue)) is required for LabVIEW's conversion blocks to function without manual string manipulation.
* **Resource Management**: VISA ports can be locked by external monitors (e.g., Arduino IDE). Always close external monitors and unplug/replug hardware if resource errors occur.
* **Driver Conflicts**: Persistent driver issues were resolved by migrating to stable COM ports (e.g., COM5).
* **Systematic Debugging**: Utilize Ctrl+B to clear broken wires and ensure wire data types (String vs. DBL) match before execution.

## Next Steps
* **Multi-Pin Implementation**: Finalize firmware to support reading from 5 digital pins on both Arduino and STM32.
* **Validation**: Verify data flow through to the Waveform Chart and confirm logging functionality.
* **STM32 Integration**: Complete the installation of STM32CubeProgrammer and add to system PATH to enable firmware uploads.
* **Advanced Pipeline**: Progress toward multi-threaded acquisition to synchronize IMU, throttle, and vibration proxy data.
