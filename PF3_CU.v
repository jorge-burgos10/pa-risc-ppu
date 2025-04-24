module Fase3_TB;
    reg Clk = 0, Reset = 1, E = 1, S = 0;
    reg [7:0] front = 0, back = 4; reg [8*8:1] keyword;
    wire [31:0] IF_I;
    wire [7:0] ID_front;
    wire [1:0] ID_RD_S;
    wire ID_Branch_C;
    wire [2:0] ID_SOH_OP;
    wire [3:0] ID_ALU_OP;
    wire ID_PSW_E;
    wire [1:0] ID_ALU_Size;
    wire ID_ALU_RW, ID_ALU_E, ID_Branch_U, ID_LOAD_E, ID_RF_LE, ID_Shift_E;
    wire [31:0] ID_I;
    wire [1:0] MUX_RD_S;
    wire MUX_Branch_C;
    wire [2:0] MUX_SOH_OP;
    wire [3:0] MUX_ALU_OP;
    wire MUX_PSW_E;
    wire [1:0] MUX_ALU_Size;
    wire MUX_ALU_RW, MUX_ALU_E, MUX_Branch_U, MUX_LOAD_E, MUX_RF_LE, MUX_Shift_E;
    wire EX_Branch_C;
    wire [2:0] EX_SOH_OP;
    wire [3:0] EX_ALU_OP;
    wire EX_PSW_E;
    wire [1:0] EX_ALU_Size;
    wire EX_ALU_RW, EX_ALU_E, EX_Branch_U, EX_LOAD_E, EX_RF_LE, EX_Shift_E;
    wire [1:0] MEM_ALU_Size;
    wire MEM_ALU_RW, MEM_ALU_E, MEM_Branch_U, MEM_LOAD_E, MEM_RF_LE;
    wire WB_RF_LE;

     // Memoria de instrucciones
    InstructionMemory IM(front, IF_I);

    //IF_ID Register
    IF_ID_Register IF_ID(Clk, Reset, E, IF_I, front, ID_I, ID_front);

    // Unidad de control
    ControlUnit CU(ID_I, ID_RD_S, ID_Branch_C, ID_SOH_OP, ID_ALU_OP, ID_PSW_E,
    ID_ALU_Size, ID_ALU_RW, ID_ALU_E, ID_Branch_U, ID_LOAD_E, ID_RF_LE, ID_Shift_E);

    //MUX_S
    Mux_2_11 MUX_S(S, ID_RD_S, ID_Branch_C, ID_SOH_OP, ID_ALU_OP,
    ID_PSW_E, ID_ALU_Size, ID_ALU_RW, ID_ALU_E, ID_Branch_U, ID_LOAD_E,
    ID_RF_LE, ID_Shift_E, MUX_RD_S, MUX_Branch_C, MUX_SOH_OP, MUX_ALU_OP, MUX_PSW_E,
    MUX_ALU_Size, MUX_ALU_RW, MUX_ALU_E, MUX_Branch_U, MUX_LOAD_E, MUX_RF_LE, MUX_Shift_E);

    //ID_EX Control Register
    ID_EX_Control ID_EX(Clk, Reset, MUX_Branch_C, MUX_SOH_OP, MUX_ALU_OP, MUX_PSW_E,
    MUX_ALU_Size, MUX_ALU_RW, MUX_ALU_E, MUX_Branch_U, MUX_LOAD_E, MUX_RF_LE, MUX_Shift_E, EX_Branch_C,
    EX_SOH_OP, EX_ALU_OP, EX_PSW_E, EX_ALU_Size,EX_ALU_RW, EX_ALU_E, EX_Branch_U,
    EX_LOAD_E, EX_RF_LE, EX_Shift_E);

    //EX_MEM Control Register
    EX_MEM_Control EX_MEM(Clk, Reset, EX_ALU_Size, EX_ALU_RW, EX_ALU_E, EX_Branch_U, EX_LOAD_E,
    EX_RF_LE, MEM_ALU_Size, MEM_ALU_RW, MEM_ALU_E, MEM_Branch_U, MEM_LOAD_E, MEM_RF_LE);

    //MEM/WB Control Register
    MEM_WB_Control MEM_WB(Clk, Reset, MEM_RF_LE, WB_RF_LE);


    // Reloj
    always #2 Clk = ~Clk;

    initial begin
        $display("Simulation started");
        #3 Reset = 0;
        #45 E = 0;
        #12 S = 1;
        #20 $finish;
    end

    always @(posedge Clk) begin
        if (!Reset) begin
            if(E) begin
            front <= back;
            back <= back + 4;
            end

            // Decodificar nombre de instrucción (keyword)
        if(S)
            keyword = "NOP";
        else begin
            case (ID_I[31:26])
                6'b101101: keyword = "ADDI";
                6'b000010: keyword = "SUB";
                6'b010000: keyword = "LDB";
                6'b011001: keyword = "STH";
                6'b100000: keyword = "COMBT";
                6'b001000: keyword = "LDIL";
                6'b111010: keyword = "BL";
                6'b110100: keyword = "EXTRS";
                6'b000000: keyword = "NOP";
                default: keyword = "UNKNOWN";
            endcase
        end
            //end

            // Línea principal con keyword, front y señales de control
            $display("%s - Front: %0d\n", 
                    keyword, front);
            $display("Control Unit Output: \tALU_OP=%b SOH_OP=%b PSW_E=%b B_U=%b B_C=%b MEM_Size=%b MEM_RW=%b MEM_E=%b MUX_E=%b RF_LE=%b RD_S=%b Shift_E=%b\n", 
                    MUX_ALU_OP, MUX_SOH_OP, MUX_PSW_E, MUX_Branch_U, MUX_Branch_C, MUX_ALU_Size, MUX_ALU_RW, MUX_LOAD_E, MUX_ALU_E, MUX_RF_LE, MUX_RD_S, MUX_Shift_E);
            $display("Control signals (EX): \tALU_OP=%b SOH_OP=%b PSW_E=%b B_U=%b B_C=%b MEM_Size=%b MEM_RW=%b MEM_E=%b MUX_E=%b RF_LE=%b Shift_E=%b\n",
                    EX_ALU_OP, EX_SOH_OP, EX_PSW_E, EX_Branch_U, EX_Branch_C, EX_ALU_Size, EX_ALU_RW, EX_LOAD_E, EX_ALU_E, EX_RF_LE, EX_Shift_E);
            $display("Control signals (MEM): \tMEM_Size=%b MEM_RW=%b MEM_E=%b MUX_E=%b RF_LE=%b\n",
                    MEM_ALU_Size, MEM_ALU_RW, MEM_ALU_E, MEM_LOAD_E, MEM_RF_LE);
            $display("Control signals (WB): \tRF_LE=%b\n",
                    WB_RF_LE);
            $display("LE=%b S=%b", E, S);
            $display("=========================");
        end
    end

