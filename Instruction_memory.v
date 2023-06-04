module IMem#(BYTE_SIZE=4, ADDR_WIDTH=32)(
input [ADDR_WIDTH-1:0] ADDR,
output [(BYTE_SIZE*8)-1:0] RD 
);

reg [7:0] mem [4095:0];

initial begin
//mem[0]<=8'h00;
//mem[1]<=8'h10;
//mem[2]<=8'ha0;
//mem[3]<=8'he3;
//mem[4]<=8'h00;
//mem[5]<=8'h20;
//mem[6]<=8'ha0;
//mem[7]<=8'he3;
//mem[8]<=8'h04;
//mem[9]<=8'h10;
//mem[10]<=8'h82;
//mem[11]<=8'he2;

//mem[12]<= 8'h00;
//mem[13]<= 8'h00;
//mem[14]<= 8'ha0;
//mem[15]<= 8'he1;

//mem[16]<=8'h00;
//mem[17]<=8'h10;
//mem[18]<=8'h82;
//mem[19]<=8'he5;

//mem[20]<= 8'h00;
//mem[21]<= 8'h00;
//mem[22]<= 8'ha0;
//mem[23]<= 8'he1;

//integer j;

//    for (j=0; j<4096; j++) begin
//        mem[j] = 0;
//    end
//    $writememb("memory_binary.txt", mem);
//    $writememh("memory_hex.txt", mem);

$readmemh("imem_data.txt", mem); // You will need this for real tests
end
genvar i;
generate
	for (i = 0; i < BYTE_SIZE; i = i + 1) begin: read_generate
		assign RD[8*i+:8] = mem[ADDR+i];
	end
endgenerate
endmodule