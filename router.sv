module router(input clock,  reset_n, input [7:0]frame_n, valid_n, di,
   output [7:0] dout, valido_n, frameo_n);


wire [31:0] dout_from_portin [7:0];
wire [3:0] addr_from_portin [7:0];
wire [7:0] vld_from_portin;

wire [7:0] grant_from_arbiter;

wire [31:0] payload_from_switch[7:0];
wire [7:0] push_from_switch;
 
wire [31:0] dout_from_fifo[7:0]; 
wire [7:0] ready_from_fifo, full_from_fifo;
 
wire [7:0] pop_from_portout;
 
//input port

DW_arb_rr #(8,1,0) arbiter(.clk(clock), .rst_n(reset_n), .init_n(1'b1), .enable(1'b1), .request(vld_from_portin), .mask(8'b0000_0000), .grant(grant_from_arbiter), .granted(), .grant_index());

switch_fabric switch_fabric(.din(dout_from_portin), .addr(addr_from_portin), .grant(grant_from_arbiter), .dout(payload_from_switch), .push(push_from_switch));

//generate loop instantiates output ports
genvar i; 
generate for(i=0;i<8;i=i+1) begin: inst
   portin portin(.clock(clock), .reset_n(reset_n), .frame_n(frame_n[i]),
      .valid_n(valid_n[i]), .di(di[i]), .granted(grant_from_arbiter[i]),
      .addr(addr_from_portin[i]), .payload(dout_from_portin[i]),
      .vld(vld_from_portin[i]));

   fifo fifo(.clock(clock), .reset_n(reset_n), .din(payload_from_switch[i]),
      .pop(pop_from_portout[i]), .push(push_from_switch[i]),
      .dout(dout_from_fifo[i]), .empty(), .full(),
      .ready(ready_from_fifo[i])); //inst[i].fifo()

   portout portout(.payload(dout_from_fifo[i]), .rdy(ready_from_fifo[i]),
      .clock(clock), .reset_n(reset_n), .frameo_n(frameo_n[i]),
      .valido_n(valido_n[i]), .dout(dout[i]), .pop(pop_from_portout[i]));
      //inst[i].portout()
   end

endgenerate

endmodule
