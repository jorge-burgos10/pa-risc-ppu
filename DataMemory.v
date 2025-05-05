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
        $readmemb("SIM_Code/file_precarga_fase_I.txt", mem); // Precarga de memoria desde archivo
        $display("Archivo cargado correctamente");
    end
    
    always @(*) begin
        if (RW == 0) begin // Operacion de lectura habilitada
            case (Size)
                2'b00: DO = {24'b0, mem[A]}; 
                2'b01: DO = {16'b0, mem[A], mem[A+1]}; 
                2'b10: DO = {mem[A], mem[A+1], mem[A+2], mem[A+3]}; 
                default: DO = 32'b0;
            endcase
            $display("READ - A: %0d, DO: %h, Size: %b, RW: %b, E: %b", A, DO, Size, RW, E);
        end else if (RW == 1 && E == 1) begin // Operación de escritura
            case (Size)
                2'b00: begin
                    mem[A] = DI[7:0]; 
                    $display("WRITE - A: %0d, Data: %h, Size: %b, RW: %b, E: %b", A, DI[7:0], Size, RW, E);
                end
                2'b01: begin 
                    mem[A] = DI[15:8];
                    mem[A+1] = DI[7:0];
                    $display("WRITE - A: %0d, Data: %h%h, Size: %b, RW: %b, E: %b", A, DI[15:8], DI[7:0], Size, RW, E);
                end
                2'b10: begin 
                    mem[A] = DI[31:24];
                    mem[A+1] = DI[23:16];
                    mem[A+2] = DI[15:8];
                    mem[A+3] = DI[7:0];
                    $display("WRITE - A: %0d, Data: %h%h%h%h, Size: %b, RW: %b, E: %b", A, DI[31:24], DI[23:16], DI[15:8], DI[7:0], Size, RW, E);
                end
            endcase
        end
    end
endmodule
