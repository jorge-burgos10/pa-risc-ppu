module PC_Reg #(parameter PC_Set = 0) (input Clk, LE, input [7:0] PC_in, output reg [7:0] PC_out);
    always @ (posedge Clk)
    if(LE) 
    begin
        PC_out <= PC_in;
    end
endmodule

module PSW (input LE, CC, output reg C_B);
    always @ (*)
    if(LE) begin
        C_B = CC;
    end
    else begin 
        C_B = 0;
    end
endmodule

module ID_EX_Register (input Clk, Reset, input [31:0] ID_PA, ID_PB, input [20:0] ID_Immediate,
input [7:0] ID_front_add, ID_Target, input [4:0] ID_RD, input [2:0] ID_Cond,
output reg [31:0] EX_PA, EX_PB, output reg [20:0] EX_Immediate, 
output reg [7:0] EX_front_add, EX_Target, output reg [4:0] EX_RD, output reg [2:0] EX_Cond);
    always @ (posedge Clk)
    if (!Reset) begin
        EX_PA <= ID_PA;
        EX_PB <= ID_PB;
        EX_Immediate <= ID_Immediate;
        EX_front_add <= ID_front_add;
        EX_Target <= ID_Target;
        EX_RD <= ID_RD;
        EX_Cond <= ID_Cond;
    end
    else begin
        EX_PA <= 0;
        EX_PA <= 0;
        EX_Immediate <= 0;
        EX_front_add <= 0;
        EX_Target <= 0;
        EX_RD <= 0;
        EX_Cond <= 0;
    end
endmodule

module EX_MEM_Register (input Clk, Reset, input [31:0] EX_PB, input [7:0] EX_Data_Address,
input [4:0] EX_RD, output reg [31:0] MEM_PB, output reg [7:0]
MEM_Data_Address, output reg [4:0] MEM_RD);
    always @ (posedge Clk)
    if (!Reset) begin
        MEM_PB <= EX_PB;
        MEM_Data_Address <= EX_Data_Address;
        MEM_RD <= MEM_RD;
    end
    else begin
        MEM_PB <= 0;
        MEM_Data_Address <= 0;
        MEM_RD <= 0;
    end
endmodule

module MEM_WB_Register (input Clk, Reset, MEM_RF_LE, input [31:0] MEM_PW, input [4:0] MEM_RD,
output reg WB_RF_LE, output reg [31:0] WB_PW, output reg [4:0] WB_RD);
    always @ (posedge Clk)
    if(!Reset) begin
        WB_PW <= MEM_PW;
        WB_RD <= MEM_RD;
        WB_RF_LE <= MEM_RF_LE;
    end
    else begin
        WB_PW <= 0;
        WB_RD <= 0;
        WB_RF_LE <= 0;
    end
endmodule

module Hazard_Detection (input [4:0] ID_RA, ID_RB, ID_RD, EX_RD, MEM_RD, WB_RD, input [1:0] ID_SR,
input EX_Load_E, EX_RF_LE, MEM_RF_LE, WB_RF_LE, output reg [1:0] A_S, B_S, output reg NOP, LE);

endmodule

module Target_Address_Generator (input B, input [7:0] Offset, FT, Target_Address);

endmodule