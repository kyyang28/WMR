function varargout = EncoderAcquisitionViaBT(varargin)
% ENCODERACQUISITIONVIABT MATLAB code for EncoderAcquisitionViaBT.fig
%      ENCODERACQUISITIONVIABT, by itself, creates a new ENCODERACQUISITIONVIABT or raises the existing
%      singleton*.
%
%      H = ENCODERACQUISITIONVIABT returns the handle to a new ENCODERACQUISITIONVIABT or the handle to
%      the existing singleton*.
%
%      ENCODERACQUISITIONVIABT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENCODERACQUISITIONVIABT.M with the given input arguments.
%
%      ENCODERACQUISITIONVIABT('Property','Value',...) creates a new ENCODERACQUISITIONVIABT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EncoderAcquisitionViaBT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EncoderAcquisitionViaBT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EncoderAcquisitionViaBT

% Last Modified by GUIDE v2.5 17-Aug-2016 04:09:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EncoderAcquisitionViaBT_OpeningFcn, ...
                   'gui_OutputFcn',  @EncoderAcquisitionViaBT_OutputFcn, ...
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


% --- Executes just before EncoderAcquisitionViaBT is made visible.
function EncoderAcquisitionViaBT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EncoderAcquisitionViaBT (see VARARGIN)

% Choose default command line output for EncoderAcquisitionViaBT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EncoderAcquisitionViaBT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EncoderAcquisitionViaBT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
clear all;

% --- Executes on button press in connectBT.
function connectBT_Callback(hObject, eventdata, handles)
% hObject    handle to connectBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global b;
b = Bluetooth('WMR_BT',1);
% b = Bluetooth('WMR_BT_TEST',1);
fopen(b);
set(handles.displayText,'String','Bluetooth is connected!!!');


% --- Executes on button press in disconnectBT.
function disconnectBT_Callback(hObject, eventdata, handles)
% hObject    handle to disconnectBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global b;
fclose(b);
clear all;
set(handles.displayText,'String','Bluetooth is disconnected!!!');


function leftEncoderText_Callback(hObject, eventdata, handles)
% hObject    handle to leftEncoderText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of leftEncoderText as text
%        str2double(get(hObject,'String')) returns contents of leftEncoderText as a double


% --- Executes during object creation, after setting all properties.
function leftEncoderText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftEncoderText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rightEncoderText_Callback(hObject, eventdata, handles)
% hObject    handle to rightEncoderText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rightEncoderText as text
%        str2double(get(hObject,'String')) returns contents of rightEncoderText as a double


% --- Executes during object creation, after setting all properties.
function rightEncoderText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rightEncoderText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in readEncoders.
function readEncoders_Callback(hObject, eventdata, handles)
% hObject    handle to readEncoders (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global b;
while(1)
    leftEncoderVal = fscanf(b,'%d')
    rightEncoderVal = fscanf(b,'%d')
    pause(1);
    set(handles.leftEncoderText,'String',num2str(leftEncoderVal));
    set(handles.rightEncoderText,'String',num2str(rightEncoderVal));
end
