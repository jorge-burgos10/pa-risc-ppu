module InstructionMemory (
    input wire [7:0] A,      
    output reg [31:0] I      
);
    
    reg [7:0] mem [0:255];   
    
    
    initial begin
        $readmemb("file_precarga_fase_I.txt", mem); 
        $display("Archivo de instrucciones cargado correctamente");
    end
    
    // Operación de lectura - Se leen 4 bytes en big-endian
    always @(*) begin
        I = {mem[A], mem[A+1], mem[A+2], mem[A+3]};
        $display("READ - A: %0d, I: %h", A, I);
    end
endmodule
