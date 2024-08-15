module spr(clk, rst_n, din, rx_valid, dout, tx_valid);
    parameter MEM_DEPTH = 256,
              ADDR_SIZE = 8;
    input clk, rst_n, rx_valid;
    input [9:0] din; 
    
    output reg tx_valid;
    output reg [7:0] dout;

    reg [7:0] mem [MEM_DEPTH-1:0];
    reg [ADDR_SIZE-1:0] addr_wr, addr_rd;

    always @(posedge clk) begin
        if(~rst_n) begin
            dout <=0;
            tx_valid <= 0;
            addr_rd <= 0;
            addr_wr <= 0;
        end
        else if(rx_valid) begin
            case (din[9:8])
                2'b00: 
                    addr_wr <= din[7:0];    
                2'b01:
                    mem[addr_wr] <= din[7:0];
                2'b10:
                    addr_rd <= din[7:0];
                2'b11:
                    dout <= mem[addr_rd]; 
            endcase
            if(din[9:8] == 2'b11) 
                tx_valid <= 1;
            else
                tx_valid <= 0;
        end
        
    end

endmodule