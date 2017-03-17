module router(input clock,  reset_n, input [7:0]frame_n, valid_n, di, output [7:0] dout, valido_n, frameo_n);


wire [31:0] dout_from_portin;
reg [3:0]addr_from_portin;
wire vld_from_portin;
reg pop_from_portout;


portin portin0(.clock(clock), .reset_n(reset_n), .frame_n(frame_n[0]), .valid_n(valid_n[0]), .di(di[0]), .addr(addr_from_portin), .payload(dout_from_portin), .vld(vld_from_portin));

//DW_arb_rr arbiter(.clock(clock))

/*genvar i;
generate for(i=0;i<8;i++) begin: inst
wire [31:0]payload;
wire frameo_n, valido_n, dout, pop;
portout g1(.payload(payload), .rdy(rdy), .clock(clock), .reset_n(reset_n), .frameo_n(frameo_n), .valido_n(valido_n), .dout(dout),.pop(pop));
end*/

endmodule
