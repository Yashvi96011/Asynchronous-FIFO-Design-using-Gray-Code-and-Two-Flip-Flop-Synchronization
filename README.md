# Asynchronous-FIFO-Design-using-Gray-Code-and-Two-Flip-Flop-Synchronization

### `Overview:`
This project implements an **Asynchronous FIFO (First-In First-Out)** memory using Verilog. The design enables reliable data transfer between two independent clock domains by employing **Gray code pointers** and **two-stage synchronizers** to avoid metastability issues.

### `The FIFO supports:`
* Independent read and write clocks
* Full and Empty flag generation
* Gray code pointer synchronization
* Safe clock-domain crossing (CDC)
* Parameterized FIFO memory


### `Features:`
* ✔ Asynchronous read and write clock domains
* ✔ Binary and Gray code pointer implementation
* ✔ Two flip-flop synchronizers for CDC
* ✔ Full and Empty status detection
* ✔ Parameterized memory depth and data width
* ✔ Self-checking testbench with different clock frequencies


 ### `Modules:`
 
 ### 1. `two_ff_syn.v`
Implements a **two-stage synchronizer** to safely transfer Gray-coded pointers between clock domains.

#### Purpose

* Prevent metastability.
* Synchronize pointers crossing clock domains.



### 2. `wptr_handler.v`

Handles write-side operations.

#### Functions

* Binary write pointer increment.
* Binary-to-Gray conversion.
* Full flag generation.
* Pointer update.


### 3. `rdptr_handle.v`

Handles read-side operations.

#### Functions

* Binary read pointer increment.
* Binary-to-Gray conversion.
* Empty flag generation.
* Pointer update.



### 4. `fifo_mem.v`

Implements the storage array.

#### Functions

* Write data on `wclk`.
* Provide data using read pointer address.



### 5. `fifotop.v`

Top-level module integrating:

* Write pointer block
* Read pointer block
* Synchronizers
* FIFO memory


### 6. `top.v`

Testbench used for simulation.

#### Clock Frequencies

| Clock                | Period |
| -------------------- | ------ |
| Write Clock (`wclk`) | 10 ns  |
| Read Clock (`rclk`)  | 14 ns  |

---

## Working Principle

### Write Operation

When:

```verilog
w_en = 1
full = 0
```

then:

1. Binary write pointer increments.
2. Converted to Gray code.
3. Data is stored in FIFO memory.
4. Gray pointer is synchronized to the read clock domain.

---

### Read Operation

When:

```verilog
r_en = 1
empty = 0
```

then:

1. Binary read pointer increments.
2. Converted to Gray code.
3. Read pointer is synchronized into the write clock domain.
4. Empty condition is checked.

---

## Gray Code Conversion

### Binary → Gray

```verilog
gray = (binary >> 1) ^ binary;
```

Example:

| Binary | Gray |
| ------ | ---- |
| 0000   | 0000 |
| 0001   | 0001 |
| 0010   | 0011 |
| 0011   | 0010 |
| 0100   | 0110 |

Gray code changes only one bit at a time, making it ideal for clock-domain crossing.

---

## Full Condition

FIFO becomes **FULL** when:

```verilog
g_rptr_sync == {~gray_next[3:2], gray_next[1:0]}
```

This indicates that the write pointer is one complete cycle ahead of the read pointer.

---

## Empty Condition

FIFO becomes **EMPTY** when:

```verilog
gray_next == g_wptr_sync
```

which means both read and write pointers point to the same location.

---



## Concepts Used

* Verilog HDL
* Clock Domain Crossing (CDC)
* Two-Flip-Flop Synchronizer
* Gray Code Counters
* FIFO Design
* Sequential Logic
* Metastability Reduction

---

### `File Structure:`
async-fifo/
│   ├── two_ff_syn.v        # Two-FF metastability synchronizer
│   ├── wptr_handler.v      # Write pointer + full flag logic
│   ├── rdptr_handle.v      # Read pointer + empty flag logic
│   ├── fifo_mem.v          # Dual-port SRAM array
│   └── fifotop.v           # Top-level integration
│   └── top.v               # Testbench with write + read phases
└── README.md


