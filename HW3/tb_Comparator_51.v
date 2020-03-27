`timescale 1ns/1ps
module tb_51_COMPARATOR();
	
	wire  [2:0] median;
	wire  [2:0] ans;
	wire  [7:0] i0, i1, i2, i3, i4;
	
	reg  [7:0] i0mem[1023:0];
	reg  [7:0] i1mem[1023:0];
	reg  [7:0] i2mem[1023:0];
	reg  [7:0] i3mem[1023:0];
	reg  [7:0] i4mem[1023:0];
	
	reg  [2:0] ansmem[1023:0];
	
	integer i;
	integer err3,err4, err5,err6, err7,err10,err20;
	
	assign i0  = i0mem[i];
	assign i1  = i1mem[i];
	assign i2  = i2mem[i];
	assign i3  = i3mem[i];
	assign i4  = i4mem[i];
	
	assign ans = ansmem[i];
	
	COMPARATOR_51 top(.median(median),
										.i0(i0), 
										.i1(i1),
										.i2(i2),
										.i3(i3),
										.i4(i4));
	
	
	initial
	begin
		$readmemb("in0.dat", i0mem);
		$readmemb("in1.dat", i1mem);
		$readmemb("in2.dat", i2mem);
		$readmemb("in3.dat", i3mem);
		$readmemb("in4.dat", i4mem);
		
		$readmemb("answer.dat",ansmem);

		$dumpfile("Comparator_51.fsdb");
		$dumpvars;
	end
	
	initial
	begin
		i = 0;
		err3 = 0;
		err4 = 0;
		err5 = 0;
		err6 = 0;
		err7 = 0;
		err10 = 0;
		err20 = 0;
	end

	

	always 
	begin
	    	#4
		if(ans !== median)
			err3 = err3 + 1;
		#1
		if(ans !== median)
			err4 = err4 + 1;
		#1
		if(ans !== median)
			err5 = err5 + 1;
		#1
		if(ans !== median)
			err6 = err6 + 1;
		#1
		if(ans !== median)
			err7 = err7 + 1;
		#1
		if(ans !== median)
			err10 = err10 + 1;
		#10
		if(ans !== median)
			err20 = err20 + 1;
		
		#1
		i = i + 1;
	end
	
	always @(i)
	if(i == 1000)
	begin
	    if(err3 == 0)
			$display("Congratulations! Your score is 70!\n");
		else if(err4 == 0)
			$display("Congratulations! Your score is 65!\n");
		else if(err5 == 0)
			$display("Congratulations! Your score is 60!\n");
		else if(err6 == 0)
			$display("Congratulations! Your score is 60!\n");
		else if(err7 == 0)
			$display("Congratulations! Your score is 50!\n");
		else if(err10 == 0)
			$display("Congratulations! Your score is 45!\n");
		else if(err20 == 0)
			$display("Congratulations! Your score is 40!\n");
		else
		begin
		   $display("There are %d errors.\n", err20);
		   $display("Your score is %g.\n", 40-err20/25);
		end
		
		$finish;
	end
	

endmodule
	
	
		


