
% run ConnectBT.m

clear all, clc;
b = Bluetooth('WMR_BT',1);
fopen(b);
disp('Bluetooth3 is connected!!!');

% while(1)
% fprintf(b, '1');
%     value = fscanf(b,'%d')
% fprintf(b, '2');
% z = fscanf(b,'%u');
% end

while(1)
    fprintf(b, '1');
    msg1 = fscanf(b,'%s')
%     fprintf(b, '2');
%     msg2 = fscanf(b,'%s')
    pause(1);
end

% run DisconnectBT.m
% disconnect bt object
fclose(b);
clear all;
