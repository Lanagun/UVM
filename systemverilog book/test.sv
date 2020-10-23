module test(PAddr, PWrite, PSel, PWData, PEnable, Rst, clk);
	//Omit the port declaration here
	initial begin
		//Driver reset
		Rst <= 0;
		#100 Rst <= 1;

		//Driver control bus
		@(posedge  clk)
		PAddr <= 16'h50;
		PWData <= 16'h50;;
		PWrite <= 1'b1;
		PSel <= 1'b1;

		//Flip PEnable
		@(posedge clk)
			PEnable <= 1'b1;
		@(posedge clk)
			PEnable <= 1'b0;

		//Verify the results
		if(top.men.memory[16'h50] == 32'h50)
			$display("Succcess");
		else 
			$display("Error, wrong value in memory");
	$finish;
endmodule : test


//A task applied to driving APB pins
task write(reg [15:0] addr, reg [31:0] data);
	//Driving control bus
	@(posedge clk)
	PAddr <= addr;
	PWData <= data;
	PWrite <= 1'b1;
	PSel <= 1'b1;

	//Flip PEnable
	@(posedge clk)
		PEnable <= 1'b1;
	@(posedge clk)
		PEnable <= 1'b0;
endtask : write

//Low-level verilog test
module test(PAddr, PWrite, PSel, PWData, PEnable, Rst, clk);
	//Omit the port decalration here.
	//The task shown in example 1.2 is omitted here.
	initial begin	
		reset();				//Device reset.
		write(16'h50, 32'h50);	//Write data to memory.

	//Verify the results.
	if(top.mem.memory[16'h50] ==32'h50)
		$display("Succcess");
	else
		$display("Error, wrong value in memory");
	$finish;
endmodule : test

//Use foreach to traverse multidimensional arrays, one thing to note is “foreach(md(i,j))“。
int md[2][3] = '{'{0,1,2}, '{3,4,5}};
initial begin 
	$display("Initial value:");
	foreach(md[i,j]) begin
		$display("md[%0d][%0d]=%0d",i,j,md[i][j]);
	end
	$display("New value:");
	//
	md = '{'{9,8,7}, '{3{32'd5}}};
	foreach(md[i,j]) begin
		$display("md[%0d][%0d] = %0d",i,j,md[i][j]);
	end
end

//
struct packed{bit red, green, blue} c[];
initial begin
	c = new[100];
	foreach(c[i]) begin
		c[i] = $urandom;			//Fill in the random number.
	end
	c.sort with(item.red);
end
