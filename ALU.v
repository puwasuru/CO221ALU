//CO221 - Digital Design 
// Project - Phase 2: Verilog implementation of the ALU
// March, 2017
// Test bed for the simple ALU

// Group no.: B2
// Members: I.P.S.B Ihalagedara,T.H.K Dilshani, K.V.V Chamara

// Top level stimulus module
// This module can be directly used in your design
module testbed;

	reg [2:0] A,B;
	reg load1,load2,run;
	wire [2:0] C; 
	reg [3:0] op_code;

	//A and B are the two 3-bit inputs coming from switches
	//C is the 3-bit output that comes from the accumulator once run is set to high
	//load1 is the load signal for operand 1 register
	//load2 is the load signal for operand 2 register
	//op_code selects the operator
		// op_code=4'b0000 - Addition
		// op_code=4'b0001 - Bitwise XOR
		// op_code=4'b0010 - Multiplication
		// op_code=4'b0011 - Shift Left
		// op_code=4'b0100 - Shift Right
		// op_code=4'b0101 - Bitwise AND
		// op_code=4'b0110 - Bitwise OR
		// op_code=4'b0111 - Bitwise NAND
		// op_code=4'b1000 - Bitwise NOR
		// op_code=4'b1001 - One bit shift left
		// op_code=4'b1010 - One bit shift right

	//you don't have to model switches or the LEDs in Verilog

	
	// Instatiation of the ALU module
	ALU mu_alu(C,A,B,load1,load2,op_code,run);

	initial
	begin

		//generate files needed to plot the waveform
		//you can plot the waveform generated after running the simulator by using gtkwave
		$dumpfile("wavedata.vcd");
	    $dumpvars(0,testbed);
	    
		//You should simulate the ALU for the given inputs
		// Input 1: A=5, B=2
		// Input 2: A=2, B=5
		//You should add another test case of your own as well
		//Out of the given op_codes and $display statements, you should select only those
		//corresponging to your implementation and erase others
	
		//A = 5 and B = 2

		//setting the reset state 
		load1<=1'b0; load2<=1'b0; run<=1'b0;

		A=3'd5; B=3'd3;
		   
		#5 load1=1'b1;
		#5 load1=1'b0;
		#5 load2=1'b1;
		#5 load2=1'b0;

		#5 op_code=4'b0001;
		#5 run=1'b1;
		#5 run=1'b0;
		$display("%b ^ %b = %b",A,B,C);
		
		#5 op_code=4'b1010;
		
		#5 run=1'b1;
		#5 run=1'b0;
		$display("%b >> 1 = %b",A,C);
		
		
		//A = 2 and B = 5
		#5 A=4'd2; B=4'd5; 
		#5 load1=1'b1;
		#5 load1=1'b0;
		#5 load2=1'b1;
		#5 load2=1'b0;

		#5 op_code=4'b0001;
		#5 run=1'b1;
		#5 run=1'b0;
		$display("%b ^ %b = %b",A,B,C);
		#5 op_code=4'b1010; 
		
		#5 run=1'b1;
		#5 run=1'b0;
		$display("%b >> 1 = %b",A,C);
				
		//Add your test case here.

		//A = 3 and B = 1
		#5 A=4'd4; B=4'd1; 
		#5 load1=1'b1;
		#5 load1=1'b0;
		#5 load2=1'b1;
		#5 load2=1'b0;

		#5 op_code=4'b0001;
		#5 run=1'b1;
		#5 run=1'b0;
		$display("%b ^ %b = %b",A,B,C);
		#5 op_code=4'b1010; 
		
		#5 run=1'b1;
		#5 run=1'b0;
		$display("%b >> 1 = %b",A,C);
		
		#10 $finish;	
		
	end

endmodule

//your modules should go here

// XOR gate
module x_or(out,in1,in2);
	input in1,in2;
	output out;

	wire b_in1,b_in2,out1,out2;

	not n1(b_in1,in1);
	not n2(b_in2,in2);
	and a1(out1,in1,b_in2);
	and a2(out2,in2,b_in1);
	or o1(out,out1,out2);
	
endmodule


// asynchronized sr latch
module asr_latch(in1,in2,q);
	input in1,in2;
	output q;

	wire qb;

	nand na1(q,in1,qb);
	nand na2(qb,in2,q);

endmodule 


// D latch
module d_latch(in,clk,q);
	input in,clk;
	output q;

	wire dn,out1,out2;

	not n3(dn,in);
	nand na3(out1,in,clk);
	nand na4(out2,dn,clk);
	asr_latch asr1(out1,out2,q);


endmodule


// D flipflop
module d_flipflop(in,clk,q);

	input in,clk;
	output q;

	wire out1,nclk;

	d_latch m(in,nclk,out1);
	not n4(nclk,clk);
	d_latch s(out1,clk,q);

endmodule

// Parallel input parallel output register
module pipo_3register(in,clk,out);

	input clk;
	input [2:0] in;
	output [2:0] out;

	d_flipflop df1(in[0],clk,out[0]);
	d_flipflop df2(in[1],clk,out[1]);
	d_flipflop df3(in[2],clk,out[2]);

endmodule

module bitwise_XOR(in1,in2,out);
	
	input [2:0] in1,in2;
	output [2:0] out;

	x_or x1(out[0],in1[0],in2[0]);
	x_or x2(out[1],in1[1],in2[1]);
	x_or x3(out[2],in1[2],in2[2]);

endmodule

module shift_right(in,clk,out);
	
	input [2:0] in;
	input clk,clr;
	output [2:0] out;

	d_flipflop df4(in[1],clk,out[0]);
	d_flipflop df5(in[2],clk,out[1]);
	d_flipflop df6(1'b0,clk,out[2]);
	

endmodule


module opcode(in,x_or,bit_shif);
	input [3:0] in;
	output x_or,bit_shif;

	wire b_1,b_2,b_3,b_4;

	not n6(b_1,in[0]);
	not n7(b_2,in[1]);
	not n8(b_3,in[2]);
	not n9(b_4,in[3]);

	and a8(x_or,in[0],b_2,b_3,b_4);
	and a9(bit_shif,in[3],b_3,in[1],b_1);
				
endmodule


module ALU(out,operand1,operand2,load1,load2,op_code,run);
	
	input [2:0] operand1,operand2;
	input [3:0] op_code;
	input load1,load2,run;

	output [2:0] out;

	wire [2:0] out1,out2,out3,bxor,sfr,out4,out5,out6;
	wire x_or,bit_shif;


	pipo_3register alupipor1(operand1,load1,out1);
	pipo_3register alupipor2(operand2,load2,out2);

	bitwise_XOR x1(out1,out2,out3);
	shift_right sr1(operand1,load1,out4);

	opcode op1(op_code,x_or,bit_shif);

	and a10(bxor[0],x_or,out3[0]);
	and a11(bxor[1],x_or,out3[1]);
	and a12(bxor[2],x_or,out3[2]);
	and a13(sfr[0],bit_shif,out4[0]);
	and a14(sfr[1],bit_shif,out4[1]);
	and a15(sfr[2],bit_shif,out4[2]);

 	pipo_3register alupipor3(bxor,run,out5);
 	pipo_3register alupipor4(sfr,run,out6);

 	or o [2:0](out,out5,out6);

endmodule