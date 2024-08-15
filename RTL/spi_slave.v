module spi_slave(clk, rst_n, SS_n, MOSI, MISO, rx_data, rx_valid, tx_data, tx_valid);
    parameter IDLE      = 3'b000, 
              CHK_CMD   = 3'b001, 
              WRITE     = 3'b010,
              READ_ADD  = 3'b011,
              READ_DATA = 3'b100;

    input clk, rst_n, SS_n, MOSI;
    output reg MISO;

    input [7:0] tx_data;
    input tx_valid; 

    output reg [9:0] rx_data;
    output rx_valid;   

    (*fsm_encoding = "gray"*)
    reg [2:0] cs, ns;
    reg addr_rd_recived;

    ////////////////////
    //next state logic//
    ////////////////////
    always @(*) begin
        case (cs)
            IDLE:
                if(~SS_n)
                    ns = CHK_CMD;
                else
                    ns = IDLE;      
            CHK_CMD:
                if(~SS_n)
                    if(~MOSI)
                        ns = WRITE;
                    else if(MOSI)
                        if(addr_rd_recived)
                            ns = READ_DATA;
                        else
                            ns = READ_ADD;
                else
                    ns = IDLE;    
            WRITE:   
                if(~SS_n) begin
                    ns = WRITE;
                end
                else
                    ns = IDLE;   
            READ_ADD:
                if(~SS_n)
                    ns = READ_ADD;
                else
                    ns = IDLE;   
            READ_DATA: 
                if(~SS_n)
                        ns = READ_DATA;
                    else
                        ns = IDLE;  
            default: 
                ns = IDLE; 
        endcase
    end
    

    //////////////// 
    //state memory//
    ////////////////
    always @(posedge clk) begin
        if(~rst_n) 
            cs <= IDLE;
        else 
            cs <= ns;     
    end

    ////////////////
    //output logic//
    ////////////////
    reg [3:0] counter_to_10, counter_to_8;
    
    always @(posedge clk) begin
        if(~rst_n) begin
           counter_to_10   <= 0;
           counter_to_8    <= 0;
           rx_data         <= 0;
           addr_rd_recived <= 0;
           MISO            <= 0;
        end
        else begin
            case(cs) 
                IDLE: begin
                    MISO          <= 0;
                    rx_data       <= 0;
                    counter_to_10 <= 0;
                    counter_to_8  <= 0;
                end

                WRITE, READ_ADD:
                    if(counter_to_10 < 10) begin
                        rx_data[9-counter_to_10] <= MOSI;
                        counter_to_10 <= counter_to_10 + 1;
                        
                    end 
                    else if(cs == READ_ADD)
                        addr_rd_recived <= 1;   

                READ_DATA: begin
                    if(counter_to_10 < 10) begin
                        rx_data[9-counter_to_10] <= MOSI;
                        counter_to_10 <= counter_to_10 + 1;
                    end 

                    if(counter_to_8 < 8 && tx_valid) begin
                        MISO <= tx_data[7-counter_to_8];
                        counter_to_8 <= counter_to_8 + 1;
                    end
                    else 
                        MISO <= 0;

                end
            endcase
        end
    end

    assign rx_valid = (counter_to_10 == 10 && cs != IDLE && ~tx_valid) ? 1'b1 : 1'b0;

endmodule