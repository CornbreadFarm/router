module router(input clock,  reset_n, input [7:0]frame_n, valid_n, di,
   output [7:0] dout, valido_n, frameo_n);


wire [31:0] dout_from_portin;
wire [3:0] addr_from_portin;
wire [7:0] vld_from_portin;

wire [31:0] payload_from_switch[7:0];

wire [7:0] grant_from_arbiter;
 
wire [31:0] dout_from_fifo[7:0]; 
wire [7:0] ready_from_fifo, full_from_fifo;
 
wire [7:0] pop_from_portout;
 
//input port
portin portin0(.clock(clock), .reset_n(reset_n), .frame_n(frame_n[0]),
   .valid_n(valid_n[0]), .di(di[0]), .addr(addr_from_portin),
   .payload(dout_from_portin), .vld(vld_from_portin[0]));

//DW_arb_rr arbiter(.clock(clock))

//generate loop instantiates output ports
genvar i; 
generate for(i=0;i<8;i=i+1) begin: inst

   fifo fifo(.clock(clock), .reset_n(reset_n), .din(payload_from_switch[i]), .pop(pop_from_portout[i]), .push(vld_from_portin[i]), .dout(dout_from_fifo[i])); //inst[i].fifo

   portout portout(.payload(dout_from_fifo[i]), .rdy(ready_from_fifo[i]), .clock(clock),
      .reset_n(reset_n), .frameo_n(frameo_n[i]), .valido_n(valido_n[i]),
      .dout(dout[i]), .pop(pop_from_portout[i])); //inst[i].portout()
   end

endgenerate

endmodule
