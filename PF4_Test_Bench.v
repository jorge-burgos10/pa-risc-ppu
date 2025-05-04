module PPU_Test_Bench;
    reg Clk = 0, Reset = 1;
    reg [8*8:1] keyword;

    PPU PPU_TB(Clk, Reset);

    always #2 Clk = ~Clk;

    initial begin
        $display("\n\n***************************************\n\n");
        #3 Reset = 0;
    end
    always @(*)
    if(PPU_TB.NOP)begin
        keyword <= "NOP";
    end
    else begin
        case (PPU_TB.ID_I[31:26])
            6'b101101: keyword <= "ADDI";
            6'b100101: keyword <= "SUBI";
            6'b110101: begin
                case (PPU_TB.ID_I[12:10])
                    3'b010: keyword <= "ZDEP";
                    default: keyword <= "ZDEP ERROR";
                endcase
            end
            6'b000010: begin
                case (PPU_TB.ID_I[11:6])
                    6'b011000: keyword <= "ADD";
                    6'b011100: keyword <= "ADDC";
                    6'b101000: keyword <= "ADDL";
                    6'b010000: keyword <= "SUB";
                    6'b010100: keyword <= "SUBB";
                    6'b001001: keyword <= "OR";
                    6'b001010: keyword <= "XOR";
                    6'b001000: keyword <= "AND";
                    default: keyword <= "ARITH ERROR";
                endcase
            end
            6'b010010: keyword <= "LDW";
            6'b010001: keyword <= "LDH";
            6'b010000: keyword <= "LDB";
            6'b001101: keyword <= "LDO";
            6'b001000: keyword <= "LDIL";  
            6'b011010: keyword <= "STW";     
            6'b011001: keyword <= "STH";
            6'b011000: keyword <= "STB";
            6'b100000: keyword <= "COMBT";
            6'b100010: keyword <= "COMBF";
            6'b111010: keyword <= "BL";
            6'b110100: begin
                case (PPU_TB.ID_I[12:10])
                    3'b111: keyword <= "EXTRS";
                    3'b110: keyword <= "EXTRU";
                    default: keyword <= "EXT ERROR";
                endcase
            end
            6'b000000: keyword <= "NOP";
            default: keyword <= "UNKNOWN";
        endcase
    end


//Monitor Begin
always @ (posedge Clk) begin
    $display("Time = %0t\t Front = %0d Back = %0d\n\tGR\t\t |\t GR1 = %0d\t GR2 = %0d\t GR3 = %0d\t GR5 = %0d\t GR6 = %0d\t GR10 = %0d\t GR11 = %0d\t GR12 = %0d\t GR14 = %0d\n",
    $time, PPU_TB.ID_PC, PPU_TB.back_out, PPU_TB.RF.Q1, PPU_TB.RF.Q2, PPU_TB.RF.Q3, PPU_TB.RF.Q5, PPU_TB.RF.Q6, PPU_TB.RF.Q10, PPU_TB.RF.Q11, PPU_TB.RF.Q12, PPU_TB.RF.Q14); 
    
    $display ("\tIF\t\t |\t Front = %0d\t Back = %0d\t MUX_1 = %0d\t MUX_2 = %0d Adder = %0d",
    PPU_TB.IF_PC, PPU_TB.back_out, PPU_TB.IF_1, PPU_TB.front, PPU_TB.back); 

    $display("Control IF\t | \tLE=%b\n",
    PPU_TB.LE);

    $display ("\tID\t\t |\t Instruction = %0s\t %b\t RA = %0d\t RB = %0d\t RD = %0d",
    keyword, PPU_TB.ID_I [31:26], PPU_TB.ID_I [25:21], PPU_TB.ID_I [20:16], PPU_TB.ID_RD); 

    $display ("\tHazard\t |\t RA = %0d\t RB = %0d\t RD = %0d EX_RD = %0d\t MEM_RD = %0d\t WB_RD = %0d\t SR = %b\t EX_LOAD = %b\t EX_RF = %b\t MEM_RF = %b\t WB_RF = %b\t A_S = %b\t B_S = %b\t NOP = %b\t LE = %b\t",
    PPU_TB.DHDU.ID_RA, PPU_TB.DHDU.ID_RB, PPU_TB.DHDU.ID_RD, PPU_TB.DHDU.EX_RD, PPU_TB.DHDU.MEM_RD,
    PPU_TB.DHDU.WB_RD, PPU_TB.DHDU.ID_SR, PPU_TB.DHDU.EX_Load_E, PPU_TB.DHDU.EX_RF_LE, PPU_TB.DHDU.MEM_RF_LE, 
    PPU_TB.DHDU.WB_RF_LE, PPU_TB.DHDU.A_S, PPU_TB.DHDU.B_S, PPU_TB.DHDU.NOP, PPU_TB.DHDU.LE);    

    $display("Control ID\t | \tALU_OP=%b SOH_OP=%b PSW_E=%b B_U=%b B_C=%b MEM_Size=%b MEM_RW=%b MEM_E=%b MUX_E=%b RF_LE=%b RD_S=%b Shift_E=%b A_S = %0d B_S = %0d\n", 
    PPU_TB.MUX_ALU_OP, PPU_TB.MUX_SOH_OP, PPU_TB.MUX_PSW_E, PPU_TB.MUX_Branch_U, PPU_TB.MUX_Branch_C, PPU_TB.MUX_ALU_Size, PPU_TB.MUX_ALU_RW,
    PPU_TB.MUX_LOAD_E, PPU_TB.MUX_ALU_E, PPU_TB.MUX_RF_LE, PPU_TB.MUX_RD_S, PPU_TB.MUX_Shift_E, PPU_TB.A_S, PPU_TB.B_S);

    $display ("\tEX\t\t |\t NEW_PC = %0d\t Target = %0d\t Cond = %0d\t PA = %0d\t PB = %0d\t Immediate = %0d\t RD = %0d",
    PPU_TB.EX_NEW_PC, PPU_TB.EX_Target, PPU_TB.EX_Cond, PPU_TB.EX_PA, PPU_TB.EX_PB, PPU_TB.EX_Immediate, PPU_TB.EX_RD); 

    $display("Control EX\t | \tALU_OP=%b SOH_OP=%b PSW_E=%b B_U=%b B_C=%b MEM_Size=%b MEM_RW=%b MEM_E=%b MUX_E=%b RF_LE=%b Shift_E=%b\n",
    PPU_TB.EX_ALU_OP, PPU_TB.EX_SOH_OP, PPU_TB.EX_PSW_E, PPU_TB.EX_Branch_U, PPU_TB.EX_Branch_C, PPU_TB.EX_ALU_Size, PPU_TB.EX_ALU_RW, PPU_TB.EX_LOAD_E,
    PPU_TB.EX_ALU_E, PPU_TB.EX_RF_LE, PPU_TB.EX_Shift_E);

    $display ("\tMEM\t\t |\t PB = %0d\t Data Address = %0d\t Data Out = %0d\t RD = %0d",
    PPU_TB.MEM_PB, PPU_TB.MEM_Data_Address, PPU_TB.MEM_DO, PPU_TB.MEM_RD); 

    $display ("\tData\t |\t Data In = %0d\t Data Address = %0d\t Data Out = %0d\t RW = %0d\t Size = %d\t Enable = %0d",
    PPU_TB.DM.DI, PPU_TB.DM.A, PPU_TB.DM.DO, PPU_TB.DM.RW, PPU_TB.DM.Size, PPU_TB.DM.E); 

    $display("Control MEM\t | \tMEM_Size=%b MEM_RW=%b MEM_E=%b MUX_E=%b RF_LE=%b\n",
    PPU_TB.MEM_ALU_Size, PPU_TB.MEM_ALU_RW, PPU_TB.MEM_ALU_E, PPU_TB.MEM_LOAD_E, PPU_TB.MEM_RF_LE);

    $display ("\tWB\t\t |\t PW = %0d\t RD = %0d",
    PPU_TB.WB_PW, PPU_TB.WB_RD);

    $display("Control WB\t | \tRF_LE=%b\n",
    PPU_TB.WB_RF_LE);
    $display(" Data Memory Out = %b %b %b %b %b %b %b %b",PPU_TB.MEM_DO[31:28], PPU_TB.MEM_DO[27:24], PPU_TB.MEM_DO[23:20], PPU_TB.MEM_DO[19:16],PPU_TB.MEM_DO[15:12], PPU_TB.MEM_DO[11:8],  PPU_TB.MEM_DO[7:4],   PPU_TB.MEM_DO[3:0]);

    $display("\n\n***************************************\n\n");
