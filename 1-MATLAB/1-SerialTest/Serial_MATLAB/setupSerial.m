function [s,flag] = setupSerial(comPort)
% Initialise the serial port commnication between Arduino and MATLAB
% We ensure that the arduino is also communicating with MATLAB at this
% time. A predefined code on the arduino acknowledges this.
% If setup is complete then the value of setup is returned as 1 otherwise
% 0.
    flag = 1;

    s = serial(comPort);
    set(s, 'DataBits', 8);
    set(s, 'StopBits', 1);
    set(s, 'BaudRate', 9600);
    set(s, 'Parity', 'none');

    fopen(s);

    a = 'b';
    while (a ~= 'a')
        % Read char from Arduino
        a = fread(s, 1, 'uchar');
    end

    if (a == 'a')
       disp('serial read'); 
    end

    % Send char to Arduino
    fprintf(s, '%c', 'a');
    mbox = msgbox('Serial communication has been setup.');
    uiwait(mbox);

%     fscanf(s, '%u');
end
