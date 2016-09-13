
clear all;
close all;

xite = 5.0;
ts = 0.01;

for k = 1:1:4001
    
s(k) = (k - 1) * ts - 20;

y1(k) = xite * sign(s(k));

epc = 0.5;

y2(k) = xite * tanh(s(k)/epc);

end

figure(1);
plot(s,y1,'r',s,y2,'b','linewidth',2);
xlabel('s'); ylabel('y');
legend('Switching function','Tanh function');
