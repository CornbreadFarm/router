module switch_fabric(input [31:0] din [7:0], input [3:0] addr [7:0],
   input [7:0] grant, output [31:0] dout [7:0]);

   wire [31:0] granted_payload   =  (grant == 8'b0000_0001) ? din[0]
                                 :  (grant == 8'b0000_0010) ? din[1]
                                 :  (grant == 8'b0000_0100) ? din[2]
                                 :  (grant == 8'b0000_1000) ? din[3]
                                 :  (grant == 8'b0001_0000) ? din[4]
                                 :  (grant == 8'b0010_0000) ? din[5]
                                 :  (grant == 8'b0100_0000) ? din[6]
                                 :  (grant == 8'b1000_0000) ? din[7]
   /*default*/                   :  32'h0000_0000;

  wire [3:0] granted_addr        =  (grant == 8'b0000_0001) ? addr[0]
                                 :  (grant == 8'b0000_0010) ? addr[1]
                                 :  (grant == 8'b0000_0100) ? addr[2]
                                 :  (grant == 8'b0000_1000) ? addr[3]
                                 :  (grant == 8'b0001_0000) ? addr[4]
                                 :  (grant == 8'b0010_0000) ? addr[5]
                                 :  (grant == 8'b0100_0000) ? addr[6]
                                 :  (grant == 8'b1000_0000) ? addr[7]
   /*default*/                   :  3'b000;

   genvar i;
//   generate for(i=0; i<7; i=i+1) begin: inst
      assign dout[0] = (granted_addr[2:0] == 3'b000) ? granted_payload : 32'h0000_0000;
      assign dout[1] = (granted_addr[2:0] == 3'b001) ? granted_payload : 32'h0000_0000;
      assign dout[2] = (granted_addr[2:0] == 3'b010) ? granted_payload : 32'h0000_0000;
      assign dout[3] = (granted_addr[2:0] == 3'b011) ? granted_payload : 32'h0000_0000;
      assign dout[4] = (granted_addr[2:0] == 3'b100) ? granted_payload : 32'h0000_0000;
      assign dout[5] = (granted_addr[2:0] == 3'b101) ? granted_payload : 32'h0000_0000;
      assign dout[6] = (granted_addr[2:0] == 3'b110) ? granted_payload : 32'h0000_0000;
      assign dout[7] = (granted_addr[2:0] == 3'b111) ? granted_payload : 32'h0000_0000;
//      end
//   endgenerate

endmodule
