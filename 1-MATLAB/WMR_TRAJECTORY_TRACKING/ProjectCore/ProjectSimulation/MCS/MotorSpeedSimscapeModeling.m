function varargout = MotorSpeedSimscapeModeling(varargin)
% MOTORSPEEDSIMSCAPEMODELING MATLAB code for MotorSpeedSimscapeModeling.fig
%      MOTORSPEEDSIMSCAPEMODELING, by itself, creates a new MOTORSPEEDSIMSCAPEMODELING or raises the existing
%      singleton*.
%
%      H = MOTORSPEEDSIMSCAPEMODELING returns the handle to a new MOTORSPEEDSIMSCAPEMODELING or the handle to
%      the existing singleton*.
%
%      MOTORSPEEDSIMSCAPEMODELING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTORSPEEDSIMSCAPEMODELING.M with the given input arguments.
%
%      MOTORSPEEDSIMSCAPEMODELING('Property','Value',...) creates a new MOTORSPEEDSIMSCAPEMODELING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MotorSpeedSimscapeModeling_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MotorSpeedSimscapeModeling_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MotorSpeedSimscapeModeling

% Last Modified by GUIDE v2.5 24-Aug-2016 03:10:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MotorSpeedSimscapeModeling_OpeningFcn, ...
                   'gui_OutputFcn',  @MotorSpeedSimscapeModeling_OutputFcn, ...
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


% --- Executes just before MotorSpeedSimscapeModeling is made visible.
function MotorSpeedSimscapeModeling_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MotorSpeedSimscapeModeling (see VARARGIN)

% Choose default command line output for MotorSpeedSimscapeModeling
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MotorSpeedSimscapeModeling wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MotorSpeedSimscapeModeling_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function inertiaText_Callback(hObject, eventdata, handles)
% hObject    handle to inertiaText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inertiaText as text
%        str2double(get(hObject,'String')) returns contents of inertiaText as a double


% --- Executes during object creation, after setting all properties.
function inertiaText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inertiaText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dampingText_Callback(hObject, eventdata, handles)
% hObject    handle to dampingText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dampingText as text
%        str2double(get(hObject,'String')) returns contents of dampingText as a double


% --- Executes during object creation, after setting all properties.
function dampingText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dampingText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function emfText_Callback(hObject, eventdata, handles)
% hObject    handle to emfText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of emfText as text
%        str2double(get(hObject,'String')) returns contents of emfText as a double


% --- Executes during object creation, after setting all properties.
function emfText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emfText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resistanceText_Callback(hObject, eventdata, handles)
% hObject    handle to resistanceText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resistanceText as text
%        str2double(get(hObject,'String')) returns contents of resistanceText as a double


% --- Executes during object creation, after setting all properties.
function resistanceText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resistanceText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inductionText_Callback(hObject, eventdata, handles)
% hObject    handle to inductionText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inductionText as text
%        str2double(get(hObject,'String')) returns contents of inductionText as a double


% --- Executes during object creation, after setting all properties.
function inductionText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inductionText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showModelingBtn.
function showModelingBtn_Callback(hObject, eventdata, handles)
% hObject    handle to showModelingBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global J b K R L

J = str2num(get(handles.inertiaText,'String'));
b = str2num(get(handles.dampingText,'String'));
K = str2num(get(handles.emfText,'String'));
R = str2num(get(handles.resistanceText,'String'));
L = str2num(get(handles.inductionText,'String'));
assignin('base', 'J', J);
assignin('base', 'b', b);
assignin('base', 'K', K);
assignin('base', 'R', R);
assignin('base', 'L', L);

open_system('MotorSpeedModelingSimscape');


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