end
//Monitors End

    initial begin
        //#100
        //$display(" Data Memory Out = %b %b %b %b %b %b %b %b",PPU_TB.MEM_DO[31:28], PPU_TB.MEM_DO[27:24], PPU_TB.MEM_DO[23:20], PPU_TB.MEM_DO[19:16],PPU_TB.MEM_DO[15:12], PPU_TB.MEM_DO[11:8],  PPU_TB.MEM_DO[7:4],   PPU_TB.MEM_DO[3:0]);
        #100 $finish;
        

    end


endmodule


module PC_Reg #(parameter PC_Set = 0) (input Clk, LE, input [31:0] PC_in, output reg [31:0] PC_out);
    initial begin
        PC_out = PC_Set;
    end    
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
input [31:0] ID_front_add, ID_Target, input [4:0] ID_RD, input [2:0] ID_Cond,
output reg [31:0] EX_PA, EX_PB, output reg [20:0] EX_Immediate, 
output reg [31:0] EX_front_add, EX_Target, output reg [4:0] EX_RD, output reg [2:0] EX_Cond);
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
        EX_PB <= 0;
        EX_Immediate <= 0;
        EX_front_add <= 0;
        EX_Target <= 0;
        EX_RD <= 0;
        EX_Cond <= 0;
    end
endmodule

module EX_MEM_Register (input Clk, Reset, input [31:0] EX_PB, EX_Data_Address,
input [4:0] EX_RD, output reg [31:0] MEM_PB, MEM_Data_Address, output reg [4:0] MEM_RD);
    always @ (posedge Clk)
    if (!Reset) begin
        MEM_PB <= EX_PB;
        MEM_Data_Address <= EX_Data_Address;
        MEM_RD <= EX_RD;
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
    if(Reset) begin
        WB_PW <= 0;
        WB_RD <= 0;
        WB_RF_LE <= 0;
    end
    else begin
        WB_PW <= MEM_PW;
        WB_RD <= MEM_RD;
        WB_RF_LE <= MEM_RF_LE;
    end
endmodule

module Hazard_Detection (input [4:0] ID_RA, ID_RB, ID_RD, EX_RD, MEM_RD, WB_RD, input [1:0] ID_SR,
input EX_Load_E, EX_RF_LE, MEM_RF_LE, WB_RF_LE, output reg [1:0] A_S, B_S, output reg NOP, LE);
always @(*) begin
        // Inicializar por defecto (sin hazard, avanzar normal)
        A_S = 2'b00;
        B_S = 2'b00;
        NOP = 1'b0;
        LE = 1'b1;

        // --- Data Forwarding para RA ---
        if (ID_SR[1]) begin // Si el primer operando existe
            if (EX_RF_LE && (ID_RA == EX_RD))
                A_S = 2'b01; // Forward desde EX
            else if (MEM_RF_LE && (ID_RA == MEM_RD))
                A_S = 2'b10; // Forward desde MEM
            else if (WB_RF_LE && (ID_RA == WB_RD))
                A_S = 2'b11; // Forward desde WB
        end

        // --- Data Forwarding para RB ---
        if (ID_SR[0]) begin // Si el segundo operando existe
            if (EX_RF_LE && (ID_RB == EX_RD))
                B_S = 2'b01; // Forward desde EX
            else if (MEM_RF_LE && (ID_RB == MEM_RD))
                B_S = 2'b10; // Forward desde MEM
            else if (WB_RF_LE && (ID_RB == WB_RD))
                B_S = 2'b11; // Forward desde WB
        end

        // --- Data Forwarding Hazard (LOAD) ---
        if (EX_Load_E && (
            (ID_SR[1] && (ID_RA == EX_RD)) ||
            (ID_SR[0] && (ID_RB == EX_RD))
        )) begin
            LE = 1'b0;   // Congela PC y IF/ID
            NOP = 1'b1;  // Coloca un NOP en EX
        end
    end
