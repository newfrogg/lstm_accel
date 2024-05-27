#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2023.1 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Mon May 27 11:43:24 +07 2024
# SW Build 3865809 on Sun May  7 15:04:56 MDT 2023
#
# IP Build 3864474 on Sun May  7 20:36:21 MDT 2023
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# simulate design
echo "xsim tb_accelerator_real_data_behav -key {Behavioral:sim_1:Functional:tb_accelerator_real_data} -tclbatch tb_accelerator_real_data.tcl -view /home/vanloi/Documents/Loi_study/DATN/vivado_LSTM/lstm_accelerator/lstm_accelerator.srcs/sim_1/imports/lstm_accelerator/tb_accelerator_real_data_behav.wcfg -log simulate.log"
xsim tb_accelerator_real_data_behav -key {Behavioral:sim_1:Functional:tb_accelerator_real_data} -tclbatch tb_accelerator_real_data.tcl -view /home/vanloi/Documents/Loi_study/DATN/vivado_LSTM/lstm_accelerator/lstm_accelerator.srcs/sim_1/imports/lstm_accelerator/tb_accelerator_real_data_behav.wcfg -log simulate.log

