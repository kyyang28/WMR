function varargout = MotorSpeedSimulation(varargin)
% MOTORSPEEDSIMULATION MATLAB code for MotorSpeedSimulation.fig
%      MOTORSPEEDSIMULATION, by itself, creates a new MOTORSPEEDSIMULATION or raises the existing
%      singleton*.
%
%      H = MOTORSPEEDSIMULATION returns the handle to a new MOTORSPEEDSIMULATION or the handle to
%      the existing singleton*.
%
%      MOTORSPEEDSIMULATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTORSPEEDSIMULATION.M with the given input arguments.
%
%      MOTORSPEEDSIMULATION('Property','Value',...) creates a new MOTORSPEEDSIMULATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MotorSpeedSimulation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MotorSpeedSimulation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MotorSpeedSimulation

% Last Modified by GUIDE v2.5 23-Aug-2016 18:43:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MotorSpeedSimulation_OpeningFcn, ...
                   'gui_OutputFcn',  @MotorSpeedSimulation_OutputFcn, ...
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


% --- Executes just before MotorSpeedSimulation is made visible.
function MotorSpeedSimulation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MotorSpeedSimulation (see VARARGIN)

% Choose default command line output for MotorSpeedSimulation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MotorSpeedSimulation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MotorSpeedSimulation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in simulinkModelingBtn.
function simulinkModelingBtn_Callback(hObject, eventdata, handles)
% hObject    handle to simulinkModelingBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MotorSpeedSimulinkModeling;


% --- Executes on button press in simscapeModelingBtn.
function simscapeModelingBtn_Callback(hObject, eventdata, handles)
% hObject    handle to simscapeModelingBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MotorSpeedSimscapeModeling;


% --- Executes on button press in simulinkBasedControllerBtn.
function simulinkBasedControllerBtn_Callback(hObject, eventdata, handles)
% hObject    handle to simulinkBasedControllerBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiwait(msgbox('To be available','Done','modal'));


% --- Executes on button press in simscapeBasedControllerBtn.
function simscapeBasedControllerBtn_Callback(hObject, eventdata, handles)
% hObject    handle to simscapeBasedControllerBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiwait(msgbox('To be available','Done','modal'));


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