endmodule

module Target_Address_Generator (input [1:0] B, input [20:0] Offset, input [31:0] FT, output reg [31:0] Target_Address); 
    reg [31:0] W_SE;
    reg [31:0] W;
    always @ (*) begin
    if (B[1] || B[0]) begin
        W_SE = {{19{Offset[12]}}, Offset[12:2], Offset[0]}; // Sign extend
    end
    else begin
        W_SE = {{11{Offset[20]}}, Offset[20:16], Offset[12:2], Offset[0]}; // Sign extend
    end
        W = W_SE << 2;
        Target_Address = FT + W;
    end
endmodule
module Mux_2 #(parameter W = 32) (output reg [W-1:0] o_mux, input i_mux, input [W-1:0] Z0, Z1);
    always @ (*) begin
        case (i_mux)
        1'b0: o_mux = Z0;
        1'b1: o_mux = Z1;
        endcase
    end
endmodule

module Mux_4 #(parameter W = 32) (output reg [W-1:0] o_mux, input [1:0] i_mux, input [W-1:0] Z0, Z1, Z2, Z3);
    always @ (*) begin
        case (i_mux)
        2'b00: o_mux = Z0;
        2'b01: o_mux = Z1;
        2'b10: o_mux = Z2;
        2'b11: o_mux = Z3;
        endcase
    end
endmodule

module Mux_3 #(parameter W = 32) (output reg [W-1:0] o_mux, input [1:0] i_mux, input [W-1:0] Z0, Z1, Z2);
    always @ (*) begin
        case (i_mux)
        2'b00: o_mux = Z0;
        2'b01: o_mux = Z1;
        2'b10: o_mux = Z2;
        endcase
    end
endmodule

module ADD #(parameter add = 4, W = 32) (input [W-1:0] add_in, output reg [W-1:0] add_out);
    always @ (*) begin
    add_out = add_in + add;
    end
