%% Try Reading Serial DATA for four sensors

clear all
close all
clear 
clc
tic 

arduinoObj = serialport("/dev/cu.usbmodem141201",9600);
configureTerminator(arduinoObj,"CR/LF");
flush(arduinoObj);

arduinoObj.UserData = struct("Data",[],"Count",1);

plotTitle = 'Arduino Data Log';  % plot title
xLabel = 'X';     % x-axis label
yLabel = 'Y';      % y-axis label
yMax  = 5;                          %y Maximum Value
yMin  = -5;                      %y minimum Value
plotGrid = 'on';                 % 'off' to turn off grid
min = -5;                         % set y-min
max = 5;                        % set y-max
delay = .01;   


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
% hard_iron2 = [-17.809;  -22.65;  -17.44];
% soft_iron2 = [    1.0289    0.0426    0.0010
%     0.0426    0.9887   -0.0184
%     0.0010   -0.0184    0.9852];
%earth2 = [-29; -6.75; -75.9];

hard_iron2 = [0; 0; 0];
soft_iron2 = eye(3);
earth2 = [0; 0; 0];


% Calibration for SENSOR 3, CS 8
% hard_iron3 = [-20.7919;   -19.6294;   14.9358];
% soft_iron3 = eye(3);
% earth3 = [-20.79; -19.6; 14.9];


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
x2 = 0;
y2 = 0;
z2 = 0;
x3 = 0;
y3 = 0;
z3 = 0;
x4 = 0;
y4 = 0;
z4 = 0;
count = 1;

%% Initiate the plots that you want here by uncommenting them. comment the ones you don't want to see.
% remember to have hold on after the first plot you uncomment!!

%  3D PLOTS

%   plotGraph2 = plot3(x,y,z, 'LineStyle', 'none', 'Marker', 'X', 'Color', 'r', 'MarkerSize', 8);
%   hold(gca, 'on');
%   plotGraph3 = plot3(x2,y2,z2, 'LineStyle', 'none', 'Marker', 'X', 'Color', 'g', 'MarkerSize', 8);
%   plotGraph4 = plot3(x3,y3,z3, 'LineStyle', 'none', 'Marker', 'X','Color', 'b', 'MarkerSize', 8);
%   plotGraph5 = plot3(x4,y4,z4, 'LineStyle', 'none', 'Marker', 'X','Color', 'b', 'MarkerSize', 8);

% 2D PLOTS

plotGraph2 = plot(time ,x ,'-r');  
hold on
% plotGraph1 = plot(time,x2,'Color','r', 'LineStyle', '--');
% plotGraph2 = plot(time,x3,'Color','r', 'LineStyle', '-.' );
% 
plotGraph3 = plot(time ,y ,'-b' );  
% hold on
% plotGraph4 = plot(time,y2,'Color','b', 'LineStyle', '--');
% plotGraph5 = plot(time,y3,'Color','b', 'LineStyle', '-.' );
% 
plotGraph6 = plot(time ,z ,'-g' );  
% hold on
plotGraph7 = plot(time,z2,'Color','g', 'LineStyle', '--');
% plotGraph8 = plot(time,z3,'Color','g', 'LineStyle', '-.' );

%% IMPORTANT: 
% below, you will see there is a for loop that just reads out stuff 12
% times, then goes into the main while loop. This is to get past some of
% the initialization stuff that the arduino serial port will spit out. I
% added more sensors, so you need to update this accordingly (I can't
% without an arduino and sensors). To do this, debug by putting a stop point at
% line 124. look at variable "which1" it should read "sensor1." It likely
% won't, so change the for loop (e.g. i =1:12 --> i = 1:16) until which1
% reads sensor1 (which2, which3, etc. will read sensor2, sensor3, and so
% on). 


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
    field = soft_iron*(var - hard_iron) - earth ;

    % apply calibration SENSOR 2
    var2 = [x_now2; y_now2; z_now2];
    field2 = soft_iron2*(var2 - hard_iron2) - earth2 ;

    % apply calibration SENSOR 3
    var3 = [x_now3; y_now3; z_now3];
    field3 = soft_iron3*(var3 - hard_iron3) - earth3 ;

    % apply calibration SENSOR 4
    var4 = [x_now4; y_now4; z_now4];
    field4 = soft_iron4*(var4 - hard_iron4) - earth4 ;
    
    %prepare for plotting
    x(count) = field(1);
    y(count) = field(2);
    z(count) = field(3);
    data_norm(count) = sqrt(x(count)^2 + y(count)^2 + z(count)^2);

    x2(count) = field2(1);
    y2(count) = field2(2);
    z2(count) = field2(3);
    data_norm2(count) = sqrt(x2(count)^2 + y2(count)^2 + z2(count)^2);

    x3(count) = field3(1);
    y3(count) = field3(2);
    z3(count) = field3(3);
    data_norm3(count) = sqrt(x3(count)^2 + y3(count)^2 + z3(count)^2);

    x4(count) = field4(1);
    y4(count) = field4(2);
    z4(count) = field4(3);
    data_norm4(count) = sqrt(x4(count)^2 + y4(count)^2 + z4(count)^2);

    count = count + 1;  

%% IMPORTANT:
    % plot --> comment out what you don't want to plot!!! if there is x, y,
    % and z, then its a plot3 graph. remember to initialize above in the
    % code. also confirm that the while loop is contingent on the plotGraph
    % that is uncommented. e.g. while(plotGraph2) means that plotGraph2
    % should be uncommented below (or switch the while loop as
    % appropriate)

% 3D PLOTS
      set(plotGraph2, 'XData', x, 'YData', y, 'ZData', z)
%      set(plotGraph3, 'XData', x2, 'YData', y2, 'ZData', z2)
%       set(plotGraph4, 'XData', x3, 'YData', y3, 'ZData', z3)
%       set(plotGraph5, 'XData', x4, 'YData', y4, 'ZData', z4)


% 2D PLOTS

%      set(plotGraph2,'XData',time,'YData',x)
%      set(plotGraph1,'XData',time,'YData',x2)
%      set(plotGraph2,'XData',time,'YData',x3)
% 
 %    set(plotGraph3,'XData',time,'YData',y)
%      set(plotGraph4,'XData',time,'YData',y2)
%      set(plotGraph5,'XData',time,'YData',y3)
% 
%       set(plotGraph6,'XData',time,'YData',z)
%      set(plotGraph7,'XData',time,'YData',z2)
%      set(plotGraph8,'XData',time,'YData',z3)

%       set(plotGraph7,'XData',time,'YData', data_norm)
end

