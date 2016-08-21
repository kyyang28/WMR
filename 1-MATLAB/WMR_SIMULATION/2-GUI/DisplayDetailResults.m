function varargout = DisplayDetailResults(varargin)
% DISPLAYDETAILRESULTS MATLAB code for DisplayDetailResults.fig
%      DISPLAYDETAILRESULTS, by itself, creates a new DISPLAYDETAILRESULTS or raises the existing
%      singleton*.
%
%      H = DISPLAYDETAILRESULTS returns the handle to a new DISPLAYDETAILRESULTS or the handle to
%      the existing singleton*.
%
%      DISPLAYDETAILRESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAYDETAILRESULTS.M with the given input arguments.
%
%      DISPLAYDETAILRESULTS('Property','Value',...) creates a new DISPLAYDETAILRESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DisplayDetailResults_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DisplayDetailResults_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DisplayDetailResults

% Last Modified by GUIDE v2.5 21-Aug-2016 14:36:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DisplayDetailResults_OpeningFcn, ...
                   'gui_OutputFcn',  @DisplayDetailResults_OutputFcn, ...
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


% --- Executes just before DisplayDetailResults is made visible.
function DisplayDetailResults_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DisplayDetailResults (see VARARGIN)

% Choose default command line output for DisplayDetailResults
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DisplayDetailResults wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DisplayDetailResults_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in plotIndividuallyBtn.
function plotIndividuallyBtn_Callback(hObject, eventdata, handles)
% hObject    handle to plotIndividuallyBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Plot the resulting graphs
run plotResults.m

% --- Executes on button press in closeBtn.
function closeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to closeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
movegui('center');
