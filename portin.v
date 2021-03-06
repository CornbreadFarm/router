module portin(input clock, reset_n, frame_n, valid_n, di, granted,
   output reg[3:0] addr, output reg [31:0] payload, output vld);

reg [5:0] cnta, cntp;
reg [3:0] inc_addr;
reg [31:0] inc_payload;
reg vld_r;

assign vld = vld_r && !granted;

always@(posedge clock, /*posedge granted,*/ negedge reset_n)
   if(!reset_n)
   begin
      cnta <=0; //address counter
      cntp <=0; //payload counter
      vld_r <= 0; //valid output
      payload <= 32'h0000_0000;
      inc_payload <= 32'h0000_0000;
      inc_addr <= 0;
   end
   else begin
      if(!frame_n && valid_n) begin //portin reads address from di
         if(cnta < 4) inc_addr[cnta] <=di;
         cnta <= cnta + 1;
      end
      else if(!frame_n && !valid_n) begin //portin reads payload from di
         if(cntp < 32) inc_payload[cntp] <= di;
         cntp <= cntp + 1;
      end
      else if(frame_n && !valid_n) begin
         payload <= {di, inc_payload[30:0]};
         inc_payload[cntp] <= di;
         addr <= inc_addr;
         vld_r <= 1;
         cnta <= 0;
         cntp <= 0;
         $strobe("DBG: %t:%d %h", $time, addr, payload);
      end
      if(granted)
         vld_r <=0;
   end
endmodule     
