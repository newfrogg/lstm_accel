`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2024 07:51:46 PM
// Design Name: 
// Module Name: tb_controller_lstm_unit
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
class GenerateInput;
    randc   bit[31:0]   input_bf;
    constraint c_input  { input_bf  <= 32'h00_ff_ff_ff; }
endclass

class GenerateWeight;
    randc   bit[31:0]   weight_bf;
    constraint c_weight { weight_bf <= 32'h00_ff_ff_ff; }
endclass

class GenerateBias;
    randc   bit[31:0]   bias_bf;
    constraint c_bias_bf { bias_bf <= 32'h00_07_ff_ff; }
endclass

module tb_controller_lstm_unit();
    logic               clk;
    logic               rstn;
    logic               r_valid;
    logic               is_last_data_gate;
    logic [31:0]        data_in;
    logic               r_data;
    logic               t_valid;
    logic [31:0]        out_data [0:3];
    logic [2:0]         o_state;
    logic [2:0]         o_lstm_state;
    logic [1:0]         o_mac_state;
    logic               o_lstm_unit_done;
    logic               o_lstm_is_continued;
    logic               o_lstm_is_waiting;
    logic [1:0]         o_type_gate;
    logic [1:0]         o_gate;
    logic [7:0]         weights [0:2];
    logic [7:0]         inputs [0:2];
    logic [31:0]        bias;
    logic               o_is_load_bias;
    logic               o_is_last_input;
    logic [3:0]         o_index;
    logic [31:0]        o_lstm_accu_bf;
    logic [31:0]        o_mac_result;
    
    
    logic [31:0]        expected_input_gate;
    logic [31:0]        expected_forget_gate;
    logic [31:0]        expected_cell_gate;
    logic [31:0]        expected_output_gate;
    
    logic [31:0]    weight_array [0:3];
    logic [31:0]    input_array;
    logic [31:0]    bias_array [0:3];

    
    controller uut (
        .clk(clk),
        .rstn(rstn),
        .r_valid(r_valid),
        .is_last_data_gate(is_last_data_gate),
        .data_in(data_in),
        .r_data(r_data),
        .t_valid(t_valid),
        .out_data(out_data),
        .o_state(o_state),
        .o_lstm_unit_done(o_lstm_unit_done),
        .o_lstm_state(o_lstm_state),
        .o_lstm_is_continued(o_lstm_is_continued),
        .o_lstm_is_waiting(o_lstm_is_waiting),
        .weights(weights),
        .inputs(inputs),
        .bias(bias),
        .o_is_load_bias(o_is_load_bias),
        .o_index(o_index),
        .o_mac_state(o_mac_state),
        .o_is_last_input(o_is_last_input),
        .o_lstm_accu_bf(o_lstm_accu_bf),
        .o_mac_result(o_mac_result),
        .o_type_gate(o_type_gate),
        .o_gate(o_gate)
    );
    
    always #5 begin 
        clk = ~clk;
         
    end
    integer index;
    integer iter;
    
    GenerateInput   input_pkt;
    GenerateWeight  weight_pkt;
    GenerateBias    bias_pkt;
    
    initial begin
        index = 0;
        iter = 0;
        expected_input_gate = 0;
        expected_forget_gate = 0;
        expected_cell_gate = 0;
        expected_output_gate = 0;
           
        input_pkt       = new ();
        weight_pkt      = new ();
        bias_pkt        = new ();
        
        clk  = 1'b0;
        rstn = 1'b0;
        r_valid = 1'b0;
        data_in = 32'd0;
        
        repeat(10)
            @(negedge clk);
        rstn = 1'b1;
        
        repeat(10)
            @(negedge clk);
    
        r_valid = 1'b1;
        //////1st///////
        $display("///////////////////////////////////////////////////////////");
        $display("//////////////////// Test No[%0d] Start /////////////////////", index);
        $display("///////////////////////////////////////////////////////////\n");
        
        repeat(20) begin
            index = 0;
            repeat(4) begin
                weight_pkt.randomize();
                @(negedge clk);
                data_in = weight_pkt.weight_bf;
                weight_array[index] = weight_pkt.weight_bf;
                index = index + 1;
            end
            
            index = 0;
            repeat(1) begin
                input_pkt.randomize();
                @(negedge clk);
                data_in = input_pkt.input_bf;
                input_array = input_pkt.input_bf;
    //            index = index + 1;
            end
            
            if (iter==0) begin
                index = 0;
                repeat(4) begin
                    bias_pkt.randomize();
                    @(negedge clk);
                    data_in = bias_pkt.bias_bf;
                    bias_array[index]  =  bias_pkt.bias_bf;
                    index = index + 1;
                end
                expected_input_gate = bias_array[0];
                expected_forget_gate = bias_array[1];
                expected_cell_gate = bias_array[2];
                expected_output_gate = bias_array[3];
            end
            else ;
            
            expected_input_gate = expected_input_gate + weight_array[0][7:0]*input_array[7:0] + weight_array[0][15:8]*input_array[15:8] + weight_array[0][23:16]*input_array[23:16];
            expected_forget_gate = expected_forget_gate + weight_array[1][7:0]*input_array[7:0] + weight_array[1][15:8]*input_array[15:8] + weight_array[1][23:16]*input_array[23:16];
            expected_cell_gate = expected_cell_gate + weight_array[2][7:0]*input_array[7:0] + weight_array[2][15:8]*input_array[15:8] + weight_array[2][23:16]*input_array[23:16];
            expected_output_gate = expected_output_gate + weight_array[3][7:0]*input_array[7:0] + weight_array[3][15:8]*input_array[15:8] + weight_array[3][23:16]*input_array[23:16];
    //        for (index = 0; index < 10; index = index + 1) begin
    //            expected_value = expected_value + weight_array[index][7:0]*input_array[index][7:0] + weight_array[index][15:8]*input_array[index][15:8] + weight_array[index][23:16]*input_array[index][23:16];
    //            $display("Accumulation[%0d] = %0h", index, expected_value);
    //        end
            
    //        $display("Accumulation[%0d] = %0h", index, expected_value);
            repeat(1) begin
                @(negedge clk);
                r_valid = 1'b0;
                data_in = 32'd0;
            end
            if (iter < 19) begin
                iter = iter + 1;
                is_last_data_gate = 1'b0;
                wait(r_data);
                @(negedge clk);
                r_valid = 1'b1;
            end
            else is_last_data_gate = 1'b1;
            
        end  
        
        wait(t_valid);
            
        if (out_data[0] === expected_input_gate && out_data[1] === expected_forget_gate && out_data[2] === expected_cell_gate && out_data[3] === expected_output_gate) begin
            $display("///////////////////////////////////////////////////////////\n");
            $display("Expected Result = [%0h, %0h, %0h, %0h], Real result = [%0h, %0h, %0h, %0h]", expected_input_gate, expected_forget_gate, expected_cell_gate, expected_output_gate, out_data[0], out_data[1], out_data[2], out_data[3]);
            $display("-------------Test No[%0d]: Result is correct!------------", index);
            $display("///////////////////////////////////////////////////////////\n");
        end
        else begin
            $display("///////////////////////////////////////////////////////////");
            $display("Expected Result = [%0h, %0h, %0h, %0h], Real result = [%0h, %0h, %0h, %0h]", expected_input_gate, expected_forget_gate, expected_cell_gate, expected_output_gate, out_data[0], out_data[1], out_data[2], out_data[3]);
            $display("--------------- Test No[%0d]: Result is wrong! ----------------", index);
            $display("///////////////////////////////////////////////////////////\n");
        end
        
        /*    
        repeat(10) begin
            pkt.randomize();
            if (index != 0) begin 
                pkt.pre_sum_bf = 32'h0;
            end
            else ;
            
            expected_value = accumulation + (pkt.weight_bf[7:0] * pkt.input_bf[7:0]) + (pkt.weight_bf[15:8] * pkt.input_bf[15:8]) + (pkt.weight_bf[23:16] * pkt.input_bf[23:16]) + pkt.pre_sum_bf[18:0];
            
            clk  = 1'b0;
            rstn = 1'b0;
            r_valid = 1'b0;
            data_in = 32'd0;
            
            repeat(10)
                @(negedge clk);
            rstn = 1'b1;
            
            //////1st///////
            $display("///////////////////////////////////////////////////////////");
            $display("//////////////////// Test No[%0d] Start /////////////////////", index);
            $display("///////////////////////////////////////////////////////////\n");
    
            repeat(10)
                @(negedge clk);
    
            r_valid = 1'b1;
            
            @(negedge clk) begin
                data_in = pkt.weight_bf;
            end
            
            @(negedge clk) begin
                data_in = pkt.input_bf;
            end
            
            @(negedge clk) begin
                data_in = pkt.pre_sum_bf;
            end
                
            @(negedge clk);
            r_valid = 1'b0;
            data_in = 32'd0;
            $display("Weight[2, 1, 0] = [%0h, %0h, %0h]", uut.weights_2, uut.weights_1, uut.weights_0);
            $display("input[2, 1, 0] = [%0h, %0h, %0h], pre_sum = %0h \n", uut.data_in_2, uut.data_in_1, uut.data_in_0, uut.pre_sum);
            wait(t_valid);
            
            if (out_data === expected_value) begin
                $display("///////////////////////////////////////////////////////////\n");
                $display("Expected Result = %0h, Real result = %0h", expected_value, out_data);
                $display("-------------Test No[%0d]: Result is correct!------------", index);
                $display("///////////////////////////////////////////////////////////\n");
            end
            else begin
                $display("///////////////////////////////////////////////////////////");
                $display("Expected Result = %0h, Real result = %0h", expected_value, out_data);
                $display("--------------- Test No[%0d]: Result is wrong! ----------------", index);
                $display("///////////////////////////////////////////////////////////\n");
            end
        end
        */
    end
    
endmodule
