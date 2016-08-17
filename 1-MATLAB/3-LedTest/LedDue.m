
a = arduino;

for i = 1:10
    writeDigitalPin(a, 36, 1);
    pause(0.5);
    writeDigitalPin(a, 36, 0);
    pause(0.5);
end

clear a;
