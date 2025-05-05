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
            3'b010: J = N;                         // Less than (signed)
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
            3'b010: F = N;                         // Less than (signed)
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
end
endmodule




module top_module;


    // Internal wires
    wire [31:0] A;
    wire [31:0] B_from_operandhandler;
    wire [31:0] Out;


    // Flag wires
    wire Z_From_ALU;
    wire N_From_ALU;
    wire V_From_ALU;
    wire CC_From_ALU;


    // PSW
    wire E;
    wire cb;


    // Control signals
    wire [31:0] RB;
    wire [20:0] I;
    wire [2:0] S;
    wire Ci;
    wire [3:0] OP;


    // Condition Handler
    wire [2:0] Cond;        
    wire B;                 
    wire J;                  


    // Instantiate operandhandler
    operandhandler u_operandhandler (
        .N(B_from_operandhandler),
        .RB(RB),
        .I(I),
        .S(S)
    );


    // Instantiate ALU
    ALU u_alu (
        .A(A),
        .B(B_from_operandhandler),
        .Ci(Ci), 
        .OP(OP),
        .Out(Out),
        .Z(Z_From_ALU),
        .N(N_From_ALU),
        .C(CC_From_ALU),
        .V(V_From_ALU)
    );


    // Instantiate PSW
    PSW u_psw (
        .E(E),
        .cb(cb),
        .CC(CC_From_ALU)
    );


    // Instantiate CH
    CH u_CH (
        .N(N_From_ALU),
        .Z(Z_From_ALU),
        .V(V_From_ALU),
        .C(CC_From_ALU),
        .Cond(Cond),
        .B(B),
        .J(J)
    );


endmodule