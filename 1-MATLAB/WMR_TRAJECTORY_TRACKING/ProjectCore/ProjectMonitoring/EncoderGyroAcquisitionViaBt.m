function varargout = EncoderGyroAcquisitionViaBt(varargin)
% ENCODERGYROACQUISITIONVIABT MATLAB code for EncoderGyroAcquisitionViaBt.fig
%      ENCODERGYROACQUISITIONVIABT, by itself, creates a new ENCODERGYROACQUISITIONVIABT or raises the existing
%      singleton*.
%
%      H = ENCODERGYROACQUISITIONVIABT returns the handle to a new ENCODERGYROACQUISITIONVIABT or the handle to
%      the existing singleton*.
%
%      ENCODERGYROACQUISITIONVIABT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENCODERGYROACQUISITIONVIABT.M with the given input arguments.
%
%      ENCODERGYROACQUISITIONVIABT('Property','Value',...) creates a new ENCODERGYROACQUISITIONVIABT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EncoderGyroAcquisitionViaBt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EncoderGyroAcquisitionViaBt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EncoderGyroAcquisitionViaBt

% Last Modified by GUIDE v2.5 27-Aug-2016 16:26:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EncoderGyroAcquisitionViaBt_OpeningFcn, ...
                   'gui_OutputFcn',  @EncoderGyroAcquisitionViaBt_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before EncoderGyroAcquisitionViaBt is made visible.
function EncoderGyroAcquisitionViaBt_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EncoderGyroAcquisitionViaBt (see VARARGIN)

% Choose default command line output for EncoderGyroAcquisitionViaBt
handles.output = hObject;
handles.xc = 0.0;
handles.yc = 0.0;
handles.thetac = 0.0;
handles.xr = 0.0;
handles.yr = 0.0;
handles.thetar = 0.0;
handles.vr = 0.0;
handles.wr = 0.0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EncoderGyroAcquisitionViaBt wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EncoderGyroAcquisitionViaBt_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
clear all;

% --- Executes on button press in btconnect.
function btconnect_Callback(hObject, eventdata, handles)
% hObject    handle to btconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global b v_r w_r x_r_0 y_r_0 theta_r_0
b = Bluetooth('WMR_BT',1);
% b = Bluetooth('WMR_BT_TEST',1);

fopen(b);

% fid = fopen(b);
% if fid == -1
%     set(handles.btstatus,'String','Cannot open bluetooth device!!!');
%     close;
% end

set(handles.btstatus,'String','Bluetooth3 is connected!!!');


% Receiving the all the initialisation information from Arduino Due and
% display on the listbox GUI component
% info1 = fscanf(b,'%c');
% set(handles.initInfo,'String',info1);
% 
% info2 = fscanf(b,'%c');
% newStr = strvcat(info1, info2);
% set(handles.initInfo,'String',newStr);
% 
% info3 = fscanf(b,'%c');
% newStr2 = strvcat(newStr, info3);
% set(handles.initInfo,'String',newStr2);
% 
% info4 = fscanf(b,'%c');
% newStr3 = strvcat(newStr2, info4);
% set(handles.initInfo,'String',newStr3);
% 
% info5 = fscanf(b,'%c');
% newStr4 = strvcat(newStr3, info5);
% set(handles.initInfo,'String',newStr4);
% 
% info6 = fscanf(b,'%c');
% newStr5 = strvcat(newStr4, info6);
% set(handles.initInfo,'String',newStr5);
% 
% info7 = fscanf(b,'%c');
% newStr6 = strvcat(newStr5, info7);
% set(handles.initInfo,'String',newStr6);
% 
% info8 = fscanf(b,'%c');
% newStr7 = strvcat(newStr6, info8);
% set(handles.initInfo,'String',newStr7);

