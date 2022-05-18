%% Try real-time algorithm from Serial - SPI 4 SENSORS
%% IMPORTANT: this code assumes a diametrically magnetized magnet!! 
% AKight 05/18/2022

clear all
close all
clc

% Initialize Serial Port
arduinoObj = serialport("/dev/cu.usbmodem142201",9600);
configureTerminator(arduinoObj,"CR/LF");
flush(arduinoObj);
arduinoObj.UserData = struct("Data",[],"Count",1);
bzs =[];

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

options = optimset('TolFun',.000000000001,'TolX',1e-12,'MaxFunEvals',500,'MaxIter',500,'Display','on'); %, "PlotFcn",["optimplotx","optimplotresnorm","optimplotfval","optimplotfirstorderopt"]);
 %options = optimoptions("lsqnonlin", "Algorithm","levenberg-marquardt")%,...
    %"PlotFcn",["optimplotx","optimplotresnorm","optimplotfval","optimplotfirstorderopt"]);

% Calibration for SENSOR 1, CS 10
%hard_iron = [-29.0450;   38.453;  -20.04];
% soft_iron = [
%     1.0235    0.0552    0.0040
%     0.0552    0.9925    0.0518
%     0.0040    0.0518    0.9901];
%earth = [-26.8; -6.36; -75.01];


hard_iron = [0; 0; 0];
soft_iron = eye(3);
earth = [0; 0; 0];

% Calibration for SENSOR 2, CS 9
%hard_iron2 = [-17.809;  -22.65;  -17.44];
% soft_iron2 = [    1.0289    0.0426    0.0010
%     0.0426    0.9887   -0.0184
%     0.0010   -0.0184    0.9852];
% earth2 = [-29; -6.75; -75.9];

hard_iron2 = [0; 0; 0];
soft_iron2 = eye(3);
earth2 = [0; 0; 0];


% Calibration for SENSOR 3, CS 8
%hard_iron3 = [-20.7919;   -19.6294;   14.9358];
%soft_iron3 = eye(3);
%earth3 = [-20.79; -19.6; 14.9];

hard_iron3 = [0; 0; 0];
soft_iron3 = eye(3);
earth3 = [0; 0; 0];


% Calibration for SENSOR 4, CS 7
%hard_iron4 = [-20.7919;   -19.6294;   14.9358];
%soft_iron4 = eye(3);
%earth4 = [-20.79; -19.6; 14.9];

hard_iron4 = [0; 0; 0];
soft_iron4 = eye(3);
earth4 = [0; 0; 0];


%Define Function Variables
time = 0;
x = 0;
y = 0;
z = 0;
count = 1;
data_norm = 0;

% hold off
 plotGraph = plot(time ,x ,'-r' , 'LineWidth', 4 );% every AnalogRead needs to be on its own Plotgraph
 hold on
 plotGraph1 = plot(time,y,'-b', 'LineWidth', 4 );
plotGraph2 = plot(time,z,'-g', 'LineWidth', 4 );  %hold on makes sure all of the channels are plotted
% plotGraph2 = plot(time,data_norm,'-y', 'LineWidth', 3 );  
% plotGraph2 = plot3(x,y,z) ; % 'LineStyle', 'none', 'Marker', 'X','MarkerSize', 8);
%zlim([0, 60])
%ylim([-20, 20])
%xlim([-20, 20])
hold on
%view([174,1])
ylabel('distance (mm)', 'FontSize', 32)

tic 

for i =1:12
data_now = readline(arduinoObj);
end

while ishandle(plotGraph2)
    % grab data from arduino and convert to double
    time(count) = toc; 
    which1 = readline(arduinoObj);
    data_now = readline(arduinoObj);  
    x_now = str2double(data_now);
    data_now1 = readline(arduinoObj);
    y_now = str2double(data_now1);
    data_now2 = readline(arduinoObj);
    z_now = str2double(data_now2);

    which2 = readline(arduinoObj);
    data_now = readline(arduinoObj);  
    x_now2 = str2double(data_now);
    data_now1 = readline(arduinoObj);
    y_now2 = str2double(data_now1);
    data_now2 = readline(arduinoObj);
    z_now2 = str2double(data_now2);

    which3 = readline(arduinoObj);
    data_now = readline(arduinoObj);  
    x_now3 = str2double(data_now);
    data_now1 = readline(arduinoObj);
    y_now3 = str2double(data_now1);
    data_now2 = readline(arduinoObj);
    z_now3 = str2double(data_now2);

    which4 = readline(arduinoObj);
    data_now = readline(arduinoObj);  
    x_now4 = str2double(data_now);
    data_now1 = readline(arduinoObj);
    y_now4 = str2double(data_now1);
    data_now2 = readline(arduinoObj);
    z_now4 = str2double(data_now2);

    % apply calibration SENSOR 1 
    var = [y_now; x_now; z_now];
    field = soft_iron*(var - hard_iron) - earth;

    % apply calibration SENSOR 2
    var2 = [x_now2; y_now2; z_now2];
    field2 = soft_iron2*(var2 - hard_iron2) - earth2;

    % apply calibration SENSOR 3
    var3 = [x_now3; y_now3; z_now3];
    field3 = soft_iron3*(var3 - hard_iron3) - earth3;

    % apply calibration SENSOR 4
    var4 = [x_now4; y_now4; z_now4];
    field4 = soft_iron4*(var4 - hard_iron4) - earth4;

    bz = [field(1) field(2) field(3) field2(1) field2(2) field2(3) field3(1) field3(2) field3(3)];
    bzs = [bzs;bz];

    % use previous reading as next guess
    if count ~=1
        x1 = solution;
    end

   
    % Solve
[solution,objectiveValue] = lsqnonlin(@(x_hat)lsqnonlinObjFcn_notSym_XYZrhothethag_4sensors(x_hat, bz, d, d2, d3),x1, [],[],options);

%Store Stuff
solutions = [solutions; solution];
solution_xyz = solution(1:3).*10^3;

    %Store Stuff
    store_solutions = [store_solutions solution(3)*10^3];
    solutions = [solutions; solution];
    store_magreadings = [store_magreadings bz(3)];

    %prepare for plotting
    x(count) = solution(1).*10^3;
    y(count) = solution(2).*10^3;
    z(count) = solution(3).*10^3;
    G1(count) = solution(6);
    G2(count) = solution(7);
    G3(count) = solution(8);

    %data_norm(count) = sqrt(x(count)^2 + y(count)^2 + z(count)^2);
    count = count + 1;   


%      plot
      set(plotGraph,'XData',time,'YData',x)
      set(plotGraph1,'XData',time,'YData',y)
      set(plotGraph2,'XData',time,'YData',z)
%      legend('X', 'Y', 'Z')
 %    set(plotGraph2,'XData',time,'YData',z)
end



