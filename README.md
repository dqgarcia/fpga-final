# Digital System Design Final
This project implements the UART transmission protocol on a Basys 3 Artix-7 FPGA board. The board can receive ASCII codes, store them in an FIFO queue, and then transmit an incremented ASCII value back when the center button is pressed. It uses multiple modules such as a baud-rate generator (baud rate should be set to 19,200), debouncing circuit for the center button, UART rx and tx modules, and FIFO queue with register module for storage.
