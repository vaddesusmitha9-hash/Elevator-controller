# Elevator Controller Using Verilog

## Overview

This project implements a **4-floor Elevator Controller** using Verilog HDL.

The controller manages elevator movement between four floors:

```text
Floor 3
Floor 2
Floor 1
Floor 0
```

The design uses a **Finite State Machine (FSM)** to control the elevator.

The elevator supports:

* Floor requests
* Upward movement
* Downward movement
* Door opening
* Automatic door closing
* Reset operation

The design is simulated and verified using **ModelSim**.

No specific FPGA development board is required.

## Features

* Verilog HDL implementation
* 4-floor elevator
* FSM-based control
* Up motor control
* Down motor control
* Door control
* Floor tracking
* Floor request input
* Automatic door timing
* Verilog testbench
* ModelSim simulation
* Waveform verification
* GitHub-ready project structure

## Project Structure

```text
verilog-elevator-controller/
│
├── README.md
│
├── src/
│   └── elevator_controller.v
│
├── tb/
│   └── elevator_controller_tb.v
│
├── sim/
│   └── run.do
│
└── docs/
    └── simulation_results.md
```

## Elevator Floors

The elevator contains four floors:

```text
+---------+
| Floor 3 |
+---------+
| Floor 2 |
+---------+
| Floor 1 |
+---------+
| Floor 0 |
+---------+
```

The elevator starts at:

```text
Floor 0
```

## Block Diagram

```text
                    +------------------+
                    |                  |
 Request[3:0] ----->|                  |
                    |  Elevator FSM    |
 Clock ------------>|                  |
 Reset ------------>|                  |
                    |                  |
                    +--------+---------+
                             |
              +--------------+--------------+
              |              |              |
              v              v              v
          Motor Up       Motor Down      Door Open
              |
              v
        Current Floor
```

## FSM States

The controller contains four states:

```text
IDLE
UP
DOWN
DOOR_OPEN
```

### IDLE

The elevator waits for a floor request.

If the requested floor is above the current floor:

```text
IDLE → UP
```

If the requested floor is below the current floor:

```text
IDLE → DOWN
```

If the requested floor is the current floor:

```text
IDLE → DOOR_OPEN
```

### UP

The elevator moves upward.

```text
motor_up = 1
motor_down = 0
door_open = 0
```

The current floor increases by one floor per clock cycle.

### DOWN

The elevator moves downward.

```text
motor_up = 0
motor_down = 1
door_open = 0
```

The current floor decreases by one floor per clock cycle.

### DOOR_OPEN

When the elevator reaches the requested floor:

```text
motor_up = 0
motor_down = 0
door_open = 1
```

The door remains open for a fixed number of clock cycles before returning to the IDLE state.

## Inputs

| Signal    |  Width | Description       |
| --------- | -----: | ----------------- |
| `clk`     |  1 bit | System clock      |
| `reset`   |  1 bit | Active-high reset |
| `request` | 4 bits | Floor request     |

## Floor Request Encoding

The request input uses one bit for each floor:

| Request |   Floor |
| ------- | ------: |
| `0001`  | Floor 0 |
| `0010`  | Floor 1 |
| `0100`  | Floor 2 |
| `1000`  | Floor 3 |

For example:

```text
request = 4'b0100
```

means:

```text
Floor 2 requested
```

## Outputs

| Signal          | Description            |
| --------------- | ---------------------- |
| `current_floor` | Current elevator floor |
| `motor_up`      | Upward motor control   |
| `motor_down`    | Downward motor control |
| `door_open`     | Door status            |

## Elevator Operation Example

Suppose the elevator starts at floor 0.

A request is made for floor 2:

```text
request = 0100
```

The controller performs:

```text
IDLE
  |
  v
UP
  |
  v
Floor 1
  |
  v
Floor 2
  |
  v
DOOR_OPEN
  |
  v
IDLE
```

The motor signals behave as:

```text
motor_up   = 1 while moving upward
motor_down = 0
door_open  = 0
```

When the elevator reaches floor 2:

```text
motor_up   = 0
motor_down = 0
door_open  = 1
```

After the door timer expires, the elevator returns to IDLE.

## Door Operation

The door remains open for a fixed number of clock cycles.

In this project:

```verilog
DOOR_TIME = 3
```

Therefore, the door stays open for approximately three clock cycles.

## Simulation

### Requirements

* ModelSim
* Verilog HDL
* Git
* GitHub account

### Running the Simulation

Open ModelSim and navigate to:

```text
verilog-elevator-controller/sim
```

Run:

```tcl
do run.do
```

The simulation script:

1. Creates the ModelSim work library.
2. Compiles the elevator controller.
3. Compiles the testbench.
4. Starts the simulation.
5. Adds important signals to the waveform.
6. Runs the simulation.
7. Displays the complete waveform.

## Testbench

The testbench verifies:

1. Initial reset
2. Request for Floor 2
3. Elevator movement from Floor 0 to Floor 2
4. Door opening at Floor 2
5. Request for Floor 0
6. Elevator movement from Floor 2 to Floor 0
7. Door opening at Floor 0
8. Request for Floor 3
9. Elevator movement from Floor 0 to Floor 3
10. Door operation at Floor 3

## Expected Simulation Output

The ModelSim Transcript should show behavior similar to:

```text
Time=0 ns   | Request=0000 | Floor=0 | UP=0 | DOWN=0 | DOOR=0
Time=30 ns  | Request=0100 | Floor=0 | UP=1 | DOWN=0 | DOOR=0
Time=40 ns  | Request=0100 | Floor=1 | UP=1 | DOWN=0 | DOOR=0
Time=50 ns  | Request=0100 | Floor=2 | UP=0 | DOWN=0 | DOOR=1

...
```

The exact timing can vary according to clock edges.

## Expected Waveform

Conceptually, a request for Floor 2 should produce:

```text
request      ____|‾‾‾‾‾‾‾‾‾|____________

motor_up     ______|‾‾‾‾‾‾|_______________

motor_down   ______________________________

floor        0──────1──────2───────────────

door_open    ________________|‾‾‾|________
                              ↑
                         Door opens
```

For a request from Floor 2 to Floor 0:

```text
request      ____|‾‾‾‾‾‾‾|_______________

motor_up     ______________________________

motor_down   ______|‾‾‾‾‾|________________

floor        2──────1──────0───────────────

door_open    ________________|‾‾‾|________
```

## Verification

| Test Case       | Expected Result     | Status |
| --------------- | ------------------- | ------ |
| Reset           | Elevator at Floor 0 | PASS   |
| Floor 2 request | Elevator moves up   | PASS   |
| Floor 2 arrival | Door opens          | PASS   |
| Floor 0 request | Elevator moves down | PASS   |
| Floor 0 arrival | Door opens          | PASS   |
| Floor 3 request | Elevator moves up   | PASS   |
| Floor 3 arrival | Door opens          | PASS   |

## Applications

Elevator controllers are examples of finite-state control systems and are related to:

* Building automation
* Industrial control
* Traffic controllers
* Automatic doors
* Robotics
* Automated transportation
* Embedded systems

## Future Improvements

The project can be extended with:

* More floors
* Multiple simultaneous requests
* Emergency stop
* Door obstruction detection
* Overload detection
* Alarm system
* Seven-segment floor display
* Seven-segment direction display
* Door-open button
* Door-close button
* Priority scheduling
* FPGA implementation

## Conclusion

This project demonstrates the design and verification of a 4-floor elevator controller using Verilog HDL.

A finite-state machine controls elevator movement, floor tracking, motor direction and door operation. The design is verified using a Verilog testbench and ModelSim waveform simulation.
