module DSP48A1_tb();

    //=========================== INPUTS ===========================
    reg CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
    reg RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
    reg CLK;
    reg CARRYIN;
    reg [7:0]OPMODE;
    reg [17:0] A,B,D,BCIN;
    reg [47:0] C,PCIN;
    //==============================================================
    
    //=========================== OUTPUTS ===========================
    wire CARRYOUT,CARRYOUTF;
    wire [17:0] BCOUT;
    wire [35:0] M;
    wire [47:0] P,PCOUT;
    //==============================================================

    // ======================================================= Instantiation DUT =======================================================
    DSP48A1 #(.A0REG(0),.A1REG(1),.B0REG(0),.B1REG(1),.CREG(1),.DREG(1),.MREG(1),.PREG(1),.CARRYINREG(1),
                .CARRYOUTREG(1),.OPMODEREG(1),.CARRYINSEL("OPMODE5"),.B_INPUT("DIRECT"),.RSTTYPE("SYNC")) 
                    DUT(A,B,C,D,CLK,CARRYIN,OPMODE,BCIN,
                        RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
                            CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,
                                CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
    // ==================================================================================================================================
    
    // ========= clock generation =========
    initial begin
        CLK = 0;
        forever #1 CLK = ~CLK;
    end
    // ====================================
    
    // =============================================== Stimulus Generation ===============================================
    initial begin
        //2.1 Verify Reset Operation
        {RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE} = {8'b1111_1111};
        {CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE} = {8'b0101_0010};
        CARRYIN = $random;
        OPMODE = $random;
        A = $random;
        B = $random;
        D = $random;
        BCIN = $random;
        C = $random;
        PCIN = $random;
        @(negedge CLK);
        if (CARRYOUT != 1'b0 || CARRYOUTF != 1'b0 || BCOUT !=18'd0 || M != 36'd0 || P !=48'd0 || PCOUT != 48'd0) begin
            $display( "Time=%0t,CARRYOUT =%b,CARRYOUTF =%b,BCOUT =%h,M =%b,P=%h,PCOUT=%h", $time,CARRYOUT,CARRYOUTF,BCOUT,M,P,PCOUT);
            $stop;
        end
        {RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE} = {8'b0000_0000};
        {CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE} = {8'b1111_1111};
        
        //2.2. Verify DSP Path 1
        OPMODE = 8'b1101_1101;
        A = 18'd20; B = 18'd10; C = 48'd350 ; D = 18'd25;
        BCIN = $random;
        CARRYIN = $random;
        PCIN = $random;
        repeat(4) @(negedge CLK);
        if (CARRYOUT != 1'b0 || CARRYOUTF != 1'b0 || BCOUT !=18'hf || M != 36'h12c || P !=48'h32 || PCOUT != 48'h32) begin
            $display( "Time=%0t,CARRYOUT =%b,CARRYOUTF =%b,BCOUT =%h,M =%h,P=%h,PCOUT=%h", $time,CARRYOUT,CARRYOUTF,BCOUT,M,P,PCOUT);
            $stop;
        end

        //2.3. Verify DSP Path 2
        OPMODE = 8'b0001_0000;
        A = 18'd20; B = 18'd10; C = 48'd350 ; D = 18'd25;
        BCIN = $random;
        CARRYIN = $random;
        PCIN = $random;
        repeat(3) @(negedge CLK);
        if (CARRYOUT != 1'b0 || CARRYOUTF != 1'b0 || BCOUT !=18'h23 || M != 36'h2bc || P !=48'd0 || PCOUT != 48'd0) begin
            $display( "Time=%0t,CARRYOUT =%b,CARRYOUTF =%b,BCOUT =%h,M =%h,P=%h,PCOUT=%h", $time,CARRYOUT,CARRYOUTF,BCOUT,M,P,PCOUT);
            $stop;
        end

        //2.4. Verify DSP Path 3 
        OPMODE = 8'b0000_1010;
        A = 18'd20; B = 18'd10; C = 48'd350 ; D = 18'd25;
        BCIN = $random;
        CARRYIN = $random;
        PCIN = $random;
        repeat(3) @(negedge CLK);
        if (CARRYOUT != 1'b0 || CARRYOUTF != 1'b0 || BCOUT !=18'ha || M != 36'hc8 || P !=48'd0 || PCOUT != 48'd0) begin
            $display( "Time=%0t,CARRYOUT =%b,CARRYOUTF =%b,BCOUT =%h,M =%h,P=%h,PCOUT=%h", $time,CARRYOUT,CARRYOUTF,BCOUT,M,P,PCOUT);
            $stop;
        end

        //2.5. Verify DSP Path 4 
        OPMODE = 8'b1010_0111;
        A = 18'd5; B = 18'd6; C = 48'd350 ; D = 18'd25; PCIN = 48'd3000;
        BCIN = $random;
        CARRYIN = $random;
        repeat(3) @(negedge CLK);
        if (CARRYOUT != 1'b1 || CARRYOUTF != 1'b1 || BCOUT !=18'h6 || M != 36'h1e || P !=48'hfe6fffec0bb1 || PCOUT != 48'hfe6fffec0bb1) begin
            $display( "Time=%0t,CARRYOUT =%b,CARRYOUTF =%b,BCOUT =%h,M =%h,P=%h,PCOUT=%h", $time,CARRYOUT,CARRYOUTF,BCOUT,M,P,PCOUT);
            $stop;
        end
        $stop;
    end
    // ====================================================================================================================

endmodule