endmodule
module Register_file(input clk, E , input [4:0] RA, RB, RW, input [31:0] PW, output [31:0] PA, PB);
  wire [31:0] O;
  wire [31:0] Q0;
  wire [31:0] Q1;
  wire [31:0] Q2;
  wire [31:0] Q3;
  wire [31:0] Q4;
  wire [31:0] Q5;
  wire [31:0] Q6;
  wire [31:0] Q7;
  wire [31:0] Q8;
  wire [31:0] Q9;
  wire [31:0] Q10;
  wire [31:0] Q11;
  wire [31:0] Q12;
  wire [31:0] Q13;
  wire [31:0] Q14;
  wire [31:0] Q15;
  wire [31:0] Q16;
  wire [31:0] Q17;
  wire [31:0] Q18;
  wire [31:0] Q19;
  wire [31:0] Q20;
  wire [31:0] Q21;
  wire [31:0] Q22;
  wire [31:0] Q23;
  wire [31:0] Q24;
  wire [31:0] Q25;
  wire [31:0] Q26;
  wire [31:0] Q27;
  wire [31:0] Q28;
  wire [31:0] Q29;
  wire [31:0] Q30;
  wire [31:0] Q31;
  bin_deco bin1 (O, RW, E);
  Regi_32 R0 (Q0, PW, O[0], clk);
  Regi_32 R1 (Q1, PW, O[1], clk);
  Regi_32 R2 (Q2, PW, O[2], clk);
  Regi_32 R3 (Q3, PW, O[3], clk);
  Regi_32 R4 (Q4, PW, O[4], clk);
  Regi_32 R5 (Q5, PW, O[5], clk);
  Regi_32 R6 (Q6, PW, O[6], clk);
  Regi_32 R7 (Q7, PW, O[7], clk);
  Regi_32 R8 (Q8, PW, O[8], clk);
  Regi_32 R9 (Q9, PW, O[9], clk);
  Regi_32 R10 (Q10, PW, O[10], clk);
  Regi_32 R11 (Q11, PW, O[11], clk);
  Regi_32 R12 (Q12, PW, O[12], clk);
  Regi_32 R13 (Q13, PW, O[13], clk);
  Regi_32 R14 (Q14, PW, O[14], clk);
  Regi_32 R15 (Q15, PW, O[15], clk);
  Regi_32 R16 (Q16, PW, O[16], clk);
  Regi_32 R17 (Q17, PW, O[17], clk);
  Regi_32 R18 (Q18, PW, O[18], clk);
  Regi_32 R19 (Q19, PW, O[19], clk);
  Regi_32 R20 (Q20, PW, O[20], clk);
  Regi_32 R21 (Q21, PW, O[21], clk);
  Regi_32 R22 (Q22, PW, O[22], clk);
  Regi_32 R23 (Q23, PW, O[23], clk);
  Regi_32 R24 (Q24, PW, O[24], clk);
  Regi_32 R25 (Q25, PW, O[25], clk);
  Regi_32 R26 (Q26, PW, O[26], clk);
  Regi_32 R27 (Q27, PW, O[27], clk);
  Regi_32 R28 (Q28, PW, O[28], clk);
  Regi_32 R29 (Q29, PW, O[29], clk);
  Regi_32 R30 (Q30, PW, O[30], clk);
  Regi_32 R31 (Q31, PW, O[31], clk);
  Mux_32 mux_A (PA, RA, 32'd0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31);
  Mux_32 mux_b(PB, RB, 32'd0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31);

endmodule

module Regi_32 (output reg [31:0] o_regi, input [31:0] i_regi, input
LE, Clk);
initial begin o_regi = 0; end
always @ (posedge Clk)
if (LE) o_regi <= i_regi;
endmodule

module bin_deco (output reg [31:0] o_deco , input [4:0] i_deco, input E );
always@* begin
    if (E) case (i_deco)
            5'd0: o_deco = 32'h1;
            5'd1: o_deco = 32'h2;
            5'd2: o_deco = 32'h4;
            5'd3: o_deco = 32'h8;
            5'd4: o_deco = 32'h10;
            5'd5: o_deco = 32'h20;
            5'd6: o_deco = 32'h40;
            5'd7: o_deco = 32'h80;
            5'd8: o_deco = 32'h100;
            5'd9: o_deco = 32'h200;
            5'd10: o_deco = 32'h400;
            5'd11: o_deco = 32'h800;
            5'd12: o_deco = 32'h1000;
            5'd13: o_deco = 32'h2000;
            5'd14: o_deco = 32'h4000;
            5'd15: o_deco = 32'h8000;
            5'd16: o_deco = 32'h10000;
            5'd17: o_deco = 32'h20000;
            5'd18: o_deco = 32'h40000;
            5'd19: o_deco = 32'h80000;
            5'd20: o_deco = 32'h100000;
            5'd21: o_deco = 32'h200000;
            5'd22: o_deco = 32'h400000;
            5'd23: o_deco = 32'h800000;
            5'd24: o_deco = 32'h1000000;
            5'd25: o_deco = 32'h2000000;
            5'd26: o_deco = 32'h4000000;
            5'd27: o_deco = 32'h8000000;
            5'd28: o_deco = 32'h10000000;
            5'd29: o_deco = 32'h20000000;
            5'd30: o_deco = 32'h40000000;
            5'd31: o_deco = 32'h80000000;
            endcase
        else o_deco = 32'h0;
    end
endmodule

module Mux_32 (output reg [31:0] o_mux, input [4:0] i_mux,
input [31:0] Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15, Z16, Z17, Z18, Z19, Z20, Z21, Z22, Z23, Z24, Z25, Z26, Z27, Z28, Z29, Z30, Z31);
always @ (i_mux , Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15, Z16, Z17, Z18, Z19, Z20, Z21, Z22, Z23, Z24, Z25, Z26, Z27, Z28, Z29, Z30, Z31)
    case (i_mux)
        5'b00000: o_mux = Z0;
        5'b00001: o_mux = Z1;
        5'b00010: o_mux = Z2;
        5'b00011: o_mux = Z3;
        5'b00100: o_mux = Z4;
        5'b00101: o_mux = Z5;
        5'b00110: o_mux = Z6;
        5'b00111: o_mux = Z7;
        5'b01000: o_mux = Z8;
        5'b01001: o_mux = Z9;
        5'b01010: o_mux = Z10;
        5'b01011: o_mux = Z11;
        5'b01100: o_mux = Z12;
        5'b01101: o_mux = Z13;
        5'b01110: o_mux = Z14;
        5'b01111: o_mux = Z15;
        5'b10000: o_mux = Z16;
        5'b10001: o_mux = Z17;
        5'b10010: o_mux = Z18;
        5'b10011: o_mux = Z19;
        5'b10100: o_mux = Z20;
        5'b10101: o_mux = Z21;
        5'b10110: o_mux = Z22;
        5'b10111: o_mux = Z23;
        5'b11000: o_mux = Z24;
        5'b11001: o_mux = Z25;
        5'b11010: o_mux = Z26;
        5'b11011: o_mux = Z27;
        5'b11100: o_mux = Z28;
        5'b11101: o_mux = Z29;
        5'b11110: o_mux = Z30;
        5'b11111: o_mux = Z31;
    endcase
endmodule
//////////////////////////// ALU module//////////////////////////////


module ALU(
    input [31:0] A, B,
    input Ci,
    input [3:0] OP,
    output reg [31:0] Out,
    output reg Z, N, C, V
);
always @(*) begin
    case(OP)
        4'b0000: {C, Out} = A + B;      // A + B
        4'b0001: {C, Out} = A + B + Ci; // A + B + Ci
        4'b0010: {C, Out} = {1'b0, A} - {1'b0, B};      // A - B
        4'b0011: {C, Out} = {1'b0, A} - {1'b0, B} - Ci; // A - B - Ci
        4'b0100: {C, Out} = {1'b0, B} - {1'b0, A};      // B - A
        4'b0101: Out = A | B;           // A OR B
        4'b0110: Out = A ^ B;           // A XOR B
        4'b0111: Out = A & B;           // A AND B
        4'b1010: Out = A;               // A
        4'b1011: Out = A + 8;           // A + 8
        4'b1100: Out = B;               // B
        default: Out = 32'b0;           // Not used cases
    endcase
   
    // Flags
    Z = (Out == 32'b0) ? 1 : 0;
    N = Out[31];
    V = ((OP == 4'b0000 || OP == 4'b0001) && (~(A[31] ^ B[31]) & (A[31] ^ Out[31]))) |
        ((OP == 4'b0010 || OP == 4'b0011) && ((A[31] ^ B[31]) & (A[31] ^ Out[31])));
end
endmodule
/////////////////////////////////////////////////////////////////////
//////////////////////////// SOH module//////////////////////////////
/////////////////////////////////////////////////////////////////////


module operandhandler ( output reg [31:0] N,  input [31:0] RB,   input [20:0] I,  input [2:0] S);
always @(*) begin
    case (S)
        3'b000: N = RB;
        3'b001: N = {{21{I[0]}}, I[10:1]};
        3'b010: N = {{18{I[0]}}, I[13:1]};
        3'b011: N = {I, 11'b0};
        3'b100: N = RB >> (31 - I[9:5]);
        3'b101: N = $signed(RB) >>> (31 - I[9:5]);  
        3'b110: N = RB << (31 - I[9:5]);  
        default: N = 32'b0;
    endcase
end
endmodule

module CH (
    input wire N, Z, V, C,        // Flags: Negative, Zero, Overflow, Carry
    input wire [2:0] Cond,        // Condition code
    input wire [1:0] B,                 // Enable
    output reg J                  // Jump condition result
);
reg F;
always @(*) begin
    if (B[1]) begin
        case (Cond)
            3'b000: J = 1'b0;                      // Never
            3'b001: J = Z;                         // Equal (Z set)
            3'b010: J = N;                     // Less than (signed)
            3'b011: J = Z | (N ^ V);               // Less or equal (signed)
            3'b100: J = ~C;                        // Less than (unsigned) → no carry = less
            3'b101: J = Z | ~C;                    // Less or equal (unsigned)
            3'b110: J = V;                         // Overflow occurred
            3'b111: J = ~Z & ~V & ~N;              // "Odd" (placeholder logic)
            default: J = 1'b0;
        endcase
    end else if (B[0]) begin
        case (Cond)
            3'b000: F = 1'b0;                      // Never
            3'b001: F = Z;                         // Equal (Z set)
            3'b010: F = N;                     // Less than (signed)
            3'b011: F = Z | (N ^ V);               // Less or equal (signed)
            3'b100: F = ~C;                        // Less than (unsigned) → no carry = less
            3'b101: F = Z | ~C;                    // Less or equal (unsigned)
            3'b110: F = V;                         // Overflow occurred
            3'b111: F = ~Z & ~V & ~N;              // "Odd" (placeholder logic)
            default: F = 1'b1;
        endcase
        J = ~F;
    end else begin
        J = 1'b0;
    end
    $display("*************Cond=%b, B=%b, N=%b, Z=%b, V=%b, C=%b", Cond, B, N, Z, V, C);
end
// display Cond, B, COND Flags

endmodule

module DataMemory (
    input wire clk,
    input wire [7:0] A,      
    input wire [31:0] DI,    
    input wire [1:0] Size,   
    input wire RW,           
    input wire E,            
    output reg [31:0] DO     
);
    
    reg [7:0] mem [0:255];   // Memoria de 256 bytes
    
    initial begin
        $readmemb("SIM_Code/Validation_PA_risc.txt", mem); // Precarga de memoria desde archivo
      //  $display("Archivo cargado correctamente");
    end
    
    always @(*) begin
        if (RW == 0) begin // Operacion de lectura habilitada
            case (Size)
                2'b00: DO = {24'b0, mem[A]}; 
                2'b01: DO = {16'b0, mem[A], mem[A+1]}; 
                2'b10: DO = {mem[A], mem[A+1], mem[A+2], mem[A+3]}; 
                default: DO = 32'b0;
            endcase
       //     $display("READ - A: %0d, DO: %h, Size: %b, RW: %b, E: %b", A, DO, Size, RW, E);
        end
    end
    
    always @(posedge clk) begin
        if (RW == 1 && E == 1) begin // Operación de escritura
            case (Size)
                2'b00: begin
                    mem[A] <= DI[7:0]; 
          //          $display("WRITE - A: %0d, Data: %h, Size: %b, RW: %b, E: %b", A, DI[7:0], Size, RW, E);
                end
                2'b01: begin 
                    mem[A] <= DI[15:8];
                    mem[A+1] <= DI[7:0];
         //           $display("WRITE - A: %0d, Data: %h%h, Size: %b, RW: %b, E: %b", A, DI[15:8], DI[7:0], Size, RW, E);
                end
                2'b10: begin 
                    mem[A] <= DI[31:24];
                    mem[A+1] <= DI[23:16];
                    mem[A+2] <= DI[15:8];
                    mem[A+3] <= DI[7:0];
         //           $display("WRITE - A: %0d, Data: %h%h%h%h, Size: %b, RW: %b, E: %b", A, DI[31:24], DI[23:16], DI[15:8], DI[7:0], Size, RW, E);
                end
            endcase
        end
    end
