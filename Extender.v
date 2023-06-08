module Extender(
input [23:0] A,
input select,
output [31:0] Q

);

assign Q = select ? {(A[23] ? 6'b111111 : 6'b0), A[23:0], 2'b00} : {24'b0, A[7:0]};

endmodule
