module portin(input clock, reset_n, frame_n, valid_n, di, clear,
   output reg[3:0] addr, output reg [31:0] payload, output reg vld);

reg [5:0] cnta, cntp;

always@(posedge clock, posedge clear, negedge reset_n)
   if(!reset_n)
   begin
      cnta <=0; //address counter
      cntp <=0; //payload counter
      vld <= 0; //valid output
      payload <= 32'h0000_00000;
   end
   else if(clear)
   begin
      vld <= 0;
      cnta <= 0;
      cntp <= 0;
      payload <= 32'h0000_00000;
   end
   else begin
      if(!frame_n && valid_n) begin
         if(cnta < 4) addr [cnta] <=di;
         cnta <= cnta + 1;
      end
      else if(!frame_n && !valid_n) begin
         if(cntp < 32) payload[cntp] <= di;
         cntp <= cntp + 1;
      end
      else if(frame_n && !valid_n) begin
         payload[cntp] <= di;
         vld <= 1;
         cnta <= 0;
         cntp <= 0;
         $strobe("DBG: %t:%d %h", $time, addr, payload);
      end
      else begin
         vld <= 0;
         cnta <= 0;
         cntp <= 0;
      end
   end
endmodule     
