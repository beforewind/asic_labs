module fir(clk, data_in, reset, data_out);

input clk; 
input signed [7:0] data_in; 
input reset; 
output signed [15:0] data_out; 
reg    signed [15:0] data_out_reg;

// coefficients
wire  signed [7:0]  h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12;
// multiplies
wire  signed [15:0] m0,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12; 
// taps delays
wire  signed [15:0] q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12; 
// adders
wire  signed [15:0] a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12;

// coefs from fir_design.py : [-1. -7. -4.  4. 18. 32. 38. 32. 18.  4. -4. -7. -1.]
// coeffs definition
assign h0  = -1;
assign h1  = -7;
assign h2  = -4;
assign h3  = 4;
assign h4  = 18;
assign h5  = 32;
assign h6  = 38;
assign h7  = 32;
assign h8  = 18;
assign h9  = 4;
assign h10 = -4;
assign h11 = -7;
assign h12 = -1;

// each multiply in the chain
assign m12 = h12 * data_in; 
assign m11 = h11 * data_in; 
assign m10 = h10 * data_in; 
assign m9  = h9  * data_in; 
assign m8  = h8  * data_in; 
assign m7  = h7  * data_in; 
assign m6  = h6  * data_in; 
assign m5  = h5  * data_in; 
assign m4  = h4  * data_in; 
assign m3  = h3  * data_in; 
assign m2  = h2  * data_in; 
assign m1  = h1  * data_in; 
assign m0  = h0  * data_in; 

// each add in the chain
assign a1  = q1  + m11;
assign a2  = q2  + m10; 
assign a3  = q3  + m9;
assign a4  = q4  + m8; 
assign a5  = q5  + m7;
assign a6  = q6  + m6; 
assign a7  = q7  + m5;
assign a8  = q8  + m4; 
assign a9  = q9  + m3;
assign a10 = q10 + m2; 
assign a11 = q11 + m1;
assign a12 = q12 + m0; 

// delay line
dff dff1( .clk(clk), .reset(reset),.d(m12), .q(q1)); 
dff dff2( .clk(clk), .reset(reset),.d(a1),  .q(q2)); 
dff dff3( .clk(clk), .reset(reset),.d(a2),  .q(q3)); 
dff dff4( .clk(clk), .reset(reset),.d(a3),  .q(q4)); 
dff dff5( .clk(clk), .reset(reset),.d(a4),  .q(q5)); 
dff dff6( .clk(clk), .reset(reset),.d(a5),  .q(q6)); 
dff dff7( .clk(clk), .reset(reset),.d(a6),  .q(q7)); 
dff dff8( .clk(clk), .reset(reset),.d(a7),  .q(q8)); 
dff dff9( .clk(clk), .reset(reset),.d(a8),  .q(q9)); 
dff dff10(.clk(clk), .reset(reset),.d(a9),  .q(q10)); 
dff dff11(.clk(clk), .reset(reset),.d(a10), .q(q11)); 
dff dff12(.clk(clk), .reset(reset),.d(a11), .q(q12)); 

// filter output data_out[n] = conv(x[n], h[n])
always @(posedge clk)
begin
  if(reset)
    data_out_reg <= 0;
  else
    data_out_reg <= a12;
end
assign data_out = data_out_reg;

// Dump waves
initial begin
  $dumpfile("dump.vcd");
  $dumpvars(1, fir);
end
endmodule
