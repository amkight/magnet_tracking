%% Try algorithm - not real time - SPI 3 SENSORS
% AKight 04/19/2022

clear all
close all
clc

%initialize optimization
x1 = [0.001, 0.001, 0.03, 0, 0, .000001, -.000025, .000010]; %First Guess [r1, r2, r3, rho, theta,  G]
tic

d = -[0.02, 0, 0];
d2 = [0.02, 0, 0];% distance in meters 

% Set nondefault solver options
ub = [50e-3,0e-3,50e-3, Inf, Inf, Inf ];  %Upper bound %BMF limits can be added into the For cycle to change based on equations above.
lb = [-50e-3,-50e-3,-50e-3, -Inf, -Inf -Inf]; %Lower bound% However, I noticed that when it works, it works anyway, but if you have problems due to
                                                % too large distance from the magnet, it does not help very much. Also
                                                % Matlab does not like it and in many cases throws errors around.
%LSE algorithm options. Does not make a lot of difference, as long as the
%precision is good enough.
options = optimset('TolFun',.0000000001,'TolX',1e-8,'MaxFunEvals',500,'MaxIter',500,'Display','on', "PlotFcn",["optimplotx","optimplotresnorm","optimplotfval","optimplotfirstorderopt"]);

%% Type in fake field here. Can be generated with function out = makeRealisticField_ali(r,b,c,m)
 

bz = [0, -55, 824, -336.8, -55, 282, 336.8, -55, 282]./10^6;

% Solve
[solution,objectiveValue] = lsqnonlin(@(x_hat)lsqnonlinObjFcn_notSym(x_hat, bz, d, d2),x1, [],[],options);

%Store Stuff
solution_xyz = solution(1:3).*10^3;
solution_G = solution(4:6).*10^6;