v_r = str2num(get(handles.vrText,'String'))
w_r = str2num(get(handles.wrText,'String'))
x_r_0 = str2num(get(handles.xrText,'String'))
y_r_0 = str2num(get(handles.yrText,'String'))
theta_r_0 = str2num(get(handles.thetarText,'String'))
assignin('base','v_r',v_r);
assignin('base','w_r',w_r);
assignin('base','x_r_0',x_r_0);
assignin('base','y_r_0',y_r_0);
assignin('base','theta_r_0',theta_r_0);

% fprintf(b, '%d', v_r);
% fprintf(b, w_r);
% fprintf(b, x_r_0);
% fprintf(b, y_r_0);
% fprintf(b, theta_r_0);

% Synchronising character 'S' with Arduino Due board to start the program
fprintf(b, '%c', 'S');

tt = 0:0.01:60;
% tt = 0:0.01:5;

% % circle
x_r_tmp = x_r_0 - v_r/w_r*sin(theta_r_0);
y_r_tmp = y_r_0 + v_r/w_r*cos(theta_r_0);

theta_r = theta_r_0 + w_r * tt;
xr = x_r_tmp + v_r/w_r * sin(theta_r);
yr = y_r_tmp - v_r/w_r * cos(theta_r);

% % line
% theta_r = theta_r_0 + w_r * tt;
% xr = x_r_0 + v_r * cos(theta_r) .* tt;
% yr = y_r_0 + v_r * sin(theta_r) .* tt;

plot(xr,yr,'r','LineWidth',2);
hold on;

i = 0;
len = size(tt);

% x_c_0 = -0.2;
% y_c_0 = -0.11;
% theta_c_0 = 0.6;
% 
% xc(1) = x_c_0;
% yc(1) = y_c_0;

while (i < len(2))
    i = i + 1;
        xc(i) = fscanf(b,'%f');
        yc(i) = fscanf(b,'%f');
        if mod(i,20)==0
            plot(xc,yc,'b--','LineWidth',2);
            axis([-2 1 -1.5 1.5]);
            drawnow;
        end

end
fclose(b);
delete(b);

% 
% pause(2);
% 
% while (1)
%     leftEncoderData = fscanf(b,'%d')
%     rightEncoderData = fscanf(b,'%d')
%     wheel_L = fscanf(b,'%f')
%     wheel_R = fscanf(b,'%f')
%     Speed_L = fscanf(b,'%d')
%     Speed_R = fscanf(b,'%d')
%     gyroData = fscanf(b,'%d')
%     set(handles.leftEncoderText,'String',num2str(rightEncoderData));
%     set(handles.rightEncoderText,'String',num2str(leftEncoderData));
%     set(handles.wheelLText,'String',num2str(wheel_L));
%     set(handles.wheelRText,'String',num2str(wheel_R));
%     set(handles.speedLText,'String',num2str(Speed_L));
%     set(handles.speedRText,'String',num2str(Speed_R));
%     set(handles.gyroText,'String',num2str(gyroData));
%     pause(0.5);
% end

% --- Executes on button press in btdisconnect.
function btdisconnect_Callback(hObject, eventdata, handles)
% hObject    handle to btdisconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global b;
set(handles.btstatus,'String','Bluetooth is disconnected!!!');
fclose(b);
delete(b);
clear all;

% --- Executes on button press in readEncoderVals.
function readEncoderVals_Callback(hObject, eventdata, handles)
% hObject    handle to readEncoderVals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global b;
while(1)
%     fprintf(b, '1');  % send '1' to arduino for receiving encoders' value
    leftEncoderData = fscanf(b,'%d')
    rightEncoderData = fscanf(b,'%d')
    set(handles.leftEncoderText,'String',num2str(rightEncoderData));
    set(handles.rightEncoderText,'String',num2str(leftEncoderData));
    pause(0.5);
end

% --- Executes on button press in readGyroVals.
function readGyroVals_Callback(hObject, eventdata, handles)
% hObject    handle to readGyroVals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global b;
while(1)
%     fprintf(b, '4');  % send '4' to arduino for receiving gyro value
    gyroData = fscanf(b,'%d')
    set(handles.gyroText,'String',num2str(gyroData));
    pause(1);
