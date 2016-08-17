function out = ReadBTData(bt)

servalue = 1;

% send servalue data from MATLAB to Arduino
fprintf(bt, servalue);

% read data value from Arduino to MATLAB and save the content to out
out = fscanf(bt,'%u');

% display the content of out
% disp(out);

end
