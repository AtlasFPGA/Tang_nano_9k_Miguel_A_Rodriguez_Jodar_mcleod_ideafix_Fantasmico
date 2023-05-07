module clock_divider_x10(
   input           clk,     // 50MHz clock input. reloj de 252 MHz
   output reg      clk2     // new 25.2MHz clock  
    );

reg [2:0] count;

// clock divider 252MHz to 25.2MHz
always@(posedge clk)
    begin
        if(count==3'd4)      // counts 5 clk cycles (0 thru 4)
            begin            
              count<=0;        
              clk2 <= ~clk2;   // toggles clk2 to hi or lo
            end
        else
            begin
              count<=count+1; 
            end              
    end 
endmodule