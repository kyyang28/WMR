function varargout = SMCLConfig(varargin)
% SMCLCONFIG MATLAB code for SMCLConfig.fig
%      SMCLCONFIG, by itself, creates a new SMCLCONFIG or raises the existing
%      singleton*.
%
%      H = SMCLCONFIG returns the handle to a new SMCLCONFIG or the handle to
%      the existing singleton*.
%
%      SMCLCONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SMCLCONFIG.M with the given input arguments.
%
%      SMCLCONFIG('Property','Value',...) creates a new SMCLCONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SMCLConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SMCLConfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SMCLConfig

% Last Modified by GUIDE v2.5 26-Aug-2016 06:22:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SMCLConfig_OpeningFcn, ...
                   'gui_OutputFcn',  @SMCLConfig_OutputFcn, ...
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


% --- Executes just before SMCLConfig is made visible.
function SMCLConfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SMCLConfig (see VARARGIN)

% Choose default command line output for SMCLConfig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SMCLConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SMCLConfig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function kphiText_Callback(hObject, eventdata, handles)
% hObject    handle to kphiText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kphiText as text
%        str2double(get(hObject,'String')) returns contents of kphiText as a double


% --- Executes during object creation, after setting all properties.
function kphiText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kphiText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eta1Text_Callback(hObject, eventdata, handles)
% hObject    handle to eta1Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eta1Text as text
%        str2double(get(hObject,'String')) returns contents of eta1Text as a double


% --- Executes during object creation, after setting all properties.
function eta1Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eta1Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eps1Text_Callback(hObject, eventdata, handles)
% hObject    handle to eps1Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eps1Text as text
%        str2double(get(hObject,'String')) returns contents of eps1Text as a double


% --- Executes during object creation, after setting all properties.
function eps1Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eps1Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gainText_Callback(hObject, eventdata, handles)
% hObject    handle to gainText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gainText as text
%        str2double(get(hObject,'String')) returns contents of gainText as a double


% --- Executes during object creation, after setting all properties.
function gainText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gainText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eps2Text_Callback(hObject, eventdata, handles)
% hObject    handle to eps2Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eps2Text as text
%        str2double(get(hObject,'String')) returns contents of eps2Text as a double


% --- Executes during object creation, after setting all properties.
function eps2Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eps2Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eta2Text_Callback(hObject, eventdata, handles)
% hObject    handle to eta2Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eta2Text as text
%        str2double(get(hObject,'String')) returns contents of eta2Text as a double


% --- Executes during object creation, after setting all properties.
function eta2Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eta2Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in confirmBtn.
function confirmBtn_Callback(hObject, eventdata, handles)
% hObject    handle to confirmBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in quitBtn.
function quitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to quitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
movegui('center');
