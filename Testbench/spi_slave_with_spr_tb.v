module spi_slave_with_spr_tb; 
    reg clk, rst_n, SS_n, MOSI;
    wire MISO;

    spi_slave_with_spr dut(clk, rst_n, SS_n, MOSI, MISO);

    initial begin
        clk = 0;
        forever 
            #1 clk = ~clk;
    end
    
    initial begin
        SS_n = 1;
        MOSI = 0;
        rst_n = 0;
        @(negedge clk);
        rst_n = 1;

        // Write Addr.
        SS_n = 0;
        @(negedge clk); MOSI = 0;

        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 0;
    
        @(negedge clk); MOSI = 1;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 1;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 1;
        @(negedge clk); MOSI = 1;
        @(negedge clk);
        SS_n = 1;

        @(negedge clk);

        // Write Data
        SS_n = 0;
        @(negedge clk); MOSI = 0;

        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 1;
        
        @(negedge clk); MOSI = 1;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 1;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 1;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 1;
        @(negedge clk); MOSI = 1;
        @(negedge clk);
        SS_n = 1;

        @(negedge clk);
        
        // Read Addr.
        SS_n = 0;
        @(negedge clk); MOSI = 1;

        @(negedge clk); MOSI = 1;
        @(negedge clk); MOSI = 0;

        @(negedge clk); MOSI = 1;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 1;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 1;
        @(negedge clk); MOSI = 1;
        @(negedge clk);
        SS_n = 1;
        @(negedge clk);

        // Read Data
        SS_n = 0; 
        @(negedge clk); MOSI = 1;

        @(negedge clk); MOSI = 1;
        @(negedge clk); MOSI = 1;
          //-- dummy data --//
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 0;
        @(negedge clk); MOSI = 1;
          //----------------//
        @(negedge clk);

        repeat(9)
            @(negedge clk);
        SS_n = 1;

        repeat(3)
            @(negedge clk)
        $stop;
    end
endmodule
