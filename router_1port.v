module router(input clock,  reset_n, input [7:0]frame_n, valid_n, di, output [7:0] dout, valido_n, frameo_n);


wire [31:0] dout_from_portin;
reg [3:0]addr_from_portin;
wire vld_from_portin;
reg pop_from_portout;


portin portin0(.clock(clock), .reset_n(reset_n), .frame_n(frame_n[0]), .valid_n(valid_n[0]), .di(di[0]), .addr(addr_from_portin), .payload(dout_from_portin), .vld(vld_from_portin));



portout portout7(.payload(dout_from_portin), .rdy(vld_from_portin), .clock(clock), .reset_n(reset_n), .frameo_n(frameo_n[7]), .valido_n(valido_n[7]), .dout(dout[7]),.pop(pop_from_portout));

endmodule
