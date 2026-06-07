# Flight Controller Characterization Report
## Volantex Stabilization System + Embedded Signal Investigation

# 1. Objective

1. Determine whether a small Volantex flight controller contains usable external telemetry signals.
2. Observe how IMU behavior affects actuator outputs.
3. Evaluate whether brushed motor driver signals can be used as a proxy for throttle or control input.
4. Compare this approach to a clean Arduino-based PWM ESC control system for brushless propulsion testing.

# 2. Experimental Setup

Hardware used:
- Volantex RC flight controller (integrated IMU + receiver)
- Original brushed motor output wiring (later disconnected/reconnected)
- Arduino Uno (2013 model)
- Analog inputs: A4 and A5
- Volatile DC supply (1S 3.7V-4.1V range)
- Physical manipulation (tilting aircraft in hand)

# 3. Key Observations

## 3.1 IMU-driven stabilization behavior

When the flight controller was powered and placed into different modes:

- Tilting the aircraft caused automatic control surface movement
- Beginner vs Expert mode changed stabilization response
- Orientation directly influenced actuator behavior

The system contains an active IMU loop:

Accelerometer + Gyroscope -> Flight stabilization algorithm -> Servo correction outputs

Conclusion: IMU is functional and directly controlling outputs. System is closed-loop, not open-loop receiver control.

## 3.2 Motor behavior under throttle input

- Motor occasionally spins for ~1 second
- Motor does not sustain continuous rotation
- Behavior is inconsistent with stick input alone

Motor output is gated by internal logic. Arming state, valid sensor state, and throttle input must all be satisfied simultaneously.

Throttle input + IMU state + safety logic -> motor enable pulse

## 3.3 Analog signal probing (Arduino A4/A5)

Initial steady readings: ~656,457 stable region with minimal variation.

During interaction/movement pairs observed:
- 466,662
- 480,649
- 358,739
- 394,711

Key pattern: one channel rises while the other falls. Occasional large divergence events. Otherwise stable mid-range bias.

## 3.4 Critical interpretation of analog data

These pins are not control inputs, not IMU outputs, and not throttle channels. They represent motor driver / H-bridge switching behavior plus biased internal analog nodes and filtered power-stage activity.

Key evidence: inverse correlation between channels, non-linear jumps, lack of consistent mapping to stick input.

## 3.5 Effect of IMU movement on analog readings

When physically tilting the aircraft: servos clearly responded, analog readings changed slightly but inconsistently, no deterministic mapping to orientation. IMU affects actuators directly, not exposed analog pins.

# 4. System Architecture Identified

[ Receiver Input ]
-> [ MCU Control Logic ]
-> [ IMU Stabilization Loop ]
-> [ Output Mixer ]
-> [ Servo Outputs ] (visible response)
-> [ Motor Driver Stage ] (gated / intermittent response)

Key insight: The system is state-machine driven, not signal-linear.

# 5. Why Analog Brushed Motor Tapping Failed

Motor output is not analog - digital switching produces averaged voltage that ADC sees as distorted values. Motor output only activates when system is armed, IMU state is valid, and throttle conditions are met. Motor driver introduces differential voltage swings, inverse channel coupling, and transient spikes unrelated to control intent.

Result: Analog readings reflect electrical consequences, not control commands.

# 6. Why Arduino PWM for Brushless is the Correct Approach

Arduino PWM (1000-2000 us) -> ESC interprets signal -> Brushless motor output

Advantages:
- Deterministic signal with known mapping between command and output
- PWM pulse width is explicit and loggable
- ESC is designed for signal-level input with no power-stage distortion

| Brushed motor taps    | Arduino PWM + ESC    |
| --------------------- | -------------------- |
| noisy electrical node | clean control signal |
| state-dependent       | deterministic        |
| non-linear            | linear mapping       |
| hidden driver logic   | explicit control     |
| hard to interpret     | easy to log          |

# 7. Final Conclusions

- IMU exists and actively stabilizes aircraft
- Actuator outputs respond to orientation
- Motor output is safety-gated and intermittent
- Analog access does not expose meaningful control signals

The system is a closed-loop IMU-stabilized state machine.

# 8. Final System Architecture

STM32 IMU -> MAVLink -> Python logger -> QGroundControl
Arduino PWM -> ESC -> Brushless motor (controlled propulsion)
Serial sync -> unified dataset (command + state + response)

# 9. Summary

The most important outcome of this investigation is that real flight control systems are state machines with internal feedback loops, and external motor wiring does not expose usable control signals. This directly justifies the shift to clean PWM-based control via Arduino and ESC for meaningful propulsion and HIL testing.
