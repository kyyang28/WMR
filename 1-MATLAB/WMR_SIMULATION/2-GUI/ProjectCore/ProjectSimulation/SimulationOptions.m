function varargout = SimulationOptions(varargin)
% SIMULATIONOPTIONS MATLAB code for SimulationOptions.fig
%      SIMULATIONOPTIONS, by itself, creates a new SIMULATIONOPTIONS or raises the existing
%      singleton*.
%
%      H = SIMULATIONOPTIONS returns the handle to a new SIMULATIONOPTIONS or the handle to
%      the existing singleton*.
%
%      SIMULATIONOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULATIONOPTIONS.M with the given input arguments.
%
%      SIMULATIONOPTIONS('Property','Value',...) creates a new SIMULATIONOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SimulationOptions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SimulationOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SimulationOptions

% Last Modified by GUIDE v2.5 21-Aug-2016 23:54:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SimulationOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @SimulationOptions_OutputFcn, ...
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


% --- Executes just before SimulationOptions is made visible.
function SimulationOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SimulationOptions (see VARARGIN)

% Choose default command line output for SimulationOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

addpath('TTCS');
addpath('MCS');

% UIWAIT makes SimulationOptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SimulationOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ttcsBtn.
function ttcsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to ttcsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
WMR_TT_SIM;

% --- Executes on button press in mcsBtn.
function mcsBtn_Callback(hObject, eventdata, handles)
% hObject    handle to mcsBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MotorSimulationOptions;

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
