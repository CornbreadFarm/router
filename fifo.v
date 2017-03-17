module fifo(output full, empty, ready output [31:0] dout, input [31:0] din, input push, pop, reset_n, clock);

parameter WIDTH = 32;
parameter DEPTH = 128;
reg [WIDTH-1:0] mem [DEPTH-1:0];

reg [6:0] head, tail;
reg [7:0] cnt;

assign dout = mem[tail];
assign full = (cnt == DEPTH);
assign empty = (cnt == 0);

always @(posedge clock, negedge reset_n) begin
   if(!reset_n) begin
      head <= 0;
      tail <= 0;
      cnt <= 0;
      ready <= 0;
   end
   else begin
      if(pop && !empty) begin
         tail <= tail + 1;
         cnt <= cnt - 1;
         ready <= 1;
      end
      if(push && !full) begin
         mem[head] <= din;
         head <= head + 1;
         cnt <= cnt + 1;
      end
   end
end

endmodule
