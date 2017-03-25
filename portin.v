module portin(input clock, reset_n, frame_n, valid_n, di, clear,
   output reg[3:0] addr, output reg [31:0] payload, output reg vld);

reg [5:0] cnta, cntp;
reg [3:0] inc_addr;
reg [31:0] inc_payload;

always@(posedge clock, posedge clear, negedge reset_n)
   if(!reset_n)
   begin
      cnta <=0; //address counter
      cntp <=0; //payload counter
      vld <= 0; //valid output
      payload <= 32'h0000_0000;
      inc_payload <= 32'h0000_0000;
      inc_addr <= 0;
   end
   else if(clear)
   begin
      vld <= 0;
      cnta <= 0;
      cntp <= 0;
      payload <= 32'h0000_0000;
      inc_payload <= 32'h0000_0000;
      payload <= 32'h0000_0000;
   end
   else begin
      if(!frame_n && valid_n) begin //address read cycle
         if(cnta < 4) inc_addr [cnta] <=di;
         cnta <= cnta + 1;
      end
      else if(!frame_n && !valid_n) begin //payload read cycle
         if(cntp < 32) inc_payload[cntp] <= di;
         cntp <= cntp + 1;
      end
      else if(frame_n && !valid_n) begin
         payload <= {di, inc_payload[30:0]};
         inc_payload[cntp] <= di;
         addr <= inc_addr;
         vld <= 1;
         cnta <= 0;
         cntp <= 0;
         $strobe("DBG: %t:%d %h", $time, addr, payload);
      end
      else begin
         vld <= 0;
         cnta <= 0;
         cntp <= 0;
         inc_payload <= 32'h0000_0000;
         inc_addr <= 0;
      end
   end
endmodule     
