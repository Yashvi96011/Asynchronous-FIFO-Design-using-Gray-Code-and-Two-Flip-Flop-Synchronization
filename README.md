# Asynchronous-FIFO-Design-using-Gray-Code-and-Two-Flip-Flop-Synchronization
A fully parameterized asynchronous FIFO (First-In, First-Out) buffer designed for safe data transfer across two independent, unrelated clock domains. Implements Gray-code pointer synchronization and two-stage flip-flop metastability resolution.

Design Concepts:

1.Why Gray Code?
Binary counters can flip multiple bits simultaneously (e.g., 0111 → 1000 flips 4 bits). If the receiving clock domain samples mid-transition, it latches a corrupt pointer value.
Gray code guarantees exactly 1 bit changes per count. A metastable sample resolves to either the old or new pointer — both are valid consecutive values — so no data corruption occurs.
Binary:  000 → 001 → 010 → 011 → 100  (can flip 3 bits at once)
Gray:    000 → 001 → 011 → 010 → 110  (always 1 bit flip)

2.Full Flag Logic:
assign full_flag = (g_rptr_sync == {~gray_next[3:2], gray_next[1:0]});
The FIFO is full when the write pointer has lapped the read pointer by exactly the FIFO depth. In 4-bit Gray code, this is detected by: top 2 bits inverted, lower bits equal.

3.Empty Flag Logic:
assign empty_flag = (gray_next == g_wptr_sync);
The FIFO is empty when both Gray-coded pointers are equal — the read pointer has caught up with the write pointer.

4.Extra Pointer Bit:
For depth = 8, addresses are 3 bits (ADDR_WIDTH = 3) but pointers are 4 bits (ADDR_WIDTH + 1).
Without the extra MSB, wptr == rptr is ambiguous — it could mean empty (no wrapping) or full (wrapped once). The MSB distinguishes these two states.

5.Two-FF Synchronizer:
Source domain signal
        │
   ┌────▼────┐  rclk  ┌─────────┐  rclk
   │  FF1   ├────────►│  FF2   ├──────► Synchronized output
   └─────────┘        └─────────┘
   (may go metastable)  (resolved)
FF1 may go metastable but resolves within one clock period. FF2 samples the settled value. MTBF with this scheme at GHz-range clocks exceeds millions of years.

Testbench Sequence:
1.Initialize all signals, assert reset
2.De-assert reset (w_rst=1, r_rst=1)
3.Write phase — write 10 values; stops automatically when full asserted
4.Read phase — read 10 values; stops automatically when empty asserted
5.Monitor output via $monitor (time, enables, data, flags)
