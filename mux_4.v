module mux_4(i_sel,i_in0,i_in1,i_in2,i_in3,o_out);

    //inputs 
    input [1:0] i_sel;
    input [47:0] i_in0,i_in1,i_in2,i_in3;

    //output
    output reg [47:0] o_out;

    always @(*) begin
        case (i_sel)
            2'b00 : o_out = i_in0;
            2'b01 : o_out = i_in1;
            2'b10 : o_out = i_in2;
            2'b11 : o_out = i_in3;
            default o_out = 48'd0;
        endcase
    end

endmodule
