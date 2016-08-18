
clear all, clc;

b = Bluetooth('WMR_BT', 1);
fopen(b);
disp('Bluetooth3 is connected!!!');

fprintf(b, 'S');

info1 = fscanf(b,'%c')
info2 = fscanf(b,'%c')
info3 = fscanf(b,'%c')
info4 = fscanf(b,'%c')
info5 = fscanf(b,'%c')
info6 = fscanf(b,'%c')
info7 = fscanf(b,'%c')
info8 = fscanf(b,'%c')

fclose(b);
clear all;
