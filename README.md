# multicycleRISCProcessor
A 16-bit multicycle RISC processor designed as a part of the EE309-Microprocessors course at EE, IIT Bombay. The design has been implemented using Verilog HDL. Quartus and Altera Modelsim were used to design, debug and test the whole project. The Verilog code was ultimately synthesized on a Terasic DE0-Nano board with the Altera Cyclone IV 4C22 FPGA.

Summary of problem statement: Design a 16-bit, 8-register, multicycle RISC processor with the following instruction set:-
  1. ADD - add 2 16 bit numbers
  2. ADZ - add if zero flag is set
  3. ADC - add if carry flag is set
  4. ADI - add immediate
  5. NDU - nand two 16 bit numbers
  6. NDC - nand if carry flag is set
  7. NDZ - nand if zero flag is set
  8. LHI - load immediate value
  9. LW - load from memory
  10. SW - store in memory
  11. LM - load multiple values from memory
  12. SM - store multiple values in memory
  13. BEQ - branch on equality
  14. JAL - jump and link
  15. JLR - jump and link to register

For a detailed description of what every description does, like its operands, destination, flags modified by it, etc., please have a look at multicycleRISCProcessor/Project-1-Multicycle-RISC-IITB.pdf

Also, do checkout the video of synthesis of the Verilog code on the FPGA and test case verification at https://drive.google.com/open?id=0ByCbdaDy1kjweTJPVG05QU1IOWs

Thanks!
