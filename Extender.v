module Extender(
input [23:0] A,
input [1:0] select,
output [31:0] Q

);

    assign Q = select[1] 
                    ? {(A[23] ? 6'b111111 : 6'b0), A[23:0], 2'b00} 
                    : (select[0] 
                                    ? (A[7:0] >> (A[11:8] * 2)) | (A[7:0] << (32 - (A[11:8] * 2)))
                                    : {20'b0, A[11:0]});

endmodule
