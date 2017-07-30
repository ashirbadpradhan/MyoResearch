echo on
global GRIDSIZE
gs=GRIDSIZE;
GRIDSIZE=100;

a=+gendath(40);
b=+gendath(40);
A=[a; b+5];
A=dataset(A,lab);
% 
% hold off;
% scatterd(A,'.');drawnow;
% w=qdc(A);
% plotd(w,'col'); drawnow;
% hold on;
% scatterd(A);
% echo off
% 
% GRIDSIZE=gs;