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

% Last Modified by GUIDE v2.5 29-Aug-2016 15:10:09

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
clc;

% Choose default command line output for EncoderGyroAcquisitionViaBt
handles.output = hObject;

handles.line_xc = 0.0;
handles.line_yc = 0.0;
handles.line_thetac = 0.0;
handles.line_xr = 0.0;
handles.line_yr = 0.0;
handles.line_thetar = 0.0;
handles.line_vr = 0.0;
handles.line_wr = 0.0;

handles.circle_xc = 0.0;
handles.circle_yc = 0.0;
handles.circle_thetac = 0.0;
handles.circle_xr = 0.0;
handles.circle_yr = 0.0;
handles.circle_thetar = 0.0;
handles.circle_vr = 0.0;
handles.circle_wr = 0.0;

handles.lineTrajectoryMode = 0;
handles.circle25cmTrajectoryMode = 0;
handles.circle50cmTrajectoryMode = 0;


line_v_r = str2num(get(handles.vrLineText,'String'));
line_w_r = str2num(get(handles.wrLineText,'String'));
line_x_r_0 = str2num(get(handles.xrLineText,'String'));
line_y_r_0 = str2num(get(handles.yrLineText,'String'));
line_theta_r_0 = str2num(get(handles.thetarLineText,'String'));
assignin('base','line_v_r',line_v_r);
assignin('base','line_w_r',line_w_r);
assignin('base','line_x_r_0',line_x_r_0);
assignin('base','line_y_r_0',line_y_r_0);
assignin('base','line_theta_r_0',line_theta_r_0);

circle_v_r = str2num(get(handles.vrCircleText,'String'));
circle_w_r = str2num(get(handles.wrCircleText,'String'));
circle_x_r_0 = str2num(get(handles.xrCircleText,'String'));
circle_y_r_0 = str2num(get(handles.yrCircleText,'String'));
circle_theta_r_0 = str2num(get(handles.thetarCircleText,'String'));
handles.circle_v_r = circle_v_r;
handles.circle_w_r = circle_w_r;
assignin('base','circle_v_r',circle_v_r);
assignin('base','circle_w_r',circle_w_r);
assignin('base','circle_x_r_0',circle_x_r_0);
assignin('base','circle_y_r_0',circle_y_r_0);
assignin('base','circle_theta_r_0',circle_theta_r_0);
    

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
global b line_v_r line_w_r line_x_r_0 line_y_r_0 line_theta_r_0 circle_v_r 
global circle_w_r circle_x_r_0 circle_y_r_0 circle_theta_r_0

set(handles.btconnect,'Enable','off');

b = Bluetooth('WMR_BT',1);
% b = Bluetooth('WMR_BT_TEST',1);

% Connect bluetooth installed on WMR
fopen(b);

% fid = fopen(b);
% if fid == -1
%     set(handles.btstatus,'String','Cannot open bluetooth device!!!');
%     close;
% end

set(handles.btstatus,'String','Bluetooth3 is connected!!!');

set(handles.btdisconnect,'Enable','on');

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


% fprintf(b, '%d', v_r);
% fprintf(b, w_r);
% fprintf(b, x_r_0);
% fprintf(b, y_r_0);
% fprintf(b, theta_r_0);

% Synchronising character 'S' with Arduino Due board to start the program

handles = guidata(hObject);

lineTrajectoryMode = handles.lineTrajectoryMode;
circle25cmTrajectoryMode = handles.circle25cmTrajectoryMode;
circle50cmTrajectoryMode = handles.circle50cmTrajectoryMode;

if lineTrajectoryMode == 1 && circle25cmTrajectoryMode == 0 && circle50cmTrajectoryMode == 0
%     Line trajectory
    fprintf(b, '%c', lineTrajectoryMode);   % Send line trajectory command to WMR
    
    line_v_r = str2num(get(handles.vrLineText,'String'));
    line_w_r = str2num(get(handles.wrLineText,'String'));
    line_x_r_0 = str2num(get(handles.xrLineText,'String'));
    line_y_r_0 = str2num(get(handles.yrLineText,'String'));
    line_theta_r_0 = str2num(get(handles.thetarLineText,'String'));
    assignin('base','line_v_r',line_v_r);
    assignin('base','line_w_r',line_w_r);
    assignin('base','line_x_r_0',line_x_r_0);
    assignin('base','line_y_r_0',line_y_r_0);
    assignin('base','line_theta_r_0',line_theta_r_0);
    