endmodule    


// [ Instruction Memory ]
module InstructionMemory(input [7:0] A, output reg [31:0] I);
    reg [7:0] mem [0:255];
    initial begin
        $readmemb("Fase_III_code.txt", mem);
        $display("Instruction memory loaded successfully");
    end
    always @(*) begin
        I = {mem[A], mem[A+1], mem[A+2], mem[A+3]};
    end
endmodule

// [ IF/ID Register ]
module IF_ID_Register (
    input Clk, input Reset, input E,
    input [31:0] IF_I, input [7:0] IF_PC,
    output reg [31:0] ID_I, output reg [7:0] ID_PC);
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
    output reg [1:0] ID_RD_S, output reg ID_Branch_C,
    output reg [2:0] ID_SOH_OP, output reg [3:0] ID_ALU_OP,
    output reg ID_PSW_E, output reg [1:0] ID_ALU_Size,
    output reg ID_ALU_RW, ID_ALU_E,
    output reg ID_Branch_U, ID_LOAD_E, ID_RF_LE, ID_Shift_E);

    always @(*) begin
        case (ID_I[31:26])
            6'b101101: begin // ADDI
                ID_RD_S = 2'b01; ID_Branch_C = 0; ID_SOH_OP = 3'b001;
                ID_ALU_OP = 4'b0000; ID_PSW_E = 1; ID_ALU_Size = 2'b10;
                ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0;
            end
            6'b000010: begin // SUB
                ID_RD_S = 2'b10; ID_Branch_C = 0; ID_SOH_OP = 3'b000;
                ID_ALU_OP = 4'b0010; ID_PSW_E = 1; ID_ALU_Size = 2'b00;
                ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0;
            end
            6'b010000: begin // LDB
                ID_RD_S = 2'b01; ID_Branch_C = 0; ID_SOH_OP = 3'b010;
                ID_ALU_OP = 4'b0000; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                ID_ALU_RW = 0; ID_ALU_E = 1; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0;
            end
            6'b011001: begin // STH
                ID_RD_S = 2'b01; ID_Branch_C = 0; ID_SOH_OP = 3'b010;
                ID_ALU_OP = 4'b0000; ID_PSW_E = 0; ID_ALU_Size = 2'b01;
                ID_ALU_RW = 1; ID_ALU_E = 0; ID_Branch_U = 0;
                ID_LOAD_E = 1; ID_RF_LE = 0; ID_Shift_E = 0;
            end
            6'b100000: begin // COMBT (salto condicional)
                ID_RD_S = 2'b01; ID_Branch_C = 1; ID_SOH_OP = 3'b000;
                ID_ALU_OP = 4'b0010; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 0; ID_Shift_E = 0;
            end
            6'b001000: begin // LDIL
                ID_RD_S = 2'b00; ID_Branch_C = 0; ID_SOH_OP = 3'b011;
                ID_ALU_OP = 4'b1010; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0;
            end
            6'b111010: begin // BL (branch link)
                ID_RD_S = 2'b00; ID_Branch_C = 0; ID_SOH_OP = 3'b000;
                ID_ALU_OP = 4'b1001; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 1;
                ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 0;
            end
            6'b110100: begin // EXTRS
                ID_RD_S = 2'b01; ID_Branch_C = 0; ID_SOH_OP = 3'b101;
                ID_ALU_OP = 4'b1010; ID_PSW_E = 0; ID_ALU_Size = 2'b00;
                ID_ALU_RW = 0; ID_ALU_E = 0; ID_Branch_U = 0;
                ID_LOAD_E = 0; ID_RF_LE = 1; ID_Shift_E = 1;
            end
            6'b000000: begin // NOP
                {ID_RD_S, ID_Branch_C, ID_SOH_OP, ID_ALU_OP, ID_PSW_E,
                ID_ALU_Size, ID_ALU_RW, ID_ALU_E, ID_Branch_U,
                ID_LOAD_E, ID_RF_LE, ID_Shift_E} = 23'b0;
            end
            default: begin
                {ID_RD_S, ID_Branch_C, ID_SOH_OP, ID_ALU_OP, ID_PSW_E,
                ID_ALU_Size, ID_ALU_RW, ID_ALU_E, ID_Branch_U,
                ID_LOAD_E, ID_RF_LE, ID_Shift_E} = 23'b0;
            end
        endcase
    end
