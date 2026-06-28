# Engineering Log: Volantex KY-EA314R4 Integration

## 1. Purpose
This document presents an independent engineering analysis of the Volantex KY-EA314R4 (400R) integrated flight controller. The goal is to identify system architecture, functional blocks, and integration pathways for external embedded systems (STM32).

## 2. Legal and Ethical Notice
Analysis is based on lawfully purchased hardware using non-invasive techniques (visual inspection, signal reasoning, datasheet comparison). This document contains no proprietary firmware, leaked schematics, or confidential data. All observations are based on physical inspection and behavioral inference.

## 3. Identification
* **Marking**: KY-EA314R4 (400R)
* **Family**: Same product line as KY-EA421R (600R) / PR2224.
* **Taxonomy**: 'R' denotes integrated flight control; '400R' indicates the 400mm airframe class.



## 4. System-Level Architecture
The KY-EA314R4 is a "flight brick" integrated control system:
* **Power**: 1S LiPo input -> LDO Regulation (3.3V/5V).
* **Control**: 32-bit MCU (ARM Cortex-M class) handling stabilization and PWM.
* **Sensors**: MEMS 6-axis IMU.
* **RF**: 2.4 GHz integrated receiver.
* **Actuation**: Brushed ESC (MOSFET H-bridge) and servo drivers.

## 5. STM32 Integration Strategy
1. **Signal Observation**: Passive capture of PWM outputs using Timer Input Capture.
2. **Interface Mapping**: Identifying PWM, I2C, or UART pathways.
3. **Signal Emulation**: Simulating receiver inputs to validate ESC/Servo response.
4. **Replacement Architecture**: Future transition to an open flight control stack using discrete hardware.

## 6. Key Engineering Insight
The KY-EA314R4 is best understood as a tightly integrated embedded control system optimized for manufacturing, rather than a single component. Understanding it as a "system-on-PCB" is critical for successful instrumentation and eventual hardware migration.