elseif circle25cmTrajectoryMode == 2 && lineTrajectoryMode == 0 && circle50cmTrajectoryMode == 0
%     Circle of radius 25cm trajectory
    fprintf(b, '%c', circle25cmTrajectoryMode); % Send circle trajectory command to WMR

    circle_v_r = str2num(get(handles.vrCircleText,'String'));
    circle_w_r = str2num(get(handles.wrCircleText,'String'));
    circle_x_r_0 = str2num(get(handles.xrCircleText,'String'));
    circle_y_r_0 = str2num(get(handles.yrCircleText,'String'));
    circle_theta_r_0 = str2num(get(handles.thetarCircleText,'String'));
    handles.circle_v_r = circle_v_r;
    handles.circle_w_r = circle_w_r;
    assignin('base','circle_v_r',circle_v_r);
    assignin('base','circle_w_r',circle_w_r);
    assignin('base','circle_x_r_0',circle_x_r_0);
    assignin('base','circle_y_r_0',circle_y_r_0);
    assignin('base','circle_theta_r_0',circle_theta_r_0);

elseif circle50cmTrajectoryMode == 3 && lineTrajectoryMode == 0 && circle25cmTrajectoryMode == 0
%     Circle of radius 50cm trajectory
    fprintf(b, '%c', circle50cmTrajectoryMode); % Send circle trajectory command to WMR

    circle_v_r = str2num(get(handles.vrCircleText,'String'));
    circle_w_r = str2num(get(handles.wrCircleText,'String'));
    circle_x_r_0 = str2num(get(handles.xrCircleText,'String'));
    circle_y_r_0 = str2num(get(handles.yrCircleText,'String'));
    circle_theta_r_0 = str2num(get(handles.thetarCircleText,'String'));
    handles.circle_v_r = circle_v_r;
    handles.circle_w_r = circle_w_r;
    assignin('base','circle_v_r',circle_v_r);
    assignin('base','circle_w_r',circle_w_r);
    assignin('base','circle_x_r_0',circle_x_r_0);
    assignin('base','circle_y_r_0',circle_y_r_0);
    assignin('base','circle_theta_r_0',circle_theta_r_0);

end

guidata(hObject, handles);

% Send 'S'(start command) to WMR
fprintf(b, '%c', 'S');

cla(handles.axes1);

if lineTrajectoryMode == 1 && circle25cmTrajectoryMode == 0 && circle50cmTrajectoryMode == 0
    % line
    tt = 0:0.01:30;
    line_theta_r = line_theta_r_0 + line_w_r * tt;
    line_xr = line_x_r_0 + line_v_r * cos(line_theta_r) .* tt;
    line_yr = line_y_r_0 + line_v_r * sin(line_theta_r) .* tt;
    plot(line_xr,line_yr,'r','LineWidth',4);
elseif circle25cmTrajectoryMode == 2 && lineTrajectoryMode == 0 && circle50cmTrajectoryMode == 0
    % circle
    tt = 0:0.01:60;
    circle_x_r_tmp = circle_x_r_0 - circle_v_r/circle_w_r * sin(circle_theta_r_0);
    circle_y_r_tmp = circle_y_r_0 + circle_v_r/circle_w_r * cos(circle_theta_r_0);
    
    circle_theta_r = circle_theta_r_0 + circle_w_r * tt;
    circle_xr = circle_x_r_tmp + circle_v_r/circle_w_r * sin(circle_theta_r);
    circle_yr = circle_y_r_tmp - circle_v_r/circle_w_r * cos(circle_theta_r);
    plot(circle_xr,circle_yr,'r','LineWidth',4);
elseif circle50cmTrajectoryMode == 3 && lineTrajectoryMode == 0 && circle25cmTrajectoryMode == 0
    % circle
    tt = 0:0.01:60;
    circle_x_r_tmp = circle_x_r_0 - circle_v_r/circle_w_r * sin(circle_theta_r_0);
    circle_y_r_tmp = circle_y_r_0 + circle_v_r/circle_w_r * cos(circle_theta_r_0);
    
    circle_theta_r = circle_theta_r_0 + circle_w_r * tt;
    circle_xr = circle_x_r_tmp + circle_v_r/circle_w_r * sin(circle_theta_r);
    circle_yr = circle_y_r_tmp - circle_v_r/circle_w_r * cos(circle_theta_r);
    plot(circle_xr,circle_yr,'r','LineWidth',4);
end

hold on;

i = 0;
len = size(tt);

while (i < len(2))
    i = i + 1;
    
%     Receiving real-time current posture data from WMR
    xc(i) = fscanf(b,'%f');
    yc(i) = fscanf(b,'%f');
    if mod(i,20)==0
        plot(xc,yc,'b*');
