module Extender(
input [23:0] A,
input select,
output [31:0] Q

);

assign Q = select ? {8'b0,A} : {24'b0,A[7:0]};

endmodule