endmodule

// [ Instruction Memory ]
module InstructionMemory(input [7:0] A, output reg [31:0] I);
    reg [7:0] mem [0:255];
    initial begin
        $readmemb("SIM_Code/Validation_PA_risc.txt", mem);
       // $display("Instruction memory loaded successfully");
    end
    always @(*) begin
        I = {mem[A], mem[A+1], mem[A+2], mem[A+3]};
    end
endmodule

// [ IF/ID Register ]
module IF_ID_Register (
    input Clk, input Reset, input E,
    input [31:0] IF_I, input [31:0] IF_PC,
    output reg [31:0] ID_I, output reg [31:0] ID_PC);
    always @(posedge Clk) begin
        if (Reset) begin
            ID_I <= 0;
            ID_PC <=0;
        end else if (E) begin
            ID_I <= IF_I;
            ID_PC <= IF_PC;
        end
    end
endmodule

// [ Control Unit ]
module ControlUnit(input [31:0] ID_I,
    output reg [1:0] ID_RD_S, ID_Branch_C,
    output reg [2:0] ID_SOH_OP, output reg [3:0] ID_ALU_OP,
    output reg ID_PSW_E, output reg [1:0] ID_SR, ID_ALU_Size,
    output reg ID_ALU_RW, ID_ALU_E,
    output reg ID_Branch_U, ID_LOAD_E, ID_RF_LE, ID_Shift_E);

    always @(*) begin
        case (ID_I[31:26])
            6'b101101: begin // ADDI
                ID_RD_S = 2'b01; ID_Branch_C = 00; ID_SOH_OP = 3'b001;
                ID_ALU_OP = 4'b0000; ID_PSW_E = 1; ID_ALU_Size = 2'b10;
                ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b10;
            end
            6'b100101: begin // SUBI
                ID_RD_S = 2'b01; ID_Branch_C = 00; ID_SOH_OP = 3'b001;
                ID_ALU_OP = 4'b0010; ID_PSW_E = 1; ID_ALU_Size = 2'b10;
                ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b10;
            end
            6'b000010: begin 
                case (ID_I[11:6])
                6'b011000: begin// ADD
                    ID_RD_S = 2'b10; ID_Branch_C = 00; ID_SOH_OP = 3'b000;
                    ID_ALU_OP = 4'b0000; ID_PSW_E = 1; ID_ALU_Size = 2'b00;
                    ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                    ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b11;
                end
                6'b011100: begin// ADDC
                    ID_RD_S = 2'b10; ID_Branch_C = 00; ID_SOH_OP = 3'b000;
                    ID_ALU_OP = 4'b0001; ID_PSW_E = 1; ID_ALU_Size = 2'b00;
                    ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                    ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b11;
                end
                6'b101000: begin// ADDL
                    ID_RD_S = 2'b10; ID_Branch_C = 00; ID_SOH_OP = 3'b000;
                    ID_ALU_OP = 4'b0010; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                    ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                    ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b11;
                end
                6'b010000: begin// SUB
                    ID_RD_S = 2'b10; ID_Branch_C = 00; ID_SOH_OP = 3'b000;
                    ID_ALU_OP = 4'b0010; ID_PSW_E = 1; ID_ALU_Size = 2'b00;
                    ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                    ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b11;
                end
                6'b010100: begin// SUBB
                    ID_RD_S = 2'b10; ID_Branch_C = 00; ID_SOH_OP = 3'b000;
                    ID_ALU_OP = 4'b0011; ID_PSW_E = 1; ID_ALU_Size = 2'b00;
                    ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                    ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b11;
                end
                6'b001001: begin// OR
                    ID_RD_S = 2'b10; ID_Branch_C = 00; ID_SOH_OP = 3'b000;
                    ID_ALU_OP = 4'b0101; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                    ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                    ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b11;
                end
                6'b001010: begin// XOR
                    ID_RD_S = 2'b10; ID_Branch_C = 00; ID_SOH_OP = 3'b000;
                    ID_ALU_OP = 4'b0110; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                    ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                    ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b11;
                end
                6'b001000: begin// AND
                    ID_RD_S = 2'b10; ID_Branch_C = 00; ID_SOH_OP = 3'b000;
                    ID_ALU_OP = 4'b0111; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                    ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                    ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b11;
                end
                default: begin
                    {ID_RD_S, ID_Branch_C, ID_SOH_OP, ID_ALU_OP, ID_PSW_E,
                    ID_ALU_Size, ID_ALU_RW, ID_ALU_E, ID_Branch_U,
                    ID_LOAD_E, ID_RF_LE, ID_Shift_E, ID_SR} = 26'b0;
                end
                endcase
            end
            6'b010010: begin // LDW
                ID_RD_S = 2'b01; ID_Branch_C = 00; ID_SOH_OP = 3'b010;
                ID_ALU_OP = 4'b0000; ID_PSW_E = 0; ID_ALU_Size = 2'b10;
                ID_ALU_RW = 0; ID_ALU_E = 1; ID_Branch_U = 0;
                ID_LOAD_E = 1; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b10;
            end  
            6'b010001: begin // LDH
                ID_RD_S = 2'b01; ID_Branch_C = 00; ID_SOH_OP = 3'b010;
                ID_ALU_OP = 4'b0000; ID_PSW_E = 0; ID_ALU_Size = 2'b01;
                ID_ALU_RW = 0; ID_ALU_E = 1; ID_Branch_U = 0;
                ID_LOAD_E = 1; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b10;
            end            
            6'b010000: begin // LDB
                ID_RD_S = 2'b01; ID_Branch_C = 00; ID_SOH_OP = 3'b010;
                ID_ALU_OP = 4'b0000; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                ID_ALU_RW = 0; ID_ALU_E = 1; ID_Branch_U = 0;
                ID_LOAD_E = 1; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b10;
            end
            6'b001101: begin // LDO
                ID_RD_S = 2'b01; ID_Branch_C = 00; ID_SOH_OP = 3'b010;
                ID_ALU_OP = 4'b0000; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b10;
            end 
            6'b001000: begin // LDIL
                ID_RD_S = 2'b00; ID_Branch_C = 00; ID_SOH_OP = 3'b011;
                ID_ALU_OP = 4'b1010; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b00;
            end   
            6'b011010: begin // STW
                ID_RD_S = 2'b01; ID_Branch_C = 00; ID_SOH_OP = 3'b010;
                ID_ALU_OP = 4'b0000; ID_PSW_E = 0; ID_ALU_Size = 2'b10;
                ID_ALU_RW = 1; ID_ALU_E = 1; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 0; ID_Shift_E = 0; ID_SR = 2'b11;
            end  
            6'b011001: begin // STH
                ID_RD_S = 2'b01; ID_Branch_C = 00; ID_SOH_OP = 3'b010;
                ID_ALU_OP = 4'b0000; ID_PSW_E = 0; ID_ALU_Size = 2'b01;
                ID_ALU_RW = 1; ID_ALU_E = 1; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 0; ID_Shift_E = 0; ID_SR = 2'b11;
            end
            6'b011000: begin // STB
                ID_RD_S = 2'b01; ID_Branch_C = 00; ID_SOH_OP = 3'b010;
                ID_ALU_OP = 4'b0000; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                ID_ALU_RW = 1; ID_ALU_E = 1; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 0; ID_Shift_E = 0; ID_SR = 2'b11;
            end  
            6'b100000: begin // COMBT (salto condicional)
                ID_RD_S = 2'b01; ID_Branch_C = 2'b01; ID_SOH_OP = 3'b000;
                ID_ALU_OP = 4'b0010; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 0; ID_Shift_E = 0; ID_SR = 2'b11;
            end
            6'b100010: begin // COMBF
                ID_RD_S = 2'b01; ID_Branch_C = 2'b10; ID_SOH_OP = 3'b010;
                ID_ALU_OP = 4'b0000; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b11;
            end  
            6'b111010: begin // BL (branch link)
                ID_RD_S = 2'b00; ID_Branch_C = 00; ID_SOH_OP = 3'b000;
                ID_ALU_OP = 4'b1001; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 1;
                ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0; ID_SR = 2'b00;
            end
            6'b110100: begin
                case (ID_I[12:10]) 
                3'b111: begin // EXTRS
                    ID_RD_S = 2'b01; ID_Branch_C = 00; ID_SOH_OP = 3'b101;
                    ID_ALU_OP = 4'b1010; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                    ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                    ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 1; ID_SR = 2'b10;
                end
                3'b110: begin // EXTRU
                    ID_RD_S = 2'b01; ID_Branch_C = 00; ID_SOH_OP = 3'b100;
                    ID_ALU_OP = 4'b1010; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                    ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                    ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 1; ID_SR = 2'b10;
                end
                default: begin
                    {ID_RD_S, ID_Branch_C, ID_SOH_OP, ID_ALU_OP, ID_PSW_E,
                    ID_ALU_Size, ID_ALU_RW, ID_ALU_E, ID_Branch_U,
                    ID_LOAD_E, ID_RF_LE, ID_Shift_E, ID_SR} = 26'b0;
                end
                endcase
            end
            6'b110101: begin
                case (ID_I[12:10]) 
                3'b010: begin // ZDEP
                    ID_RD_S = 2'b01; ID_Branch_C = 00; ID_SOH_OP = 3'b110;
                    ID_ALU_OP = 4'b1010; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                    ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                    ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 1;
                end
                default: begin
                    {ID_RD_S, ID_Branch_C, ID_SOH_OP, ID_ALU_OP, ID_PSW_E,
                    ID_ALU_Size, ID_ALU_RW, ID_ALU_E, ID_Branch_U,
                    ID_LOAD_E, ID_RF_LE, ID_Shift_E, ID_SR} = 26'b0;
                end
                endcase
            end
            6'b000000: begin // NOP
                {ID_RD_S, ID_Branch_C, ID_SOH_OP, ID_ALU_OP, ID_PSW_E,
                ID_ALU_Size, ID_ALU_RW, ID_ALU_E, ID_Branch_U,
                ID_LOAD_E, ID_RF_LE, ID_Shift_E, ID_SR} = 26'b0;
            end
            default: begin
                {ID_RD_S, ID_Branch_C, ID_SOH_OP, ID_ALU_OP, ID_PSW_E,
                ID_ALU_Size, ID_ALU_RW, ID_ALU_E, ID_Branch_U,
                ID_LOAD_E, ID_RF_LE, ID_Shift_E, ID_SR} = 26'b0;
            end
        endcase
    end
