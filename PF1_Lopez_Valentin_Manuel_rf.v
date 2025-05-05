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