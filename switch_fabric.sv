module switch_fabric(input [31:0] din [7:0], input [3:0] addr [7:0],
   input [7:0] grant, output [31:0] dout [7:0], output [7:0] push);

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
   /*default*/                   :  4'b1000;

//   genvar i;
//   generate for(i=0; i<7; i=i+1) begin: inst
      assign dout[0] = (granted_addr == 4'b0000) ? granted_payload : 32'h0000_0000;
      assign dout[1] = (granted_addr == 4'b0001) ? granted_payload : 32'h0000_0000;
      assign dout[2] = (granted_addr == 4'b0010) ? granted_payload : 32'h0000_0000;
      assign dout[3] = (granted_addr == 4'b0011) ? granted_payload : 32'h0000_0000;
      assign dout[4] = (granted_addr == 4'b0100) ? granted_payload : 32'h0000_0000;
      assign dout[5] = (granted_addr == 4'b0101) ? granted_payload : 32'h0000_0000;
      assign dout[6] = (granted_addr == 4'b0110) ? granted_payload : 32'h0000_0000;
      assign dout[7] = (granted_addr == 4'b0111) ? granted_payload : 32'h0000_0000;
//      end
//   endgenerate

      assign push[0] = (granted_addr == 4'b0000);
      assign push[1] = (granted_addr == 4'b0001);
      assign push[2] = (granted_addr == 4'b0010);
      assign push[3] = (granted_addr == 4'b0011);
      assign push[4] = (granted_addr == 4'b0100);
      assign push[5] = (granted_addr == 4'b0101);
      assign push[6] = (granted_addr == 4'b0110);
      assign push[7] = (granted_addr == 4'b0111);

endmodule
