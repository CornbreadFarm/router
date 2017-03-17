// This is a simple testbench you can use to test out your 8x8 switch

module tb;
reg reset_n,clock;
initial clock=0;
initial reset_n=1; 

// Used for reporting summary
reg [7:0] da_sent_pkts [8];
reg [7:0] da_rcvd_pkts [8];
reg [7:0] sa_sent_pkts [8];
integer i;
// Initialized our reporting data structure 
initial
for (i=0;i<8;i=i+1) begin
  da_sent_pkts[i]=0;
  da_rcvd_pkts[i]=0;
  sa_sent_pkts[i]=0;
end
// Clock Generator
always #5 clock=!clock; 

reg [7:0] di, frame_n, valid_n;
wire  [7:0] dout, valido_n, frameo_n;

// This is our DUT
 router dut (
    clock, reset_n, frame_n, valid_n, di, dout, valido_n, frameo_n);


// We have a monitor connected to all 8 ports  
 monitor #(0)  port0(clock,reset_n,frameo_n[0],valido_n[0],dout[0]);
 monitor #(1)  port1(clock,reset_n,frameo_n[1],valido_n[1],dout[1]);
 monitor #(2)  port2(clock,reset_n,frameo_n[2],valido_n[2],dout[2]);
 monitor #(3)  port3(clock,reset_n,frameo_n[3],valido_n[3],dout[3]);
 monitor #(4)  port4(clock,reset_n,frameo_n[4],valido_n[4],dout[4]);
 monitor #(5)  port5(clock,reset_n,frameo_n[5],valido_n[5],dout[5]);
 monitor #(6)  port6(clock,reset_n,frameo_n[6],valido_n[6],dout[6]);
 monitor #(7)  port7(clock,reset_n,frameo_n[7],valido_n[7],dout[7]);

reg dummy; 
// Initialization of inputs to the switch 
initial begin di=0; frame_n=8'hff; valid_n=8'hff; // Let's reset the switch
repeat(2) @(posedge clock) ;
reset_n = 0;
repeat(4) @(posedge clock) ;
reset_n = 1;
repeat (10) @(posedge clock); 


///  Main part of testbench to send stimulus to DUT

// setpkt (source address, destination address, payload)

if ($test$plusargs("SMOKE")) begin 
  $display("STARTING SMOKE TEST!!!!"); 
  sendpkt(0,7,32'hdead_beef); 
end

if ($test$plusargs("1PORT")) begin 
  $display("STARTING 1-PORT TEST!!!!"); 
  sendpkt(0,0,32'h1234_1234); 
  sendpkt(0,1,32'hdead_beef); 
  sendpkt(0,2,32'h9876_abcd); 
  sendpkt(0,3,32'h5555_5555); 
  sendpkt(0,4,32'hdead_beef); 
  sendpkt(0,5,32'habcd_dcba); 
  sendpkt(0,6,32'h5455_5050); 
  sendpkt(0,7,32'h0000_1111); 
end

if ($test$plusargs("4PORT")) begin 
  $display("STARTING 4-PORT TEST!!!!"); 
  fork 
    repeat(10) sendpkt(0,3,$random); 
    repeat(10) sendpkt(1,2,$random); 
    repeat(10) sendpkt(2,1,$random); 
    repeat(10) sendpkt(3,0,$random); 
  join
end

if ($test$plusargs("CONCURRENT")) begin 
  $display("STARTING CONCURRENT TEST!!!!"); 
  fork 
    repeat(10) sendpkt(0,7,$random); 
    repeat(10) sendpkt(1,7,$random); 
    repeat(10) sendpkt(2,7,$random); 
    repeat(10) sendpkt(3,7,$random); 
  join
end



#10000 $finish;
end


final begin 
$display("\n*******************End of Simulation Report*******************" ); 
for (i=0;i<8;i=i+1) begin 
  $display("Port %2d [transmitted=%d] [received=%d] [expected=%d]",i ,sa_sent_pkts[i],da_rcvd_pkts[i],da_sent_pkts[i]); 
end
end

// Task to send packet 
task automatic  sendpkt (input [3:0] sa,da, input [31:0] data); 
integer i; 
begin 
$display("Sending packet @%5t [sa=%d] [da=%d] data=%h",$time,sa,da,data); 
da_sent_pkts[da] = da_sent_pkts[da] + 1; 
sa_sent_pkts[sa] = sa_sent_pkts[sa] + 1; 
  @(posedge clock); 
  frame_n[sa]  <= 1'b0; 
  di[sa] <= da[0]; 
@(posedge clock)  di[sa] <= da[1]; 
@(posedge clock)  di[sa] <= da[2]; 
@(posedge clock)  di[sa] <= da[3]; 
// Padding
repeat(10) @(posedge clock) di[sa] <= 1'b1; 
for (i=0;i<32;i=i+1) begin 
  valid_n[sa] <= 0; 
  di[sa] <= data[i]; 
  frame_n[sa] <= i==31; 
  @(posedge clock); 
end
valid_n[sa] <= 1'b1; 
@(posedge clock); 
end
endtask 
endmodule

module monitor(input clock,reset_n,frame_n,valid_n,data_in); 
parameter port=0; 
integer i; 
reg [31:0]  data; 
reg in_progress; 
initial begin 
 in_progress = 0; 
 @(negedge reset_n);  
 @(posedge reset_n);  
 forever begin 
   in_progress <= 0; 
   while  (frame_n | valid_n) @(posedge clock) ; 
   in_progress = 1; 
   tb.da_rcvd_pkts[port] = tb.da_rcvd_pkts[port] + 1; 
   for (i=0;i<32;i=i+1) begin 
    data[i] <= data_in;  
    @(posedge clock); 
  end
$display("Received packet @%5t [sa=%2d] data=%h",$time,port,data); 
end
end

endmodule

