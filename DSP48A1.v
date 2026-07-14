module DSP48A1(A,B,C,D,CLK,CARRYIN,OPMODE,BCIN,
                RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
                    CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,
                        CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
    
    //=========================== PARAMETERS ===========================
    parameter A0REG = 0; parameter A1REG = 1;
    parameter B0REG = 0; parameter B1REG = 1;
    parameter CREG = 1;
    parameter DREG = 1;
    parameter MREG = 1;
    parameter PREG = 1;
    parameter CARRYINREG = 1;
    parameter CARRYOUTREG = 1;
    parameter OPMODEREG = 1;
    parameter CARRYINSEL = "OPMODE5";//OPMODE5 OR CARRYIN
    parameter B_INPUT = "DIRECT"; //DIRECT OR CASCADE
    parameter RSTTYPE = "SYNC"; //SYNC OR ASYNC
    //==================================================================
    
    //=========================== INPUTS ===========================
    input CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
    input RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
    input CLK;
    input CARRYIN;
    input [7:0]OPMODE;
    input [17:0] A,B,D,BCIN;
    input [47:0] C,PCIN;
    //==============================================================

    //=========================== OUTPUTS ===========================
    output CARRYOUT,CARRYOUTF;
    output [17:0] BCOUT;
    output [35:0] M;
    output [47:0] P,PCOUT;
    //==============================================================

    //=========================== WIRES ===========================
    wire [17:0] A0_REG,A1_REG,B0_REG,B1_REG,D_REG,B_out;
    wire [47:0] C_REG,post_add_sub,out_X,out_Z;
    wire [35:0] M_REG,out_multiplier;
    wire [17:0] pre_add_sub,i_B1_REG;
    wire i_CYI,o_CYI;
    wire i_CYO;
    wire o_opmode_4,o_opmode_5,o_opmode_6,o_opmode_7;
    wire [1:0] o_opmode_0_1,o_opmode_3_2;
    //==============================================================


    //==================================================================== INSTANTIATIONS DFF_MUX ====================================================================
    dff_mux #(.WIDTH(18),.SEL(A0REG),.RSTTYPE(RSTTYPE)) a0reg(.i_clk(CLK),.i_rst(RSTA),.i_en(CEA),.i_data(A),.o_data(A0_REG));
    dff_mux #(.WIDTH(18),.SEL(A1REG),.RSTTYPE(RSTTYPE)) a1reg(.i_clk(CLK),.i_rst(RSTA),.i_en(CEA),.i_data(A0_REG),.o_data(A1_REG));
    dff_mux #(.WIDTH(18),.SEL(B0REG),.RSTTYPE(RSTTYPE)) b0reg(.i_clk(CLK),.i_rst(RSTB),.i_en(CEB),.i_data(B_out),.o_data(B0_REG));
    dff_mux #(.WIDTH(18),.SEL(B1REG),.RSTTYPE(RSTTYPE)) b1reg(.i_clk(CLK),.i_rst(RSTB),.i_en(CEB),.i_data(i_B1_REG),.o_data(B1_REG));
    dff_mux #(.WIDTH(18),.SEL(DREG),.RSTTYPE(RSTTYPE)) dreg(.i_clk(CLK),.i_rst(RSTD),.i_en(CED),.i_data(D),.o_data(D_REG));
    dff_mux #(.WIDTH(48),.SEL(CREG),.RSTTYPE(RSTTYPE)) creg(.i_clk(CLK),.i_rst(RSTC),.i_en(CEC),.i_data(C),.o_data(C_REG));
    dff_mux #(.WIDTH(36),.SEL(MREG),.RSTTYPE(RSTTYPE)) mreg(.i_clk(CLK),.i_rst(RSTM),.i_en(CEM),.i_data(out_multiplier),.o_data(M_REG));
    dff_mux #(.WIDTH(1),.SEL(CARRYINREG),.RSTTYPE(RSTTYPE))  CYI(.i_clk(CLK),.i_rst(RSTCARRYIN),.i_en(CECARRYIN),.i_data(i_CYI),.o_data(o_CYI));
    dff_mux #(.WIDTH(1),.SEL(CARRYOUTREG),.RSTTYPE(RSTTYPE)) CYO(.i_clk(CLK),.i_rst(RSTCARRYIN),.i_en(CECARRYIN),.i_data(i_CYO),.o_data(CARRYOUT));
    dff_mux #(.WIDTH(48),.SEL(PREG),.RSTTYPE(RSTTYPE)) preg(.i_clk(CLK),.i_rst(RSTP),.i_en(CEP),.i_data(post_add_sub),.o_data(P));
    
    dff_mux #(.WIDTH(2),.SEL(OPMODEREG),.RSTTYPE(RSTTYPE)) opmode01(.i_clk(CLK),.i_rst(RSTOPMODE),.i_en(CEOPMODE),.i_data(OPMODE[1:0]),.o_data(o_opmode_0_1));
    dff_mux #(.WIDTH(2),.SEL(OPMODEREG),.RSTTYPE(RSTTYPE)) opmode32(.i_clk(CLK),.i_rst(RSTOPMODE),.i_en(CEOPMODE),.i_data(OPMODE[3:2]),.o_data(o_opmode_3_2));
    dff_mux #(.WIDTH(1),.SEL(OPMODEREG),.RSTTYPE(RSTTYPE)) opmode4(.i_clk(CLK),.i_rst(RSTOPMODE),.i_en(CEOPMODE),.i_data(OPMODE[4]),.o_data(o_opmode_4));
    dff_mux #(.WIDTH(1),.SEL(OPMODEREG),.RSTTYPE(RSTTYPE)) opmode5(.i_clk(CLK),.i_rst(RSTOPMODE),.i_en(CEOPMODE),.i_data(OPMODE[5]),.o_data(o_opmode_5));
    dff_mux #(.WIDTH(1),.SEL(OPMODEREG),.RSTTYPE(RSTTYPE)) opmode6(.i_clk(CLK),.i_rst(RSTOPMODE),.i_en(CEOPMODE),.i_data(OPMODE[6]),.o_data(o_opmode_6));
    dff_mux #(.WIDTH(1),.SEL(OPMODEREG),.RSTTYPE(RSTTYPE)) opmode7(.i_clk(CLK),.i_rst(RSTOPMODE),.i_en(CEOPMODE),.i_data(OPMODE[7]),.o_data(o_opmode_7));
    //===================================================================================================================================================================

    //================================================= INSTAANTIATION MUX_4 =================================================
    mux_4 X(.i_sel(o_opmode_0_1),.i_in0(48'd0),.i_in1({12'd0,M_REG}),.i_in2(P),.i_in3({D[11:0],A1_REG,B1_REG}),.o_out(out_X));
    mux_4 Z(.i_sel(o_opmode_3_2),.i_in0(48'd0),.i_in1(PCIN),.i_in2(P),.i_in3(C_REG),.o_out(out_Z));
    //========================================================================================================================

    //======================================== assign ==========================================
    assign B_out = (B_INPUT == "DIRECT")?B:(B_INPUT == " CASCADE")?BCIN:0;
    assign pre_add_sub = (o_opmode_6)?(D_REG-B0_REG) : (D_REG+B0_REG) ;
    assign i_B1_REG = (o_opmode_4)?pre_add_sub:B0_REG;
    assign out_multiplier = B1_REG * A1_REG;
    assign i_CYI = (CARRYINSEL == "OPMODE5")?o_opmode_5:(CARRYINSEL == "CARRYIN")?CARRYIN:0;
    assign {i_CYO,post_add_sub} = (o_opmode_7)?(out_Z-(out_X+o_CYI)):(out_X+out_Z+o_CYI);
    assign BCOUT = B1_REG;
    assign M = M_REG;
    assign CARRYOUTF = CARRYOUT;
    assign PCOUT = P;
    //=============================================================================================
    
endmodule
