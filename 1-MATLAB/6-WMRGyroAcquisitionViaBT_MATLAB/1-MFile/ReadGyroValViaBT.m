
% run ConnectBT.m

clear all, clc;
b = Bluetooth('WMR_BT',1);
fopen(b);
disp('Bluetooth is connected');

% while(1)
%     fprintf(b, '1');
%     leftEncoder = fscanf(b,'%d')
%     rightEncoder = fscanf(b,'%d')

while (1)
    fprintf(b, '2');
    gyroVal = fscanf(b,'%d')
end
% fprintf(b, '2');
% z = fscanf(b,'%u');
% end

% run DisconnectBT.m
% disconnect bt object
fclose(b);
clear all;
