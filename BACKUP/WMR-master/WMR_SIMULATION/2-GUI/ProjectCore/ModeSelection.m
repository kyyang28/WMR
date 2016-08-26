function varargout = ModeSelection(varargin)
% MODESELECTION MATLAB code for ModeSelection.fig
%      MODESELECTION, by itself, creates a new MODESELECTION or raises the existing
%      singleton*.
%
%      H = MODESELECTION returns the handle to a new MODESELECTION or the handle to
%      the existing singleton*.
%
%      MODESELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODESELECTION.M with the given input arguments.
%
%      MODESELECTION('Property','Value',...) creates a new MODESELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ModeSelection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ModeSelection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ModeSelection

% Last Modified by GUIDE v2.5 21-Aug-2016 21:08:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ModeSelection_OpeningFcn, ...
                   'gui_OutputFcn',  @ModeSelection_OutputFcn, ...
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


% --- Executes just before ModeSelection is made visible.
function ModeSelection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ModeSelection (see VARARGIN)

% Choose default command line output for ModeSelection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% add related paths
addpath('ProjectSimulation');
addpath('ProjectSimulation\TTCS');
addpath('ProjectSimulation\MCS');
addpath('ProjectMonitoring');

% UIWAIT makes ModeSelection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ModeSelection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in performSimulation.
function performSimulation_Callback(hObject, eventdata, handles)
% hObject    handle to performSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SimulationOptions;

% --- Executes on button press in performPractice.
function performPractice_Callback(hObject, eventdata, handles)
% hObject    handle to performPractice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('To be available!!');

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
