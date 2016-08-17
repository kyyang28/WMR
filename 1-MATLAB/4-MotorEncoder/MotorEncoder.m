
a = arduino('COM3', 'Due');

% LeftMotorINA = 51;
% LeftMotorINB = 49;

% RightMotorINA = 33;
% RightMotorINB = 31;

% LeftMotorPWMPin = 9;
% RightMotorPWMPin = 7;

writePWMVoltage(a, 'D9', 0.4);
writePWMVoltage(a, 'D7', 0.4);

for i = 1:10
    writeDigitalPin(a, 'D51', 0);
    writeDigitalPin(a, 'D49', 1);
    writeDigitalPin(a, 'D33', 0);
    writeDigitalPin(a, 'D31', 1);
    pause(1);
end

clear a;
