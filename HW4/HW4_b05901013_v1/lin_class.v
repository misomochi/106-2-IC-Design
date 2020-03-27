`include "lib.v"

module lin_class (input         i_clk,
				  input         i_rst_n,
				  input  [5:0]  i_im1,
				  input  [5:0]  i_im2,
				  input  [5:0]  i_im3,
				  output [15:0] o_wgt_sum,
				  output        o_pos,
				  output [50:0] number);

				  wire [50:0] transistor_count [12:0];
				  wire [11:0] w_0, w_1, w_2;
				  wire [15:0] ex_w_0, ex_w_1, ex_w_2, _w_0, _w_1, _w_2;
				  wire [15:0] s_0, s_1 ,sum_0, sum_1, sum_2;

				  //sum_0 of [6:0] transistor_count
				  assign number = transistor_count[0] + transistor_count[1] + transistor_count[2] + transistor_count[3] + transistor_count[4] + transistor_count[5] + transistor_count[6] + transistor_count[7] + transistor_count[8] + transistor_count[9] + transistor_count[10] + transistor_count[11] + transistor_count[12];

				  //sign extension
				  assign _w_0 = {{4{w_0[11]}}, w_0};
				  assign _w_1 = {{4{w_1[11]}}, w_1};
				  assign _w_2 = {{4{w_2[11]}}, w_2};

				  //weighted summer
				  HPM hpm1(.P(w_0), .X(i_im1), .W(6'b000101), .HPM_num(transistor_count[0])); //w_0 = 000101
				  sixteenBitReg sbr1(.Q(ex_w_0), .D(_w_0), .CLK(i_clk), .RESET(i_rst_n), .number(transistor_count[1])); //1st layer register

				  HPM hpm2(.P(w_1), .X(i_im2), .W(6'b000001), .HPM_num(transistor_count[2])); //w_1 = 000001
				  sixteenBitReg sbr2(.Q(ex_w_1), .D(_w_1), .CLK(i_clk), .RESET(i_rst_n), .number(transistor_count[3])); //1st layer register

				  HPM hpm3(.P(w_2), .X(i_im3), .W(6'b110111), .HPM_num(transistor_count[4])); //w_2 = 110111
				  sixteenBitReg sbr3(.Q(ex_w_2), .D(_w_2), .CLK(i_clk), .RESET(i_rst_n), .number(transistor_count[5])); //1st layer register

				  CRA cra1(.CO(), .S(s_0), .A(ex_w_0), .B(ex_w_1), .CRA_num(transistor_count[6])); //no carry-in needed
				  sixteenBitReg sbr4(.Q(sum_0), .D(s_0), .CLK(i_clk), .RESET(i_rst_n), .number(transistor_count[7])); //2nd layer register

				  CRA cra2(.CO(), .S(s_1), .A(ex_w_2), .B(16'b1111111110110100), .CRA_num(transistor_count[8]));
				  sixteenBitReg sbr5(.Q(sum_1), .D(s_1), .CLK(i_clk), .RESET(i_rst_n), .number(transistor_count[9])); //2nd layer register

				  CRA cra3(.CO(), .S(sum_2), .A(sum_0), .B(sum_1), .CRA_num(transistor_count[10]));
				  sixteenBitReg sbr6 (.Q(o_wgt_sum), .D(sum_2), .CLK(i_clk), .RESET(i_rst_n), .number(transistor_count[11]));
				  IV comparator(.Z(o_pos), .A(o_wgt_sum[15]), .number(transistor_count[12])); //o_wgt_sum[15] > 0, o_pos = HIGH; o_wgt_sum[15] < 1, o_pos = LOW

endmodule

//HPM Baugh-Hooley Multiplier
module HPM(P, X, W, HPM_num);
	output [11:0] P;
	input [5:0] X, W; //input X & weight coefficient W

	output wire [50:0] HPM_num;
	wire [50:0] transistor_count [66:0];
	wire [34:0] w;
	wire [29:0] c;
	wire [19:0] s;

	//sum of [66:0] transistor_count
	assign HPM_num = transistor_count[0] + transistor_count[1] + transistor_count[2] + transistor_count[3] + transistor_count[4] + transistor_count[5] + transistor_count[6] + transistor_count[7] + transistor_count[8] + transistor_count[9] + transistor_count[10] + transistor_count[11] + transistor_count[12] + transistor_count[13] + transistor_count[14] + transistor_count[15] + transistor_count[16] + transistor_count[17] + transistor_count[18] + transistor_count[19] + transistor_count[20] + transistor_count[21] + transistor_count[22] + transistor_count[23] + transistor_count[24] + transistor_count[25] + transistor_count[26] + transistor_count[27] + transistor_count[28] + transistor_count[29] + transistor_count[30] + transistor_count[31] + transistor_count[32] + transistor_count[33] + transistor_count[34] + transistor_count[35] + transistor_count[36] + transistor_count[37] + transistor_count[38] + transistor_count[39] + transistor_count[40] + transistor_count[41] + transistor_count[42] + transistor_count[43] + transistor_count[44] + transistor_count[45] + transistor_count[46] + transistor_count[47] + transistor_count[48] + transistor_count[49] + transistor_count[50] + transistor_count[51] + transistor_count[52] + transistor_count[53] + transistor_count[54] + transistor_count[55] + transistor_count[56] + transistor_count[57] + transistor_count[58] + transistor_count[59] + transistor_count[60] + transistor_count[61] + transistor_count[62] + transistor_count[63] + transistor_count[64] + transistor_count[65] + transistor_count[66];

	//products of single bit(adder inputs)
	AN2 a1(.Z(P[0]), .A(X[0]), .B(W[0]), .number(transistor_count[0])); //LSB of HPM
	AN2 a2(.Z(w[0]), .A(X[1]), .B(W[0]), .number(transistor_count[1]));
	AN2 a3(.Z(w[1]), .A(X[0]), .B(W[1]), .number(transistor_count[2]));
	AN2 a4(.Z(w[2]), .A(X[1]), .B(W[1]), .number(transistor_count[3]));
	AN2 a5(.Z(w[3]), .A(X[0]), .B(W[2]), .number(transistor_count[4]));
	AN2 a6(.Z(w[4]), .A(X[2]), .B(W[0]), .number(transistor_count[5]));
	AN2 a7(.Z(w[5]), .A(X[1]), .B(W[2]), .number(transistor_count[6]));
	AN2 a8(.Z(w[6]), .A(X[0]), .B(W[3]), .number(transistor_count[7]));
	AN2 a9(.Z(w[7]), .A(X[2]), .B(W[1]), .number(transistor_count[8]));
	AN2 a10(.Z(w[8]), .A(X[3]), .B(W[0]), .number(transistor_count[9]));
	AN2 a11(.Z(w[9]), .A(X[1]), .B(W[3]), .number(transistor_count[10]));
	AN2 a12(.Z(w[10]), .A(X[0]), .B(W[4]), .number(transistor_count[11]));
	AN2 a13(.Z(w[11]), .A(X[3]), .B(W[1]), .number(transistor_count[12]));
	AN2 a14(.Z(w[12]), .A(X[2]), .B(W[2]), .number(transistor_count[13]));
	AN2 a15(.Z(w[13]), .A(X[4]), .B(W[0]), .number(transistor_count[14]));
	AN2 a16(.Z(w[14]), .A(X[1]), .B(W[4]), .number(transistor_count[15]));
	ND2 n1(.Z(w[15]), .A(X[0]), .B(W[5]), .number(transistor_count[16]));
	AN2 a17(.Z(w[16]), .A(X[3]), .B(W[2]), .number(transistor_count[17]));
	AN2 a18(.Z(w[17]), .A(X[2]), .B(W[3]), .number(transistor_count[18]));
	AN2 a19(.Z(w[18]), .A(X[4]), .B(W[1]), .number(transistor_count[19]));
	ND2 n2(.Z(w[19]), .A(X[5]), .B(W[0]), .number(transistor_count[20]));
	AN2 a20(.Z(w[20]), .A(X[2]), .B(W[4]), .number(transistor_count[21]));
	ND2 n3(.Z(w[21]), .A(X[1]), .B(W[5]), .number(transistor_count[22]));
	AN2 a21(.Z(w[22]), .A(X[4]), .B(W[2]), .number(transistor_count[23]));
	AN2 a22(.Z(w[23]), .A(X[3]), .B(W[3]), .number(transistor_count[24]));
	ND2 n4(.Z(w[24]), .A(X[5]), .B(W[1]), .number(transistor_count[25]));
	AN2 a23(.Z(w[25]), .A(X[3]), .B(W[4]), .number(transistor_count[26]));
	ND2 n5(.Z(w[26]), .A(X[2]), .B(W[5]), .number(transistor_count[27]));
	AN2 a24(.Z(w[27]), .A(X[4]), .B(W[3]), .number(transistor_count[28]));
	ND2 n6(.Z(w[28]), .A(X[5]), .B(W[2]), .number(transistor_count[29]));
	AN2 a25(.Z(w[29]), .A(X[4]), .B(W[4]), .number(transistor_count[30]));
	ND2 n8(.Z(w[30]), .A(X[3]), .B(W[5]), .number(transistor_count[31]));
	ND2 n9(.Z(w[31]), .A(X[5]), .B(W[3]), .number(transistor_count[32]));
	ND2 n10(.Z(w[32]), .A(X[5]), .B(W[4]), .number(transistor_count[33]));
	ND2 n11(.Z(w[33]), .A(X[4]), .B(W[5]), .number(transistor_count[34]));
	AN2 a26(.Z(w[34]), .A(X[5]), .B(W[5]), .number(transistor_count[35]));

	//Half & Full Adders
	HA1 h1(.O(c[0]), .S(P[1]), .A(w[0]), .B(w[1]), .number(transistor_count[36]));
	HA1 h2(.O(c[1]), .S(s[0]), .A(w[2]), .B(w[3]), .number(transistor_count[37]));
	FA1 f1(.CO(c[2]), .S(P[2]), .A(w[4]), .B(s[0]), .CI(c[0]), .number(transistor_count[38]));
	HA1 h3(.O(c[3]), .S(s[1]), .A(w[5]), .B(w[6]), .number(transistor_count[39]));
	FA1 f2(.CO(c[4]), .S(s[2]), .A(s[1]), .B(w[7]), .CI(w[8]), .number(transistor_count[40]));
	FA1 f3(.CO(c[5]), .S(P[3]), .A(c[1]), .B(s[2]), .CI(c[2]), .number(transistor_count[41]));
	HA1 h4(.O(c[6]), .S(s[3]), .A(w[9]), .B(w[10]), .number(transistor_count[42]));
	FA1 f4(.CO(c[7]), .S(s[4]), .A(w[11]), .B(w[12]), .CI(w[13]), .number(transistor_count[43]));
	FA1 f5(.CO(c[8]), .S(s[5]), .A(s[3]), .B(s[4]), .CI(c[3]), .number(transistor_count[44]));
	FA1 f6(.CO(c[9]), .S(P[4]), .A(c[4]), .B(s[5]), .CI(c[5]), .number(transistor_count[45]));
	HA1 h5(.O(c[10]), .S(s[6]), .A(w[14]), .B(w[15]), .number(transistor_count[46]));
	FA1 f7(.CO(c[11]), .S(s[7]), .A(w[16]), .B(w[17]), .CI(w[18]), .number(transistor_count[47]));
	FA1 f8(.CO(c[12]), .S(s[8]), .A(w[19]), .B(s[6]), .CI(c[6]), .number(transistor_count[48]));
	FA1 f9(.CO(c[13]), .S(s[9]), .A(s[7]), .B(s[8]), .CI(c[7]), .number(transistor_count[49]));
	FA1 f10(.CO(c[14]), .S(P[5]), .A(c[8]), .B(s[9]), .CI(c[9]), .number(transistor_count[50]));
	FA1 f11(.CO(c[15]), .S(s[10]), .A(w[20]), .B(w[21]), .CI(1'b1), .number(transistor_count[51]));
	FA1 f12(.CO(c[16]), .S(s[11]), .A(w[22]), .B(w[23]), .CI(w[24]), .number(transistor_count[52]));
	FA1 f13(.CO(c[17]), .S(s[12]), .A(c[10]), .B(s[10]), .CI(c[11]), .number(transistor_count[53]));
	FA1 f14(.CO(c[18]), .S(s[13]), .A(s[11]), .B(s[12]), .CI(c[12]), .number(transistor_count[54]));
	FA1 f15(.CO(c[19]), .S(P[6]), .A(c[13]), .B(s[13]), .CI(c[14]), .number(transistor_count[55]));
	FA1 f16(.CO(c[20]), .S(s[14]), .A(w[25]), .B(w[26]), .CI(w[27]), .number(transistor_count[56]));
	FA1 f17(.CO(c[21]), .S(s[15]), .A(c[15]), .B(w[28]), .CI(c[16]), .number(transistor_count[57]));
	FA1 f18(.CO(c[22]), .S(s[16]), .A(s[14]), .B(s[15]), .CI(c[17]), .number(transistor_count[58]));
	FA1 f19(.CO(c[23]), .S(P[7]), .A(c[18]), .B(s[16]), .CI(c[19]), .number(transistor_count[59]));
	FA1 f20(.CO(c[24]), .S(s[17]), .A(w[29]), .B(w[30]), .CI(c[20]), .number(transistor_count[60]));
	FA1 f21(.CO(c[25]), .S(s[18]), .A(w[31]), .B(s[17]), .CI(c[21]), .number(transistor_count[61]));
	FA1 f22(.CO(c[26]), .S(P[8]), .A(c[22]), .B(s[18]), .CI(c[23]), .number(transistor_count[62]));
	FA1 f23(.CO(c[27]), .S(s[19]), .A(w[32]), .B(w[33]), .CI(c[24]), .number(transistor_count[63]));
	FA1 f24(.CO(c[28]), .S(P[9]), .A(c[25]), .B(s[19]), .CI(c[26]), .number(transistor_count[64]));
	FA1 f25(.CO(c[29]), .S(P[10]), .A(c[27]), .B(w[34]), .CI(c[28]), .number(transistor_count[65]));
	HA1 h6(.O(), .S(P[11]), .A(1'b1), .B(c[29]), .number(transistor_count[66]));//MSB

endmodule

//Carry-Ripple Adder
module CRA(CO, S, A, B, CRA_num);
	output CO;
	output [15:0] S;
	input [15:0] A, B;

	output wire [50:0] CRA_num;
	wire [50:0] transistor_count [15:0];
	wire [14:0]c;
	
	//sum_0 of [15:0]transistor_count
	assign CRA_num = transistor_count[0] + transistor_count[1] + transistor_count[2] + transistor_count[3] + transistor_count[4] + transistor_count[5] + transistor_count[6] + transistor_count[7] + transistor_count[8] + transistor_count[9] + transistor_count[10] + transistor_count[11] + transistor_count[12] + transistor_count[13] + transistor_count[14] + transistor_count[15];

	HA1 f1(.O(c[0]), .S(S[0]), .A(A[0]), .B(B[0]), .number(transistor_count[0])); //no carry-in needed
	FA1 f2(.CO(c[1]), .S(S[1]), .A(A[1]), .B(B[1]), .CI(c[0]), .number(transistor_count[1]));
	FA1 f3(.CO(c[2]), .S(S[2]), .A(A[2]), .B(B[2]), .CI(c[1]), .number(transistor_count[2]));
	FA1 f4(.CO(c[3]), .S(S[3]), .A(A[3]), .B(B[3]), .CI(c[2]), .number(transistor_count[3]));
	FA1 f5(.CO(c[4]), .S(S[4]), .A(A[4]), .B(B[4]), .CI(c[3]), .number(transistor_count[4]));
	FA1 f6(.CO(c[5]), .S(S[5]), .A(A[5]), .B(B[5]), .CI(c[4]), .number(transistor_count[5]));
	FA1 f7(.CO(c[6]), .S(S[6]), .A(A[6]), .B(B[6]), .CI(c[5]), .number(transistor_count[6]));
	FA1 f8(.CO(c[7]), .S(S[7]), .A(A[7]), .B(B[7]), .CI(c[6]), .number(transistor_count[7]));
	FA1 f9(.CO(c[8]), .S(S[8]), .A(A[8]), .B(B[8]), .CI(c[7]), .number(transistor_count[8]));
	FA1 f10(.CO(c[9]), .S(S[9]), .A(A[9]), .B(B[9]), .CI(c[8]), .number(transistor_count[9]));
	FA1 f11(.CO(c[10]), .S(S[10]), .A(A[10]), .B(B[10]), .CI(c[9]), .number(transistor_count[10]));
	FA1 f12(.CO(c[11]), .S(S[11]), .A(A[11]), .B(B[11]), .CI(c[10]), .number(transistor_count[11]));
	//sign extension
	FA1 f13(.CO(c[12]), .S(S[12]), .A(A[12]), .B(B[12]), .CI(c[11]), .number(transistor_count[12]));
	FA1 f14(.CO(c[13]), .S(S[13]), .A(A[13]), .B(B[13]), .CI(c[12]), .number(transistor_count[13]));
	FA1 f15(.CO(c[14]), .S(S[14]), .A(A[14]), .B(B[14]), .CI(c[13]), .number(transistor_count[14]));
	FA1 f16(.CO(CO), .S(S[15]), .A(A[15]), .B(B[15]), .CI(c[14]), .number(transistor_count[15]));

	//critical path delay 9.927(ns)

endmodule

module sixteenBitReg (Q, D, CLK, RESET, number);
	output [15:0] Q;
	input [15:0] D;
	input CLK, RESET;

	output wire [50:0] number;
	wire [50:0] transistor_count [15:0];

	assign number = transistor_count[0] + transistor_count[1] + transistor_count[2] + transistor_count[3] + transistor_count[4] + transistor_count[5] + transistor_count[6] + transistor_count[7] + transistor_count[8] + transistor_count[9] + transistor_count[10] + transistor_count[11] + transistor_count[12] + transistor_count[13] + transistor_count[14] + transistor_count[15];
	
	FD2 fd2_1(.Q(Q[0]), .D(D[0]), .CLK(CLK), .RESET(RESET), .number(transistor_count[1]));
	FD2 fd2_2(.Q(Q[1]), .D(D[1]), .CLK(CLK), .RESET(RESET), .number(transistor_count[2]));
	FD2 fd2_3(.Q(Q[2]), .D(D[2]), .CLK(CLK), .RESET(RESET), .number(transistor_count[3]));
	FD2 fd2_4(.Q(Q[3]), .D(D[3]), .CLK(CLK), .RESET(RESET), .number(transistor_count[4]));
	FD2 fd2_5(.Q(Q[4]), .D(D[4]), .CLK(CLK), .RESET(RESET), .number(transistor_count[5]));
	FD2 fd2_6(.Q(Q[5]), .D(D[5]), .CLK(CLK), .RESET(RESET), .number(transistor_count[6]));
	FD2 fd2_7(.Q(Q[6]), .D(D[6]), .CLK(CLK), .RESET(RESET), .number(transistor_count[7]));
	FD2 fd2_8(.Q(Q[7]), .D(D[7]), .CLK(CLK), .RESET(RESET), .number(transistor_count[8]));
	FD2 fd2_9(.Q(Q[8]), .D(D[8]), .CLK(CLK), .RESET(RESET), .number(transistor_count[9]));
	FD2 fd2_10(.Q(Q[9]), .D(D[9]), .CLK(CLK), .RESET(RESET), .number(transistor_count[10]));
	FD2 fd2_11(.Q(Q[10]), .D(D[10]), .CLK(CLK), .RESET(RESET), .number(transistor_count[11]));
	FD2 fd2_12(.Q(Q[11]), .D(D[11]), .CLK(CLK), .RESET(RESET), .number(transistor_count[12]));
	FD2 fd2_13(.Q(Q[12]), .D(D[12]), .CLK(CLK), .RESET(RESET), .number(transistor_count[13]));
	FD2 fd2_14(.Q(Q[13]), .D(D[13]), .CLK(CLK), .RESET(RESET), .number(transistor_count[14]));
	FD2 fd2_15(.Q(Q[14]), .D(D[14]), .CLK(CLK), .RESET(RESET), .number(transistor_count[15]));
	FD2 fd2_16(.Q(Q[15]), .D(D[15]), .CLK(CLK), .RESET(RESET), .number(transistor_count[0]));

endmodule