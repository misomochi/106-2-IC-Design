`timescale 1ns/1ps
`include "lib.v"

module COMPARATOR_51(median, i0, i1, i2, i3, i4);
	//DO NOT CHANGE!
	output [2:0] median;
	input  [7:0] i0, i1, i2, i3, i4;

    wire [29:0]w;
    wire [9:0]g;
    wire ALB, AGB, ALC, AGC, ALD, AGD, ALE, AGE, BLC, BGC, BLD, BGD, BLE, BGE, CLD, CGD, CLE, CGE, DLE, DGE, MA, MB, MC, MD;

    // i0~i4 comparison
    BC_8 C1(.L(ALB), .G(AGB), .a(i0), .b(i1)); // A&B
    BC_8 C2(.L(ALC), .G(AGC), .a(i0), .b(i2)); // A&C
    BC_8 C3(.L(ALD), .G(AGD), .a(i0), .b(i3)); // A&D
    BC_8 C4(.L(ALE), .G(AGE), .a(i0), .b(i4)); // A&E
    BC_8 C5(.L(BLC), .G(BGC), .a(i1), .b(i2)); // B&C
    BC_8 C6(.L(BLD), .G(BGD), .a(i1), .b(i3)); // B&D
    BC_8 C7(.L(BLE), .G(BGE), .a(i1), .b(i4)); // B&E
    BC_8 C8(.L(CLD), .G(CGD), .a(i2), .b(i3)); // C&D
    BC_8 C9(.L(CLE), .G(CGE), .a(i2), .b(i4)); // C&E
    BC_8 C10(.L(DLE), .G(DGE), .a(i3), .b(i4)); // D&E
    // i0 is the median
    AN4 A1(.Z(w[0]), .A(ALB), .B(ALC), .C(AGD), .D(AGE));
    AN4 A2(.Z(w[1]), .A(ALB), .B(ALD), .C(AGC), .D(AGE));
    AN4 A3(.Z(w[2]), .A(ALB), .B(ALE), .C(AGC), .D(AGD));
    AN4 A4(.Z(w[3]), .A(ALC), .B(ALD), .C(AGB), .D(AGE));
    AN4 A5(.Z(w[4]), .A(ALC), .B(ALE), .C(AGB), .D(AGD));
    AN4 A6(.Z(w[5]), .A(ALD), .B(ALE), .C(AGB), .D(AGC));
    OR3 O1(.Z(g[0]), .A(w[0]), .B(w[1]), .C(w[2]));
    OR3 O2(.Z(g[1]), .A(w[3]), .B(w[4]), .C(w[5]));
    OR2 O3(.Z(MA), .A(g[0]), .B(g[1]));
    // i1 is the median
    AN4 A7(.Z(w[6]), .A(AGB), .B(BLC), .C(BGD), .D(BGE));
    AN4 A8(.Z(w[7]), .A(AGB), .B(BLD), .C(BGC), .D(BGE));
    AN4 A9(.Z(w[8]), .A(AGB), .B(BLE), .C(BGC), .D(BGD));
    AN4 A10(.Z(w[9]), .A(BLC), .B(BLD), .C(ALB), .D(BGE));
    AN4 A11(.Z(w[10]), .A(BLC), .B(BLE), .C(ALB), .D(BGD));
    AN4 A12(.Z(w[11]), .A(BLD), .B(BLE), .C(ALB), .D(BGC));
    OR3 O4(.Z(g[2]), .A(w[6]), .B(w[7]), .C(w[8]));
    OR3 O5(.Z(g[3]), .A(w[9]), .B(w[10]), .C(w[11]));
    OR2 O6(.Z(MB), .A(g[2]), .B(g[3]));
    // i2 is the median
    AN4 A13(.Z(w[12]), .A(AGC), .B(BGC), .C(CGD), .D(CGE));
    AN4 A14(.Z(w[13]), .A(AGC), .B(CLD), .C(BLC), .D(CGE));
    AN4 A15(.Z(w[14]), .A(AGC), .B(CLE), .C(BLC), .D(CGD));
    AN4 A16(.Z(w[15]), .A(BGC), .B(CLD), .C(ALC), .D(CGE));
    AN4 A17(.Z(w[16]), .A(BGC), .B(CLE), .C(ALC), .D(CGD));
    AN4 A18(.Z(w[17]), .A(CLD), .B(CLE), .C(ALC), .D(BLC));
    OR3 O7(.Z(g[4]), .A(w[12]), .B(w[13]), .C(w[14]));
    OR3 O8(.Z(g[5]), .A(w[15]), .B(w[16]), .C(w[17]));
    OR2 O9(.Z(MC), .A(g[4]), .B(g[5]));
    // i3 is the median
    AN4 A19(.Z(w[18]), .A(AGD), .B(BGD), .C(CLD), .D(DGE));
    AN4 A20(.Z(w[19]), .A(AGD), .B(CGD), .C(BLD), .D(DGE));
    AN4 A21(.Z(w[20]), .A(AGD), .B(DLE), .C(BLD), .D(CLD));
    AN4 A22(.Z(w[21]), .A(BGD), .B(CGD), .C(ALD), .D(DGE));
    AN4 A23(.Z(w[22]), .A(BGD), .B(DLE), .C(ALD), .D(CLD));
    AN4 A24(.Z(w[23]), .A(CGD), .B(DLE), .C(ALD), .D(BLD));
    OR3 O10(.Z(g[6]), .A(w[18]), .B(w[19]), .C(w[20]));
    OR3 O11(.Z(g[7]), .A(w[21]), .B(w[22]), .C(w[23]));
    OR2 O12(.Z(MD), .A(g[6]), .B(g[7]));
    // i4 is the median
    AN4 A25(.Z(w[24]), .A(AGE), .B(BGE), .C(CLE), .D(DLE));
    AN4 A26(.Z(w[25]), .A(AGE), .B(CGE), .C(BLE), .D(DLE));
    AN4 A27(.Z(w[26]), .A(AGE), .B(DGE), .C(BLE), .D(CLE));
    AN4 A28(.Z(w[27]), .A(BGE), .B(CGE), .C(ALE), .D(DLE));
    AN4 A29(.Z(w[28]), .A(BGE), .B(DGE), .C(ALE), .D(CLE));
    AN4 A30(.Z(w[29]), .A(CGE), .B(DGE), .C(ALE), .D(BLE));
    OR3 O13(.Z(g[8]), .A(w[24]), .B(w[25]), .C(w[26]));
    OR3 O14(.Z(g[9]), .A(w[27]), .B(w[28]), .C(w[29]));
    //median[2]
    OR2 O15(.Z(median[2]), .A(g[8]), .B(g[9]));
    //median[1]
    OR2 O16(.Z(median[1]), .A(MC), .B(MD));
    //median[0]
    OR2 O17(.Z(median[0]), .A(MB), .B(MD));