%         plot(xc,yc,'b*','LineWidth',2);

        if lineTrajectoryMode == 1 && circle25cmTrajectoryMode == 0 && circle50cmTrajectoryMode == 0
            axis([-0.5 4 -1 4]);
        elseif circle25cmTrajectoryMode == 2 && lineTrajectoryMode == 0 && circle50cmTrajectoryMode == 0
%             2*circle_v_r/circle_w_r = diameter of circle
            axis([-2*circle_v_r/circle_w_r-0.2 circle_x_r_0+0.2 circle_y_r_0-circle_v_r/circle_w_r-0.3 circle_y_r_0+circle_v_r/circle_w_r+0.2]);
        elseif circle50cmTrajectoryMode == 3 && circle25cmTrajectoryMode == 0 && lineTrajectoryMode == 0
%             2*circle_v_r/circle_w_r = diameter of circle
            axis([-2*circle_v_r/circle_w_r-0.2 circle_x_r_0+0.2 circle_y_r_0-circle_v_r/circle_w_r-0.3 circle_y_r_0+circle_v_r/circle_w_r+0.2]);
        end
        drawnow;
    end
end

% fclose(b);
% delete(b);

set(handles.lineTrajectoryBtn,'Enable','on');
set(handles.circle25cmTrajectoryBtn,'Enable','on');
set(handles.circle50cmTrajectoryBtn,'Enable','on');

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
set(handles.btconnect,'Enable','on');
set(handles.lineTrajectoryBtn,'Enable','on');
set(handles.circle25cmTrajectoryBtn,'Enable','on');
set(handles.circle50cmTrajectoryBtn,'Enable','on');
fclose(b);
delete(b);
clear all;
clc;


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


function xcLineText_Callback(hObject, eventdata, handles)
% hObject    handle to xcLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xcLineText as text
%        str2double(get(hObject,'String')) returns contents of xcLineText as a double


% --- Executes during object creation, after setting all properties.
function xcLineText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xcLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ycLineText_Callback(hObject, eventdata, handles)
% hObject    handle to ycLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ycLineText as text
%        str2double(get(hObject,'String')) returns contents of ycLineText as a double


% --- Executes during object creation, after setting all properties.
function ycLineText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ycLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thetacLineText_Callback(hObject, eventdata, handles)
% hObject    handle to thetacLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thetacLineText as text
%        str2double(get(hObject,'String')) returns contents of thetacLineText as a double


% --- Executes during object creation, after setting all properties.
function thetacLineText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thetacLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xrLineText_Callback(hObject, eventdata, handles)
% hObject    handle to xrLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xrLineText as text
%        str2double(get(hObject,'String')) returns contents of xrLineText as a double


% --- Executes during object creation, after setting all properties.
function xrLineText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xrLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yrLineText_Callback(hObject, eventdata, handles)
% hObject    handle to yrLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yrLineText as text
%        str2double(get(hObject,'String')) returns contents of yrLineText as a double


% --- Executes during object creation, after setting all properties.
function yrLineText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yrLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thetarLineText_Callback(hObject, eventdata, handles)
% hObject    handle to thetarLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thetarLineText as text
%        str2double(get(hObject,'String')) returns contents of thetarLineText as a double


% --- Executes during object creation, after setting all properties.
function thetarLineText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thetarLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vrLineText_Callback(hObject, eventdata, handles)
% hObject    handle to vrLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vrLineText as text
%        str2double(get(hObject,'String')) returns contents of vrLineText as a double


% --- Executes during object creation, after setting all properties.
function vrLineText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vrLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wrLineText_Callback(hObject, eventdata, handles)
% hObject    handle to wrLineText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wrLineText as text
%        str2double(get(hObject,'String')) returns contents of wrLineText as a double


% --- Executes during object creation, after setting all properties.
function wrLineText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wrLineText (see GCBO)
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
function pushbutton13_Callback(hObject, eventdata, ~)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in lineTrajectoryBtn.
function lineTrajectoryBtn_Callback(hObject, eventdata, handles)
% hObject    handle to lineTrajectoryBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);
set(handles.circle25cmTrajectoryBtn,'Enable','off');
set(handles.circle50cmTrajectoryBtn,'Enable','off');
set(handles.btconnect,'Enable','on');

handles.lineTrajectoryMode = 1;
handles.circle25cmTrajectoryMode = 0;
handles.circle50cmTrajectoryMode = 0;
guidata(hObject, handles);


% --- Executes on button press in circle25cmTrajectoryBtn.
function circle25cmTrajectoryBtn_Callback(hObject, eventdata, handles)
% hObject    handle to circle25cmTrajectoryBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global circle_v_r circle_w_r
handles = guidata(hObject);

