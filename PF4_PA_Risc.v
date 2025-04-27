`include "General_Modules.v"
`include "Miscellaneous.v"
`include "PF1_Lopez_Valentin_Manuel_rf.v"
`include "ALU_SOH_CH_PSW.v"
`include "DataMemory.v"
`include "PF3_CU.v"

module PPU (input Clk, Reset);

// Clock and Control
wire Clk, Reset, LE;

// IF Stage
wire [7:0] back, back_out;
wire [7:0] IF_1, front, IF_PC;
wire [31:0] IF_I;
wire [31:0] ID_I;
wire [7:0] ID_PC;

// ID Stage
wire [4:0] ID_RD;
wire [4:0] RW;
wire [7:0] ID_PA, ID_PB;
wire [31:0] PA; 
wire [31:0] PB;
wire [7:0] EX_Data_Address;
wire [31:0] MEM_PW;
wire [31:0] WB_PW;
wire [7:0] ID_NEW_PC;

// Control Unit outputs
wire [1:0] ID_RD_S;
wire ID_Branch_C;
wire [2:0] ID_SOH_OP;
wire [3:0] ID_ALU_OP;
wire ID_PSW_E;
wire [1:0] ID_ALU_Size;
wire ID_ALU_RW, ID_ALU_E, ID_Branch_U, ID_LOAD_E, ID_RF_LE, ID_Shift_E;

// MUX outputs (control signals for ID_EX stage)
wire [1:0] MUX_RD_S;
wire MUX_Branch_C;
wire [2:0] MUX_SOH_OP;
wire [3:0] MUX_ALU_OP;
wire MUX_PSW_E;
wire [1:0] MUX_ALU_Size;
wire MUX_ALU_RW, MUX_ALU_E, MUX_Branch_U, MUX_LOAD_E, MUX_RF_LE, MUX_Shift_E;

// Hazard Detection
wire [1:0] ID_SR;
wire EX_LOAD_E;
wire EX_RF_LE;
wire MEM_RF_LE;
wire WB_RF_LE;
wire [1:0] A_S, B_S;
wire NOP;

// ID_EX Pipeline Register
wire [7:0] EX_PA, EX_PB;
wire [20:0] EX_Immediate;
wire [7:0] EX_NEW_PC;
wire [7:0] EX_Target;
wire [4:0] EX_RD;
wire [2:0] EX_Cond;

// ID_EX Control
wire EX_Branch_C;
wire [2:0] EX_SOH_OP;
wire [3:0] EX_ALU_OP;
wire EX_PSW_E;
wire [1:0] EX_ALU_Size;
wire EX_ALU_RW, EX_ALU_E, EX_Branch_U, EX_Shift_E;

// EX Stage
wire [7:0] SOH_In, SOH_Out;
wire [7:0] C_B;
wire [7:0] ALU_Out;
wire Z, N, C, V;

// PSW outputs
wire CC;

// Branch Decision
wire J;

// EX/MEM Register
wire [7:0] MEM_PB, MEM_Data_Address;
wire [4:0] MEM_RD;

// EX_MEM Control
wire MEM_ALU_Size;
wire MEM_ALU_RW, MEM_ALU_E, MEM_Branch_U, MEM_LOAD_E;

// MEM Stage
wire [7:0] MEM_DO;

// MEM_WB Register
wire [4:0] WB_RD;


//IF Stage Begin
PC_Reg #(.PC_Set(4)) Back (Clk, LE, back, back_out);
Add IF (back_out, back);
Mux_2 #(.W(8)) IF1 (IF_1, J, back_out, EX_Target);
Mux_2 #(.W(8)) IF2 (front, ID_Branch_U, IF_1, EX_Target);
PC_Reg Front (Clk, LE, front, IF_PC);
InstructionMemory IM (IF_PC, IF_I);
//IF Stage End

IF_ID_Register IF_ID (Clk, Reset, LE, IF_I, IF_PC, ID_I, ID_PC);

//ID Stage Begin
Mux_3 #(.W(5)) RD (ID_RD, ID_RD_S, ID_I [25:21], ID_I [20:16], ID_I [4:0]);
Register_file RF (Clk, WB_RF_LE , ID_I [25:21], ID_I [20:16], RW, WB_PW, PA, PB);
Mux_4 PA_M (ID_PA, A_S, PA, EX_Data_Address, MEM_PW, WB_PW);
Mux_4 PB_M (ID_PB, B_S, PB, EX_Data_Address, MEM_PW, WB_PW);
ADD #(.add(8)) ID (ID_PC, ID_NEW_PC);

