## UAS Systems Integration & Telemetry Extension

This project extends a brushless propulsion and instrumentation testbench into a lightweight UAS-style systems integration environment.

The goal is to bridge embedded hardware (STM32 + Arduino-based ESC control) with a Python-based telemetry and control layer, forming a unified data acquisition and ground-station-compatible interface.

---

### Implemented Capabilities

- Extended existing propulsion testbench with a Python-based telemetry and control layer  
- Integrated STM32 sensor outputs (IMU + system telemetry) with Arduino ESC PWM control signals  
- Developed structured logging pipeline in Python for synchronized capture of:
  - throttle input commands  
  - motor/ESC response behavior  
  - IMU-derived motion state data  
  - voltage/system-level telemetry (where available)

---

### MAVLink / Ground Station Integration

- Implemented Python-based MAVLink message generation layer
- Streams synthesized telemetry derived from embedded sensor inputs
- Enables visualization in **QGroundControl-compatible ground station environments**
- Provides real-time representation of:
  - system state
  - attitude estimation (sensor-derived)
  - throttle / control input response

This creates a simplified ground-control-style feedback loop between embedded hardware and operator interface tooling.

---

### Systems Architecture Outcome

The resulting system demonstrates a minimal end-to-end UAS data flow:

Embedded Layer (STM32 + Arduino)
→ Sensor + control signal capture  
→ Python telemetry aggregation layer  
→ MAVLink encoding  
→ Ground station visualization (QGroundControl)

---

### Stretch / Experimental Direction

- Multi-threaded acquisition pipeline for concurrent sensor + control signal logging  
- Time-synchronized dataset generation across IMU, throttle, and vibration proxies  
- Expansion toward hardware-in-the-loop (HITL) style test architecture  
- Exploration of deterministic timing between embedded events and telemetry output  
- Vibration proxy testing using external accelerometer sources (tablet/phone-based instrumentation as interim solution)

---

### Systems Engineering Intent

This work is structured as a UAS-oriented integration testbed, focusing on:

- real-time telemetry architecture  
- embedded-to-Python data pipelines  
- ground station compatibility patterns (MAVLink)  
- reproducible test execution for propulsion system behavior
- 
## Experimental Energy Subsystem: PEM Hydrogen Fuel Cell (Research Direction)

An auxiliary PEM hydrogen fuel cell subsystem is included in the broader experimental architecture as part of ongoing systems-level investigation into alternative power sources for small UAV-class propulsion systems.

### Current Status

- Physically present as a standalone power subsystem
- Not currently integrated into the ESC propulsion power path
- Operated independently for characterization and measurement

### Characterization Focus

- Open-circuit and loaded voltage stability under varying conditions
- Transient response behavior under step-load scenarios
- Comparison against LiPo baseline propulsion power source
- Compatibility assessment with ESC-driven motor loads

### Future Integration Study (Non-Operational / Experimental Only)

Planned research directions include:

- Controlled coupling of PEM fuel cell output into propulsion power architecture
- Evaluation of hybrid power blending (LiPo + fuel cell assist model)
- Thermal coupling analysis between propulsion system and fuel cell subsystem
- System-level efficiency comparison across power configurations

### Systems Engineering Context

This subsystem is treated as a modular experimental energy source within a staged integration framework:

1. Baseline LiPo-powered propulsion validation  
2. Independent fuel cell characterization  
3. Controlled, instrumented coupling experiments  
4. Hybrid architecture evaluation (research phase only)

The intent is to evaluate feasibility, stability, and control implications of integrating non-battery energy sources into small-scale UAV propulsion systems under instrumented test conditions.
