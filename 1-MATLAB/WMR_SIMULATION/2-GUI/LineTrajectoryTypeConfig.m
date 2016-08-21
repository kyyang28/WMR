function varargout = LineTrajectoryTypeConfig(varargin)
% LINETRAJECTORYTYPECONFIG MATLAB code for LineTrajectoryTypeConfig.fig
%      LINETRAJECTORYTYPECONFIG, by itself, creates a new LINETRAJECTORYTYPECONFIG or raises the existing
%      singleton*.
%
%      H = LINETRAJECTORYTYPECONFIG returns the handle to a new LINETRAJECTORYTYPECONFIG or the handle to
%      the existing singleton*.
%
%      LINETRAJECTORYTYPECONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LINETRAJECTORYTYPECONFIG.M with the given input arguments.
%
%      LINETRAJECTORYTYPECONFIG('Property','Value',...) creates a new LINETRAJECTORYTYPECONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LineTrajectoryTypeConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LineTrajectoryTypeConfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LineTrajectoryTypeConfig

% Last Modified by GUIDE v2.5 21-Aug-2016 03:37:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LineTrajectoryTypeConfig_OpeningFcn, ...
                   'gui_OutputFcn',  @LineTrajectoryTypeConfig_OutputFcn, ...
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


% --- Executes just before LineTrajectoryTypeConfig is made visible.
function LineTrajectoryTypeConfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LineTrajectoryTypeConfig (see VARARGIN)

% Choose default command line output for LineTrajectoryTypeConfig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LineTrajectoryTypeConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LineTrajectoryTypeConfig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in closeBtn.
function closeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to closeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on button press in confirmBtn.
function confirmBtn_Callback(hObject, eventdata, handles)
% hObject    handle to confirmBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vrVal wrVal

dlgTitle = 'Quit';
dlgQuestion = 'Do you want to quit the config window?';
choice = questdlg(dlgQuestion, dlgTitle, 'Yes', 'No', 'Yes');
switch choice
    case 'Yes'
        vrVal = str2num(get(handles.vrText,'String'));
        wrVal = str2num(get(handles.wrText,'String'));
        assignin('base', 'vrVal', vrVal);
        assignin('base', 'wrVal', wrVal);
        close;
    case 'No'
end

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
movegui('center');
