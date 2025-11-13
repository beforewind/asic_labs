module dff(clk, reset, d, q);
input clk;
input reset;
input  [15:0] d;
output [15:0] q; 
reg    [15:0] q_r;

always @(posedge clk or posedge reset)
begin
    if(reset)
        q_r <= 16'b0;
    else
        q_r <= d;
end
    
assign q = q_r; 
endmodule