circle_v_r = str2num(get(handles.vrCircleText,'String'));
circle_w_r = str2num(get(handles.wrCircleText,'String'));
assignin('base','circle_v_r',circle_v_r);
assignin('base','circle_w_r',circle_w_r);

if (circle_v_r == 0.2) && (circle_w_r == 0.8)
    set(handles.lineTrajectoryBtn,'Enable','off');
    set(handles.circle50cmTrajectoryBtn,'Enable','off');
    set(handles.btconnect,'Enable','on');

    handles.lineTrajectoryMode = 0;
    handles.circle25cmTrajectoryMode = 2;
    handles.circle50cmTrajectoryMode = 0;
    guidata(hObject, handles);    
else
    uiwait(msgbox('Please setup the v_r and w_r to 0.2 and 0.8 respectively','Setup','Modal'));
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function wrCircleText_Callback(hObject, eventdata, handles)
% hObject    handle to wrCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wrCircleText as text
%        str2double(get(hObject,'String')) returns contents of wrCircleText as a double


% --- Executes during object creation, after setting all properties.
function wrCircleText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wrCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vrCircleText_Callback(hObject, eventdata, handles)
% hObject    handle to vrCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vrCircleText as text
%        str2double(get(hObject,'String')) returns contents of vrCircleText as a double


% --- Executes during object creation, after setting all properties.
function vrCircleText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vrCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thetarCircleText_Callback(hObject, eventdata, handles)
% hObject    handle to thetarCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thetarCircleText as text
%        str2double(get(hObject,'String')) returns contents of thetarCircleText as a double


% --- Executes during object creation, after setting all properties.
function thetarCircleText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thetarCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yrCircleText_Callback(hObject, eventdata, handles)
% hObject    handle to yrCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yrCircleText as text
%        str2double(get(hObject,'String')) returns contents of yrCircleText as a double


% --- Executes during object creation, after setting all properties.
function yrCircleText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yrCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xrCircleText_Callback(hObject, eventdata, handles)
% hObject    handle to xrCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xrCircleText as text
%        str2double(get(hObject,'String')) returns contents of xrCircleText as a double


% --- Executes during object creation, after setting all properties.
function xrCircleText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xrCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thetacCircleText_Callback(hObject, eventdata, handles)
% hObject    handle to thetacCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thetacCircleText as text
%        str2double(get(hObject,'String')) returns contents of thetacCircleText as a double


% --- Executes during object creation, after setting all properties.
function thetacCircleText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thetacCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ycCircleText_Callback(hObject, eventdata, handles)
% hObject    handle to ycCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ycCircleText as text
%        str2double(get(hObject,'String')) returns contents of ycCircleText as a double


% --- Executes during object creation, after setting all properties.
function ycCircleText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ycCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xcCircleText_Callback(hObject, eventdata, handles)
% hObject    handle to xcCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xcCircleText as text
%        str2double(get(hObject,'String')) returns contents of xcCircleText as a double


% --- Executes during object creation, after setting all properties.
function xcCircleText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xcCircleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in circle50cmTrajectoryBtn.
function circle50cmTrajectoryBtn_Callback(hObject, eventdata, handles)
% hObject    handle to circle50cmTrajectoryBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global circle_v_r circle_w_r

handles = guidata(hObject);
% v_r = handles.circle_v_r
% w_r = handles.circle_w_r
% handles.circle_v_r
% handles.circle_w_r
% v_r = evalin('base','circle_v_r');
% w_r = evalin('base','circle_w_r');

circle_v_r = str2num(get(handles.vrCircleText,'String'));
circle_w_r = str2num(get(handles.wrCircleText,'String'));
assignin('base','circle_v_r',circle_v_r);
assignin('base','circle_w_r',circle_w_r);

if (circle_v_r == 0.2) && (circle_w_r == 0.4)
    set(handles.lineTrajectoryBtn,'Enable','off');
    set(handles.circle25cmTrajectoryBtn,'Enable','off');
    set(handles.btconnect,'Enable','on');

    handles.lineTrajectoryMode = 0;
    handles.circle25cmTrajectoryMode = 0;
    handles.circle50cmTrajectoryMode = 3;
    guidata(hObject, handles);    
else
    h = msgbox('Please setup the v_r and w_r to 0.2 and 0.4 respectively','Setup','Modal');
%     set(h, 'position', [350 400 400 50]); %makes box bigger
%     ah = get( h, 'CurrentAxes' );
%     ch = get( ah, 'Children' );
%     set( ch, 'FontSize', 10 );
    uiwait(h);
end