endmodule

module Mux_2_11 (input S,
    input [1:0] ID_RD_S, ID_Branch_C,
    input [2:0] ID_SOH_OP, input [3:0] ID_ALU_OP,
    input ID_PSW_E, input [1:0] ID_ALU_Size,
    input ID_ALU_RW, ID_ALU_E,
    input ID_Branch_U, ID_LOAD_E, ID_RF_LE, ID_Shift_E, output reg [1:0] MUX_RD_S, MUX_Branch_C,
    output reg [2:0] MUX_SOH_OP, output reg [3:0] MUX_ALU_OP,
    output reg MUX_PSW_E, output reg [1:0] MUX_ALU_Size,
    output reg MUX_ALU_RW, MUX_ALU_E,
    output reg MUX_Branch_U, MUX_LOAD_E, MUX_RF_LE, MUX_Shift_E);
    always @(*) begin
        if (S) 
            begin
                MUX_RD_S = 2'b00; MUX_Branch_C = 2'b00; MUX_SOH_OP = 3'b000;
                MUX_ALU_OP = 4'b0000; MUX_PSW_E = 0; MUX_ALU_Size = 2'b00;
                MUX_ALU_RW = 0; MUX_ALU_E = 0; MUX_Branch_U = 0;
                MUX_LOAD_E = 0; MUX_RF_LE = 0; MUX_Shift_E = 0; 
            end
        else
            begin 
                MUX_RD_S = ID_RD_S; MUX_Branch_C = ID_Branch_C; MUX_SOH_OP = ID_SOH_OP;
                MUX_ALU_OP = ID_ALU_OP; MUX_PSW_E = ID_PSW_E; MUX_ALU_Size = ID_ALU_Size;
                MUX_ALU_RW = ID_ALU_RW; MUX_ALU_E = ID_ALU_E; MUX_Branch_U = ID_Branch_U;
                MUX_LOAD_E = ID_LOAD_E; MUX_RF_LE = ID_RF_LE; MUX_Shift_E = ID_Shift_E;
            end
    end
