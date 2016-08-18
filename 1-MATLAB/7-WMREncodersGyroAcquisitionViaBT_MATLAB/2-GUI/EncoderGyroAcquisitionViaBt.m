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

% Last Modified by GUIDE v2.5 18-Aug-2016 03:55:06

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
global b;
b = Bluetooth('WMR_BT',1);
% b = Bluetooth('WMR_BT_TEST',1);
fopen(b);
% fid = fopen(b);
% if fid == -1
%     set(handles.btstatus,'String','Cannot open bluetooth device!!!');
%     close;
% end

set(handles.btstatus,'String','Bluetooth3 is connected!!!');

fprintf(b, 'S');

info1 = fscanf(b,'%c')
set(handles.initInfo,'String',info1);

info2 = fscanf(b,'%c')
newStr = strvcat(info1, info2);
set(handles.initInfo,'String',newStr);

info3 = fscanf(b,'%c')
newStr2 = strvcat(newStr, info3);
set(handles.initInfo,'String',newStr2);

info4 = fscanf(b,'%c')
newStr3 = strvcat(newStr2, info4);
set(handles.initInfo,'String',newStr3);

info5 = fscanf(b,'%c')
newStr4 = strvcat(newStr3, info5);
set(handles.initInfo,'String',newStr4);

info6 = fscanf(b,'%c')
newStr5 = strvcat(newStr4, info6);
set(handles.initInfo,'String',newStr5);

info7 = fscanf(b,'%c')
newStr6 = strvcat(newStr5, info7);
set(handles.initInfo,'String',newStr6);

info8 = fscanf(b,'%c')
newStr7 = strvcat(newStr6, info8);
set(handles.initInfo,'String',newStr7);

% --- Executes on button press in btdisconnect.
function btdisconnect_Callback(hObject, eventdata, handles)
% hObject    handle to btdisconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global b;
fclose(b);
clear all;
set(handles.btstatus,'String','Bluetooth is disconnected!!!');

% --- Executes on button press in readEncoderVals.
function readEncoderVals_Callback(hObject, eventdata, handles)
% hObject    handle to readEncoderVals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global b;
while(1)
    fprintf(b, '1');
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
    fprintf(b, '2');
    gyroData = fscanf(b,'%d')
    set(handles.gyroText,'String',num2str(gyroData));
    pause(0.5);
end
