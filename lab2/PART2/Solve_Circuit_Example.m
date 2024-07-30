% cleaning the workspace, and cmd window
clear all;
close all;
clc;

fprintf('the first netlist:\n');
[sum,num]=Solve_AC_Circuit('circuit_1.cir');

clear all;
fprintf('the second netlist:\n');
[sum,num]=Solve_AC_Circuit('circuit_2.cir');

clear all;

fprintf('the third netlist:\n');
[sum,num]=Solve_AC_Circuit('circuit_3.cir');