endmodule

// [ ID/EX Register ]
module ID_EX_Control ( 
    input Clk, input Reset, input [1:0] MUX_Branch_C,
    input [2:0] MUX_SOH_OP, input [3:0] MUX_ALU_OP,
    input MUX_PSW_E, input [1:0] MUX_ALU_Size,
    input MUX_ALU_RW, MUX_ALU_E, 
    input MUX_Branch_U, MUX_LOAD_E, MUX_RF_LE, MUX_Shift_E, output reg [1:0] EX_Branch_C,
    output reg [2:0] EX_SOH_OP, output reg [3:0] EX_ALU_OP,
    output reg EX_PSW_E, output reg [1:0] EX_ALU_Size,
    output reg EX_ALU_RW, EX_ALU_E,
    output reg EX_Branch_U, EX_LOAD_E, EX_RF_LE, EX_Shift_E);
    initial begin EX_Branch_U = 0; end //don't touch
    always @(posedge Clk) begin
        if (Reset) begin
            EX_Branch_C <= 0; EX_SOH_OP <= 3'b000;
            EX_ALU_OP <= 4'b0000; EX_PSW_E <= 0; EX_ALU_Size <= 2'b00;
            EX_ALU_RW <= 0; EX_ALU_E <= 0; EX_Branch_U <= 0;
            EX_LOAD_E <= 0; EX_RF_LE <= 0; EX_Shift_E <= 0;
        end else begin
            EX_Branch_C <= MUX_Branch_C; EX_SOH_OP <= MUX_SOH_OP;
            EX_ALU_OP <= MUX_ALU_OP; EX_PSW_E <= MUX_PSW_E; EX_ALU_Size <= MUX_ALU_Size;
            EX_ALU_RW <= MUX_ALU_RW; EX_ALU_E <= MUX_ALU_E; EX_Branch_U <= MUX_Branch_U;
            EX_LOAD_E <= MUX_LOAD_E; EX_RF_LE <= MUX_RF_LE; EX_Shift_E <= MUX_Shift_E; 
        end
    end
endmodule

// [ EX/MEM Register ]
module EX_MEM_Control (
    input Clk, input Reset, input [1:0] EX_ALU_Size,
    input EX_ALU_RW, EX_ALU_E, input EX_LOAD_E, EX_RF_LE, output reg [1:0] MEM_ALU_Size,
    output reg MEM_ALU_RW, MEM_ALU_E,
    output reg MEM_LOAD_E, MEM_RF_LE);
    always @(posedge Clk) begin
        if (Reset) begin
            MEM_ALU_Size <= 2'b00; MEM_ALU_RW <= 0; MEM_ALU_E <= 0;
            MEM_LOAD_E <= 0; MEM_RF_LE <= 0;
        end else begin
            MEM_ALU_Size <= EX_ALU_Size; MEM_ALU_RW <= EX_ALU_RW; MEM_ALU_E <= EX_ALU_E;
            MEM_LOAD_E <= EX_LOAD_E; MEM_RF_LE <= EX_RF_LE;
        end
    end
