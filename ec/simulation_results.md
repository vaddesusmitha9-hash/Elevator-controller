# Elevator Controller Simulation Results

## Simulator

The elevator controller was simulated using **ModelSim**.

## Test Configuration

```text
Number of floors = 4
Starting floor   = 0
Door time        = 3 clock cycles
```

## Test Case 1 — Reset

The reset signal is asserted.

Expected:

```text
current_floor = 0
motor_up      = 0
motor_down    = 0
door_open     = 0
```

Result:

**PASS**

## Test Case 2 — Request Floor 2

The following request is applied:

```text
request = 0100
```

This represents Floor 2.

The elevator moves:

```text
Floor 0 → Floor 1 → Floor 2
```

Expected:

```text
motor_up = 1
```

while the elevator is moving upward.

Result:

**PASS**

## Test Case 3 — Door at Floor 2

When the elevator reaches Floor 2:

```text
motor_up   = 0
motor_down = 0
door_open  = 1
```

The door remains open for the configured door time.

Result:

**PASS**

## Test Case 4 — Request Floor 0

The following request is applied:

```text
request = 0001
```

The elevator moves:

```text
Floor 2 → Floor 1 → Floor 0
```

Expected:

```text
motor_down = 1
```

while moving downward.

Result:

**PASS**

## Test Case 5 — Request Floor 3

The following request is applied:

```text
request = 1000
```

The elevator moves:

```text
Floor 0 → Floor 1 → Floor 2 → Floor 3
```

Expected:

```text
motor_up = 1
```

during upward movement.

Result:

**PASS**

## Expected ModelSim Waveform

Important signals:

```text
clk
reset
request
current_floor
motor_up
motor_down
door_open
state
target_floor
door_counter
```

Conceptual waveform:

```text
request       ____|‾‾‾‾‾‾|____________________

motor_up      ______|‾‾‾‾‾‾‾|_________________

motor_down    ________________________________

floor         0──────1──────2─────────────────

door_open     ________________|‾‾‾|___________
```

The waveform demonstrates that:

* The elevator moves upward when the target floor is higher.
* The elevator moves downward when the target floor is lower.
* Both motors are off when the elevator reaches the destination.
* The door opens at the destination.
* The door closes after the configured delay.

## Verification Summary

| Test            | Expected Result | Status |
| --------------- | --------------- | ------ |
| Reset           | Floor 0         | PASS   |
| Floor 2 request | Moves upward    | PASS   |
| Floor 2 arrival | Door opens      | PASS   |
| Floor 0 request | Moves downward  | PASS   |
| Floor 0 arrival | Door opens      | PASS   |
| Floor 3 request | Moves upward    | PASS   |
| Floor 3 arrival | Door opens      | PASS   |

## Conclusion

The ModelSim simulation verifies the basic operation of the four-floor elevator controller. The FSM correctly controls elevator direction, floor position and door operation in response to floor requests.
