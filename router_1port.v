module router(input clock,  reset_n, input [7:0]frame_n, valid_n, di, output [7:0] dout, valido_n, frameo_n);


wire [31:0] dout_from_portin;
wire [31:0] dout_from_fifo;
wire [3:0] addr_from_portin;
wire [7:0] vld_from_portin;
wire ready_from_fifo;
wire pop_from_portout;
wire [7:0] grant_from_arbiter;

DW_arb_rr #(8,1,0) arbiter(.clk(clock), .rst_n(reset_n), .init_n(1'b1), .enable(1'b1), .request(vld_from_portin), .mask(8'b0000_0000), .grant(grant_from_arbiter), .granted(), .grant_index());

portin portin0(.clock(clock), .reset_n(reset_n), .frame_n(frame_n[0]), .valid_n(valid_n[0]), .di(di[0]), .granted(grant_from_arbiter[0]), .addr(addr_from_portin), .payload(dout_from_portin), .vld(vld_from_portin[0]));

fifo fifo7(.full(), .empty(), .ready(ready_from_fifo), .dout(dout_from_fifo), .din(dout_from_portin), .push(grant_from_arbiter[0]), .pop(pop_from_portout), .reset_n(reset_n), .clock(clock));

portout portout7(.payload(dout_from_fifo), .rdy(ready_from_fifo), .clock(clock), .reset_n(reset_n), .frameo_n(frameo_n[7]), .valido_n(valido_n[7]), .dout(dout[7]),.pop(pop_from_portout));

endmodule