end


% --- Executes on selection change in initInfo.
function initInfo_Callback(hObject, eventdata, handles)
% hObject    handle to initInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns initInfo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from initInfo


% --- Executes during object creation, after setting all properties.
function initInfo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on button press in readGyroValues.
function readGyroValues_Callback(hObject, eventdata, handles)
% hObject    handle to readGyroValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global b;
while(1)
%     fprintf(b, '4');  % send '4' to arduino for receiving gyro value
    gyroData = fscanf(b,'%d')
    set(handles.gyroText,'String',num2str(gyroData));
    pause(0.5);
end


% --- Executes on button press in readWheelsValues.
function readWheelsValues_Callback(hObject, eventdata, handles)
% hObject    handle to readWheelsValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global b;
while(1)
%     fprintf(b, '2');  % send '2' to arduino for receiving wheel_L and wheel_R values
    wheel_L = fscanf(b,'%f')
    wheel_R = fscanf(b,'%f')
    set(handles.wheelLText,'String',num2str(wheel_L));
    set(handles.wheelRText,'String',num2str(wheel_R));
    pause(0.5);
end

% --- Executes on button press in readSpeedValues.
function readSpeedValues_Callback(hObject, eventdata, handles)
% hObject    handle to readSpeedValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global b;
while(1)
%     fprintf(b, '3');  % send '3' to arduino for receiving speed_L and speed_R values
    Speed_L = fscanf(b,'%d')
    Speed_R = fscanf(b,'%d')
    set(handles.speedLText,'String',num2str(Speed_L));
    set(handles.speedRText,'String',num2str(Speed_R));
    pause(0.5);
end


% --- Executes on button press in clearListBox.
function clearListBox_Callback(hObject, eventdata, handles)
% hObject    handle to clearListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.clearListBox, 'Value', []);


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
movegui('center');


function xcText_Callback(hObject, eventdata, handles)
% hObject    handle to xcText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xcText as text
%        str2double(get(hObject,'String')) returns contents of xcText as a double


% --- Executes during object creation, after setting all properties.
function xcText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xcText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ycText_Callback(hObject, eventdata, handles)
% hObject    handle to ycText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ycText as text
%        str2double(get(hObject,'String')) returns contents of ycText as a double


% --- Executes during object creation, after setting all properties.
function ycText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ycText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thetacText_Callback(hObject, eventdata, handles)
% hObject    handle to thetacText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thetacText as text
%        str2double(get(hObject,'String')) returns contents of thetacText as a double


% --- Executes during object creation, after setting all properties.
function thetacText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thetacText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xrText_Callback(hObject, eventdata, handles)
% hObject    handle to xrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xrText as text
%        str2double(get(hObject,'String')) returns contents of xrText as a double


% --- Executes during object creation, after setting all properties.
function xrText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yrText_Callback(hObject, eventdata, handles)
% hObject    handle to yrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yrText as text
%        str2double(get(hObject,'String')) returns contents of yrText as a double


% --- Executes during object creation, after setting all properties.
function yrText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thetarText_Callback(hObject, eventdata, handles)
% hObject    handle to thetarText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thetarText as text
%        str2double(get(hObject,'String')) returns contents of thetarText as a double


% --- Executes during object creation, after setting all properties.
function thetarText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thetarText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vrText_Callback(hObject, eventdata, handles)
% hObject    handle to vrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vrText as text
%        str2double(get(hObject,'String')) returns contents of vrText as a double


% --- Executes during object creation, after setting all properties.
function vrText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wrText_Callback(hObject, eventdata, handles)
% hObject    handle to wrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wrText as text
%        str2double(get(hObject,'String')) returns contents of wrText as a double


% --- Executes during object creation, after setting all properties.
function wrText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btconnect.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to btconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btdisconnect.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to btdisconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in close.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
