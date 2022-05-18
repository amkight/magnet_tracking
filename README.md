# magnet_tracking



How to use this code repository (for three sensors, steps are the same for 4 sensors, but the script names have 4sensors in them):

Step 1) Upload the arduino SPI code to the arduino. 

Arduino code: “mag2Matlab_delaySPI_3sens.ino” 
Note: if you would like to add an extra sensor, instantiate another lis3mdl by putting ‘Adafruit_LIS3MDL lis3mdl4;’ and copy and pasting the code below for another instance

Step 2) To visualize the raw sensor readings, use MATLAB	

	MATLAB script: “trySerial_SPI_ThreeSensor.m”
Note: before calibrating, set the hard, soft, and earth iron offsets to 0, identity, and 0, respectively. You will have to set the serial port to the one you are plugged into (you can check this by looking at the arduino program)

You can play with the plot settings to visualize in the way that works for you 

Step 3) Calibrate the sensors by setting the plot settings to plot3 and rotating around a sphere. 

Step 4) Run the calibration on each sensor with the calibration function
	
	MATLAB function: “magCalmyAxes(x,y,z)”
Sensor 1 will have been recorded as x, y, z, and sensor two will have been recorded as x2, y2, z2, and so on. Run this function for each sensor to obtain hard and soft iron offsets.

Step 5) Check the calibration by plugging in the offsets/scaling factors into trySerial_SPI_ThreeSensor.m. All sensors should be reading the same value, and when you spin in a sphere, they should go the same direction and read equal magnitudes for each axis.

Step 6) With satisfactory calibration, you can run the realtime optimization function
	
	MATLAB script: “optimization_3sensors_XYZrhothetaG_REALTIME.m”
Note: Make sure to plug in the calibration values. This code includes sensor offsets as d, d1, etc. these values can be changed if your sensors are different distances apart.

Also note: if things aren’t working, check the cost function “lsqnonlinObjFcn_notSym_XYZrhothetag.m” and make sure that the field measurement readings are in uT (sometimes it gets divided again by 10^6 even though it’s already in uT).

Step 7) You can also run an offline optimization if you read in the magnetic field in the SPI script
	
	MATLAB script: “optimization_3sensors_XYZrhothetaG_notRealTime.m”

EXTRA TIPS: 

Code assumes diametrically magnetized magnet

“Clear all” if you have opened the serial port in MATLAB and you want to go back to arduino
