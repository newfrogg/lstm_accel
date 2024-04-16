`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 11:06:46 PM
// Design Name: 
// Module Name: tanh_appr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tanh_appr #( parameter OUT_BITWIDTH = 8,
                    parameter IN_BITWIDTH = 32) (
                    input   logic   [31:0]  data_in,    //  32 bits input
                    output  logic   [7:0]   data_out    // 8 bits output
        );
                    
            // (1, 7, 24)
        localparam 
//            COEF0   = 32'h80_e8_00_00,  // -0.90625
//            COEF1   = 32'h80_7b_00_00,  // -0.48046875
//            COEF2   = 32'h80_0d_00_00,  // -0.05078125
//            COEF3   = 32'h00_0d_00_00,  // 0.05078125
//            COEF4   = 32'h00_7b_00_00,  // 0.48046875
//            COEF5   = 32'h00_e8_00_00,  // 0.90625
            
            COEF0   = 32'hbf680000,
            COEF1   = 32'hbef60000,
            COEF2   = 32'hbd500000,
            COEF3   = 32'h3d500000,
            COEF4   = 32'h3ef60000,
            COEF5   = 32'h3f680000,
     // (8, 24)
//            RANGE1  = 32'h83_00_00_00,      // -3
//            RANGE2  = 32'h81_E8_F5_C2,      // -1.91
//            RANGE3  = 32'h80_DC_28_F5,      // -0.86
//            RANGE4  = 32'h80_33_33_33,      // -0.2
//            RANGE5  = 32'h00_18_00_00,      // 0.2
//            RANGE6  = 32'h00_DC_28_F5,      // 0.86
//            RANGE7  = 32'h01_E8_F5_C2,      // 1.91
//            RANGE8  = 32'h03_00_00_00;      // 3

            RANGE1  = 32'hc0400000,     // -3
            RANGE2  = 32'hbff47ae1,     // -1.91
            RANGE3  = 32'hbf5c28f6,     // -0.86
            RANGE4  = 32'hbe4ccccd,     // -0.2
            RANGE5  = 32'h3e4ccccd,     // 0.2
            RANGE6  = 32'h3f5c28f6,     // 0.86
            RANGE7  = 32'h3ff47ae1,     // 1.91
            RANGE8  = 32'h40400000;     // 3
            
     logic  [31:0]  temp;
     always @(*) begin
        if (data_in >= RANGE1) begin
            data_out    = -1;
        end
        else if (data_in >= RANGE2 && data_in < RANGE1) begin
            temp        = data_in >>> 5;
            data_out    = {1'b1, {temp[30:24] + COEF0[30:24]} };
        end
        else if (data_in >= RANGE3 && data_in < RANGE2) begin
            temp        = data_in >>> 2;
            data_out    = {1'b1, {temp[30:24] + COEF1[30:24]} };
        end
        else if (data_in >= RANGE4 && data_in < RANGE3) begin
            temp        = data_in + (data_in >>> 2);
            data_out    = {1'b1, {temp[30:24] + COEF2[30:24]} };
        end
        else if (data_in >= 32'h80_00_00_00 && data_in < RANGE4) begin
            data_out    = data_in[31:24];
        end
        else if (data_in >= 32'h00_00_00_00 && data_in < RANGE5) begin
            data_out    = data_in[31:24];
        end
        else if (data_in >= RANGE5 && data_in < RANGE6) begin
            temp        = data_in - (data_in >>> 2);
            data_out    = {1'b0, {temp[30:24] + COEF3[30:24]} };
        end
        else if (data_in >= RANGE6 && data_in < RANGE7) begin
            temp        = data_in >>> 2;
            data_out    = {1'b0, {temp[30:24] + COEF4[30:24]} };
        end
        else if (data_in >= RANGE7 && data_in < RANGE8) begin
            temp        = data_in >>> 5;
            data_out    = {1'b1, {temp[30:24] + COEF5[30:24]} };
        end
        else if (data_in >= RANGE8 && data_in < 32'h7f_ff_ff_ff) begin
            data_out    = 1;
        end
     end
endmodule
