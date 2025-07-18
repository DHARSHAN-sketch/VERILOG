\\topmodule

module fourtop(
    input [3:0] a_in, b_in,
    input cin_in, clk, clear,
    output [3:0] sum_out,
    output cout_out
);

    // Internal wires
    wire [3:0] a, b;
    wire cin;
    wire [3:0] a_bar, b_bar, cin_bar;

    wire [3:0] sum_from_fa, sumzer, sumone;
    wire cout_from_fa;
    wire [3:0] sum_bar;
    wire cout_bar;

    // Input D Flip-Flops
    D_FF_4BIT dff_a(clk, clear, a_in, a, a_bar);
    D_FF_4BIT dff_b(clk, clear, b_in, b, b_bar);
    D_FF_1BIT dff_c(clk, clear, cin_in, cin, cin_bar);

    // Carry Select Adder
    carryselect FA1(sumzer, sumone, sum_from_fa, cout_from_fa, a, b, cin);

    // Output D Flip-Flops
    D_FF_4BIT dff_sum(clk, clear, sum_from_fa, sum_out, sum_bar);
    D_FF_1BIT dff_cout(clk, clear, cout_from_fa, cout_out, cout_bar);

endmodule

\\D flipflop
module D_FF_1BIT (
    input clk1,    
    input reset1,  
    input d, 
    output reg q,
    output reg qb 
);

    always @(posedge clk1 or posedge reset1) 
    begin
        if (reset1)
        begin
            q <= 1'b0;
            qb<=1'b1; 
            end
        else
        begin
            q <= d; 
            qb <= ~d;  
            end
    end

endmodule

\\4Bit D flipflop
module D_FF_4BIT (input clk,input reset,input [3:0] d, 
output reg [3:0] q,output reg [3:0] qb);
    always @(posedge clk or posedge reset) 
    begin
        if (reset)
        begin
            q <= 4'b0000;
            qb<=4'b1111; // Reset output to 0
            end
        else
        begin
            q <= d; 
            qb <= ~d;
            
            end
    end
endmodule

\\ Carry select adder code
module carryselect(output [3:0] sum0,sum1, sum,output c_out,
                   input [3:0] a, b,c_in);
wire c1_0, c2_0, c3_0, cout_0;
wire c1_1, c2_1, c3_1, cout_1;

    FULL_ADDER FA1(sum0[0], c1_0, a[0], b[0], c_in);
    FULL_ADDER FA2(sum0[1], c2_0, a[1], b[1], c1_0);
    FULL_ADDER FA3(sum0[2], c3_0, a[2], b[2], c2_0);
    FULL_ADDER FA4(sum0[3], cout_0, a[3], b[3], c3_0);

    FULL_ADDER FA5(sum1[0], c1_1, a[0], b[0], c_in);
    FULL_ADDER FA6(sum1[1], c2_1, a[1], b[1], c1_1);
    FULL_ADDER FA7(sum1[2], c3_1, a[2], b[2], c2_1);
    FULL_ADDER FA8(sum1[3], cout_1, a[3], b[3], c3_1);

    always @(*) begin
        case(c_in)
            1'b0: sum = sum0;
            1'b1: sum = sum1;
        endcase
    end
    assign c_out = (c_in == 1'b0) ? cout_0 : cout_1;
endmodule


