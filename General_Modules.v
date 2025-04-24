module PC_Reg (input Clk, LE, input [7:0] PC_in, output reg [7:0] PC_out);
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
