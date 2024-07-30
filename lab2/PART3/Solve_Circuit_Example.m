% cleaning the workspace, and cmd window
clear all;
close all;
clc;

% running the first SPICE netlist
fprintf('the first netlist:\n');
[sum,num]=Solve_AMP_Circuit('circuit_1.cir');


