#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2023.1 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Wed Apr 10 13:24:41 +07 2024
# SW Build 3865809 on Sun May  7 15:04:56 MDT 2023
#
# IP Build 3864474 on Sun May  7 20:36:21 MDT 2023
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# simulate design
echo "xsim tb_controller_lstm_unit_behav -key {Behavioral:sim_1:Functional:tb_controller_lstm_unit} -tclbatch tb_controller_lstm_unit.tcl -log simulate.log"
xsim tb_controller_lstm_unit_behav -key {Behavioral:sim_1:Functional:tb_controller_lstm_unit} -tclbatch tb_controller_lstm_unit.tcl -log simulate.log

