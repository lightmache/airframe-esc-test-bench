# Hybrid Propulsion & Thermal Coupling Testbed  
### 3D-Printed T-38 Trainer Airframe (Experimental Platform)

## Overview

This project is an experimental test platform investigating electrical propulsion behavior and thermal coupling effects in a small-scale brushless motor system mounted on a 3D-printed T-38 trainer-inspired airframe.

The system is designed as a staged engineering testbed to evaluate propulsion power sources, instrumentation methods, and potential future integration of a PEM hydrogen fuel cell as an auxiliary energy subsystem.

This is a bench-level experimental system for data collection and analysis, not a flight-certified vehicle.

---

## Research Objective

The primary objective is to evaluate:

- Brushless motor + ESC behavior under controlled throttle profiles  
- Electrical and thermal characteristics of small UAV-scale propulsion systems  
- Feasibility of integrating a PEM hydrogen fuel cell as an auxiliary DC power source  
- Potential waste-heat coupling between propulsion system and fuel cell subsystem (future phase)

---

## System Architecture (Current Phase)

### Propulsion Subsystem (Active)
- Brushless DC motor
- Electronic Speed Controller (ESC)
- Arduino-based PWM throttle control (servo signal interface)
- LiPo battery power source (primary test configuration)

### Instrumentation Subsystem (Active)
- STM32F3 Discovery board
- Real-time voltage and system behavior logging
- Arduino control signal generation

### Airframe
- 3D-printed Northrop T-38 trainer-inspired structure
- Used as a mechanical mounting and integration platform for propulsion testing

---

## Fuel Cell Subsystem (Experimental / Not yet integrated into propulsion loop)

A PEM hydrogen fuel cell is included as an auxiliary energy source under evaluation.

Current status:
- Not integrated into ESC propulsion power path
- Being characterized for:
  - steady-state voltage output stability
  - load response behavior
  - compatibility with ESC-driven propulsion demands

Future work will evaluate controlled integration into the propulsion system under defined test constraints.

---

## Development Phases

### Phase 1 — Baseline Propulsion Characterization (In Progress)
- LiPo → ESC → motor validation
- PWM throttle response testing
- STM32 logging of system behavior
- Establish baseline performance curves

### Phase 2 — Fuel Cell Characterization (In Progress / Planned)
- Independent PEM fuel cell testing
- Load response and voltage stability measurement
- Electrical compatibility assessment

### Phase 3 — Coupling Investigation (Planned)
- Evaluate fuel cell contribution to propulsion power path
- Compare performance against LiPo baseline
- Analyze transient response differences between power sources

### Phase 4 — Hybrid Integration Study (Future Work)
- Controlled hybrid power experiments
- Thermal + electrical coupling analysis
- System-level efficiency and stability evaluation

---

## Safety Notes

- Bench-level testing only
- Low-throttle constrained operation during experiments
- Fuel cell is not currently part of primary propulsion power path
- ESC/motor tests are conducted within safe PWM limits
- Power systems are monitored during all test runs

---

## Key Technologies

- STM32F3 Discovery (instrumentation & logging)
- Arduino (PWM control interface)
- Brushless DC motor + ESC
- LiPo battery power system
- PEM hydrogen fuel cell (experimental subsystem)
- 3D printing (airframe development)

---

## Status

🟡 Active experimental prototype  
🟡 Subsystem validation in progress  
🟡 Hybrid integration under investigation  

---

## Notes

This project follows a staged systems engineering approach:

1. Baseline propulsion system validation  
2. Independent subsystem characterization  
3. Controlled coupling experiments  
4. Iterative integration toward hybrid propulsion architecture evaluation  
