module portout(input [31:0] payload, input rdy, clock, reset_n, output reg frameo_n, valido_n, dout, pop);

reg [5:0] cntp;
reg state;
parameter S0 = 1'b0, S1 = 1'b1;

always @(posedge clock, negedge reset_n)
begin
   if(!reset_n) begin
      dout <= 0;
      frameo_n <= 1;
      valido_n <= 1;
      pop <= 0;
      cntp <= 0;
      state <= S0;
   end
   else
      case(state)
      S0:
         if(rdy) begin
            pop <= 1;
            state <= S1;            
         end
         else begin
            dout <= 0;
            frameo_n <= 1;
            valido_n <= 1;
            pop <= 0;
            cntp <= 0; 
            state <= S0;
         end

      S1: 
         if(cntp < 32) begin
            pop <= 0;
            dout <= payload[cntp];
            cntp <= cntp + 1;
            frameo_n <= 0;
            valido_n <= 0;
            state <= S1;
         end
         else begin
            cntp <= 0;
            pop <= 0;
            dout <= 0;
            frameo_n <= 1;
            valido_n <= 1;
            state <= S0;
         end
      endcase
end
endmodule
