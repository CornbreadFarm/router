module portout(input [31:0] payload, input rdy, clock, reset_n, output reg frameo_n, valido_n, dout, pop);

reg [5:0] count;
reg [31:0] saved_payload;
reg  state;
parameter WAIT = 1'b0, READ_PAYLOAD = 1'b1;

always @(posedge clock, negedge reset_n)
begin
   if(!reset_n) begin
      dout <= 0;
      frameo_n <= 1;
      valido_n <= 1;
      pop <= 0;
      count <= 0;
      saved_payload <= 32'h0000_0000;
      state <= WAIT;
   end
   else
      case(state)
      WAIT:
         if(rdy) begin
            pop <= 1;
            saved_payload <= payload;
            state <= READ_PAYLOAD;            
         end
         else begin
            pop <= 0;
            dout <= 0;
            frameo_n <= 1;
            valido_n <= 1;
            count <= 0;
            saved_payload <= 32'h0000_0000; 
            state <= WAIT;
         end

      READ_PAYLOAD: 
         if(count <= 31) begin
            pop <= 0;
            dout <= saved_payload[count];
            count <= count + 1;
            frameo_n <= 0;
            valido_n <= 0;
            state <= READ_PAYLOAD;
         end
         else begin
            pop <= 0;
            dout <= 0;
            count <= 0;
            frameo_n <= 1;
            valido_n <= 1;
            saved_payload <= 32'h0000_0000;
            state <= WAIT;
         end
      endcase
end
endmodule