//Control System Begin
ControlUnit CU (ID_I, ID_RD_S, ID_Branch_C, ID_SOH_OP, ID_ALU_OP, ID_PSW_E,
ID_ALU_Size, ID_ALU_RW, ID_ALU_E, ID_Branch_U, ID_LOAD_E, ID_RF_LE, ID_Shift_E);
Mux_2_11 MUX_S (S, ID_RD_S, ID_Branch_C, ID_SOH_OP, ID_ALU_OP,
ID_PSW_E, ID_ALU_Size, ID_ALU_RW, ID_ALU_E, ID_Branch_U, ID_LOAD_E,
ID_RF_LE, ID_Shift_E, MUX_RD_S, MUX_Branch_C, MUX_SOH_OP, MUX_ALU_OP, MUX_PSW_E,
MUX_ALU_Size, MUX_ALU_RW, MUX_ALU_E, MUX_Branch_U, MUX_LOAD_E, MUX_RF_LE, MUX_Shift_E);
Hazard_Detection DHDU (ID_I [25:21], ID_I [20:16], ID_RD, EX_RD, MEM_RD, WB_RD, ID_SR, EX_LOAD_E,
EX_RF_LE, MEM_RF_LE, WB_RF_LE, A_S, B_S, NOP, LE);
//Control System End

//ID Stage End

ID_EX_Register ID_EX (Clk, Reset, ID_PA, ID_PB, ID_I [20:0], ID_NEW_PC, ID_Target,
ID_RD, ID_I [17:15], EX_PA, EX_PB, EX_Immediate, EX_NEW_PC, EX_Target, EX_RD, EX_Cond);
ID_EX_Control ID_EX_C (Clk, Reset, MUX_Branch_C, MUX_SOH_OP, MUX_ALU_OP, MUX_PSW_E,
MUX_ALU_Size, MUX_ALU_RW, MUX_ALU_E, MUX_Branch_U, MUX_LOAD_E, MUX_RF_LE, MUX_Shift_E, EX_Branch_C,
EX_SOH_OP, EX_ALU_OP, EX_PSW_E, EX_ALU_Size,EX_ALU_RW, EX_ALU_E, EX_Branch_U,
EX_LOAD_E, EX_RF_LE, EX_Shift_E);

//EX Stage Begin
Mux_2 EX1 (SOH_In, EX_Shift_E, EX_PB, EX_PA);
operandhandler SOH (SOH_Out, SOH_In, EX_Immediate, EX_SOH_OP);
ALU alu(EX_PA, SOH_Out, C_B, EX_ALU_OP, ALU_Out, Z, N, C, V);
PSW psw (LE, CC, C_B);
CH ch (N, Z, V, C, EX_Cond, ID_Branch_C, J);
Mux_2 #(.W(8)) EX2 (EX_Data_Address, ID_Branch_U, ALU_Out, EX_NEW_PC);
//EX Stage End

EX_MEM_Register EX_MEM (Clk, Reset, EX_PB, EX_Data_Address, EX_RD, MEM_PB, MEM_Data_Address, MEM_RD);
EX_MEM_Control EX_MEM_C (Clk, Reset, EX_ALU_Size, EX_ALU_RW, EX_ALU_E, EX_Branch_U, EX_LOAD_E,
EX_RF_LE, MEM_ALU_Size, MEM_ALU_RW, MEM_ALU_E, MEM_Branch_U, MEM_LOAD_E, MEM_RF_LE);

//MEM Stage Begin
DataMemory DM (Clk, MEM_Data_Address, MEM_PB, MEM_ALU_Size, MEM_ALU_RW, MEM_ALU_E, MEM_DO);
Mux_2 #(.W(8)) MEM1 (MEM_PW, MEM_LOAD_E, MEM_Data_Address, MEM_DO);
//MEM Stage End

MEM_WB_Register MEM_WB (Clk, Reset, MEM_RF_LE, MEM_PW, MEM_RD, WB_RF_LE, WB_PW, WB_RD);

endmodule
