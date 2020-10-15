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