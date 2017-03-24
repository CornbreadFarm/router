module switch_fabric(input [31:0] payload [7:0], input [3:0] addr [7:0], input [2:0] grant_index, output [31:0] dout [7:0]);

always @ (payload, addr, grant_index) begin  
   dout[addr] = payload[grant_index];
end

endmodule
