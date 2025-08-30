module Sign_Extend (in,out);
  input [15:0] in;
  output [31:0] out;   
// Sign extension by replicating the MSB (in[15])
  assign out = {{16{in[15]}}, in};

endmodule
