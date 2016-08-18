
% run ConnectBT.m

clear all, clc;
b1 = Bluetooth('WMR_BT',1);
b2 = Bluetooth('WMR_BT_TEST',1);
fopen(b1);
fopen(b2);

while(1)
    value1 = fscanf(b1,'%d')
    value2 = fscanf(b2,'%d')
    pause(1);
end

% while(1)
%     fprintf(b, '1');
%     msg1 = fscanf(b,'%s')
%     fprintf(b, '2');
%     msg2 = fscanf(b,'%s')
%     pause(1);
% end

% run DisconnectBT.m
% disconnect bt object
fclose(b1);
fclose(b2);
clear all;
