

clear all, clc;

% Connect BT
b = Bluetooth('WMR_BT', 1);
fopen(b);
display('Bluetooth is connected!!!');

% Encoders and gyro data acquisition
while (1)
    fprintf(b, '1');
    fprintf(b, '2');
    leftEncoder = fscanf(b,'%d')
    rightEncoder = fscanf(b,'%d')
    gyroVal = fscanf(b,'%d')
    pause(1);
end

% Disconnect BT
fclose(b);
clear all;
display('Bluetooth is disconnected!!!');