endmodule

//1-bit comparator
module BC_1(L, E, G, a, b);
    output L, E, G;
    input a, b;

    wire [1:0]w;

    IV i1(.Z(w[0]), .A(a));
    IV i2(.Z(w[1]), .A(b));
    AN2 a1(.Z(L), .A(w[0]), .B(b)); //a<b
    AN2 a2(.Z(G), .A(w[1]), .B(a)); //a>b
    NR2 n1(.Z(E), .A(L), .B(G)); //a=b
endmodule

//8-bit comparator for 2's complement
module BC_8(L, G, a, b);
    output L, G;
    input [7:0]a, b;

    wire [23:0]w;
    wire [13:0]l;
    wire [26:0]g;

    // 1-bit comparators c1~c8
    BC_1 c1(.L(w[0]), .E(w[1]), .G(w[2]), .a(a[7]), .b(b[7]));
    BC_1 c2(.L(w[3]), .E(w[4]), .G(w[5]), .a(a[6]), .b(b[6]));
    BC_1 c3(.L(w[6]), .E(w[7]), .G(w[8]), .a(a[5]), .b(b[5]));
    BC_1 c4(.L(w[9]), .E(w[10]), .G(w[11]), .a(a[4]), .b(b[4]));
    BC_1 c5(.L(w[12]), .E(w[13]), .G(w[14]), .a(a[3]), .b(b[3]));
    BC_1 c6(.L(w[15]), .E(w[16]), .G(w[17]), .a(a[2]), .b(b[2]));
    BC_1 c7(.L(w[18]), .E(w[19]), .G(w[20]), .a(a[1]), .b(b[1]));
    BC_1 c8(.L(w[21]), .E(), .G(w[23]), .a(a[0]), .b(b[0]));
    //when former bits are the same
    AN2 a1(.Z(l[0]), .A(w[1]), .B(w[3]));
    AN2 a2(.Z(l[1]), .A(w[1]), .B(w[5]));
    AN3 a3(.Z(l[2]), .A(w[1]), .B(w[4]), .C(w[6]));
    AN3 a4(.Z(l[3]), .A(w[1]), .B(w[4]), .C(w[8]));
    AN4 a5(.Z(l[4]), .A(w[1]), .B(w[4]), .C(w[7]), .D(w[9]));
    AN4 a6(.Z(l[5]), .A(w[1]), .B(w[4]), .C(w[7]), .D(w[11]));
    //5-input AND (A<B)
    AN2 a7(.Z(g[0]), .A(w[1]), .B(w[4]));
    AN2 a8(.Z(g[1]), .A(w[7]), .B(w[10]));
    AN3 a9(.Z(l[6]), .A(g[0]), .B(g[1]), .C(w[12]));
    //5-input AND (A>B)
    AN2 a10(.Z(g[2]), .A(w[1]), .B(w[4]));
    AN2 a11(.Z(g[3]), .A(w[7]), .B(w[10]));
    AN3 a12(.Z(l[7]), .A(g[2]), .B(g[3]), .C(w[14]));
    //6-input AND (A<B)
    AN3 a13(.Z(g[4]), .A(w[1]), .B(w[4]), .C(w[7]));
    AN3 a14(.Z(g[5]), .A(w[10]), .B(w[13]), .C(w[15]));
    AN2 a15(.Z(l[8]), .A(g[4]), .B(g[5]));
    //6-input AND (A>B)
    AN3 a16(.Z(g[6]), .A(w[1]), .B(w[4]), .C(w[7]));
    AN3 a17(.Z(g[7]), .A(w[10]), .B(w[13]), .C(w[17]));
    AN2 a18(.Z(l[9]), .A(g[6]), .B(g[7]));
    //7-input AND
    AN3 a19(.Z(g[8]), .A(w[1]), .B(w[4]), .C(w[7]));
    AN3 a20(.Z(g[9]), .A(w[10]), .B(w[13]), .C(w[16]));
    AN3 a21(.Z(l[10]), .A(g[8]), .B(g[9]), .C(w[18]));
    //7-input AND
    AN3 a22(.Z(g[10]), .A(w[20]), .B(w[16]), .C(w[13]));
    AN3 a23(.Z(g[11]), .A(w[10]), .B(w[7]), .C(w[4]));
    AN3 a24(.Z(l[11]), .A(g[10]),.B(g[11]),.C(w[1]));
    //8-input AND
    AN3 a25(.Z(g[12]), .A(w[21]), .B(w[19]), .C(w[16]));
    AN3 a26(.Z(g[13]), .A(w[13]), .B(w[10]), .C(w[7]));
    AN2 a27(.Z(g[14]), .A(w[4]), .B(w[1]));
    AN3 a28(.Z(l[12]), .A(g[12]), .B(g[13]), .C(g[14]));
    //8-input AND
    AN3 a29(.Z(g[15]), .A(w[23]), .B(w[19]), .C(w[16]));
    AN3 a30(.Z(g[16]), .A(w[13]), .B(w[10]), .C(w[7]));
    AN2 a31(.Z(g[17]), .A(w[4]), .B(w[1]));
    AN3 a32(.Z(l[13]), .A(g[15]), .B(g[16]), .C(g[17]));
    //A<B: 8-input OR
    OR3 o1(.Z(g[18]), .A(w[2]), .B(l[0]), .C(l[2]));
    OR3 o2(.Z(g[19]), .A(l[4]), .B(l[6]), .C(l[8]));
    OR2 o3(.Z(g[20]), .A(l[10]), .B(l[12]));
    OR3 o4(.Z(L), .A(g[18]), .B(g[19]), .C(g[20]));
    //A>B: 8-input OR
    OR3 o5(.Z(g[21]), .A(w[0]), .B(l[1]), .C(l[3]));
    OR3 o6(.Z(g[22]), .A(l[5]), .B(l[7]), .C(l[9]));
    OR2 o7(.Z(g[23]), .A(l[11]), .B(l[13]));
    OR3 o8(.Z(G), .A(g[21]), .B(g[22]), .C(g[23]));
endmodule