endmodule

module Mux_2_11 (input S,
    input [1:0] ID_RD_S, input ID_Branch_C,
    input [2:0] ID_SOH_OP, input [3:0] ID_ALU_OP,
    input ID_PSW_E, input [1:0] ID_ALU_Size,
    input ID_ALU_RW, ID_ALU_E,
    input ID_Branch_U, ID_LOAD_E, ID_RF_LE, ID_Shift_E, output reg [1:0] MUX_RD_S, output reg MUX_Branch_C,
    output reg [2:0] MUX_SOH_OP, output reg [3:0] MUX_ALU_OP,
    output reg MUX_PSW_E, output reg [1:0] MUX_ALU_Size,
    output reg MUX_ALU_RW, MUX_ALU_E,
    output reg MUX_Branch_U, MUX_LOAD_E, MUX_RF_LE, MUX_Shift_E);
    always @(*) begin
        if (S) 
            begin
                MUX_RD_S = 2'b00; MUX_Branch_C = 0; MUX_SOH_OP = 3'b000;
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
    input Clk, input Reset, input MUX_Branch_C,
    input [2:0] MUX_SOH_OP, input [3:0] MUX_ALU_OP,
    input MUX_PSW_E, input [1:0] MUX_ALU_Size,
    input MUX_ALU_RW, MUX_ALU_E, 
    input MUX_Branch_U, MUX_LOAD_E, MUX_RF_LE, MUX_Shift_E, output reg EX_Branch_C,
    output reg [2:0] EX_SOH_OP, output reg [3:0] EX_ALU_OP,
    output reg EX_PSW_E, output reg [1:0] EX_ALU_Size,
    output reg EX_ALU_RW, EX_ALU_E,
    output reg EX_Branch_U, EX_LOAD_E, EX_RF_LE, EX_Shift_E);
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
    input EX_ALU_RW, EX_ALU_E, input EX_Branch_U, EX_LOAD_E, EX_RF_LE, output reg [1:0] MEM_ALU_Size,
    output reg MEM_ALU_RW, MEM_ALU_E,
    output reg MEM_Branch_U, MEM_LOAD_E, MEM_RF_LE);
    always @(posedge Clk) begin
        if (Reset) begin
            MEM_ALU_Size <= 2'b00; MEM_ALU_RW <= 0; MEM_ALU_E <= 0;
            MEM_Branch_U <= 0; MEM_LOAD_E <= 0; MEM_RF_LE <= 0;
        end else begin
            MEM_ALU_Size <= EX_ALU_Size; MEM_ALU_RW <= EX_ALU_RW; MEM_ALU_E <= EX_ALU_E;
            MEM_Branch_U <= EX_Branch_U; MEM_LOAD_E <= EX_LOAD_E; MEM_RF_LE <= EX_RF_LE;
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