%% Try NOT real-time algorithm for 4 sensors
%% IMPORTANT: this code assumes a diametrically magnetized magnet!! 
% AKight 05/18/2022

clear all
close all
clc

%initialize optimization
x1 = [0.001, 0.001, 0.06, 0, 0, .000015, .000025, .000010]; %First Guess [r1, r2, r3, theta, rho, G]
store_solutions = [];
store_magreadings = [];
store_model = []; 
solutions = [];
G1 = 0; G2 = 0; G3 = 0;
tic

%plug in the offsets in x, y, z for each sensor in meters
d = -[0.03, 0, 0]; % sensor 2
d2 = [0.03, 0, 0]; % sensor 3
d3 = [0, -0.03, 0]; % sensor 4


% Set nondefault solver options --> here you only need to change bounds if
% it could be helpful. you may want to change rho and theta.
ub = [50e-3,50e-3,50e-3, pi, pi, Inf, Inf, Inf ];  %Upper bound [r1, r2, r3, theta, rho, G]
lb = [-50e-3,-50e-3,0, -pi, -pi, -Inf, -Inf -Inf]; %Lower bound [r1, r2, r3, theta, rho, G] (never negative in z for example)

options = optimset('TolFun',0.000000000001,'TolX',1e-12,'MaxFunEvals',500,'MaxIter',500,'Display','on'); %, "PlotFcn",["optimplotx","optimplotresnorm","optimplotfval","optimplotfirstorderopt"]);
 %options = optimoptions("lsqnonlin", "Algorithm","levenberg-marquardt")%,...
    %"PlotFcn",["optimplotx","optimplotresnorm","optimplotfval","optimplotfirstorderopt"]);

bz = [1,2,3,4,5,6,7,8,9,10,11,12]; %%fill in fake field here in uT

% use previous reading as next guess

 % Solve - solution is [r1, r2, r3, theta, rho, G], and objectiveValue is
 % the cost function value with that solution
[solution,objectiveValue] = lsqnonlin(@(x_hat)lsqnonlinObjFcn_notSym_XYZrhothethag_4sensors(x_hat, bz, d, d2, d3),x1, [],[],options);

%Store Stuff
solutions = [solutions; solution];
solution_xyz = solution(1:3).*10^3;




