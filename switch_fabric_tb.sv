module switch_fabric_tb();

reg clk;
reg [31:0] din [7:0];
reg [3:0] addr [7:0];
reg [7:0] grant;
wire [31:0] dout [7:0];

switch_fabric dut(.din(din), .addr(addr), .grant(grant), .dout(dout));

always #5 clk = !clk;
initial begin
din[7] = 32'hDEAD_BEEF;
din[6] = 32'hCAFE_BADD;
din[5] = 32'hFEAD_1007;
din[4] = 32'h4206_9001;
din[3] = 32'h0F0F_0F0F;
din[2] = 32'hDECA_DE10;
din[1] = 32'hBABA_B00E;
din[0] = 32'hFADE_BABE;
addr[0] = 4'b0111;
addr[1] = 4'b0111;
addr[2] = 4'b0111;
addr[3] = 4'b0111;
addr[4] = 4'b0111;
addr[5] = 4'b0111;
addr[6] = 4'b0111;
addr[7] = 4'b0111;
clk = 0;

@(posedge clk) grant = 8'b0000_0001;
@(posedge clk) grant = 8'b0000_0010;
@(posedge clk) grant = 8'b1000_0000;
@(posedge clk) grant = 8'b0010_0000;
@(posedge clk) grant = 8'b0100_0000;
@(posedge clk) grant = 8'b0001_0000;
@(posedge clk) grant = 8'b0101_0010;
@(posedge clk) grant = 8'b1000_1000;
#100 $finish;
end 

initial $monitor("t = %t grant: %b dout[7]: %h", $time, grant, dout[7]) ;

endmodule
