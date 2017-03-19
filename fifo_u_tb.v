module fifo_u_tb();
wire full, empty, ready;
wire [31:0] dout;

parameter REPEAT_ITERATIONS = 10;

reg push, pop, reset_n, clock;
reg [31:0] din;

fifo dut(.full(full), .empty(empty), .dout(dout), .push(push), .pop(pop),
   .reset_n(reset_n), .clock(clock), .din(din));

always #5 clock = !clock;

initial begin
   
   push = 0;
   pop = 0;
   reset_n = 0;
   clock = 0;
   din = 32'h0000_0000;

   #10;

   @(posedge clock) reset_n = 1;

   #10;

   repeat(REPEAT_ITERATIONS)
   begin
      @(posedge clock) begin
         push <= 1;
         din <= $random;
      end
   end
   
   @(posedge clock) push <= 0;

   repeat(REPEAT_ITERATIONS)
   begin
      @(posedge clock) pop <= 1;
   end

   #10;
   $display("End of fifo unit testbench.");
   $finish;

end

initial $monitor(" %t: din: %h, push: %b, pop: %b, reset_n: %b full: %b empty: %b dout: %h",
   $time, din, push, pop, reset_n, full, empty, dout);

endmodule
