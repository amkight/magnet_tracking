% Ali Kight 04/10/2022 
%% 3-axis Magnetometer Calibration Script
% Correct the magnetometer data so that it lies on a sphere.

% run trySerial.m, move magnetometer around in all axes 
function magCalmyAxes(x,y,z)
x = x'; y = y'; z = z';
d = [x, y, z];  %create matrix of readings 

[A,b,magB] = magcal(d) % calibration coefficients, printed
dc = (d-b)*A; % correct data to a sphere
% Visualize the uncalibrated and calibrated magnetometer data.
plot3(x(:),y(:),z(:), 'LineStyle', 'none', 'Marker', 'X', ...
    'MarkerSize', 8);
hold(gca, 'on');
grid(gca, 'on');
plot3(dc(:,1),dc(:,2),dc(:,3), 'LineStyle', 'none', 'Marker', ...
    'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); 
axis equal
xlabel('uT');
ylabel('uT');
xlabel('uT');
legend('Uncalibrated Samples', 'Calibrated Samples', ...
    'Location', 'southoutside');
title("Uncalibrated vs Calibrated" + newline + ...
    "Magnetometer Measurements");
hold(gca, 'off');
end 