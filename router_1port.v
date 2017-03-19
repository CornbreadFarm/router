module router(input clock,  reset_n, input [7:0]frame_n, valid_n, di, output [7:0] dout, valido_n, frameo_n);


wire [31:0] dout_from_portin;
wire [31:0] dout_from_fifo;
wire [3:0] addr_from_portin;
wire vld_from_portin;
wire ready_from_fifo;
wire pop_from_portout;


portin portin0(.clock(clock), .reset_n(reset_n), .frame_n(frame_n[0]), .valid_n(valid_n[0]), .di(di[0]), .addr(addr_from_portin), .payload(dout_from_portin), .vld(vld_from_portin));

fifo fifo7(.ready(ready_from_fifo), .dout(dout_from_fifo), .din(dout_from_portin), .push(vld_from_portin), .pop(pop_from_portout), .reset_n(reset_n), .clock(clock));

portout portout7(.payload(dout_from_fifo), .rdy(ready_from_fifo), .clock(clock), .reset_n(reset_n), .frameo_n(frameo_n[7]), .valido_n(valido_n[7]), .dout(dout[7]),.pop(pop_from_portout));

endmodule
