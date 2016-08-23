function varargout = MotorSimulationOptions(varargin)
% MOTORSIMULATIONOPTIONS MATLAB code for MotorSimulationOptions.fig
%      MOTORSIMULATIONOPTIONS, by itself, creates a new MOTORSIMULATIONOPTIONS or raises the existing
%      singleton*.
%
%      H = MOTORSIMULATIONOPTIONS returns the handle to a new MOTORSIMULATIONOPTIONS or the handle to
%      the existing singleton*.
%
%      MOTORSIMULATIONOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTORSIMULATIONOPTIONS.M with the given input arguments.
%
%      MOTORSIMULATIONOPTIONS('Property','Value',...) creates a new MOTORSIMULATIONOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MotorSimulationOptions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MotorSimulationOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MotorSimulationOptions

% Last Modified by GUIDE v2.5 23-Aug-2016 18:24:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MotorSimulationOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @MotorSimulationOptions_OutputFcn, ...
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


% --- Executes just before MotorSimulationOptions is made visible.
function MotorSimulationOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MotorSimulationOptions (see VARARGIN)
clc;
% Choose default command line output for MotorSimulationOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MotorSimulationOptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MotorSimulationOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
movegui('center');


% --- Executes on button press in speedSimulationBtn.
function speedSimulationBtn_Callback(hObject, eventdata, handles)
% hObject    handle to speedSimulationBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MotorSpeedSimulation;

% --- Executes on button press in positionSimulationBtn.
function positionSimulationBtn_Callback(hObject, eventdata, handles)
% hObject    handle to positionSimulationBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in quitBtn.
function quitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to quitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;
