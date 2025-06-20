# CONFIGURABLE TEST SYSTEM FOR DIGITAL CHIPS BASED ON REGISTER STRINGS

This project implements a configurable test system for digital chips based on register strings in VHDL designed to be synthesized and run on the Nexys A-7 board.

## Author

Developed by Beltrán Fernández Aguirre.  
Email: beltferag@gmail.com  
GitHub: https://github.com/BeltranFdez

## Description

In this system, the user is able to introduce different conditions under which the test is to be executed. Some of these conditions to be introduced by the user are the frequency at which the internal clock should run, the percentage of bit changes in the test string, and the number of bits to send. After the test is  executed, the user receives information on the result of the test under the conditions entered.

## Features

- **VHDL Code:** Entire system implemented using VHDL.
- **Nexys A-7 Compatible:** Configured and tested to function on the Nexys A-7 board.
- **Digital chip tester:** Designed to detect errors in digital chip's registers.

## Requirements

- **Synthesis Tool:** Xilinx Vivado.
- **Board:** Nexys A-7.
- **6 Wires:** In order to connect the chip and the board.

## Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/BeltranFdez/chip_tester.git
    ```

2. **Open the project:** Import the project into your synthesis environment (Xilinx Vivado).

3. **Configure the board:** Ensure you have selected and configured the Nexys A-7 board appropriately.

## Usage

The project can be used in different ways depending on which top-level file you select in your synthesis or simulation environment. Choose the appropriate file based on your goals:

1. **Real Chip Testing System:**  
   To deploy the test system on the board with real chips, set `VALUES_V4` as your top-level file.

2. **System with Chip Emulator:**  
   To implement both the system and the chip emulator on the board, select `VALUES_SYNTH_V1` as your top-level file.

3. **Testbench Simulations:**  
   For running simulations with the testbenches, set `CHIP_SIM_V2` as your top-level file.

Make sure your synthesis or simulation environment is properly configured with the corresponding top-level file before proceeding.

5. **Synthesize the system:** Run the synthesis flow to generate the bitstream.

6. **Load the bitstream:** Connect the Nexys A-7 board to your PC and use the programmer to load the generated bitstream.

7. **Verify the system:** Check the functionality following the instructions of the manual.
