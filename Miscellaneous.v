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

module ADD #(parameter add = 4, W = 8) (input [W-1:0] add_in, output reg [W-1:0] add_out);
    always @ (*) begin
    add_out = add_in + add;
    end
endmodule