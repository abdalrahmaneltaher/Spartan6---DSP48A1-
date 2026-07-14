module dff_mux(i_clk,i_rst,i_en,i_data,o_data);

    //parameter
    parameter WIDTH = 18;
    parameter SEL = 1;
    parameter RSTTYPE = "SYNC"; //ASYNC or SYNC
    
    //inputs
    input i_en,i_clk,i_rst;
    input [WIDTH-1:0] i_data;
    
    //output
    output [WIDTH-1:0] o_data;

    reg [WIDTH-1:0] q;

    generate
        if (RSTTYPE == "SYNC") begin
            always @(posedge i_clk) begin
                if(i_rst)
                    q <= 0;
                else begin
                    if(i_en)
                        q <= i_data;
                end
            end
        end
        else if(RSTTYPE == "ASYNC") begin
            always @(posedge i_clk or posedge i_rst) begin
                if(i_rst)
                    q <= 0;
                else begin
                    if(i_en)
                        q <= i_data;
                end
            end
        end
    endgenerate

    assign o_data =(SEL == 1)? q:i_data;

endmodule