endmodule

// [ MEM/WB Register ]
module MEM_WB_Control (
    input Clk, input Reset, input MEM_RF_LE, output reg WB_RF_LE);
    always @(posedge Clk) begin
        if (Reset) begin
            WB_RF_LE <= 0;
        end else begin
            WB_RF_LE <= MEM_RF_LE;
        end
    end
endmodule

module PPU (input Clk, Reset);
// Clock and Control
wire Clk, Reset, LE;
// IF Stage
wire [31:0] back, back_out;
wire [31:0] IF_1, front, IF_PC;
wire [31:0] IF_I;
wire [31:0] ID_I;
wire [31:0] ID_PC;

// ID Stage
wire [4:0] ID_RD;
wire [4:0] RW;
wire [31:0] ID_PA, ID_PB;
wire [31:0] PA; 
wire [31:0] PB;
wire [31:0] EX_Data_Address;
wire [31:0] MEM_PW;
wire [31:0] WB_PW;
wire [31:0] ID_NEW_PC, ID_Target;

// Control Unit outputs
wire [1:0] ID_RD_S, ID_Branch_C;
wire [2:0] ID_SOH_OP;
wire [3:0] ID_ALU_OP;
wire ID_PSW_E;
wire [1:0] ID_ALU_Size;
wire ID_ALU_RW, ID_ALU_E, ID_Branch_U, ID_LOAD_E, ID_RF_LE, ID_Shift_E;

// MUX outputs (control signals for ID_EX stage)
wire [1:0] MUX_RD_S;
wire [1:0] MUX_Branch_C;
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
wire [31:0] EX_PA, EX_PB;
wire [20:0] EX_Immediate;
wire [31:0] EX_NEW_PC;
wire [31:0] EX_Target;
wire [4:0] EX_RD;
wire [2:0] EX_Cond;

// ID_EX Control
wire [1:0] EX_Branch_C;
wire [2:0] EX_SOH_OP;
wire [3:0] EX_ALU_OP;
wire EX_PSW_E;
wire [1:0] EX_ALU_Size;
wire EX_ALU_RW, EX_ALU_E, EX_Branch_U, EX_Shift_E;

// EX Stage
wire [31:0] SOH_In, SOH_Out;
wire C_B;
wire [31:0] ALU_Out;
wire Z, N, C, V;

// PSW outputs
wire CC;

// Branch Decision
wire J;

// EX/MEM Register
wire [31:0] MEM_PB;
wire [31:0] MEM_Data_Address;
wire [4:0] MEM_RD;

// EX_MEM Control
wire [1:0] MEM_ALU_Size;
wire MEM_ALU_RW, MEM_ALU_E, MEM_Branch_U, MEM_LOAD_E;

// MEM Stage
wire [31:0] MEM_DO;

// MEM_WB Register
wire [4:0] WB_RD;


//IF Stage Begin
PC_Reg #(.PC_Set(4)) Back (Clk, LE, back, back_out);
ADD IF (front, back);
Mux_2 IF1 (IF_1, J, back_out, EX_Target);
Mux_2 IF2 (front, EX_Branch_U, IF_1, EX_Target);
PC_Reg Front (Clk, LE, front, IF_PC);
InstructionMemory IM (IF_PC [7:0], IF_I);
//IF Stage End

IF_ID_Register IF_ID (Clk, Reset, LE, IF_I, IF_PC, ID_I, ID_PC);

//ID Stage Begin
Mux_3 #(.W(5)) RD (ID_RD, ID_RD_S, ID_I [25:21], ID_I [20:16], ID_I [4:0]);
Register_file RF (Clk, WB_RF_LE , ID_I [25:21], ID_I [20:16], WB_RD, WB_PW, PA, PB);
Mux_4 PA_M (ID_PA, A_S, PA, EX_Data_Address, MEM_PW, WB_PW);
Mux_4 PB_M (ID_PB, B_S, PB, EX_Data_Address, MEM_PW, WB_PW);
ADD #(.add(8)) ID (ID_PC, ID_NEW_PC);
Target_Address_Generator TAG (ID_Branch_C, ID_I [20:0], ID_NEW_PC, ID_Target);

//Control System Begin
ControlUnit CU (ID_I, ID_RD_S, ID_Branch_C, ID_SOH_OP, ID_ALU_OP, ID_PSW_E, ID_SR,
ID_ALU_Size, ID_ALU_RW, ID_ALU_E, ID_Branch_U, ID_LOAD_E, ID_RF_LE, ID_Shift_E);
Mux_2_11 MUX_S (NOP, ID_RD_S, ID_Branch_C, ID_SOH_OP, ID_ALU_OP,
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
CH ch (N, Z, V, C, EX_Cond, EX_Branch_C, J);
Mux_2 EX2 (EX_Data_Address, ID_Branch_U, ALU_Out, EX_NEW_PC);
//EX Stage End

EX_MEM_Register EX_MEM (Clk, Reset, EX_PB, EX_Data_Address, EX_RD, MEM_PB, MEM_Data_Address, MEM_RD);
EX_MEM_Control EX_MEM_C (Clk, Reset, EX_ALU_Size, EX_ALU_RW, EX_ALU_E, EX_LOAD_E,
EX_RF_LE, MEM_ALU_Size, MEM_ALU_RW, MEM_ALU_E, MEM_LOAD_E, MEM_RF_LE);

//MEM Stage Begin
DataMemory DM (Clk, MEM_Data_Address [7:0], MEM_PB, MEM_ALU_Size, MEM_ALU_RW, MEM_ALU_E, MEM_DO);
Mux_2 MEM1 (MEM_PW, MEM_LOAD_E, MEM_Data_Address, MEM_DO);
//MEM Stage End

MEM_WB_Register MEM_WB (Clk, Reset, MEM_RF_LE, MEM_PW, MEM_RD, WB_RF_LE, WB_PW, WB_RD);

endmodule