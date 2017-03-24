module switch_fabric_tb();

register [31:0] payload [7:0];
register [3:0] addr [7:0];
wire [31:0] dout [7:0];

switch_fabric dut(.payload(payload),.addr(addr),.dout(dout))
endmodule
