//task TESTCASE 
`include "memory2.v"
module mem_tb();

parameter WIDTH=16;
parameter DEPTH=64;
parameter ADDR_WITH=$clog2(DEPTH);
parameter ST_ADDR =15;
parameter NUM_TXS=5;

reg clk_i,rst_i,wr_rd_i,valid_i;
reg [WIDTH-1:0]wdata_i;
reg [ADDR_WITH-1:0]addr_i;
wire [WIDTH-1:0]rdata_o;
wire ready_o;

memory #(WIDTH,DEPTH,ADDR_WITH)dut (.*);

integer i;
reg [8*30:1]testcase;

always #5 clk_i=~clk_i;

initial begin	
	clk_i=0;
	rst_i=1;
	rst_logic();			//reset the input signals
	repeat(2)@(posedge clk_i);
	rst_i=0;
	$value$plusargs("testcase=%0s",testcase);
	$display("###########testcase=%0s",testcase);
	case(testcase)
		"ONE_WRITE" : begin
			$display("$$$$$$$$$$$$$$44");

			write_logic(0,1);			//first : st address sec : how transcations

		end
		"ONE_WRITE_ONE_READ": begin
				write_logic(0,1);			//first : st address sec : how transcations
				read_logic(0,1);
		end
		"WRITE_ALL_LOCATION":begin
				write_logic(0,DEPTH);			//first : st address sec : how transcations
		end
		"WRITE_READ_ALL_LOCATION":begin
				write_logic(0,DEPTH);			//first : st address sec : how transcations
				read_logic(0,DEPTH);

		end
		"WRITE_READ_SPECIFIC_LOC":begin
				write_logic(ST_ADDR,NUM_TXS);			//first : st address sec : how transcations
				read_logic(ST_ADDR,NUM_TXS);

	end
endcase
	#100;
	$finish;
end
	//write transaction
task write_logic(input reg[ADDR_WITH-1:0]str_addr , input reg[ADDR_WITH:0]num_txs);
begin
	for(i=str_addr;i<=str_addr+num_txs;i=i+1)begin
		@(posedge clk_i);		//every operation performed at +ve egde of clk
		wr_rd_i=1;				//  doing write operation
		addr_i=i;
		wdata_i=$random;
		valid_i=1;
		wait(ready_o==1);
	end
			@(posedge clk_i );
			rst_logic();
end
endtask

	//read transaction
task read_logic(input reg[ADDR_WITH-1:0]str_addr , input reg[ADDR_WITH:0]num_txs);
begin
	for(i=str_addr;i<=str_addr+num_txs;i=i+1)begin
		@(posedge clk_i);		//every operation performed at +ve egde of clk
		wr_rd_i=0;				//  doing read operation
		addr_i=i;
		valid_i=1;
		wait(ready_o==1);
	end
		@(posedge clk_i );
			rst_logic();
end
endtask
//rest logic
task rst_logic();
begin
	addr_i=0;
	wdata_i=0;
	wr_rd_i=0;
	valid_i=0;
end
endtask
endmodule
